#!/usr/bin/env bash
# Windows variant of smoke_bundle.sh (which is unix-socket only): boots the
# bundle on TCP localhost and runs the same extension + write/read battery.
# Runs under an MSYS2 bash on the CI runner.
#
# Like smoke_bundle.sh, kept out of tool/build_postgres/ on purpose: it is a
# post-build check, not a build input, so it must not perturb the build-recipe
# cache key.
set -euo pipefail

BUNDLE="${1:?usage: smoke_bundle_windows.sh <extracted-bundle-dir>}"
BIN="$BUNDLE/bin"
[ -x "$BIN/postgres.exe" ] || { echo "smoke: $BIN/postgres.exe missing" >&2; exit 1; }

export PROJ_LIB="$BUNDLE/share/proj"

WORK="$(mktemp -d)"
DATA="$WORK/data"
PORT="${SMOKE_PG_PORT:-15499}"

finish() {
  local rc=$?
  if [ "$rc" -ne 0 ] && [ -f "$DATA/server.log" ]; then
    echo "=== postgres server.log ==="; cat "$DATA/server.log"
  fi
  "$BIN/pg_ctl" -D "$DATA" -m immediate stop >/dev/null 2>&1 || true
  rm -rf "$WORK" 2>/dev/null || true
}
trap finish EXIT

echo "smoke: initdb"
"$BIN/initdb" -D "$DATA" -U postgres --auth=trust --encoding=UTF8 >/dev/null

echo "smoke: start postgres (127.0.0.1:$PORT)"
"$BIN/pg_ctl" -D "$DATA" -w -t 60 -l "$DATA/server.log" \
  -o "-p $PORT -c listen_addresses=127.0.0.1" start

run_sql() {
  "$BIN/psql" -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$PORT" -U postgres -d postgres -X -q "$@"
}

echo "smoke: load extensions + exercise the supported contract"
run_sql < "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/smoke_bundle.sql"

echo "smoke: OK -- $("$BIN/postgres" --version)"
