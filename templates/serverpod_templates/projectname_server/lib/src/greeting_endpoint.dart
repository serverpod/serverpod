import 'generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

// This is an example endpoint of your server. It's best practice to use the
// `Endpoint` ending of the class name, but it will be removed when accessing
// the endpoint from the client. I.e., this endpoint can be accessed through
// `client.greeting` on the client side.

// After adding or modifying an endpoint, you will need to run
// `serverpod generate` to update the server and client code.

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
class GreetingEndpoint extends Endpoint {
  // This method is called when the client calls the `hello` method on the
  // `greeting` endpoint.
  //
  // The `Session` parameter contains the context of the client request.
  // It provides access to the database and other server-side resources like
  // secrets from your password file, the cache, storage, and server-event
  // messaging.
  //
  // You can use any serializable type as a parameter or return type, read more
  // in the [docs](https://docs.serverpod.dev/concepts/working-with-endpoints).

  /// Returns a personalized greeting message: "Hello {name}".
  Future<Greeting> hello(Session session, String name) async {
    return Greeting(
      message: 'Hello $name',
      author: 'Serverpod',
      timestamp: DateTime.now(),
    );
  }
}
