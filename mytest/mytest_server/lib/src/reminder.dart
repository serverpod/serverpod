import 'package:serverpod/serverpod.dart';

class Reminder extends FutureCall {
  Future<void> hello(Session session) async {
    session.log('Hello!');
  }

  Future<void> delayedHello(Session session) async {
    session.log('Waiting for 2 minutes!');
    await Future.delayed(const Duration(minutes: 2));
    session.log('Delayed Hello!');
  }

  Future<void> bye(Session session) async {
    session.log('Bye!');
  }

  Future<void> delayedBye(Session session) async {
    session.log('Waiting for 1 minute!');
    await Future.delayed(const Duration(minutes: 1));
    session.log('Delayed Bye!');
  }
}
