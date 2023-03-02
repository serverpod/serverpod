#!/bin/sh

# Makes script exit on first non-zero error code
set -e

echo "### Run CLI tests"

# Install the serverpod command
echo "### Installing CLI tools"

export PATH="$PATH":"$HOME/.pub-cache/bin"

export SERVERPOD_HOME=$(pwd)
echo "### Serverpod home: $SERVERPOD_HOME"

# Verify that template directory exists
TEMPLATE_DIR="$SERVERPOD_HOME/templates/serverpod_templates"
echo "### Templates at: $TEMPLATE_DIR"
test -d $TEMPLATE_DIR

cd tools/serverpod_cli
dart pub global activate -s path .
cd ../..

# Create temporary directory for testing
echo "### Creating test directory"
cd tests

rm -rf temp
mkdir temp
cd temp

echo "### Running serverpod create"
# Configure Serverpod home directory (required for templates)

# Create test project
serverpod create cli_test

# Verify that key files exists
echo "### Verifying that created files exists"
test -d cli_test/cli_test_server
test -d cli_test/cli_test_client
test -d cli_test/cli_test_flutter

# Server files
test -f cli_test/cli_test_server/pubspec.yaml
test -f cli_test/cli_test_server/.gitignore
test -f cli_test/cli_test_server/lib/server.dart
test -f cli_test/cli_test_server/lib/src/endpoints/example_endpoint.dart
test -f cli_test/cli_test_server/lib/src/generated/endpoints.dart
test -f cli_test/cli_test_server/lib/src/generated/example.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_server/lib/src/generated/serverOnly/default_server_only_class.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_server/lib/src/generated/serverOnly/default_server_only_enum.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_server/lib/src/generated/serverOnly/not_server_only_class.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_server/lib/src/generated/serverOnly/not_server_only_enum.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_server/lib/src/generated/serverOnly/server_only_class.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_server/lib/src/generated/serverOnly/server_only_enum.dart

# Client files
test -f cli_test/cli_test_client/pubspec.yaml
test -f cli_test/cli_test_client/lib/cli_test_client.dart
test -f cli_test/cli_test_client/lib/src/protocol/client.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_client/lib/src/protocol/serverOnly/default_server_only_class.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_client/lib/src/protocol/serverOnly/default_server_only_enum.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_client/lib/src/protocol/serverOnly/not_server_only_class.dart
test -f $SERVERPOD_HOME/tests/serverpod_test_client/lib/src/protocol/serverOnly/not_server_only_enum.dart
[ ! -f $SERVERPOD_HOME/tests/serverpod_test_client/lib/src/protocol/serverOnly/server_only_class.dart ]
[ ! -f $SERVERPOD_HOME/tests/serverpod_test_client/lib/src/protocol/serverOnly/server_only_enum.dart ]

# Flutter files
test -f cli_test/cli_test_flutter/pubspec.yaml
test -f cli_test/cli_test_flutter/lib/main.dart

echo "### Removing generated files"
rm -f cli_test/cli_test_server/lib/src/generated/*.dart
rm -f cli_test/cli_test_client/lib/src/protocol/*.dart

echo "### Running serverpod generate"
cd cli_test/cli_test_server
serverpod generate
cd ../..

echo "### Verifying that generated files exists"
test -f cli_test/cli_test_client/lib/src/protocol/client.dart
test -f cli_test/cli_test_server/lib/src/generated/endpoints.dart
test -f cli_test/cli_test_server/lib/src/generated/example.dart

echo "### Cleaning up"
cd ..
# rm -rf temp
