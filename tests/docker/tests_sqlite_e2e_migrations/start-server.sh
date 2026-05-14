#!/bin/bash

# Reset the database (SQLite files under sqlite_data/).
# Do not rm -rf sqlite_data: it may be a Docker bind mount (device busy).
echo "### Resetting SQLite database"
rm -f sqlite_data/*.db*
echo ""

# We are all set to start the server
echo "### Starting test server"
pwd
dart run bin/main.dart -m production --apply-migrations
