part of 'email_accounts.dart';

/// Administrative email account management functions.
///
/// These should generally not be exposed to clients, but might be useful for
/// internal tasks or an admin dashboard.
///
/// An instance of this class is available at [EmailAccounts.admin].
final class EmailAccountsAdmin {
  EmailAccountsAdmin._();

  /// Cleans up the log of failed password reset attempts older than
  /// [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// window that is checked upon password reset requets, as configured in
  /// [EmailAccountConfig.maxPasswordResetAttempts].
  Future<void> deletePasswordResetAttempts(
    final Session session, {
    Duration? olderThan,
    final Transaction? transaction,
  }) async {
    olderThan ??= EmailAccounts.config.maxPasswordResetAttempts.timeframe;

    final removeBefore = clock.now().subtract(olderThan);

    await EmailAccountPasswordResetAttempt.db.deleteWhere(
      session,
      where: (final t) => t.attemptedAt < removeBefore,
      transaction: transaction,
    );
  }

  /// Cleans up expired password reset attempts.
  Future<void> deleteExpiredPasswordResetRequests(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final lastValidDateTime = clock.now().subtract(
          EmailAccounts.config.passwordResetVerificationCodeLifetime,
        );

    await EmailAccountPasswordResetRequest.db.deleteWhere(
      session,
      where: (final t) => t.created < lastValidDateTime,
      transaction: transaction,
    );
  }

  /// Cleans up expired account creation requests.
  Future<void> deleteExpiredAccountCreations(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final lastValidDateTime = clock.now().subtract(
          EmailAccounts.config.registrationVerificationCodeLifetime,
        );

    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final t) => t.created < lastValidDateTime,
      transaction: transaction,
    );
  }

  /// Cleans up the log of failed login attempts older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// window that is checked upon login, as configured in
  /// [EmailAccountConfig.emailSignInFailureResetTime].
  Future<void> deleteFailedLoginAttempts(
    final Session session, {
    Duration? olderThan,
    final Transaction? transaction,
  }) async {
    olderThan ??= EmailAccounts.config.failedLoginRateLimit.timeframe;

    final removeBefore = clock.now().subtract(olderThan);

    await EmailAccountFailedLoginAttempt.db.deleteWhere(
      session,
      where: (final t) => t.attemptedAt < removeBefore,
      transaction: transaction,
    );
  }

  /// Checks whether an email authentication exists for the given email address.
  Future<
      ({
        UuidValue authUserId,
        UuidValue emailAccountId,
        bool hasPassword,
      })?> findAccount(
    final Session session, {
    required String email,
    final Transaction? transaction,
  }) async {
    email = email.toLowerCase();

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    if (account == null) {
      return null;
    }

    return (
      authUserId: account.authUserId,
      emailAccountId: account.id!,
      hasPassword: account.passwordHash.lengthInBytes > 0,
    );
  }

  /// Checks whether the registration request is still pending, and if so
  /// returns the associated email.
  ///
  /// In case the registration has been completed or the request is expired this
  /// returns `null`.
  Future<
      ({
        String email,
        bool isVerified,
      })?> findRegistrationRequest(
    final Session session, {
    required final UuidValue accountRequestId,
    final Transaction? transaction,
  }) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      transaction: transaction,
    );

    if (request == null || request.isExpired) {
      return null;
    }

    return (
      email: request.email,
      isVerified: request.verifiedAt != null,
    );
  }

  /// Deletes a registration request by its ID.
  Future<void> deleteRegistrationRequestById(
    final Session session,
    final UuidValue accountRequestId, {
    final Transaction? transaction,
  }) async {
    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(accountRequestId),
      transaction: transaction,
    );
  }

  /// Creates an email authentication for the auth user with the given email and
  /// password.
  ///
  /// The [email] will be treated as validated right away, so the caller must
  /// ensure that it comes from a trusted source.
  /// The [password] argument is not checked against the configured password
  /// policy.
  /// A `null` [password] can be passed to create an account without a password.
  /// In that case either the user has to complete a password reset or
  /// [setPassword] needs to be called before the user can log in.
  ///
  /// Returns the email account ID for the newly created authentication method.
  Future<UuidValue> createEmailAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required String email,
    required final String? password,
    final Transaction? transaction,
  }) async {
    email = email.toLowerCase();

    final passwordHash = password != null
        ? await EmailAccountSecretHash.createHash(value: password)
        : (hash: Uint8List.fromList([]), salt: Uint8List.fromList([]));

    final account = await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: email,
        passwordHash: passwordHash.hash.asByteData,
        passwordSalt: passwordHash.salt.asByteData,
      ),
      transaction: transaction,
    );

    return account.id!;
  }

  /// Sets the password for the authentication belonging to the given email.
  ///
  /// The [password] argument is not checked against the configured password
  /// policy.
  ///
  /// Throws an [EmailAccountNotFoundException] in case no account exists for
  /// the given email address.
  Future<void> setPassword(
    final Session session, {
    required String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    email = email.toLowerCase();

    var account = (await EmailAccount.db.find(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    ))
        .singleOrNull;

    if (account == null) {
      throw EmailAccountNotFoundException(email: email);
    }

    final passwordHash = await EmailAccountSecretHash.createHash(
      value: password,
    );

    account = await EmailAccount.db.updateRow(
      session,
      account.copyWith(
        passwordHash: passwordHash.hash.asByteData,
        passwordSalt: passwordHash.salt.asByteData,
      ),
      transaction: transaction,
    );
  }
}
