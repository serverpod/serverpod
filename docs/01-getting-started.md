# Getting started
Serverpod is an open-source, scalable app server, written in Dart for the Flutter community. Serverpod automatically generates your protocol and client-side code by analyzing your server. Calling a remote endpoint is as easy as making a local method call.

## Installing Serverpod
Serverpod is tested on Mac and Linux (Mac recommended), support for Windows is in the works. Before you can install Serverpod, you need to the following tools installed:
- __Flutter__ and __Dart__. You will need Flutter version 2.10 or later. https://flutter.dev/docs/get-started/install
- __Docker__. Docker is used to manage Postgres and Redis. https://docs.docker.com/desktop/mac/install/

Once you have Flutter and Docker installed and configured, open up a terminal and install Serverpod by running:

```sh
dart pub global activate serverpod_cli
```

Now test the install by running:

```sh
serverpod
```

If everything is correctly configured, the help for the serverpod command is now displayed.

## Creating your first project
To get your local server up and running, you need to create a new Serverpod project. Make sure that Docker Desktop is running, then create a new project by running `serverpod create`.

```sh
serverpod create mypod
```

This command will create a new directory called `mypod`, with three dart packages inside; `mypod_server`, `mypod_client`, and `mypod_flutter`.

- `mypod_server`: This package contains your server-side code. Modify it to add new endpoints or other features your server needs.
- `mypod_client`: This is the code needed to communicate with the server. Typically, all code in this package is generated automatically, and you should not edit the files in this package.
- `mypod_flutter`: This is the Flutter app, pre-configured to connect to your local server.

### Starting Postgres and Redis
The Serverpod server needs access to a Postgres database and Redis to run. When running `serverpod create` the database was configured with a default set of tables. To start Postgres and Redis `cd` into `mypod_server`, then run.

```sh
docker-compose up -d --build
```

This will build and start a set of Docker containers and give access to Postgres and Redis. If you need to stop the containers at some point, just run `docker-compose stop`.

### Start the server
Now you should be all set to run your server. Start it by changing into the `mypod_server` directory and type:

```sh
dart bin/main.dart
```

If everything is working you should see something like this on your terminal:

```
Mode: development
Config loaded from: config/development.yaml
api port: 8080
service port: 8081
postgres host: localhost
postgres port: 8090
postgres name: serverpod_test
postgres user: postgres
postgres pass: ********
redis host: localhost
redis port: 8091
redis pass: ********
Insights listening on port 8081
Server id 0 listening on port 8080
```
