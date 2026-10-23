#!/bin/bash
#
# Runs the installer inside a clean Ubuntu container as a regular user, with
# only the host prerequisites the installer tells people to install. Expects
# the install directory mounted at /install and the bootstrap bundle at
# /bundle/serverpod-bootstrap-linux-x64.tar.gz.

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -q
apt-get install -y -q curl git tar xz-utils ca-certificates

useradd -m dev
# shellcheck disable=SC2016 # the body runs as dev, where $HOME is theirs
su dev -c '
  set -eu
  export HOME=/home/dev SHELL=/bin/bash
  export SERVERPOD_BOOTSTRAP_BUNDLE=/bundle/serverpod-bootstrap-linux-x64.tar.gz
  cd "$HOME"
  sh /install/install.sh --yes
  sh /install/test/verify_install.sh /install/install.sh "$HOME/.bashrc"
'
