# MANUAL PASO A PASO – Bazar Carmelito
## Formulario + SQLite + DBeaver + GitHub

Este manual está pensado para alguien que **nunca ha conectado un formulario con una base de datos**.  
Sigue cada paso **en orden**. No saltes ninguno.

---

# ANTES DE EMPEZAR – Qué programas necesitas

Debes tener instalados estos 4 programas en tu computadora:

| Nº | Programa | Para qué sirve | Cómo saber si ya lo tienes |
|----|----------|----------------|----------------------------|
| 1 | **Python** | Hace funcionar el servidor | Abre la terminal y escribe `python --version` |
| 2 | **VS Code** | Abrir la carpeta del proyecto | Busca “Visual Studio Code” en el menú Inicio |
| 3 | **DBeaver** | Ver los datos de la base SQLite | Busca “DBeaver” en el menú Inicio |
| 4 | **Navegador** | Ver el formulario (Chrome, Edge o Firefox) | Ya lo tienes |

Si te falta alguno, instálalo primero (al final del manual hay enlaces).

---

# PASO 1 – Descomprimir el proyecto

1. Busca el archivo ZIP que descargaste (ejemplo: `Bazar_Carmelito_SQLite_Local.zip`).
2. Clic derecho sobre el ZIP → **Extraer todo...** (o “Extract here”).
3. Elige una carpeta fácil de encontrar, por ejemplo:
   ```
   C:\Users\TU_USUARIO\Documents\Bazar_Carmelito
   ```
4. Dentro debes ver carpetas como:
   - `backend`
   - `database`
   - `frontend`
   - `docs`

**Importante:** recuerda dónde quedó esa carpeta. La vas a abrir varias veces.

---

# PASO 2 – Abrir el proyecto en VS Code

1. Abre el programa **Visual Studio Code** (VS Code).
2. En la barra de menú superior haz clic en:
   ```
   File  →  Open Folder...
   ```
   (En español: **Archivo → Abrir carpeta...**)
3. Navega hasta la carpeta del proyecto (la que descomprimiste).
4. Selecciónala y haz clic en **Seleccionar carpeta** / **Open**.
5. A la izquierda verás el explorador de archivos con las carpetas `backend`, `database`, `frontend`, etc.

Si VS Code pregunta “¿Confías en los autores de esta carpeta?”, elige **Yes** / **Sí**.

---

# PASO 3 – Abrir la terminal DENTRO de VS Code

1. En VS Code, en la barra de menú superior haz clic en:
   ```
   Terminal  →  New Terminal
   ```
   (En español: **Terminal → Nueva terminal**)
2. Abajo se abrirá una ventana negra o blanca. Eso es la **terminal**.
3. Fíjate en el texto que aparece. Debe terminar algo así:
   ```
   ...\Bazar_Carmelito>
   ```
   o
   ```
   ...\Proyecto_Bazar_Carmelito>
   ```

Esa es la carpeta raíz del proyecto. Bien.

---

# PASO 4 – Entrar a la carpeta backend

En la terminal escribe exactamente esto y presiona **Enter**:

```bash
cd backend
```

Ahora el texto de la terminal debe terminar en:

```
...\backend>
```

Si escribiste mal y da error, escribe:

```bash
cd ..
cd backend
```

---

# PASO 5 – Instalar las librerías (solo la primera vez)

En la misma terminal (dentro de `backend`) escribe:

```bash
pip install -r requirements.txt
```

Presiona **Enter**.

### ¿Qué debe pasar?
Verás varias líneas bajando. Al final algo como:

```
Successfully installed flask ... flask-cors ...
```

### Si `pip` no funciona, prueba estas alternativas (una por una):

```bash
python -m pip install -r requirements.txt
```

o

```bash
py -m pip install -r requirements.txt
```

Cuando diga “Successfully installed”, sigue al paso 6.

---

# PASO 6 – Encender el servidor (lo más importante)

Sigue dentro de la carpeta `backend` en la terminal.  
Escribe:

```bash
python server.py
```

Si no funciona:

```bash
py server.py
```

o

```bash
python3 server.py
```

### ¿Qué DEBES ver en la terminal?

Algo parecido a esto:

```
========================================
  BAZAR CARMELITO - Servidor local
========================================
  Formulario : http://localhost:3000
  API health : http://localhost:3000/api/health
  Base datos : ...\database\bazar_carmelito.db
========================================
  Presiona Ctrl+C para detener

 * Running on http://127.0.0.1:3000
```

