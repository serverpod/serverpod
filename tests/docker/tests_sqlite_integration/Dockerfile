# Dart SDK from the official image.
FROM dart:3.10.3 AS dart-sdk
FROM ubuntu:24.04 AS build

# Use Ubuntu 24.04 as base image to ensure SQLite >= 3.41.0 is available.
COPY --from=dart-sdk /usr/lib/dart /usr/lib/dart
ENV PATH="/usr/lib/dart/bin:${PATH}"

# Install SQLite.
RUN apt-get update && apt-get install -y libsqlite3-dev

# Set the working directory.
WORKDIR /app

# Copy the whole serverpod repo into the container.
COPY . .

# Install dependencies.
WORKDIR /app/tests/serverpod_test_sqlite/serverpod_test_sqlite_server
RUN dart pub get

# Setup database tables and start the server.
CMD ["../../docker/tests_sqlite_integration/run_tests.sh"]
