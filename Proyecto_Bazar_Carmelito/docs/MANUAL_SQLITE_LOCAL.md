# MANUAL COMPLETO – Bazar Carmelito (SQLite local)

Este manual explica **paso a paso** cómo:

1. Usar la base de datos en **SQLite** (como te enseñaron en VS Code)
2. Hacer que el **formulario guarde ventas** en esa base
3. Subir todo a **GitHub**
4. Que cualquier integrante **descargue el repo** y lo use en su PC
5. Ver los registros con **DBeaver**

> Sistema **local**: cada persona usa su propia copia de la base en su computadora.  
> No es una web pública; es un proyecto funcional para la universidad.

---

# PARTE 0 – Herramientas (instalar una sola vez)

| Herramienta | Para qué | Descarga |
|-------------|----------|----------|
| **Python 3** | Ejecutar el servidor que conecta el formulario con SQLite | https://www.python.org/downloads/ |
| **VS Code** | Editar el proyecto | https://code.visualstudio.com |
| **Git** | Clonar / subir a GitHub | https://git-scm.com |
| **DBeaver** | Ver la base de datos SQLite | https://dbeaver.io |

## Instalar Python correctamente (Windows)

1. Entra a https://www.python.org/downloads/
2. Descarga la versión **3.11 o 3.12**.
3. Al instalar, **marca la casilla**:
   ```
   ☑ Add python.exe to PATH
   ```
4. Termina la instalación.
5. Cierra y vuelve a abrir la terminal (o VS Code).
6. Comprueba:

```bash
python --version
pip --version
```

Si `python` no funciona, prueba:

```bash
py --version
```

En ese caso, en los comandos de este manual usa `py` en lugar de `python`.

---

# PARTE 1 – Estructura del proyecto

```
Proyecto_Bazar_Carmelito/
├── backend/
│   ├── server.py           ← servidor Python (Flask)
│   └── requirements.txt    ← librerías necesarias
├── database/
│   └── bazar_carmelito.db  ← BASE DE DATOS SQLITE
├── frontend/
│   └── index.html          ← formulario de ventas
├── docs/
│   └── MANUAL_SQLITE_LOCAL.md
├── sql/                    ← scripts SQL de referencia
└── README.md
```

**Cómo se conecta todo:**

```
Navegador (formulario)
        ↓
http://localhost:3000
        ↓
server.py (Python)
        ↓
database/bazar_carmelito.db   ← aquí se guardan las ventas
        ↑
     DBeaver (para ver los datos)
```

---

# PARTE 2 – Usar el sistema en TU computadora

## Paso 2.1 – Obtener el proyecto

### Opción A – Clonar desde GitHub

```bash
git clone https://github.com/USUARIO/NOMBRE-DEL-REPO.git
cd NOMBRE-DEL-REPO
```

### Opción B – Descargar ZIP

1. En GitHub: botón verde **Code** → **Download ZIP**
2. Descomprime
3. En VS Code: **File → Open Folder** y elige esa carpeta

---

## Paso 2.2 – Instalar librerías de Python (solo la primera vez)

1. Abre la terminal en VS Code: **Terminal → New Terminal**
2. Entra a la carpeta backend:

```bash
cd backend
```

3. Instala Flask:

```bash
pip install -r requirements.txt
```

Si `pip` no funciona:

```bash
python -m pip install -r requirements.txt
```

o

```bash
py -m pip install -r requirements.txt
```

Debes ver que se instalan `flask` y `flask-cors` sin errores.

---

## Paso 2.3 – Arrancar el servidor

Sigue en la carpeta `backend` y ejecuta:

```bash
python server.py
```

(o `py server.py` si corresponde)

Debes ver:

```
========================================
  BAZAR CARMELITO - Servidor local
========================================
  Formulario : http://localhost:3000
  API health : http://localhost:3000/api/health
  Base datos : ...\database\bazar_carmelito.db
========================================
```

**No cierres esta terminal.** Mientras esté abierta, el formulario puede guardar datos.

Para detener el servidor: `Ctrl + C`.

---

## Paso 2.4 – Abrir el formulario

1. Abre Chrome, Edge o Firefox.
2. Escribe en la barra de direcciones:

```
http://localhost:3000
```

3. Arriba a la derecha debe aparecer: **Conectado a SQLite** (badge verde).
4. Si dice “Sin conexión”:
   - Revisa que el servidor siga corriendo
   - Abre http://localhost:3000/api/health → debe mostrar `"ok": true`

---

## Paso 2.5 – Registrar una venta de prueba

1. Fecha y hora ya vienen cargadas.
2. Clic en **+ Agregar producto**.
3. Elige un producto de la lista (se cargan desde la base SQLite).
4. Indica cantidad (y descuento si quieres).
5. Clic en **💾 Registrar Venta en SQLite**.
6. Debe salir mensaje de éxito.
7. Abajo verás la venta en “Últimas ventas”.

La venta quedó guardada en:

```
database/bazar_carmelito.db
```

---

# PARTE 3 – Ver los registros en DBeaver

