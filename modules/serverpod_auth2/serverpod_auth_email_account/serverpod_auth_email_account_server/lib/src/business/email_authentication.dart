import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';

final class EmailAuthentication {
  // TODO: Expose config here?

  /// Returns the user ID upon successful login.
  // TODO: Rather return a union with success and detailed error cases?
  static Future<UuidValue> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    // TODO: Obviosly check password, detailed errors, etc.

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email.toLowerCase()),
    );

    if (account != null) {
      return account.id!;
    }

    final importFunc = EmailAccountConfig.current.existingUserImportFunction;
    if (importFunc != null) {
      final userId = await importFunc(
        session,
        email: email,
        password: password,
      );
      if (userId != null) {
        await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            userId: userId,
            created: DateTime.now(), // migrate creation date?
            email: email,
            passwordHash: password,
          ),
        );
      }
    }

    throw 'No user found';
  }

  /// Returns the registration process ID.
  ///
  /// The caller may store additional information attached to this ID,
  /// which will be returned from [verify] later on.
  static Future<UuidValue> requestAccount(
    Session session, {
    required String email,
    required String password,
  }) async {
    // TODO: If `session` is authenticated, store thatn and link to that user later

    final verificationCode = 'random${DateTime.now()}';

    final request = await EmailAccountRequest.db.insertRow(
      session,
      EmailAccountRequest(
        email: email.toLowerCase(),
        passwordHash: password,
        created: DateTime.now(),
        expiration: DateTime.now().add(
          EmailAccountConfig.current.registrationVerificationCodeLifetime,
        ),
        verificationCode: verificationCode,
      ),
    );

    EmailAccountConfig.current.sendRegistrationVerificationMail
        ?.call(email: email, verificationToken: verificationCode);

    return request.id!;
  }

  /// Returns the account request creation ID if the request is valid.
  ///
  /// If `true`, this means `createAccount` will succeed.
  static Future<(UuidValue accountRequestId, String email)>
      verifyAccountRequest(
    Session session, {
    required String verificationCode,
  }) async {
    final request = (await EmailAccountRequest.db.find(session,
            where: (t) => t.verificationCode.equals(verificationCode)))
        // TODO: Is this not supported on the query?
        .firstWhere((r) => r.expiration.isBefore(DateTime.now()));

    return (request.id!, request.email);
  }

  static Future<(UuidValue, String)> createAccount(
    Session session, {
    required String verificationCode,

    /// Authentication user ID this account should be linked up with
    required UuidValue userId,
  }) async {
    final request = (await EmailAccountRequest.db.find(session,
            where: (t) => t.verificationCode.equals(verificationCode)))
        // TODO: Is this not supported on the query?
        .where((r) => r.expiration.isBefore(DateTime.now()))
        .single;

    await EmailAccountRequest.db.deleteRow(session, request);

    final account = await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        userId: userId,
        created: DateTime.now(),
        email: request.email,
        passwordHash: request.passwordHash,
      ),
    );

    return (account.id!, request.email);
  }

  static Future<void> requestPasswordReset(
    Session session, {
    required String email,
  }) async {
    final resetToken = 'random${DateTime.now()}';

    final account = await EmailAccountRequest.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email.toLowerCase()),
    );

    // TODO: warn if `null`
    EmailAccountConfig.current.sendPasswordResetMail?.call(
      email: email,
      resetToken: resetToken,
    );

    await EmailAccountPasswordResetRequest.db.insertRow(
      session,
      EmailAccountPasswordResetRequest(
        authenticationId: account!.id!,
        created: DateTime.now(),
        expiration: DateTime.now()
            .add(EmailAccountConfig.current.passwordResetCodeLifetime),
        verificationCode: resetToken,
      ),
    );
  }

  /// Returns the user ID for the successfully changed password
  static Future<UuidValue> completePasswordReset(
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

    EmailAccount.db.updateRow(
      session,
      account.copyWith(passwordHash: newPassword),
    );

    return account.userId;
  }
}
