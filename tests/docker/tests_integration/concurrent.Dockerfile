# Specify the Dart SDK base image version
FROM dart:3.5.0 AS build

# Install psql client.
RUN apt-get update && apt-get install -y postgresql-client

# Set the working directory
WORKDIR /app

# Copy the whole serverpod repo into the container.
COPY . .

WORKDIR /app/tests/serverpod_test_server
RUN dart pub get

# Setup database tables.
CMD ["../docker/tests_integration/run_tests_concurrently.sh"]
