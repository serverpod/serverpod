#!/bin/sh
#
# Serverpod installer: Flutter if needed, the Serverpod CLI, and a PATH setup.
#
#   curl -fsSL https://serverpod.dev/install.sh | sh
#   curl -fsSL https://serverpod.dev/install.sh | sh -s -- --yes
#
# Supports macOS on Apple silicon and Linux on x86_64 (Ubuntu LTS is what we
# test). Nothing outside ~/.serverpod is written except one line in your
# shell startup file, and that is asked about first.
#
# Environment overrides, mainly for CI:
#   SERVERPOD_INSTALL_YES=1          same as --yes
#   SERVERPOD_INSTALL_DIR=<dir>      instead of ~/.serverpod
#   SERVERPOD_BOOTSTRAP_BUNDLE=<tar> a local bootstrap bundle to use instead
#                                    of downloading the released one

set -eu

# --- Pinned versions. The release workflow reads these; bump them together. ---
BOOTSTRAP_TAG="install-v1"
FLUTTER_VERSION="3.47.7"
FLUTTER_SHA256_LINUX_X64="af7455f540df951184c7953fbe3cf884766e7541dacf8571f9f582db03dd6230"
FLUTTER_SHA256_MACOS_ARM64="dd9da574c3168460550117eb0e8dd0313ae934fabf64a82a6d557fff5fd1422e"
# -----------------------------------------------------------------------------

BOOTSTRAP_RELEASE="https://github.com/serverpod/serverpod/releases/download/$BOOTSTRAP_TAG"
FLUTTER_RELEASES="https://storage.googleapis.com/flutter_infra_release/releases/stable"

INSTALL_DIR="${SERVERPOD_INSTALL_DIR:-$HOME/.serverpod}"
ASSUME_YES="${SERVERPOD_INSTALL_YES:-0}"

info() { printf '%s\n' "$*" >&2; }
fail() { printf 'error: %s\n' "$*" >&2; exit 1; }

for arg in "$@"; do
  case "$arg" in
    -y|--yes) ASSUME_YES=1 ;;
    -h|--help) sed -n '3,17p' "$0" 2>/dev/null | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) fail "unknown option: $arg" ;;
  esac
done

# --- Platform -----------------------------------------------------------------

case "$(uname -s)/$(uname -m)" in
  Linux/x86_64)
    PLATFORM="linux-x64"
    FLUTTER_ARCHIVE="linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
    FLUTTER_SHA256="$FLUTTER_SHA256_LINUX_X64"
    ;;
  Darwin/arm64)
    PLATFORM="macos-arm64"
    FLUTTER_ARCHIVE="macos/flutter_macos_arm64_${FLUTTER_VERSION}-stable.zip"
    FLUTTER_SHA256="$FLUTTER_SHA256_MACOS_ARM64"
    ;;
  *)
    fail "$(uname -s) on $(uname -m) is not supported yet. See https://docs.serverpod.dev/installation for manual setup."
    ;;
esac

# --- Host prerequisites -------------------------------------------------------

missing=""
for tool in curl git tar; do
  command -v "$tool" >/dev/null 2>&1 || missing="$missing $tool"
done
case "$PLATFORM" in
  linux-*) command -v xz >/dev/null 2>&1 || missing="$missing xz" ;;
  macos-*) command -v unzip >/dev/null 2>&1 || missing="$missing unzip" ;;
esac
if [ -n "$missing" ]; then
  info "Missing:$missing"
  case "$PLATFORM" in
    linux-*) info "Install them first, for example:"; info "  sudo apt-get install -y curl git tar xz-utils" ;;
    macos-*) info "Install the Xcode command line tools first:"; info "  xcode-select --install" ;;
  esac
  exit 1
fi

sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

verify_sha256() {
  actual="$(sha256_of "$1")"
  [ "$actual" = "$2" ] || fail "checksum mismatch for $(basename "$1"): expected $2, got $actual"
}

# --- Approval -----------------------------------------------------------------

