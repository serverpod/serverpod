import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TestCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableEntity? object) async {
    if (object != null) {
      SimpleData data = object as SimpleData;
      session.log('${data.num}');
    } else {
      session.log('null');
    }
  }
}
