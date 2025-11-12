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

### Google Sign-In Setup

To enable Google Sign-In, you need to set up OAuth 2.0 credentials in the
[Google Cloud Console](https://console.cloud.google.com/apis/credentials).

1. Go to the [Credentials page](https://console.cloud.google.com/apis/credentials) in the Google Cloud Console.
2. Click on "Create credentials" and select "OAuth 2.0 Client IDs".
3. Configure the consent screen as required.
4. Set the application type to "Web application" and add authorized redirect URIs.
5. Save the generated client ID and client secret, as you will need them for your Serverpod configuration.

The downloaded credentials JSON should be added to the `config/passwords.yaml` on the `googleClientSecret` field, as shown in the template file.
