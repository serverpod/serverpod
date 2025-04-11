import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth2_server/serverpod_auth2_server.dart' as auth2;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;

/// Returns the (new) [AuthUser] ID
final Future<UuidValue?> Function(Session session, String key)
// ignore: prefer_function_declarations_over_variables
    sessionMigrationFunction = (session, key) async {
  final authInfo = await auth.authenticationHandler(session, key);

  final oldUserId = authInfo?.userId;
  if (oldUserId == null) {
    return null;
  }

  // TODO: Share look-up and migration logic
  final migratedUser = await MigratedUser.db
      .findFirstRow(session, where: (t) => t.oldUserId.equals(oldUserId));

  if (migratedUser != null) {
    return migratedUser.newUserId;
  }

  final newUserId = await auth2.Users.create(
    session,
    scopes: authInfo!.scopes.map((s) => s.name).nonNulls.toSet(),
  );

  return newUserId;
};
