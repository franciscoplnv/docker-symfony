#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
cd "$PROJECT_ROOT"
source .env
if [[ -z "${IMAGE_TAG:-}" ]]; then
  echo "IMAGE_TAG no está definido en .env" >&2
  exit 1
fi
echo "  * Verifying docker compose config with IMAGE_TAG=${IMAGE_TAG}"
docker compose config >/dev/null

echo "  * Building image franciscolnv/symfony-plnv:${IMAGE_TAG}"
docker build -t "franciscolnv/symfony-plnv:${IMAGE_TAG}" .
