import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestExceptionCall extends FutureCall {
  Future<void> run(Session session, SimpleData? data) async {
    if (data != null) {
      session.log('${data.num}');
    } else {
      session.log('null');
    }
    throw Exception('TestExceptionCall throwing an exception');
  }
}
