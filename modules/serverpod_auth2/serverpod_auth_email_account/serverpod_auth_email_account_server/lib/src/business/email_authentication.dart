import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';

final class EmailAuthentication {
  /// Returns the user ID upon successful login.
  // TODO: Rather return a union with success and detailed error cases?
  static Future<int> login(
    Session session, {
    required String email,
    required String password,
  }) async {
// TODO: Obviosly check password, detailed errors, etc.

    final account = await EmailAccount.db.findFirstRow(session,
        where: (t) => t.email.equals(email.toLowerCase()));

    return account!.userId;
  }

  /// Returns the registration process ID.
  ///
  /// The caller may store additional information attached to this ID,
  /// which will be returned from [verify] later on.
  static Future<int> requestAccount(
    Session session, {
    required String email,
    required String password,
  }) async {
    final verificationCode = 'random${DateTime.now()}';

    final request = await EmailAccountRequest.db.insertRow(
      session,
      EmailAccountRequest(
        email: email.toLowerCase(),
        passwordHash: password,
        created: DateTime.now(),
        expiration: DateTime.now().add(Duration(days: 1)),
        verificationCode: verificationCode,
      ),
    );

    // TODO: Send out `verificationCode`, via email-specific auth config

    return request.id!;
  }

  /// Returns whether the verification code is correct.
  ///
  /// If `true`, this means `createAccount` will succeed.
  static Future<bool> verifyAccountRequest(
    Session session, {
    required String verificationCode,
  }) async {
    return (await EmailAccountRequest.db.find(session,
            where: (t) => t.verificationCode.equals(verificationCode)))
        // TODO: Is this nor supported on the query?
        .where((r) => r.expiration.isBefore(DateTime.now()))
        .isNotEmpty;
  }

  static Future<void> createAccount(
    Session session, {
    required String verificationCode,

    /// Authentication user ID this account should be linked up with
    required int userId,
  }) async {
    final request = (await EmailAccountRequest.db.find(session,
            where: (t) => t.verificationCode.equals(verificationCode)))
        // TODO: Is this nor supported on the query?
        .where((r) => r.expiration.isBefore(DateTime.now()))
        .single;

    await EmailAccountRequest.db.deleteRow(session, request);

    await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        userId: userId,
        created: DateTime.now(),
        email: request.email,
        passwordHash: request.passwordHash,
      ),
    );
  }

  static Future<void> requestPasswordReset(
    Session session, {
    required String email,
  }) async {
    final verificationCode = 'random${DateTime.now()}';

    final account = await EmailAccountRequest.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email.toLowerCase()),
    );

    // TODO: Send `verificationCode`

    await EmailAccountPasswordResetRequest.db.insertRow(
        session,
        EmailAccountPasswordResetRequest(
          authenticationId: account!.id!,
          created: DateTime.now(),
          expiration: DateTime.now().add(Duration(days: 1)),
          verificationCode: verificationCode,
        ));
  }

  static Future<void> completePasswordReset(
    Session session, {
    required String resetCode,
    required String newPassword,
  }) async {
    final resetRequest = (await EmailAccountPasswordResetRequest.db
            .find(session, where: (t) => t.verificationCode.equals(resetCode)))
        .singleWhere((r) => r.expiration.isBefore(DateTime.now()));

    await EmailAccountPasswordResetRequest.db.deleteRow(session, resetRequest);

    final account = (await EmailAccount.db
        .findById(session, resetRequest.authenticationId))!;

    EmailAccount.db
        .updateRow(session, account.copyWith(passwordHash: newPassword));
  }
}