info "Serverpod installer"
info ""
info "This will:"
info "  - download the Serverpod bootstrap tool to a temporary directory"
info "  - install Flutter $FLUTTER_VERSION to $INSTALL_DIR/flutter if none is found"
info "  - run \`dart install serverpod_cli\`"
info "  - write $INSTALL_DIR/env.sh and source it from your shell startup file"
info ""
if [ "$ASSUME_YES" != "1" ]; then
  if [ -r /dev/tty ]; then
    printf 'Continue? [y/N] ' >&2
    read -r answer < /dev/tty
  else
    fail "no terminal to ask on. Re-run with --yes to approve."
  fi
  case "$answer" in
    y|Y|yes|YES) ;;
    *) info "Nothing changed."; exit 1 ;;
  esac
fi

# --- Bootstrap bundle ---------------------------------------------------------

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

bootstrap_dir="$tmp/bootstrap"
mkdir -p "$bootstrap_dir"
bundle="${SERVERPOD_BOOTSTRAP_BUNDLE:-}"
if [ -z "$bundle" ]; then
  bundle="$tmp/serverpod-bootstrap-$PLATFORM.tar.gz"
  info "Downloading the Serverpod bootstrap tool..."
  curl -fsSL "$BOOTSTRAP_RELEASE/serverpod-bootstrap-$PLATFORM.tar.gz" -o "$bundle"
  curl -fsSL "$BOOTSTRAP_RELEASE/serverpod-bootstrap-$PLATFORM.tar.gz.sha256" -o "$bundle.sha256"
  verify_sha256 "$bundle" "$(tr -d ' \n' < "$bundle.sha256")"
fi
tar -xzf "$bundle" -C "$bootstrap_dir"
bootstrap="$bootstrap_dir/bin/serverpod_cli"
[ -x "$bootstrap" ] || fail "the bootstrap bundle has no bin/serverpod_cli"

# --- Flutter ------------------------------------------------------------------

# What doctor reports for Flutter on this PATH. The JSON key order is fixed by
# the CLI (schemaVersion 1), so a sed is enough without jq.
flutter_status() {
  "$bootstrap" doctor --json --no-analytics 2>/dev/null |
    sed -n 's/.*"id": *"flutter", *"title": *"Flutter", *"status": *"\([a-z]*\)".*/\1/p'
}

managed_flutter="$INSTALL_DIR/flutter"
if [ -x "$managed_flutter/bin/flutter" ]; then
  # A previous run installed it; a new shell would already have it on PATH.
  PATH="$managed_flutter/bin:$PATH"
fi

status="$(flutter_status || true)"
case "$status" in
  ready)
    info "Using the Flutter already on your PATH."
    ;;
  missing)
    info "Downloading Flutter $FLUTTER_VERSION..."
    archive="$tmp/$(basename "$FLUTTER_ARCHIVE")"
    curl -fSL --progress-bar "$FLUTTER_RELEASES/$FLUTTER_ARCHIVE" -o "$archive"
    verify_sha256 "$archive" "$FLUTTER_SHA256"
    info "Installing Flutter to $managed_flutter..."
    mkdir -p "$INSTALL_DIR"
    rm -rf "$managed_flutter"
    case "$archive" in
      *.zip) unzip -q "$archive" -d "$INSTALL_DIR" ;;
      *) tar -xJf "$archive" -C "$INSTALL_DIR" ;;
    esac
    PATH="$managed_flutter/bin:$PATH"
    info "Setting up Flutter (this downloads its Dart SDK once)..."
    flutter --version >/dev/null
    ;;
  *)
    "$bootstrap" doctor --no-analytics || true
    fail "fix Flutter first, then run this installer again."
    ;;
esac

# --- Serverpod CLI ------------------------------------------------------------

info "Installing the Serverpod CLI with \`dart install serverpod_cli\`..."
dart install serverpod_cli

# --- PATH setup and verification ----------------------------------------------

info ""
"$bootstrap" doctor --fix --yes --no-analytics
info ""
info "Open a new terminal, then create your first project with:"
info "  serverpod create my_project"
