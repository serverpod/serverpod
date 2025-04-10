import 'generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

// This is an example endpoint of your server. It's best practice to use the
// `Endpoint` ending of the class name, but it will be removed when accessing
// the endpoint from the client. I.e., this endpoint can be accessed through
// `client.example` on the client side.

// After adding or modifying an endpoint, you will need to run
// `serverpod generate` to update the server and client code.
class GreetingEndpoint extends Endpoint {
  // You create methods in your endpoint which are accessible from the client by
  // creating a public method with `Session` as its first parameter.
  // `bool`, `int`, `double`, `String`, `UuidValue`, `Duration`, `DateTime`, `ByteData`,
  // and other serializable classes, exceptions and enums from your from your `protocol` directory.
  // The methods should return a typed future; the same types as for the parameters are
  // supported. The `session` object provides access to the database, logging,
  // passwords, and information about the request being made to the server.
  Future<Greeting> hello(Session session, String name) async {
    final greeter = Greeter();
    return greeter.call(name);
  }
}

/// This is a simple class that generates a greeting message.
/// It can be configured with a custom greeting message. E.g. if reusing between
/// multiple endpoints.
/// The `call` method takes a name and returns a `Greeting` object.
/// When building endpoints, think of them as functions which take the
/// input they are called with plus anything they fetch from the database etc
/// and return a result. But they should not maintain any state between calls.
class Greeter {
  final String greeting;

  Greeter({this.greeting = 'Hello'});

  /// This method takes a name and returns a `Greeting` object.
  /// call is a special method in Dart that allows an object to be called as a function.
  /// see https://dart.dev/language/callable-objects
  Greeting call(String name) {
    return Greeting(
      message: '$greeting $name',
      author: 'Serverpod',
      timestamp: DateTime.now(),
    );
  }
}
