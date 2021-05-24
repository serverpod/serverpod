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

## Working with endpoints
Endpoints are the connection points to the server from the client. With Serverpod, you add methods to your endpoint, and your client code will be generated to make the method call. For the code to be generated, you need to place your endpoint in the endpoints directory of your server. Your endpoint should extend the `Endpoint` class. For methods to be generated, they need to return a typed `Future`, and its first argument should be a `Session` object. The `Session` object holds information about the call being made to the server and provides access to the database.

    import 'package:serverpod/serverpod.dart';

    class ExampleEndpoint extends Endpoint {
      Future<String> hello(Session session, String name) async {
        return 'Hello $name';
      }
    }

The above code will create an endpoint called `example` (the Endpoint suffix will be removed) with the single `hello` method. To generate the serverside code run `serverpod generate` in the home directory of the server.

On the client side, you can now call the method by calling:

    var result = await client.example.hello('World');

### Passing parameters
There are some limitations to how endpoint methods can be implemented. Currently named parameters are not yet supported. Parameters and return types can be of type `bool`, `int`, `double`, `String`, `DateTime`, or generated serializable objects (see next section). A typed `Future` should always be returned. Null safety is supported. When passing a `DateTime` it is always converted to UTC.

## Generating serializable classes
Serverpod makes it easy to generate serializable classes that can be passed between server and client or used to connect with the database. The structure for the classes is defined in yaml-files in the protocol directory. Run `serverpod generate` to build the Dart code for the classes and make them accessible to both the server and client.

Here is a simple example of a yaml-file defining a serializable class:

    class: Company
    fields:
      name: String
      foundedDate: DateTime?
      employees: List<Employee>

Supported types are `bool`, `int`, `double`, `String`, `DateTime`, and other serializable classes. You can also use lists of objects. Null safety is supported. Once your classes are generated, you can use them as parameters or return types to endpoint methods.

### Database mappings
It's possible to map serializable classes straight to tables in your database. To do this, add the `table` key to your yaml file:

    class: Company
    table: company
      name: String
      foundedDate: DateTime?
      employees: List<Employee>

When running `serverpod generate`, the database schema will be saved in the `generated/tables.pgsql` file. You can use this to create the corresponding database tables.

In some cases, you want to save a field to the database, but it should never be sent to the server. You can exclude it from the protocol by adding the `database` flag to the type.

    class: UserData
    fields:
      name: String
      password: String, database

Likewise, if you only want a field to be accessible in the protocol but not stored in the server, you can add the `api` flag. By default, a field is accessible to both the API and the database.

### Database indexes
For performance reasons, you may want to add indexes to your database tables. You add these in the yaml-files defining the serializable objects.

    class: Company
    table: company
      name: String
      foundedDate: DateTime?
      employees: List<Employee>
    indexes:
      company_name_idx:
        fields: name

The `fields` key holds a comma-separated list of column names. In addition, it's possible to add a type key (default is `btree`), and a `unique` key (default is `false`).
