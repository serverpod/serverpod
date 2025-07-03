import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_server/serverpod_auth_email_server.dart'
    as new_email;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';

/// Email account endpoint base class which automatically migrates accounts.
abstract class MigratingEmailEndpointBase
    extends new_email.EmailAccountEndpoint {
  @override
  Future<new_email.AuthSuccess> login(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    await AuthMigrationEmail.migrateWithPassword(
      session,
      email: email,
      password: password,
    );

    return super.login(session, email: email, password: password);
  }

  @override
  Future<void> startRegistration(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    await AuthMigrationEmail.migrateWithPassword(
      session,
      email: email,
      password: password,
    );

    return super.startRegistration(session, email: email, password: password);
  }

  @override
  Future<void> startPasswordReset(
    final Session session, {
    required final String email,
  }) async {
    await AuthMigrationEmail.migrateWithoutPassword(session, email: email);

    return super.startPasswordReset(session, email: email);
  }
}
