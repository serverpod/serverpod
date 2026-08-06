#!/usr/bin/env bash
# Smoke-test a Serverpod PostgreSQL image: boot it -> load pgvector + PostGIS ->
# write and read a row that exercises both -> stop. Catches an image that pulls
# and starts but cannot serve the columns Serverpod generates - PostGIS missing
# because the base image changed PG_MAJOR under us, or an extension that
# installs but fails to load on one architecture - i.e. failures that only
# surface once a real query runs.
#
#   smoke.sh <image-ref>   # e.g. ghcr.io/serverpod/postgres:16
#
# Gates publishing in .github/workflows/publish-postgres-image.yaml, and doubles
# as the check to run by hand against a local build or an already-published tag.
set -euo pipefail

IMAGE="${1:?usage: smoke.sh <image-ref>}"
NAME="serverpod-postgres-smoke-$$"

trap 'docker rm -f "$NAME" >/dev/null 2>&1 || true' EXIT

# No published ports: this talks to the container over docker exec, so it cannot
# collide with a database the developer already has on 5432/8090.
docker run -d --name "$NAME" -e POSTGRES_PASSWORD=postgres "$IMAGE" >/dev/null

# The image's own initialization runs a socket-only temporary server first, so
# readiness is checked over TCP to be sure the real server is up rather than the
# init-time one.
ready=0
for _ in $(seq 60); do
  if docker exec "$NAME" pg_isready -h 127.0.0.1 -U postgres -q; then ready=1; break; fi
  sleep 1
done
if [ "$ready" != 1 ]; then
  echo "smoke: postgres in $IMAGE never became ready" >&2
  docker logs "$NAME" >&2
  exit 1
fi

docker exec -e PGPASSWORD=postgres "$NAME" \
  psql -h 127.0.0.1 -U postgres -v ON_ERROR_STOP=1 \
    -c 'CREATE EXTENSION vector' \
    -c 'CREATE EXTENSION postgis' \
    -c 'CREATE TABLE smoke (id serial primary key, embedding vector(3), location geography(Point, 4326))' \
    -c "INSERT INTO smoke (embedding, location) VALUES ('[1,2,3]', ST_Point(11.1, 22.2))" \
    -c "SELECT id, embedding <-> '[3,2,1]' AS distance, ST_AsText(location) FROM smoke" \
    -c 'SELECT extname, extversion FROM pg_extension ORDER BY 1'
