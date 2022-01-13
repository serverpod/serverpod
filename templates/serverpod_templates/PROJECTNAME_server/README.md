## This is the starting point for a Serverpod server.

To run your server, you first need to start Postgres and Redis. It's easiest to do with Docker.

    docker-compose up --build --detach

Then you can start the Serverpod server.

    dart bin/main.dart

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

    docker-compose stop
