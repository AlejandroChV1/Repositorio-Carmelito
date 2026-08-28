/**
 * Bazar Carmelito - Backend local (SQLite)
 * Ejecutar: npm start
 * API en: http://localhost:3000
 */

const path = require('path');
const fs = require('fs');
const express = require('express');
const cors = require('cors');
const Database = require('better-sqlite3');

const app = express();
const PORT = 3000;

// Ruta a la base de datos SQLite (un nivel arriba, carpeta database)
const DB_PATH = path.join(__dirname, '..', 'database', 'bazar_carmelito.db');

if (!fs.existsSync(DB_PATH)) {
  console.error('❌ No se encontró la base de datos en:', DB_PATH);
  console.error('   Asegúrate de que exista: database/bazar_carmelito.db');
  process.exit(1);
}

const db = new Database(DB_PATH);
db.pragma('foreign_keys = ON');

app.use(cors());
app.use(express.json());

// Servir el frontend estático
app.use(express.static(path.join(__dirname, '..', 'frontend')));

// --------------------------------------------------
// GET /api/productos  → lista productos con precio y stock
// --------------------------------------------------
app.get('/api/productos', (req, res) => {
  try {
    const rows = db.prepare(`
      SELECT
        p.id_producto,
        p.codigo,
        p.nombre,
        p.descripcion,
        i.stock_actual,
        i.stock_minimo,
        COALESCE(
          (SELECT dv.precio_unitario
           FROM detalle_venta dv
           WHERE dv.id_producto = p.id_producto
           ORDER BY dv.id_detalle_venta DESC
           LIMIT 1),
          CASE
            WHEN p.codigo LIKE 'PAP%' THEN 10.0
            WHEN p.codigo LIKE 'JUG%' THEN 20.0
            ELSE 8.0
          END
        ) AS precio
      FROM producto p
      LEFT JOIN inventario i ON p.id_producto = i.id_producto
      WHERE p.estado = 1
      ORDER BY p.nombre
      LIMIT 200
    `).all();

    res.json({ ok: true, data: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// --------------------------------------------------
// GET /api/usuarios
// --------------------------------------------------
app.get('/api/usuarios', (req, res) => {
  try {
    const rows = db.prepare(`
      SELECT id_usuario, nombres, apellidos, nombre_usuario
      FROM usuario
      WHERE estado = 1
    `).all();
    res.json({ ok: true, data: rows });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

// --------------------------------------------------
// GET /api/ventas  → últimas ventas
// --------------------------------------------------
app.get('/api/ventas', (req, res) => {
  try {
    const rows = db.prepare(`
      SELECT id_venta, numero_venta, fecha_venta, hora_venta, total, estado
      FROM venta
      ORDER BY fecha_venta DESC, hora_venta DESC
      LIMIT 15
    `).all();
    res.json({ ok: true, data: rows });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

// --------------------------------------------------
// POST /api/ventas  → registrar una venta completa
// Body esperado:
// {
//   fecha_venta, hora_venta, id_usuario, observacion,
//   subtotal, descuento_total, total,
//   detalles: [ { id_producto, cantidad, precio_unitario, descuento, subtotal } ]
// }
// --------------------------------------------------
app.post('/api/ventas', (req, res) => {
  const body = req.body;

  if (!body || !Array.isArray(body.detalles) || body.detalles.length === 0) {
    return res.status(400).json({ ok: false, error: 'Debes enviar al menos un producto en detalles.' });
  }

  const insertVenta = db.prepare(`
    INSERT INTO venta (
      id_venta, numero_venta, fecha_venta, hora_venta,
      id_usuario, subtotal, descuento_total, total, estado, observacion
    ) VALUES (
      @id_venta, @numero_venta, @fecha_venta, @hora_venta,
      @id_usuario, @subtotal, @descuento_total, @total, @estado, @observacion
    )
  `);

  const insertDetalle = db.prepare(`
    INSERT INTO detalle_venta (
      id_detalle_venta, id_venta, id_producto,
      cantidad, precio_unitario, descuento, subtotal
    ) VALUES (
      @id_detalle_venta, @id_venta, @id_producto,
      @cantidad, @precio_unitario, @descuento, @subtotal
    )
  `);

  const getStock = db.prepare(`SELECT stock_actual FROM inventario WHERE id_producto = ?`);
  const updateStock = db.prepare(`
    UPDATE inventario
    SET stock_actual = ?, ultima_actualizacion = datetime('now','localtime')
    WHERE id_producto = ?
  `);

  // IDs
  const ts = Date.now().toString().slice(-8);
  const idVenta = 'V' + ts;
  const numeroVenta = body.numero_venta || ('V-' + ts);

  const registrar = db.transaction(() => {
    insertVenta.run({
      id_venta: idVenta,
      numero_venta: numeroVenta,
      fecha_venta: body.fecha_venta,
      hora_venta: body.hora_venta,
      id_usuario: body.id_usuario || 'U001',
      subtotal: Number(body.subtotal) || 0,
      descuento_total: Number(body.descuento_total) || 0,
      total: Number(body.total) || 0,
      estado: 'Completada',
      observacion: body.observacion || 'Venta de mostrador'
    });

    body.detalles.forEach((d, index) => {
      const idDetalle = 'DV' + ts + String(index + 1).padStart(2, '0');
      insertDetalle.run({
        id_detalle_venta: idDetalle,
        id_venta: idVenta,
        id_producto: d.id_producto,
        cantidad: Number(d.cantidad),
        precio_unitario: Number(d.precio_unitario),
        descuento: Number(d.descuento) || 0,
        subtotal: Number(d.subtotal)
      });

      // Actualizar inventario
      const inv = getStock.get(d.id_producto);
      if (inv) {
        const nuevo = Math.max(0, Number(inv.stock_actual) - Number(d.cantidad));
        updateStock.run(nuevo, d.id_producto);
      }
    });

    return { id_venta: idVenta, numero_venta: numeroVenta };
  });

  try {
    const result = registrar();
    console.log(`✅ Venta registrada: ${result.numero_venta}`);
    res.json({ ok: true, ...result, mensaje: 'Venta registrada correctamente en SQLite' });
  } catch (err) {
    console.error('❌ Error al registrar venta:', err.message);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// --------------------------------------------------
// GET /api/health
// --------------------------------------------------
app.get('/api/health', (req, res) => {
  try {
    const productos = db.prepare('SELECT COUNT(*) AS n FROM producto').get().n;
    const ventas = db.prepare('SELECT COUNT(*) AS n FROM venta').get().n;
    res.json({
      ok: true,
      mensaje: 'Backend Bazar Carmelito funcionando',
      database: DB_PATH,
      productos,
      ventas
    });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

// Ruta raíz → formulario
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'frontend', 'index.html'));
});

app.listen(PORT, () => {
  console.log('');
  console.log('========================================');
  console.log('  BAZAR CARMELITO - Servidor local');
  console.log('========================================');
  console.log(`  Formulario : http://localhost:${PORT}`);
  console.log(`  API        : http://localhost:${PORT}/api/health`);
  console.log(`  Base datos : ${DB_PATH}`);
  console.log('========================================');
  console.log('  Presiona Ctrl+C para detener');
  console.log('');
});
