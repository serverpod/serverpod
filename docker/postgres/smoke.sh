#!/usr/bin/env bash
# Smoke-test a Serverpod PostgreSQL image: boot it -> load pgvector + PostGIS ->
# write and read a row that exercises both -> stop. Catches an image that pulls
# and starts but cannot serve the columns Serverpod generates - PostGIS missing
# because the base image changed PG_MAJOR under us, or an extension that
# installs but fails to load on one architecture - i.e. failures that only
# surface once a real query runs.
#
#   smoke.sh <image-ref> [platform]
#   # e.g. smoke.sh ghcr.io/serverpod/postgres:16 linux/arm64
#
# SMOKE_TIMEOUT (seconds, default 300) bounds the wait for postgres to accept
# connections. The default is sized for an emulated architecture, where the
# first boot has to run initdb under QEMU; a native run reaches it in seconds.
#
# Gates publishing in .github/workflows/publish-postgres-image.yaml, and doubles
# as the check to run by hand against a local build or an already-published tag.
set -euo pipefail

IMAGE="${1:?usage: smoke.sh <image-ref> [platform]}"
PLATFORM="${2:-}"
SMOKE_TIMEOUT="${SMOKE_TIMEOUT:-300}"
NAME="serverpod-postgres-smoke-$$"

trap 'docker rm -f "$NAME" >/dev/null 2>&1 || true' EXIT

# No published ports: this talks to the container over docker exec, so it cannot
# collide with a database the developer already has on 5432/8090.
run_args=(-d --name "$NAME" -e POSTGRES_PASSWORD=postgres)
if [ -n "$PLATFORM" ]; then run_args+=(--platform "$PLATFORM"); fi
docker run "${run_args[@]}" "$IMAGE" >/dev/null

# The image's own initialization runs a socket-only temporary server first, so
# readiness is checked over TCP to be sure the real server is up rather than the
# init-time one.
#
# The budget is wall-clock, not a number of tries: under emulation both initdb
# and every pg_isready run several times slower, so a fixed try count shrinks
# the real budget exactly when the image needs more of it. A container that has
# already exited is never going to become ready, so that is failed immediately
# rather than waited out.
ready=0
deadline=$((SECONDS + SMOKE_TIMEOUT))
while [ "$SECONDS" -lt "$deadline" ]; do
  if docker exec "$NAME" pg_isready -h 127.0.0.1 -U postgres -q; then ready=1; break; fi
  if [ "$(docker inspect -f '{{.State.Running}}' "$NAME" 2>/dev/null)" != 'true' ]; then
    echo "smoke: the container exited before postgres accepted connections" >&2
    docker logs "$NAME" >&2
    exit 1
  fi
  sleep 1
done
if [ "$ready" != 1 ]; then
  echo "smoke: postgres in $IMAGE never became ready within ${SMOKE_TIMEOUT}s" >&2
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
