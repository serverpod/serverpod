import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth2_server/serverpod_auth2_server.dart' as auth2;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

// shared with type in `EmailAccountConfig` (could even use symlinks or similar for the import functions)
typedef ExistingUserImportFunction = Future<UuidValue?> Function(
  Session session, {
  required String email,
  required String password,
});

// ignore: prefer_function_declarations_over_variables
final ExistingUserImportFunction emailAccountImportFunction = (
  session, {
  required email,
  required password,
}) async {
  final authInfo = await Emails.authenticate(session, email, password);

  if (!authInfo.success) {
    throw 'not found'; // discern between does not exist and does not work?
  }

  final oldUserId = authInfo.userInfo!.id!;

  final migratedUser = await MigratedUser.db
      .findFirstRow(session, where: (t) => t.oldUserId.equals(oldUserId));

  if (migratedUser != null) {
    return migratedUser.newUserId;
  }

  final newUserId = await auth2.Users.create(
    session,
    scopes: authInfo.userInfo!.scopeNames.toSet(),
  );

  return newUserId;
};
