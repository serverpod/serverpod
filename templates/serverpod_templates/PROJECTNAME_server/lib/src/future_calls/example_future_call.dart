import 'package:serverpod/serverpod.dart';

// Future calls are calls that will be invoked at a later time. An example is if
// you want to send a drip-email campaign after a user signs up. You can
// schedule a future call for a day, a week, or a month. The calls are stored in
// the database, so they will persist even if the server is restarted.
//
//  To add a future call to your server, you need to register it in the
//  `server.dart` file. Schedule the call using the
//  `session.server.futureCallWithDelay` or `session.server.futureCallAtTime`
//  methods. You can optionally pass a serializable object together with the
//  call.

class ExampleFutureCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableEntity? object) async {
    // Do something interesting in the future here.
  }
}
