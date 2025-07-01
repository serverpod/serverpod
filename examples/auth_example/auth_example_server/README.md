# auth_example_server

This is the starting point for your Serverpod server.

To run your server, you first need to start Postgres and Redis. It's easiest to do with Docker.

```bash
$ cd auth_example/auth_example_server
$ docker compose up --build --detach
```

Use these credentials in order for the server to connect to the database:

```yaml
host: localhost
user: postgres
database: auth_example
password: 9S8rYW7XeIA8bmGY9FBzOSLwQZtQEFNr
```

Create the local `passwords.yaml` file in the server `config` directory. `auth_example/auth_example_server/config/passwords.yaml` with the following content:

```yaml
development:
  database: '9S8rYW7XeIA8bmGY9FBzOSLwQZtQEFNr'
  redis: 'V7YogaG9K2rnIpS1odXIKrqsW8kkfddt'
  serviceSecret: 'ybgnrRP6XpV7xKzLCAshHMZWBDNGSj2w'
```

Then apply the database migrations to the database by running the following command from the `auth_example_server` directory:

```bash
$ dart bin/main.dart --apply-migrations -r maintenance
```

Then you can start the Serverpod server.

```bash
$ dart bin/main.dart
```

Finally, start the Flutter app by changing into the `auth_example_flutter` directory and running the `flutter run` command:

```bash
$ cd auth_example/auth_example_flutter
$ flutter run -d chrome
```

If you want to run the example on a platform other than Chrome, you will need to run `flutter create .` to create projects for the different platforms.

If you run the app in an Android emulator, change the address to `10.0.2.2` as this is the IP address of the host machine. To access the server from a different device on the same network (such as a physical phone) replace localhost with the local ip address. You can find the local ip by running `ifconfig` (Linux/MacOS) or `ipconfig` (Windows).

Make sure to also update the publicHost in the development config to make sure the server always serves the client with the correct path to assets etc.

```yaml
# auth_example_server/config/development.yaml
apiServer:
  port: 8080
  publicHost: localhost # Change this line
  publicPort: 8080
  publicScheme: http
...
```

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

```bash
$ docker compose stop
```