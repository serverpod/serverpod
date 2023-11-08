#!/bin/sh

# Makes script exit on first non-zero error code
set -e

# Install the serverpod command
echo "### Installing CLI tools"

export PATH="$PATH":"$HOME/.pub-cache/bin"

export SERVERPOD_HOME=$(pwd)
echo "### Serverpod home: $SERVERPOD_HOME"

cd tools/serverpod_cli
dart pub global activate -s path .
cd ../..

# Wait for the server to be up (timeout after 60 seconds)
echo "### Wait for test server"
/app/tests/docker/tests_e2e_migrations/wait-for-it.sh serverpod_test_server:8080 -t 60 -- echo "### Server main is UP"
/app/tests/docker/tests_e2e_migrations/wait-for-it.sh serverpod_test_server:8081 -t 60 -- echo "### Server insights is UP"
echo ""

# We are all set to start the server
echo "### Running integration tests"
cd tests/serverpod_test_server
dart pub get
dart test test_e2e_migrations --concurrency=1