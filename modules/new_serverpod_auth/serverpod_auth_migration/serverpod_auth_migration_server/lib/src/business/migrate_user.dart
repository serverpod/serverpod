import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_core_server/auth_user.dart' as new_auth_user;
import 'package:serverpod_auth_core_server/profile.dart' as new_profile;
import 'package:serverpod_auth_idp_server/providers/email.dart' as auth_next;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;

/// Migrates a user with all their authentication methods, if it hasn't already
/// been migrated.
///
/// In case the user has been migrated earlier, this method does nothing.
@internal
Future<(MigratedUser migratedUser, bool didCreate)> migrateUserIfNeeded(
  final Session session,
  final legacy_auth.UserInfo userInfo, {
  required final Transaction transaction,
  required final auth_next.EmailIDP newEmailIDP,
  final new_auth_user.AuthUsers authUsers = const new_auth_user.AuthUsers(),
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

  final authUser = await authUsers.create(
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
    newEmailIDP: newEmailIDP,
  );

  await _importUserIdentifier(
    session,
    userInfo: userInfo,
    newAuthUserId: authUser.id,
    transaction: transaction,
  );

  if (AuthMigrations.config.importSessions) {
    await _importSessions(
      session,
      oldUserId: userInfo.id!,
      newAuthUserId: authUser.id,
      transaction: transaction,
    );
  }

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

  return (migratedUser, true);
}

Future<void> _importEmailAccounts(
  final Session session, {
  required final int oldUserId,
  required final UuidValue newAuthUserId,
  required final Transaction transaction,
  required final auth_next.EmailIDP newEmailIDP,
}) async {
  final emailAuths = await legacy_auth.EmailAuth.db.find(
    session,
    where: (final t) => t.userId.equals(oldUserId),
    transaction: transaction,
  );
  for (final emailAuth in emailAuths) {
    final newEmailAccountId = await newEmailIDP.admin.createEmailAuthentication(
      session,
      authUserId: newAuthUserId,
      email: emailAuth.email,
      password: null,
      transaction: transaction,
    );

    await AuthBackwardsCompatibility.storeLegacyPassword(
      session,
      emailAccountId: newEmailAccountId,
      passwordHash: emailAuth.hash,
      transaction: transaction,
    );
  }
}

Future<void> _importSessions(
  final Session session, {
  required final int oldUserId,
  required final UuidValue newAuthUserId,
  required final Transaction transaction,
}) async {
  final authKeys = await legacy_auth.AuthKey.db.find(
    session,
    where: (final t) => t.userId.equals(oldUserId),
    transaction: transaction,
  );

  for (final authKey in authKeys) {
    await AuthBackwardsCompatibility.storeLegacySession(
      session,
      authUserId: newAuthUserId,
      scopeNames: authKey.scopeNames,
      sessionKeyHash: authKey.hash,
      method: authKey.method,
      transaction: transaction,
    );
  }
}

Future<void> _importUserIdentifier(
  final Session session, {
  required final legacy_auth.UserInfo userInfo,
  required final UuidValue newAuthUserId,
  required final Transaction transaction,
}) async {
  // We have to always import the user identifier, even if it matches the email,
  // as the legacy Google sign-in was using the email instead a "user ID".
  if (userInfo.userIdentifier.isNotEmpty) {
    await AuthBackwardsCompatibility.storeLegacyExternalUserIdentifier(
      session,
      authUserId: newAuthUserId,
      userIdentifier: userInfo.userIdentifier,
      transaction: transaction,
    );
  }
}

Future<void> _importProfile(
  final Session session,
  final UuidValue authUserId,
  final legacy_auth.UserInfo userInfo, {
  required final Transaction transaction,
  final new_profile.UserProfiles userProfiles =
      const new_profile.UserProfiles(),
}) async {
  await userProfiles.createUserProfile(
    session,
    authUserId,
    new_profile.UserProfileData(
      userName: userInfo.userName,
      fullName: userInfo.fullName,
      email: userInfo.email,
    ),
    transaction: transaction,
  );

  final profileImageUrl = userInfo.imageUrl != null
      ? Uri.tryParse(userInfo.imageUrl!)
      : null;
  if (profileImageUrl != null) {
    try {
      await userProfiles.setUserImageFromUrl(
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
