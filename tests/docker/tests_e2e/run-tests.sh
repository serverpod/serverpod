#!/bin/bash

# Makes script exit on first non-zero error code
set -e

param=${1:-vm}

# Wait for the server to be up (timeout after 60 seconds)
echo "### Wait for test server"
/app/tests/docker/tests_e2e/wait-for-it.sh serverpod_test_server:8080 -t 60 -- echo "### Server main is UP"
/app/tests/docker/tests_e2e/wait-for-it.sh serverpod_test_server:8081 -t 60 -- echo "### Server insights is UP"
echo ""

echo "### Running e2e tests"
cd tests/serverpod_test_server
echo "dart test test_e2e --concurrency=1 -p $param"
xvfb-run -a dart test test_e2e --concurrency=1 -p $param --reporter=failures-only
