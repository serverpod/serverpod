import 'package:serverpod_test_nonvector_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BirthdayReminder extends FutureCall<Greeting> {
  @override
  Future<void> invoke(Session session, Greeting? object) async {
    session.log('${object?.message} Remember to send a birthday card!');
  }
}
