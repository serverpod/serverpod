import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as new_email_account;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart'
    as new_profile;
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as new_auth_user;

/// Migrates a user with all their authentication methods, if it hasn't already
/// been migrated.
///
/// In case the user has been migrated earlier, this method does nothing.
@internal
Future<(MigratedUser migratedUser, bool didCreate)> migrateUserIfNeeded(
  final Session session,
  final legacy_auth.UserInfo userInfo, {
  required final Transaction transaction,
}) async {
  var migratedUser = await MigratedUser.db.findFirstRow(
    session,
    where: (final t) => t.oldUserId.equals(userInfo.id!),
    transaction: transaction,
  );

  if (migratedUser != null) {
    session.log(
      'User ${userInfo.id} has already been migrated. Skipping.',
      level: LogLevel.debug,
    );

    return (migratedUser, false);
  }

  final authUser = await new_auth_user.AuthUsers.create(
    session,
    blocked: userInfo.blocked,
    scopes: userInfo.scopes,
    transaction: transaction,
  );

  await _importEmailAccounts(
    session,
    oldUserId: userInfo.id!,
    newAuthUserId: authUser.id,
    transaction: transaction,
  );

  await _importUserIdentifier(
    session,
    userInfo: userInfo,
    newAuthUserId: authUser.id,
    transaction: transaction,
  );

  if (AuthMigrations.config.importProfile) {
    await _importProfile(
      session,
      authUser.id,
      userInfo,
      transaction: transaction,
    );
  }

  migratedUser = await MigratedUser.db.insertRow(
    session,
    MigratedUser(oldUserId: userInfo.id!, newAuthUserId: authUser.id),
    transaction: transaction,
  );

  await AuthMigrations.config.userMigrationHook?.call(
    session,
    oldUserId: userInfo.id!,
    newAuthUserId: migratedUser.newAuthUserId,
    transaction: transaction,
  );

  return (migratedUser, true);
}

Future<void> _importEmailAccounts(
  final Session session, {
  required final int oldUserId,
  required final UuidValue newAuthUserId,
  required final Transaction transaction,
}) async {
  final emailAuths = await legacy_auth.EmailAuth.db.find(
    session,
    where: (final t) => t.userId.equals(oldUserId),
    transaction: transaction,
  );
  for (final emailAuth in emailAuths) {
    await new_email_account.EmailAccounts.admin.createEmailAuthentication(
      session,
      authUserId: newAuthUserId,
      email: emailAuth.email,
      password: null,
      transaction: transaction,
    );
  }
}

Future<void> _importUserIdentifier(final Session session,
    {required final legacy_auth.UserInfo userInfo,
    required final UuidValue newAuthUserId,
    required final Transaction transaction}) async {
  // We have to always import the user identifier, even if it matches the email,
  // as the legacy Google sign-in was using the email instead a "user ID".
  if (userInfo.userIdentifier.isNotEmpty) {
    await LegacyUserIdentifier.db.insertRow(
      session,
      LegacyUserIdentifier(
        newAuthUserId: newAuthUserId,
        userIdentifier: userInfo.userIdentifier,
      ),
      transaction: transaction,
    );
  }
}

Future<void> _importProfile(
  final Session session,
  final UuidValue authUserId,
  final legacy_auth.UserInfo userInfo, {
  required final Transaction transaction,
}) async {
  await new_profile.UserProfiles.createUserProfile(
    session,
    authUserId,
    new_profile.UserProfileData(
      userName: userInfo.userName,
      fullName: userInfo.fullName,
      email: userInfo.email,
    ),
    transaction: transaction,
  );

  final profileImageUrl =
      userInfo.imageUrl != null ? Uri.tryParse(userInfo.imageUrl!) : null;
  if (profileImageUrl != null) {
    try {
      await new_profile.UserProfiles.setUserImageFromUrl(
        session,
        authUserId,
        profileImageUrl,
        transaction: transaction,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed to load user image from "$profileImageUrl"',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
    }
  }
}
