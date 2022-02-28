# Working with endpoints
Endpoints are the connection points to the server from the client. With Serverpod, you add methods to your endpoint, and your client code will be generated to make the method call. For the code to be generated, you need to place your endpoint in the endpoints directory of your server. Your endpoint should extend the `Endpoint` class. For methods to be generated, they need to return a typed `Future`, and its first argument should be a `Session` object. The `Session` object holds information about the call being made and provides access to the database.

```dart
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }
}
```

The above code will create an endpoint called `example` (the Endpoint suffix will be removed) with the single `hello` method. To generate the client-side code run `serverpod generate` in the home directory of the server.

On the client side, you can now call the method by calling:

```dart
var result = await client.example.hello('World');
```

## Passing parameters
There are some limitations to how endpoint methods can be implemented. Currently named parameters are not yet supported (however, optional parameters are). Parameters and return types can be of type `bool`, `int`, `double`, `String`, `DateTime`, or generated serializable objects (see next section). A typed `Future` should always be returned. Null safety is supported. When passing a `DateTime` it is always converted to UTC.

Note: `List` and `Map` can currently not be passed as arguments, instead use a serializable object that contains the data you want to send. Support is on the roadmap and is a planned future feature.

## Return types
The return type must be a typed Future, supported return types is the same as for parameters.
