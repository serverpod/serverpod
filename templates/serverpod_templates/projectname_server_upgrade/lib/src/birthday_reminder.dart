import 'package:projectname_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// This is a simple example of a future call that sends a birthday reminder.
class BirthdayReminder extends FutureCall<Greeting> {
  @override
  Future<void> invoke(Session session, Greeting? object) async {
    // This is where you would implement the logic to send a birthday reminder.
    // For example, you could send an email or a notification to the user.
    // You can access the user information from the `object` parameter if needed.

    session.log('${object?.message} Remember to send a birthday card!');
  }
}
