import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// This is a simple example of a future call that logs a birthday reminder.
///
/// In a real-world application, you would implement the logic to send a
/// an email or a push notification to the user.
class BirthdayReminder extends FutureCall<Greeting> {
  @override
  Future<void> invoke(Session session, Greeting? object) async {
    // This is where you would implement the logic to send a birthday reminder.
    // For example, you could send an email or a notification to the user.
    // You can access the user information from the `object` parameter if needed.

    session.log('${object?.message} Remember to send a birthday card!');
  }
}
