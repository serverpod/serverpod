import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

Future<UuidValue> createAuthUser(final Session session) async {
  final authUser = await AuthUser.db.insertRow(
    session,
    AuthUser(
      created: DateTime.now(),
      scopeNames: {},
      blocked: false,
    ),
  );

  return authUser.id!;
}
