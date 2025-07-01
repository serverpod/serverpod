# Chat example

This example showcases Serverpod's chat and auth modules. It demonstrates how to build a basic chat application with multiple chat channels.

To run the example on your local machine, make sure you have Serverpod installed on your system. Then start the Docker containers associated with the project.

```bash
cd chat/chat_server
docker compose up --build --detach
```

Then apply the database migrations to the database by running the following command from the `chat_server` directory:

```bash
dart bin/main.dart --apply-migrations -r maintenance
```

With the database tables installed, you can now start the server. Do this by running the following command from the `chat_server` directory:

```bash
dart bin/main.dart
```

Finally, start the Flutter app by changing into the `chat_flutter` directory and running the `flutter run` command:

```bash
cd chat/chat_flutter
flutter run -d chrome
```

If you want to run the example on a platform other than Chrome, you will need to run `flutter create .` to create projects for the different platforms. For MacOS, you will need to update the credentials for the app to access the server from your settings in Xcode.

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

```bash
docker compose stop
```

To completely clear all Docker containers, run:

```bash
docker compose down -v
```

If you want to connect to the local database from `pgsql` or another Postgres tool use these credentials:

```yaml
host: localhost
user: postgres
database: chat
password: postgres_password
```