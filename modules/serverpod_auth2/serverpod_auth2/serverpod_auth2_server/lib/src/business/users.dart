import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth2_server/serverpod_auth2_server.dart';

final class Users {
  /// Returns the new [AuthUser] id
  static Future<UuidValue> create(
    Session session, {
    Set<String> scopes = const {},
  }) async {
    final user = await AuthUser.db.insertRow(
      session,
      AuthUser(
        created: DateTime.now(),
        blocked: false,
        scopeNames: scopes,
      ),
    );

    return user.id!;
  }

// TODO: update scopes API
// TODO: block / unblock API
}
