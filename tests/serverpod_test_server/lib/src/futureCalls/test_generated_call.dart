import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestGeneratedCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello $name');
  }

  Future<void> bye(Session session, String name, {int code = 0}) async {
    session.log('Bye $name. Code: $code');
  }

  /// A sample future call that logs data.
  Future<void> logData(Session session, SimpleData data) async {
    session.log('${data.num}');
  }
}
