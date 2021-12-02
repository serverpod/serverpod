import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableEntity? object) async {
    if (object != null) {
      var data = object as SimpleData;
      session.log('${data.num}');
    }
    else {
      session.log('null');
    }
  }
}