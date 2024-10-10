#!/bin/bash

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
dart test test_integration --concurrency=1
checkLastExitCode

cd ../serverpod_test_module/serverpod_test_module_server/
echo $(pwd)
dart test ./test/integration
