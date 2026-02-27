#!/bin/bash

# This script runs the integration tests that are not compatible with running concurrently (i.e. with the `--concurrency=1` flag).
# All tests tagged with 'integration' (default tag for the test tools) will be excluded from this test script.

checkLastExitCode() {
  local last_exit_code=$?
  if [ $last_exit_code -ne 0 ]; then
    exit $last_exit_code
  fi
}

# Wait for database to be up (timeout after 60 seconds)
echo "### Wait for Postgres"
/app/tests/docker/tests_integration/wait-for-it.sh postgres:5432 -t 60 -- echo "### Postgres is UP"
/app/tests/docker/tests_integration/wait-for-it.sh redis:6379 -t 60 -- echo "### Redis is UP"
echo ""

# Reset the database
echo "### Resetting database"
env PGPASSWORD="password" psql -h postgres -U postgres -d serverpod_test -f /app/tests/docker/tests_integration/reset_db.pgsql

# We apply migrations to database 
echo "### Apply migrations"
pwd
dart bin/main.dart -m production -r maintenance --apply-migrations

# Run tests
echo "### Running tests"
dart test test_integration -x integration --concurrency=1 --reporter=failures-only
checkLastExitCode
