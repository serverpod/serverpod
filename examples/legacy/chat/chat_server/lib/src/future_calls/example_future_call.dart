import 'package:serverpod/serverpod.dart';

// Future calls are calls that will be invoked at a later time. An example is if
// you want to send a drip-email campaign after a user signs up. You can
// schedule a future call for a day, a week, or a month. The calls are stored in
// the database, so they will persist even if the server is restarted.
//
//  Schedule the call using the `session.serverpod.futureCalls.callWithDelay`
//  or `session.serverpod.futureCalls.callAtTime` methods. You can optionally
//  pass a serializable object together with the call.

class ExampleFutureCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    // Do something interesting in the future here.
  }
}