### Reglas de oro de este paso

- **NO cierres** esta terminal.
- **NO cierres** VS Code.
- Mientras veas ese mensaje, el sistema está “encendido”.
- Si cierras la terminal, el formulario deja de guardar datos.

Déjala abierta y pasa al paso 7.

---

# PASO 7 – Abrir el formulario en el navegador

1. Abre **Chrome**, **Edge** o **Firefox** (cualquier navegador).
2. En la barra de direcciones (arriba, donde escribes las páginas web) escribe exactamente:

```
http://localhost:3000
```

3. Presiona **Enter**.

### ¿Qué debes ver?

- El título **Bazar Carmelito**
- Un badge verde que diga **Conectado a SQLite**
- Campos de fecha, hora, vendedor
- Botón **+ Agregar producto**
- Botón **Registrar Venta en SQLite**

### Si ves “Sin conexión” o la página no carga

- Vuelve a la terminal de VS Code.
- Comprueba que el servidor siga corriendo (mensaje de “Running on...”).
- Si no está corriendo, repite el **PASO 6**.
- Prueba también abrir: `http://127.0.0.1:3000`

---

# PASO 8 – Registrar una venta de prueba

1. En el formulario, haz clic en **+ Agregar producto**.
2. En la lista desplegable elige un producto (ejemplo: Cuaderno, Bolígrafo...).
3. Deja la cantidad en 1 (o cambia si quieres).
4. Haz clic en el botón azul:
   ```
   💾 Registrar Venta en SQLite
   ```
5. Debe aparecer un mensaje de **éxito**.
6. Abajo en la página deberías ver esa venta en “Últimas ventas”.

Si sale error, copia el mensaje y revisa que el servidor (PASO 6) siga encendido.

---

# PASO 9 – Ver los datos en DBeaver (conectar la base de datos)

Aquí conectas el archivo SQLite para ver las tablas y los registros.

## 9.1 Abrir DBeaver

1. Abre el programa **DBeaver** desde el menú Inicio.

## 9.2 Crear una conexión nueva

1. En la barra superior de DBeaver busca el ícono de un **enchufe con un signo +**  
   (o menú: **Database → New Database Connection**).
2. Se abre una ventana con muchos tipos de bases de datos.
3. Busca y haz clic en **SQLite**.
4. Haz clic en **Next** / **Siguiente**.

## 9.3 Elegir el archivo de la base de datos

1. Verás un campo que se llama **Path** (Ruta).
2. Haz clic en el botón **Browse...** (Examinar).
3. Navega hasta la carpeta de tu proyecto.
4. Entra en la carpeta **database**.
5. Selecciona el archivo:
   ```
   bazar_carmelito.db
   ```
6. Clic en **Abrir**.
7. Haz clic en **Test Connection** / **Probar conexión**.
   - Si pide descargar drivers, acepta (**Download**).
   - Debe decir que la conexión es correcta.
8. Haz clic en **Finish** / **Finalizar**.

## 9.4 Ver las tablas

1. A la izquierda en DBeaver verás tu conexión (algo como `bazar_carmelito`).
2. Haz clic en la flechita para expandirla.
3. Expande **Tables** (Tablas).
4. Verás tablas como:
   - `venta`
   - `detalle_venta`
   - `producto`
   - `inventario`
   - `usuario`
   - etc.

## 9.5 Ver los registros de ventas

1. Clic derecho sobre la tabla **venta**.
2. Elige **View Data** / **Ver datos**.
3. A la derecha aparecerán las filas.
4. Busca la venta que registraste en el formulario (por fecha o número de venta).

### Consulta SQL (opcional pero útil)

1. Clic derecho en la conexión → **SQL Editor → New SQL Script**.
2. Pega esto y pulsa el botón de ejecutar (triángulo verde) o `Ctrl+Enter`:

```sql
SELECT * FROM venta ORDER BY fecha_venta DESC;
```

Para ver el detalle con nombre de producto:

