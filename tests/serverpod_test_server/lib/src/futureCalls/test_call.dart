import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestCall extends FutureCall {
  Future<void> run(Session session, SimpleData data) async {
    session.log('${data.num}');
  }
}
