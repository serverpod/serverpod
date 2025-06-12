import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

Future<AuthUserModel> createAuthUser(final Session session) {
  return AuthUsers.create(session);
}

Future<
    ({
      UuidValue accountRequestId,
      String verificationCode,
      UuidValue emailAccountId,
    })> createVerifiedEmailAccount(
  final Session session, {
  required final UuidValue authUserId,
  required final String email,
  required final String password,
}) async {
  late UuidValue pendingAccountRequestId;
  late String pendingAccountVerificationCode;
  EmailAccounts.config = EmailAccountConfig(
    sendRegistrationVerificationCode: (
      final session, {
      required final email,
      required final accountRequestId,
      required final verificationCode,
      required final transaction,
    }) {
      pendingAccountRequestId = accountRequestId;
      pendingAccountVerificationCode = verificationCode;
    },
  );

  await EmailAccounts.startAccountCreation(
    session,
    email: email,
    password: password,
  );

  await EmailAccounts.verifyAccountCreation(
    session,
    accountRequestId: pendingAccountRequestId,
    verificationCode: pendingAccountVerificationCode,
  );

  final creationResult = await EmailAccounts.completeAccountCreation(
    session,
    authUserId: authUserId,
    accountRequestId: pendingAccountRequestId,
  );

  EmailAccounts.config = EmailAccountConfig();

  return (
    accountRequestId: pendingAccountRequestId,
    verificationCode: pendingAccountVerificationCode,
    emailAccountId: creationResult.emailAccountId,
  );
}

Future<(UuidValue paswordResetRequestId, String verificationCode)>
    requestPasswordReset(
  final Session session, {
  required final String email,
}) async {
  late UuidValue pendingPasswordResetRequestId;
  late String pendingPasswordResetVerificationCode;
  EmailAccounts.config = EmailAccountConfig(
    sendPasswordResetVerificationCode: (
      final session, {
      required final email,
      required final passwordResetRequestId,
      required final transaction,
      required final verificationCode,
    }) {
      pendingPasswordResetRequestId = passwordResetRequestId;
      pendingPasswordResetVerificationCode = verificationCode;
    },
  );

  await EmailAccounts.startPasswordReset(
    session,
    email: email,
  );

  EmailAccounts.config = EmailAccountConfig();

  return (pendingPasswordResetRequestId, pendingPasswordResetVerificationCode);
}

Future<void> resetPassword(
  final Session session, {
  required final String email,
  required final String newPassword,
}) async {
  late UuidValue pendingPasswordResetRequestId;
  late String pendingPasswordResetVerificationCode;
  EmailAccounts.config = EmailAccountConfig(
    sendPasswordResetVerificationCode: (
      final session, {
      required final email,
      required final passwordResetRequestId,
      required final transaction,
      required final verificationCode,
    }) {
      pendingPasswordResetRequestId = passwordResetRequestId;
      pendingPasswordResetVerificationCode = verificationCode;
    },
  );

  await EmailAccounts.startPasswordReset(
    session,
    email: email,
  );

  EmailAccounts.config = EmailAccountConfig();

  await EmailAccounts.completePasswordReset(
    session,
    passwordResetRequestId: pendingPasswordResetRequestId,
    verificationCode: pendingPasswordResetVerificationCode,
    newPassword: newPassword,
  );
}

Future<void> cleanUpEmailAccountDatabaseEntities(final Session session) async {
  for (final authUser in await AuthUsers.list(session)) {
    await AuthUsers.delete(
      session,
      authUserId: authUser.id,
    );
  }

  await EmailAccountRequest.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountFailedLoginAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountPasswordResetRequestAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountPasswordResetAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountRequestCompletionAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );
}
