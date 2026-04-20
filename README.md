# docker-symfony

[![Test docker image](https://github.com/franciscoplnv/docker-symfony/actions/workflows/test-image.yml/badge.svg)](https://github.com/franciscoplnv/docker-symfony/actions/workflows/test-image.yml)
[![Última release](https://img.shields.io/github/v/release/franciscoplnv/docker-symfony)](https://github.com/franciscoplnv/docker-symfony/releases/latest)
[![Fecha release](https://img.shields.io/github/release-date/franciscoplnv/docker-symfony)](https://github.com/franciscoplnv/docker-symfony/releases/latest)

Las badges superiores muestran el estado del workflow de pruebas y la versión/fecha del release más reciente.

Proyecto base para desarrollo con Symfony usando Docker Compose y MariaDB.

La imagen actual está basada en `php:8.4-cli-alpine` y mantiene Composer, Symfony CLI, Xdebug y las extensiones PHP necesarias para CI y desarrollo. En las pruebas locales, la imagen resultante queda en torno a `189 MiB`.

## Requisitos
- Docker
- Docker Compose v2 (usa `compose.yml`)

## Servicios
- **app**: Contenedor PHP 8.4 Alpine + Symfony CLI
- **db**: MariaDB para desarrollo
- **dbTest**: MariaDB para pruebas

## Uso rápido

1. Asegúrate de que `.env` define `IMAGE_TAG` (ej. `v0.10.0`) y luego construye la imagen personalizada:
   ```bash
   docker build -t franciscolnv/symfony-plnv:${IMAGE_TAG} .
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

Usamos `.env` para fijar el tag que se usa localmente y en los ejemplos (`IMAGE_TAG=v0.10.0`). La GitHub Action también lee ese archivo, así que actualiza `IMAGE_TAG` antes de construir o lanzar nuevos releases para garantizar que el pipeline y el entorno local publiquen exactamente la misma etiqueta.

La imagen se publica automáticamente en Docker Hub cuando se crea un **Release** en GitHub.

### Pasos para publicar una nueva versión
1. Actualiza el `Dockerfile` y `.env` (por ejemplo, `IMAGE_TAG=v0.10.0`).
2. Commit en `main`.
3. Crea un tag y un release en GitHub (ej. `v0.10.0`).
4. La GitHub Action publicará: `franciscolnv/symfony-plnv:v0.10.0`

### Ejemplo de release
- Title: `v0.10.0 – Alpine base`
- Notes:
  - Migrate base image to PHP 8.4 CLI Alpine
  - Keep Composer, Symfony CLI, Xdebug and required PHP extensions
  - Reduce image size to about 189 MiB

## Notas
- La imagen personalizada se debe actualizar si cambias la versión de PHP o dependencias.
- Usa el tag de release (`v0.10.0`, `v0.10.1`, etc.) para reflejar los últimos cambios.

## Pruebas
- `scripts/test-image.sh` carga `.env`, valida `docker compose config` y reconstruye la imagen usando `IMAGE_TAG` para garantizar que el pipeline reproduce el comportamiento local.
- El workflow **Test docker image** ejecuta ese script en GitHub Actions automáticamente para pushes y PRs en `main`; el badge más arriba refleja su estado.

---
Autor: Francisco Piedras
