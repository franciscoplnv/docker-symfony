# docker-symfony

Proyecto base para desarrollo con Symfony usando Docker Compose y MariaDB.

## Requisitos
- Docker
- Docker Compose v2 (usa `compose.yml`)

## Servicios
- **app**: Contenedor PHP 8.4 + Symfony CLI
- **db**: MariaDB para desarrollo
- **dbTest**: MariaDB para pruebas

## Uso rápido

1. Construye la imagen personalizada:
   ```bash
   docker build -t franciscolnv/symfony-plnv:0.9.0 .
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

## Versionado y publicación de la imagen

La imagen se publica automáticamente en Docker Hub cuando se crea un **Release** en GitHub.

### Pasos para publicar una nueva versión
1. Actualiza el `Dockerfile` (por ejemplo, base PHP 8.4).
2. Commit en `main`.
3. Crea un tag y un release en GitHub (ej. `v0.9.0`).
4. La GitHub Action publicará: `franciscolnv/symfony-plnv:v0.9.0`

### Ejemplo de release
- Title: `v0.9.0 – PHP 8.4 base`
- Notes:
  - Bump base image to PHP 8.4 CLI
  - Keep extensions, Composer, Xdebug and Symfony CLI

## Notas
- La imagen personalizada se debe actualizar si cambias la versión de PHP o dependencias.
- Usa el tag de release (`v0.9.0`, `v0.9.1`, etc.) para reflejar los últimos cambios.

---
Autor: Francisco Piedras
