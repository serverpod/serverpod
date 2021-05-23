# Serverpod

Serverpod is a next-generation app and web server, explicitly built for the Flutter and Dart ecosystem. It allows you to write your server-side code in Dart, automatically generate your APIs, and hook up your database with minimal effort. Serverpod is open-source, and you can host your server anywhere.

___Please note that Serverpod is still in early-stage development, and things may frequently change over the next few months.___

Every design decision made in Serverpod aims to minimize the amount of code that needs to be written and make it as readable as possible. Apart from being just a server, Serverpod incorporates many common tasks that are otherwise cumbersome to implement or require external services.

- Serverpod will automatically generate the protocol and client-side code by analyzing your server. Calling a remote endpoint is as easy as making a local method call — no more deciphering and parsing REST API responses.
- Connecting the database has never been easier. Database rows are represented by typed Dart classes and can even be serialized and sent directly to the client.
- Need to perform a task at a specific time in the future? Serverpod supports future calls that are persistent even if you need to restart the server.
- Caching and scaling are made simple. Commonly requested objects can be cached locally on a single server or distributed over a cluster of servers.

## Installing Serverpod
Serverpod is tested on Mac and Linux but may work on other platforms too. Before you can install Serverpod, you need to the following tools installed:
- __Flutter__ and __Dart__. Serverpod is technically only using Dart, but most use cases include writing a client in Flutter. You will need Dart version 2.12 or later. https://flutter.dev/docs/get-started/install
- __Postgresql__. Using a Postgresql database with Serverpod is not optional as many of the core features need the database to operate. Postgresql version 13 is recommended. https://www.postgresql.org/download/

Once you have Dart installed and configured, open up a terminal and install Serverpod by running:

    dart pub global activate serverpod_cli

Now test the install by running:

    serverpod

If everything is correctly configured, the help for the serverpod command is now displayed.

## Creating your first project
To get your local server up and running, you need to create a new Serverpod project and configure the database. Create a new project by running `serverpod create`.

    serverpod create mypod

This command will create a new directory called `mypod`, with two dart packages inside; `mypod_server` and `mypod_client`.

- `mypod_server`: This package contains your server-side code. Modify it to add new endpoints or other features your server needs.
- `mypod_client`: This is the code needed to communicate with the server. Typically, all code in this package is generated automatically, and you should not edit the files in this package.

### Connect the database
Now that the project has been created, you need to hook it up with the database. Open the `mypod_server` package in your favorite IDE. Edit the `config/development.yaml` file and replace `DATABASE_NAME` and `DATABASE_USER` with the database name and the user name required to connect to the database. You most likely set this up when you installed your Postgresql database. Open `config/passwords.yaml` and replace the `DATABASE_PASSWORD` with the password for the database.

### Create the default set of tables
Finally, you need to populate the database with some tables that Serverpod uses internally. To do this, connect to your database and run the queries [found here](https://github.com/serverpod/serverpod/blob/master/packages/serverpod/generated/tables.pgsql).

### Start the server
Now you should be all set to run your server. Start it by changing into the mypod_server directory and type:

    dart pub get
    dart bin/main.dart

If everything is working you should see something like this on your terminal:

    Mode: development
    Config loaded from: config/development.yaml
    port: 8080
    database host: localhost
    database port: 5432
    database name: mydatabase
    database user: myusername
    database pass: ********
    Insights listening on port 8081
    Server id 0 listening on port 8080