## Paso 3.1 – Instalar DBeaver

1. https://dbeaver.io/download/
2. Elige **DBeaver Community** (gratis).
3. Instálalo.

## Paso 3.2 – Conectar el archivo SQLite

1. Abre DBeaver.
2. **Database → New Database Connection** (o ícono de enchufe con +).
3. Elige **SQLite** → **Next**.
4. En **Path** → **Browse...** y selecciona:

```
ruta\a\Proyecto_Bazar_Carmelito\database\bazar_carmelito.db
```

5. **Test Connection** (si pide drivers, acepta descargarlos).
6. **Finish**.

## Paso 3.3 – Consultar datos

1. Panel izquierdo → tu conexión → **Tables**.
2. Tablas clave:
   - `venta` → cada venta
   - `detalle_venta` → productos de cada venta
   - `producto` → 500 productos
   - `inventario` → stock actual
3. Clic derecho en `venta` → **View Data**.
4. O usa el **SQL Editor**:

```sql
-- Últimas ventas
SELECT * FROM venta
ORDER BY fecha_venta DESC, hora_venta DESC;

-- Detalle con nombre de producto
SELECT
    v.numero_venta,
    v.fecha_venta,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal
FROM venta v
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN producto p ON dv.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC;
```

Después de registrar una venta en el formulario, en DBeaver pulsa **F5** (Refresh) para ver los datos nuevos.

---

# PARTE 4 – Subir el proyecto a GitHub

## Paso 4.1 – Crear repositorio vacío en GitHub

1. https://github.com → inicia sesión.
2. **+** → **New repository**.
3. Nombre: `bazar-carmelito` (o el que acuerde el grupo).
4. Descripción: `Sistema de inventario y ventas - SQLite local`.
5. Public (o Private).
6. **No** marques “Add a README” si ya tienes archivos.
7. **Create repository**.

## Paso 4.2 – Subir desde la terminal

Colócate en la **raíz** del proyecto (donde están `backend`, `database`, `frontend`):

```bash
git init
git add .
git commit -m "Bazar Carmelito: formulario + SQLite + backend Python"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/bazar-carmelito.git
git push -u origin main
```

Cambia `TU_USUARIO` y el nombre del repo.

Si pide contraseña: usa un **Personal Access Token** de GitHub  
(Settings → Developer settings → Personal access tokens → Generate, permiso `repo`).

## Paso 4.3 – Qué se sube y qué no

| Sí subir | No subir (ya está en .gitignore) |
|----------|-----------------------------------|
| `backend/server.py`, `requirements.txt` | `__pycache__/`, entornos virtuales |
| `frontend/index.html` | |
| `database/bazar_carmelito.db` | |
| `docs/`, `sql/`, `README.md` | |

Cada persona, al clonar, obtiene su **copia** del `.db`. Las ventas que registre viven solo en su PC (salvo que vuelva a subir el archivo actualizado).

---

# PARTE 5 – Texto para compañeros del grupo

```
1. Clonar:
   git clone https://github.com/USUARIO/bazar-carmelito.git
   cd bazar-carmelito

2. Instalar (solo primera vez):
   cd backend
   pip install -r requirements.txt

3. Arrancar:
   python server.py

4. Abrir navegador:
   http://localhost:3000

5. Ver datos:
   Abrir database/bazar_carmelito.db con DBeaver
```

---

# PARTE 6 – Problemas frecuentes

| Problema | Solución |
|----------|----------|
| `python` no se reconoce | Reinstalar Python marcando “Add to PATH” y reiniciar la terminal |
| `pip install` falla | Usar `python -m pip install -r requirements.txt` |
| Badge “Sin conexión” | Ejecutar `python server.py` y no cerrar la terminal |
| Puerto 3000 en uso | Cerrar el otro programa o cambiar `port=3000` en `server.py` |
| No hay productos en el combo | Abrir http://localhost:3000/api/productos; si falla, revisar que exista `database/bazar_carmelito.db` |
| DBeaver no ve ventas nuevas | Pulsar F5 / Refresh en DBeaver |
| Error al guardar venta | Revisar la terminal del servidor; ahí aparece el mensaje de error de SQLite |

---

# PARTE 7 – Checklist

- [ ] Python instalado (`python --version`)
- [ ] Proyecto clonado o descomprimido
- [ ] `cd backend` + `pip install -r requirements.txt` OK
- [ ] `python server.py` muestra la URL
- [ ] http://localhost:3000 abre el formulario
- [ ] Badge verde “Conectado a SQLite”
- [ ] Venta de prueba registrada
- [ ] DBeaver conectado a `bazar_carmelito.db`
- [ ] La venta se ve en la tabla `venta`
- [ ] Proyecto en GitHub
- [ ] Un compañero pudo clonar y repetir los pasos

---

Con esto tienes:

- Base de datos **SQLite** (como en clase)
- Formulario que **sí guarda** en la base
- Todo listo para **GitHub**
- Uso **local** por cada integrante
- Consulta de registros con **DBeaver**
