#!/bin/sh
#
# Checks what install.sh leaves behind, then runs it again to prove a rerun
# changes nothing. Run as the user who ran the installer, with the same
# SERVERPOD_BOOTSTRAP_BUNDLE override.
#
#   tools/serverpod_cli/install/test/verify_install.sh <install.sh> <startup-file>

set -eu

script="${1:?path to install.sh}"
startup="${2:?shell startup file the installer should have edited}"
env_file="$HOME/.serverpod/env.sh"

fail() { printf 'verify: %s\n' "$*" >&2; exit 1; }

[ -f "$env_file" ] || fail "$env_file was not written"
# shellcheck source=/dev/null
. "$env_file"

serverpod_on_path="$(command -v serverpod || true)"
case "$serverpod_on_path" in
  */install/bin/*) ;;
  *) fail "serverpod on PATH is not the dart install one: '$serverpod_on_path'" ;;
esac

echo "verify: doctor passes with the new PATH"
serverpod doctor --no-analytics

echo "verify: a project can be created"
project_dir="$(mktemp -d)"
(cd "$project_dir" && serverpod create ci_project --template server --no-interactive --no-analytics)
[ -f "$project_dir/ci_project/ci_project_server/pubspec.yaml" ] || fail "serverpod create left no server package"

echo "verify: a rerun changes nothing"
env_before="$(cat "$env_file")"
startup_before="$(cat "$startup")"
sh "$script" --yes
[ "$env_before" = "$(cat "$env_file")" ] || fail "the rerun rewrote $env_file differently"
[ "$startup_before" = "$(cat "$startup")" ] || fail "the rerun changed $startup"
# shellcheck disable=SC2016 # the literal $HOME is what the installer writes
lines="$(grep -c '\. "\$HOME/.serverpod/env.sh"' "$startup" || true)"
[ "$lines" = "1" ] || fail "expected one source line in $startup, found $lines"

echo "verify: ok"
