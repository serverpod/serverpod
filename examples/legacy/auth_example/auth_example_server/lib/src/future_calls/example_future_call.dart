import 'package:serverpod/serverpod.dart';

// Future calls are calls that will be invoked at a later time. An example is if
// you want to send a drip-email campaign after a user signs up. You can
// schedule a future call for a day, a week, or a month. The calls are stored in
// the database, so they will persist even if the server is restarted.
//
//  Declare a class that extends `FutureCall` with public `Future<void>`
//  methods that take a `Session` as their first parameter. Type-safe methods
//  for scheduling the calls are generated when running `serverpod generate`.
//  Schedule a call using the `session.serverpod.futureCalls.callWithDelay`
//  or `session.serverpod.futureCalls.callAtTime` methods.

class ExampleFutureCall extends FutureCall {
  Future<void> doSomething(Session session) async {
    // Do something interesting in the future here.
  }
}
