#!/bin/bash

# This script runs the integration tests that are not compatible with running concurrently (i.e. with the `--concurrency=1` flag).
# All tests tagged with 'integration' (default tag for the test tools) will be excluded from this test script.

checkLastExitCode() {
  local last_exit_code=$?
  if [ $last_exit_code -ne 0 ]; then
    exit $last_exit_code
  fi
}

# Reset the database (SQLite file)
echo "### Resetting SQLite database"
rm -f sqlite_data/*.db*
echo ""

# We apply migrations to database
echo "### Apply migrations"
pwd
dart run bin/main.dart -m production -r maintenance --apply-migrations

# Run tests
echo "### Running tests"
dart test test_integration --concurrency=1 --reporter=failures-only
checkLastExitCode
