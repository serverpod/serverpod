#!/bin/bash
#
# Builds the bootstrap bundle install.sh downloads: this checkout's
# serverpod_cli built with `dart build cli` in production mode, packed as
# serverpod-bootstrap-<platform>.tar.gz with a sha256 sidecar.
#
#   tools/serverpod_cli/install/build_bootstrap.sh <linux-x64|macos-arm64> <out-dir>
#
# Run from the repository root with a Dart SDK on PATH. Rewrites the
# workspace pubspecs for production mode, as the publish workflow does.

set -euo pipefail

platform="${1:?platform, such as linux-x64}"
out="${2:?output directory}"

if [ ! -f util/.serverpod_util_root ]; then
  echo "Run this script from the root of the Serverpod repository." >&2
  exit 1
fi

export SERVERPOD_HOME="$PWD"

(cd tools/serverpod_cli && dart pub get)
dart tools/serverpod_cli/bin/serverpod_cli.dart generate-pubspecs \
  --version "$(cat SERVERPOD_VERSION)" \
  --dart-version "$(cat DART_VERSION)" \
  --flutter-version "$(cat FLUTTER_VERSION)" \
  --mode production

build="$(mktemp -d)"
trap 'rm -rf "$build"' EXIT
(
  cd tools/serverpod_cli
  dart pub get
  # Not `dart compile exe`: sqlite3's native-asset build hooks need `build cli`.
  dart build cli -t bin/serverpod_cli.dart -o "$build"
)

mkdir -p "$out"
archive="$out/serverpod-bootstrap-$platform.tar.gz"
tar -C "$build/bundle" -czf "$archive" .
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$archive" | cut -d' ' -f1 > "$archive.sha256"
else
  shasum -a 256 "$archive" | cut -d' ' -f1 > "$archive.sha256"
fi

echo "Built $archive ($(du -h "$archive" | cut -f1))"
