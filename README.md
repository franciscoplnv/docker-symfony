# docker-symfony

Proyecto base para desarrollo con Symfony usando Docker Compose y MariaDB.

## Requisitos
- Docker
- Docker Compose v2 (usa `compose.yml`)

## Servicios
- **app**: Contenedor PHP 8.3 + Apache + Symfony CLI
- **db**: MariaDB para desarrollo
- **dbTest**: MariaDB para pruebas

## Uso rápido

1. Construye la imagen personalizada:
   ```bash
   docker build -t franciscolnv/symfony-plnv:0.4 .
   ```

2. Levanta los servicios:
   ```bash
   docker compose up -d
   ```

3. Accede al contenedor app:
   ```bash
   docker compose exec app bash
   ```

4. Accede a MariaDB:
   ```bash
   docker compose exec db mysql -u mariadb -p
   ```

## Volúmenes
- `www`: Código fuente Symfony
- `mariadb-data`: Datos de la base principal
- `mariadbTest-data`: Datos de la base de pruebas

## Personalización
- Modifica el `Dockerfile` para instalar dependencias extra.
- Edita `compose.yml` para agregar servicios o cambiar configuraciones.

## Notas
- La imagen personalizada se debe actualizar si cambias la versión de PHP o dependencias.
- Usa la etiqueta `0.4` para reflejar los últimos cambios.

---
Autor: Francisco Piedras