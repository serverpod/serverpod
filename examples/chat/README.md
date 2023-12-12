# Chat example

This example showcases Serverpod's chat and auth modules. It demonstrates how to build a basic chat application with multiple chat channels.

To run the example on your local machine, make sure you have Serverpod installed on your system. Then start the Docker containers associated with the project.

```bash
cd chat/chat_server
docker compose up --build --detach
```

Use these credentials in order for the server to connect to the database:

```yaml
host: localhost
user: postgres
database: chat
password: postgres_password
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