```sql
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

**Nota:** cada vez que registres una venta nueva en el formulario, en DBeaver pulsa **F5** o el botón de actualizar para ver los datos nuevos.

---

# PASO 10 – Resumen visual de “quién se conecta con quién”

```
┌─────────────────────┐
│  VS Code            │
│  Terminal:          │
│  python server.py   │  ← ESTO DEBE ESTAR ENCENDIDO
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Navegador          │
│  localhost:3000     │  ← AQUÍ LLENAS EL FORMULARIO
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  database/          │
│  bazar_carmelito.db │  ← AQUÍ SE GUARDAN LOS DATOS
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  DBeaver            │  ← AQUÍ MIRAS LAS TABLAS
└─────────────────────┘
```

---

# PASO 11 – Subir el proyecto a GitHub (cuando ya funcione)

Solo haz esto cuando el formulario ya te guarde ventas y las veas en DBeaver.

## 11.1 Crear el repositorio en GitHub

1. Entra a https://github.com e inicia sesión.
2. Arriba a la derecha: botón **+** → **New repository**.
3. Repository name: `bazar-carmelito`
4. Déjalo en **Public**.
5. **No** marques “Add a README”.
6. Clic en **Create repository**.

## 11.2 Subir desde la terminal de VS Code

1. En VS Code, abre una **nueva** terminal  
   (`Terminal → New Terminal`).
2. Asegúrate de estar en la carpeta **raíz** del proyecto (no dentro de `backend`).  
   Si estás en `backend`, escribe:
   ```bash
   cd ..
   ```
3. Ejecuta estos comandos **uno por uno** (cambia `TU_USUARIO`):

```bash
git init
git add .
git commit -m "Bazar Carmelito sistema completo SQLite"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/bazar-carmelito.git
git push -u origin main
```

Si pide usuario y contraseña:
- Usuario = tu usuario de GitHub
- Contraseña = un **token** (no tu clave normal).  
  Se crea en: GitHub → Settings → Developer settings → Personal access tokens.

---

# ORDEN CORRECTO CADA VEZ QUE QUIERAS USAR EL SISTEMA

Cada vez que enciendas tu PC y quieras trabajar:

1. Abre **VS Code** → abre la carpeta del proyecto.
2. Abre la **Terminal** dentro de VS Code.
3. Escribe:
   ```bash
   cd backend
   python server.py
   ```
4. Deja esa terminal abierta.
5. Abre el **navegador** en `http://localhost:3000`
6. Usa el formulario.
7. (Opcional) Abre **DBeaver** para ver los datos.

Cuando termines: en la terminal presiona `Ctrl + C` para apagar el servidor.

---

# PROBLEMAS MÁS COMUNES (y solución exacta)

### “python no se reconoce como comando”
- Python no está en el PATH.
- Reinstala Python desde https://www.python.org/downloads/
- En la instalación **marca**: ☑ Add python.exe to PATH
- Cierra y vuelve a abrir VS Code.

### La página localhost:3000 no abre
- El servidor no está corriendo.
- Vuelve al PASO 6 y ejecuta `python server.py`.
- No cierres esa terminal.

### Badge rojo “Sin conexión”
- Igual que arriba: el servidor está apagado.
- Enciéndelo de nuevo.

### DBeaver no encuentra el archivo .db
- En Browse debes entrar a la carpeta **database** del proyecto.
- El archivo se llama exactamente: `bazar_carmelito.db`

### Registré una venta pero no la veo en DBeaver
- En DBeaver pulsa **F5** (actualizar).
- O vuelve a hacer clic derecho en la tabla `venta` → View Data.

### Error al hacer `pip install`
Prueba:
```bash
python -m pip install -r requirements.txt
```

---

# CHECKLIST FINAL (márcalo en papel)

- [ ] Descomprimí el ZIP en Documents (o similar)
- [ ] Abrí la carpeta en VS Code (File → Open Folder)
- [ ] Abrí la terminal en VS Code
- [ ] Escribí `cd backend`
- [ ] Ejecuté `pip install -r requirements.txt`
- [ ] Ejecuté `python server.py` y vi el mensaje “Running on...”
- [ ] Dejé la terminal abierta
- [ ] Abrí el navegador en http://localhost:3000
- [ ] Vi el badge verde “Conectado a SQLite”
- [ ] Registré una venta de prueba
- [ ] Abrí DBeaver
- [ ] Conecté el archivo database/bazar_carmelito.db
- [ ] Vi la tabla `venta` con mi registro nuevo

---

# Enlaces de descarga (si te falta algo)

- Python: https://www.python.org/downloads/
- VS Code: https://code.visualstudio.com
- DBeaver: https://dbeaver.io/download/
- Git (para GitHub): https://git-scm.com

---

Si en algún paso exacto te atoras (por ejemplo “en el paso 6 me sale este error...”), copia el mensaje completo de la terminal o una captura de lo que ves y te indico el siguiente clic.
