import 'package:serverpod/serverpod.dart';

/// Callback to be invoked when a `serverpod_auth` `UserInfo` has been migrated
/// to a `serverpod_auth_user` `AuthUser`.
///
/// This is called only once, even if multiple authentications are migrated for
/// the user successively.
typedef UserMigrationFunction =
    Future<void> Function(
      Session session, {
      required int oldUserId,
      required UuidValue newAuthUserId,
      Transaction? transaction,
    });
