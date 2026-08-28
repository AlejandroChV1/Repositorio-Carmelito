# 🛒 Bazar Carmelito – Inventario y Ventas (SQLite)

Sistema académico con **SQLite local**: el formulario registra ventas en la base de datos de tu computadora. Ideal para clonar desde GitHub y usar en cada PC del grupo, y revisar datos con DBeaver.

## Inicio rápido

```bash
# 1. Entrar al backend
cd backend

# 2. Instalar (solo la primera vez)
pip install -r requirements.txt

# 3. Arrancar
python server.py
```

Abre el navegador en: **http://localhost:3000**

## Manual completo

**[docs/MANUAL_SQLITE_LOCAL.md](docs/MANUAL_SQLITE_LOCAL.md)**

Incluye instalación de Python, uso del formulario, conexión con DBeaver y pasos para subir a GitHub.

## Estructura

```
├── backend/          server.py + requirements.txt
├── database/         bazar_carmelito.db (SQLite)
├── frontend/         Formulario HTML
├── docs/             Manuales
└── sql/              Scripts SQL de referencia
```

## Objetivo

Registrar y controlar productos y ventas de agosto, analizar rotación e identificar qué productos requieren reposición de inventario.
