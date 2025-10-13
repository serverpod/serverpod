# auth_server

This is the starting point for your Serverpod server.

To run your server, you first need to create a copy of the `template.passwords.yaml` file in the `config` directory, named `passwords.yaml`.

```bash
$ cp config/template.passwords.yaml config/passwords.yaml
```

Then you need to start Postgres and Redis. It's easiest to do with Docker.

```bash
$ cd auth/auth_server
$ docker compose up --build --detach
```

After that you can start the Serverpod server.

```bash
$ dart bin/main.dart --apply-migrations
``` 

The `--apply-migrations` flag is only needed the first time you run the server, or when you have made changes to the database schema.

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

```bash
$ docker compose stop
```

## Integrating Identity Providers

Instructions will be added here as identity providers are implemented in the example.
