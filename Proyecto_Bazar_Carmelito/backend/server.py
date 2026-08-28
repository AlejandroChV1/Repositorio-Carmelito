"""
Bazar Carmelito - Backend local (SQLite)
Ejecutar:  python server.py
API/Form:  http://localhost:3000
"""

import os
import sqlite3
import time
from pathlib import Path
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR.parent / "database" / "bazar_carmelito.db"
FRONTEND_DIR = BASE_DIR.parent / "frontend"

app = Flask(__name__, static_folder=str(FRONTEND_DIR), static_url_path="")
CORS(app)


def get_db():
    if not DB_PATH.exists():
        raise FileNotFoundError(f"No se encontró la base de datos: {DB_PATH}")
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


@app.get("/api/health")
def health():
    try:
        conn = get_db()
        productos = conn.execute("SELECT COUNT(*) AS n FROM producto").fetchone()["n"]
        ventas = conn.execute("SELECT COUNT(*) AS n FROM venta").fetchone()["n"]
        conn.close()
        return jsonify({
            "ok": True,
            "mensaje": "Backend Bazar Carmelito funcionando",
            "database": str(DB_PATH),
            "productos": productos,
            "ventas": ventas,
        })
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)}), 500


@app.get("/api/productos")
def productos():
    try:
        conn = get_db()
        rows = conn.execute(
            """
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
            """
        ).fetchall()
        conn.close()
        return jsonify({"ok": True, "data": [dict(r) for r in rows]})
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)}), 500


@app.get("/api/usuarios")
def usuarios():
    try:
        conn = get_db()
        rows = conn.execute(
            """
            SELECT id_usuario, nombres, apellidos, nombre_usuario
            FROM usuario
            WHERE estado = 1
            """
        ).fetchall()
        conn.close()
        return jsonify({"ok": True, "data": [dict(r) for r in rows]})
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)}), 500


@app.get("/api/ventas")
def listar_ventas():
    try:
        conn = get_db()
        rows = conn.execute(
            """
            SELECT id_venta, numero_venta, fecha_venta, hora_venta, total, estado
            FROM venta
            ORDER BY fecha_venta DESC, hora_venta DESC
            LIMIT 15
            """
        ).fetchall()
        conn.close()
        return jsonify({"ok": True, "data": [dict(r) for r in rows]})
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)}), 500


@app.post("/api/ventas")
def crear_venta():
    body = request.get_json(silent=True) or {}
    detalles = body.get("detalles") or []
    if not detalles:
        return jsonify({"ok": False, "error": "Debes enviar al menos un producto en detalles."}), 400

    ts = str(int(time.time() * 1000))[-8:]
    id_venta = "V" + ts
    numero_venta = body.get("numero_venta") or ("V-" + ts)

    try:
        conn = get_db()
        cur = conn.cursor()

        cur.execute(
            """
            INSERT INTO venta (
                id_venta, numero_venta, fecha_venta, hora_venta,
                id_usuario, subtotal, descuento_total, total, estado, observacion
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                id_venta,
                numero_venta,
                body.get("fecha_venta"),
                body.get("hora_venta"),
                body.get("id_usuario") or "U001",
                float(body.get("subtotal") or 0),
                float(body.get("descuento_total") or 0),
                float(body.get("total") or 0),
                "Completada",
                body.get("observacion") or "Venta de mostrador",
            ),
        )

        for i, d in enumerate(detalles, start=1):
            id_detalle = f"DV{ts}{i:02d}"
            cur.execute(
                """
                INSERT INTO detalle_venta (
                    id_detalle_venta, id_venta, id_producto,
                    cantidad, precio_unitario, descuento, subtotal
                ) VALUES (?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    id_detalle,
                    id_venta,
                    d["id_producto"],
                    float(d["cantidad"]),
                    float(d["precio_unitario"]),
                    float(d.get("descuento") or 0),
                    float(d["subtotal"]),
                ),
            )

            row = cur.execute(
                "SELECT stock_actual FROM inventario WHERE id_producto = ?",
                (d["id_producto"],),
            ).fetchone()
            if row is not None:
                nuevo = max(0, float(row["stock_actual"]) - float(d["cantidad"]))
                cur.execute(
                    """
                    UPDATE inventario
                    SET stock_actual = ?, ultima_actualizacion = datetime('now','localtime')
                    WHERE id_producto = ?
                    """,
                    (nuevo, d["id_producto"]),
                )

        conn.commit()
        conn.close()
        print(f"✅ Venta registrada: {numero_venta}")
        return jsonify({
            "ok": True,
            "id_venta": id_venta,
            "numero_venta": numero_venta,
            "mensaje": "Venta registrada correctamente en SQLite",
        })
    except Exception as e:
        print("❌ Error:", e)
        return jsonify({"ok": False, "error": str(e)}), 500


@app.get("/")
def index():
    return send_from_directory(FRONTEND_DIR, "index.html")


@app.get("/<path:path>")
def static_proxy(path):
    return send_from_directory(FRONTEND_DIR, path)


if __name__ == "__main__":
    if not DB_PATH.exists():
        print("❌ No se encontró la base de datos en:", DB_PATH)
        raise SystemExit(1)

    print("")
    print("========================================")
    print("  BAZAR CARMELITO - Servidor local")
    print("========================================")
    print("  Formulario : http://localhost:3000")
    print("  API health : http://localhost:3000/api/health")
    print(f"  Base datos : {DB_PATH}")
    print("========================================")
    print("  Presiona Ctrl+C para detener")
    print("")
    app.run(host="127.0.0.1", port=3000, debug=False)
