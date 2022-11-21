# Chat example
This example showcases Serverpod's chat and auth modules. It demonstrates how to build a basic chat application with multiple chat channels.

To run the example on your local machine, make sure you have Serverpod installed on your system. Then start the Docker containers associated with the project.

```bash
cd chat/chat_server
docker-compose up --build --detach
```

Now, you need to add the required database tables to your docker container, which is running Postgres. You must add the tables from the chat module, the auth module, and the chat example itself. You can find the SQL code to do so here:

[Chat module tables](https://github.com/serverpod/serverpod/blob/main/modules/serverpod_chat/serverpod_chat_server/generated/tables.pgsql)
[Auth module tables](https://github.com/serverpod/serverpod/blob/main/modules/serverpod_auth/serverpod_auth_server/generated/tables.pgsql)
[Chat example tables](https://github.com/serverpod/serverpod/blob/main/examples/chat/chat_server/generated/tables-serverpod.pgsql)

Connect to the database with the following credentials:

```yaml
host: localhost
user: postgres
database: chat
password: database_password
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

If you want to run the example on a platform other than Chrome, you will need to run `flutter create .` to create projects for the different platforms.
