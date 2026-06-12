# projectname_server

This is the starting point for your Serverpod server.

To run your server, you first need to start Postgres and Redis. It's easiest to do with Docker.

    docker compose up --build --detach

Then you can start the Serverpod server.

    dart bin/main.dart

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

    docker compose stop

## Production Deployment

The server is packaged as a Docker image. Build it from the **project root** (one level above this directory):

    docker build -f projectname_server/Dockerfile . -t my-image

Run the image with the four required environment variables:

    docker run -d \
      -e runmode=production \
      -e serverid=default \
      -e logging=normal \
      -e role=monolith \
      -p 8080:8080 -p 8081:8081 -p 8082:8082 \
      my-image

Before the first run, apply database migrations:

    docker run --rm -e runmode=production my-image --apply-migrations

For cloud-specific deployment guides (GCP Cloud Run, AWS ECS, fly.io, and others), see the [Serverpod deployment documentation](https://docs.serverpod.dev).
