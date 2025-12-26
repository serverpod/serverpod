import 'package:serverpod/serverpod.dart';

class TestGeneratedCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello $name');
  }

  Future<void> bye(Session session, String name, {int code = 0}) async {
    session.log('Bye $name. Code: $code');
  }
}
