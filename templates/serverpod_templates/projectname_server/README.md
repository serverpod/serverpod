# projectname_server

This is the starting point for your Serverpod server.

To run your server, you first need to start Postgres and Redis. It's easiest to do with Docker.

    docker compose up --build --detach

Then you can start the Serverpod server.

    dart bin/main.dart

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

    docker compose stop

## Production Deployment

This server includes a multi-stage `Dockerfile` for building a self-contained
production image. Build and run it from the project root:

    docker build -f projectname_server/Dockerfile -t projectname_server:latest .
    docker run \
      -e runmode=production \
      -e serverid=default \
      -e logging=normal \
      -e role=monolith \
      -p 8080:8080 -p 8081:8081 -p 8082:8082 \
      projectname_server:latest

The server reads `config/production.yaml` and `config/passwords.yaml` for
database and Redis connection details. Run database migrations before starting:

    dart run bin/main.dart --apply-migrations

A ready-to-customize GitHub Actions deploy workflow is included at
`.github/workflows/deploy.yml`. Open it and uncomment the platform section
that matches your hosting provider (GCP Cloud Run, AWS ECS, or fly.io).

For managed hosting, see [Serverpod Cloud](https://serverpod.dev/cloud).
For self-hosting setup guides, see the
[Serverpod deployment documentation](https://docs.serverpod.dev/deployment).
