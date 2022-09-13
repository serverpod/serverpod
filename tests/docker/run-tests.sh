#!/bin/sh

# Makes script exit on first non-zero error code
set -e

# Wait for the server to be up (timeout after 60 seconds)
echo "### Wait for test server"
/app/tests/docker/wait-for-it.sh serverpod_test_server:8080 -t 60 -- echo "### Server main is UP"
/app/tests/docker/wait-for-it.sh serverpod_test_server:8081 -t 60 -- echo "### Server insights is UP"
echo ""

# We are all set to start the server
echo "### Running tests"
cd packages/serverpod
dart pub get
dart test test/authentication_test.dart
# dart test test/cloud_storage_s3_test.dart
dart test test/cloud_storage_test.dart
dart test test/connection_test.dart
dart test test/local_cache_test.dart
dart test test/module_test.dart
dart test test/redis_test.dart
dart test test/serialization_test.dart
dart test test/service_protocol_test.dart
dart test test/websocket_test.dart


# dart test test/authentication_test.dart
