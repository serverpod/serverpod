#!/bin/bash

# This script runs the integration tests that are compatible with running concurrently.
# Only tests tagged with 'integration' (default tag for the test tools) will be run in parallel
# and the rest are excluded from this job.

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
# Have to set INTEGRATION_TEST_SERVERPOD_MODE to 'test' to use the `test.yaml` config file. 
# This avoids conflicting server ports in the test files that boots up the server outside
# of a test group.
INTEGRATION_TEST_SERVERPOD_MODE=test dart test test_integration -t integration --reporter=failures-only
