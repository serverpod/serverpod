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

## Communicating with the database
___Note that the Serverpod ORM is still under heavy development, and the APIs may change.___

Serverpod makes it easy to communicate with your database using strictly typed objects without a single SQL line. But, if you need to do more complex tasks, you can always do direct SQL calls.

For the communication to work, you need to have generated serializable classes with the `table` key set, and the corresponding table must have been created in the database.

### Inserting a table row
Insert a new row in the database by calling the insert method of the `db` field in your `Session` object.

    var myRow = Company(name: 'Serverpod corp.', employees: []);
    await session.db.insert(myRow);

After the object has been inserted, it's `id` field is set from its row in the database.

### Finding a single row
You can find a single row, either by its `id` or using an expression. You need to pass a reference to the table description in the call. Table descriptions are accessible through global variables with the object's class name preceded by a `t`.

    var myCompany = await session.db.findById(tCompany, companyId) as Company?;

If no matching row is found, `null` is returned. You can also search for rows using expressions with the `where` parameter.

    var myCompany = await session.db.findSingleRow(
      tCompany,
      where: tCompany.name.equals('My Company'),
    );

### Finding multiple rows
To find multiple rows, use the same principle as for finding a single row. Returned will be a `List` of `TableRow`s. Iterate over the list to access the indivitual rows.

    var rows = await session.db.find(
      tCompany,
      where: tCompany.id < 100,
      limit 50,
    );
    var companies = rows.cast<Company>();

### Updating a row
To update a row, use the `update` method. The object that you update must have its `id` set to a non `null` value.

    var myCompany = await session.db.findById(tCompany, companyId) as Company?;
    myCompany.name = 'New name';
    await session.db.update(myCompany);

### Deleting rows
Deleting a single row works similarly to the `update` method, but you can also delete rows using the where parameter.

    // Delete a single row
    await session.db.deleteRow(myCompany);

    // Delete all rows where the company name ends with 'Ltd'
    await session.db.delete(
      where: tCompany.name.like('%Ltd'),
    );

### Creating expressions
To find or delete specific rows, most often, expressions are needed. Serverpod makes it easy to build expressions that are statically type-checked. Columns are referenced using the global `Table` objects. The table objects are named the same as the generated object classes but prefixed with a `t`. The `>`, `>=`, `<`, `<=`, `&`, and `|` operators are overridden to make it easier to work with column values. When using the operators, it's good practice to place them within a set of parentheses as the precedence rules are not always what would be expected. These are some examples of expressions.

    // The name column of the Company table equals 'My company')
    tCompany.name.equals('My company')

    // Companies founded at or after 2020
    tCompany.foundedDate >= DateTime.utc(2020)

    // Companies with number of employees between 10 and 100
    (tCompany.numEmployees > 10) & (tCompany.numEmployees <= 100)

    // Companies that has the founded date set
    tCompany.foundedDate.notEquals(null)

### Transactions and joins
Transactions and joins are still under development.

### Executing raw queries
Sometimes more advanced tasks need to be performed on the database. For those occasions, it's possible to run raw SQL queries on the database. Use the `query` method. A `List<List<dynamic>>` will be returned with rows and columns.

    var result = await session.db.query('SELECT * FROM mytable WHERE ...');

## Caching
Accessing the database can sometimes be expensive for complex database queries or if you need to run many different queries for a specific task. Serverpod makes it easy to cache frequently requested objects in RAM. Any serializable object can be cached. If your Serverpod is hosted across multiple servers in a cluster, objects can be stored in the distributed cache. When reading from the distributed cache, Serverpod will automatically figure out where it is stored. This is useful for objects that need to remain the same across servers but still can be cached.

Caches can be accessed through the `Session` object. This is an example of an endpoint method for requesting data about a user:

    Future<UserData> getUserData(Session session, int userId) async {
      // Define a unique key for the UserData object
      var cacheKey = 'UserData-$userId';

      // Try to retrieve the object from the cache
      var userData = await session.caches.local.get(cacheKey) as UserData?;

      // If the object wasn't found in the cache, load it from the database and
      // save it in the cache. Make it valid for 5 minutes.
      if (userData == null) {
        userData = session.db.findById(tUserData, userId) as UserData?;
        await session.caches.local.put(cacheKey, userData!, lifetime: Duration(minutes: 5));
      }

      // Return the user data to the client
      return userData;
    }

In total, there are four caches where you can store your objects. Two caches are local to the server handling the current session, and two are distributed across the server cluster. There are two variants for the local and distributed cache, one regular cache, and a priority cache. Place objects that are frequently accessed in the priority cache.

## Logging
Serverpod uses the database for storing logs; this makes it easy to search for errors, slow queries, or debug messages. To log custom messages during the execution of a session, use the `log` method of the `session` object. When the session is closed, either from successful execution or by failing from throwing an exception, the messages are written to the log. By default, session log entries are written for every completed session.

    session.log('This is working well');

Log entries are stored in the following tables of the database: `serverpod_log` for text messages, `serverpod_query_log` for queries, and `serverpod_session_log` for completed sessions. Optionally, it's possible to pass a log level with the message to filter out messages depending on the server's runtime settings.

## Configuration files and deployment
Serverpod has three main configuration files, depending on which mode the server is running; `development`, `staging`, or `production`. The files are located in the`config/` directory. By default, the server will start in development mode. To use another configuration file, use the `--mode` option when starting the server. If you are running multiple servers in a cluster, use the `--server-id` option to specify the id of each server. By default, the server will run as id 0. For instance, to start the server in production mode with id 2, run the following command:

dart bin/main.dart --mode production --server-id 2

Depending on how memory intensive the server is and how many requests it is serving at peak times, you may want to increase the maximum heap size Dart can use. You can do this by passing the `--old_gen_heap_size` option to dart. If you set it to `0` it will give Dart unlimited heap space. Serverpod will run on most operating systems where you can run Dart; Flutter is not required.
