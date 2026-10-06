import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../../core.dart';
import '../../../email/util/email_string_extension.dart';
import '../email_passwordless_idp_config.dart';
import '../email_passwordless_idp_server_exceptions.dart';

/// {@template email_passwordless_idp_login_util}
/// This class contains the utility functions of the passwordless email
/// identity provider that create and verify login requests.
///
/// The main entry points are [startLogin], which returns the ID of a new login
/// request and sends out its verification code, and [verifyLoginCode], which
/// consumes the request once the code is correct.
///
/// This class also contains utility functions for administration tasks, such
/// as deleting expired login requests and resetting rate limits.
///
/// None of the rate limiters is used while holding a database connection of
/// another transaction, as that exhausts the connection pool when many calls
/// run at once: [startLogin] and [verifyLoginCode] manage their own
/// transactions and are not meant to be called from within one.
/// {@endtemplate}
class EmailPasswordlessIdpLoginUtil {
  final EmailPasswordlessIdpLoginUtilConfig _config;
  final Argon2HashUtil _verificationCodeHash;
  late final DatabaseRateLimiter _loginRequestRateLimiter;
  late final DatabaseRateLimiter _failedLoginRateLimiter;
  late final DatabaseRateLimiter _verificationRateLimiter;

  /// A hash of a code that is never valid, used to spend the time of a code
  /// verification when there is no real code to verify against.
  late final Future<String> _unmatchableHash = _verificationCodeHash
      .createHashFromString(secret: const Uuid().v4());

  /// Creates a new [EmailPasswordlessIdpLoginUtil] instance.
  EmailPasswordlessIdpLoginUtil({
    required final EmailPasswordlessIdpLoginUtilConfig config,
    required final Argon2HashUtil verificationCodeHash,
  }) : _config = config,
       _verificationCodeHash = verificationCodeHash {
    _loginRequestRateLimiter = DatabaseRateLimiter(
      RateLimiterConfig(
        domain: 'email_passwordless',
        source: 'login_request',
        maxAttempts: config.loginRequestRateLimit.maxAttempts,
        timeframe: config.loginRequestRateLimit.timeframe,
      ),
    );
    _failedLoginRateLimiter = DatabaseRateLimiter(
      RateLimiterConfig(
        domain: 'email_passwordless',
        source: 'failed_login',
        maxAttempts: config.failedLoginRateLimit.maxAttempts,
        timeframe: config.failedLoginRateLimit.timeframe,
      ),
    );
    _verificationRateLimiter = DatabaseRateLimiter(
      RateLimiterConfig(
        domain: 'email_passwordless',
        source: 'login_verification',
        maxAttempts: config.loginVerificationCodeAllowedAttempts,
        onRateLimitExceeded: _onRateLimitExceeded,
      ),
    );
  }

  /// {@template email_passwordless_idp_login_util.start_login}
  /// Starts a passwordless login for [email].
  ///
  /// Creates a login request with a fresh verification code, replacing a
  /// pending request of the email address that is older than
  /// [EmailPasswordlessIdpConfig.resendCooldown], and returns its ID. The code
  /// is then sent with [EmailPasswordlessIdpConfig.sendSignInVerificationCode]
  /// if an account exists for the email address, or with
  /// [EmailPasswordlessIdpConfig.sendSignUpVerificationCode] if not. The code
  /// together with the returned request ID is used with [verifyLoginCode].
  ///
  /// The code is sent after the request has been committed to the database, and
  /// before this method returns. Failures of the send callbacks are logged and
  /// are not propagated to the caller.
  ///
  /// If the email address has no account and
  /// [EmailPasswordlessIdpConfig.allowSignUp] is `false`, a decoy request is
  /// created, with a random code that is never sent. Everything else behaves as
  /// for known email addresses, including the request ID, the attempt limits
  /// and the errors, so that a client can not find out whether an account
  /// exists. The code can not be guessed in practice, and the login of a decoy
  /// request fails with the same error as a wrong code even if it is guessed.
  /// The only difference left is the time of sending the email.
  ///
  /// The method will throw the following
  /// [EmailPasswordlessLoginServerException] subclasses:
  /// - [EmailPasswordlessInvalidEmailException] if the email address is not
  ///   valid.
  /// - [EmailPasswordlessResendCooldownException] if a request for the email
  ///   address has been created less than
  ///   [EmailPasswordlessIdpConfig.resendCooldown] ago, also if it has been
  ///   created by a concurrent call. The ID of the pending request is never
  ///   returned to anyone but the caller that created it.
  /// - [EmailPasswordlessLoginRequestRateLimitedException] if too many requests
  ///   have been made for the email address.
  /// {@endtemplate}
  Future<UuidValue> startLogin(
    final Session session, {
    required String email,
  }) async {
    email = email.normalizedEmail;

    if (!_config.validateEmail(email)) {
      throw EmailPasswordlessInvalidEmailException();
    }

    // Checked before recording the attempt, so that calls that are rejected
    // anyway do not use up the attempts of the email address.
    final pendingRequest = await EmailAccountLoginRequest.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
    );
    if (pendingRequest != null && _isWithinCooldown(pendingRequest)) {
      throw EmailPasswordlessResendCooldownException();
    }

    // The attempt is recorded in a transaction of its own, so it must not run
    // while another transaction of this call holds a connection.
    if (!await _loginRequestRateLimiter.tryRecordAttempt(
      session,
      key: email,
    )) {
      throw EmailPasswordlessLoginRequestRateLimitedException();
    }

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
    );

    final verificationCode = _config.loginVerificationCodeGenerator();
    final verificationCodeHash = await _verificationCodeHash
        .createHashFromString(secret: verificationCode);

    final EmailAccountLoginRequest request;
    try {
      request = await session.db.transaction(
        (final transaction) => _replaceRequest(
          session,
          email: email,
          verificationCodeHash: verificationCodeHash,
          transaction: transaction,
        ),
      );
    } on DatabaseUniqueViolationException {
      // A concurrent call has created the request of the email address first.
      throw EmailPasswordlessResendCooldownException();
    }

    if (account == null && !_config.allowSignUp) {
      session.log(
        'Not sending a login code to $email, reason: email does not exist and sign-up is not allowed',
        level: LogLevel.debug,
      );

      return request.id!;
    }

    await _sendVerificationCode(
      session,
      send: account == null
          ? _config.sendSignUpVerificationCode
          : _config.sendSignInVerificationCode,
      email: email,
      loginRequestId: request.id!,
      verificationCode: verificationCode,
    );

    return request.id!;
  }

  /// Verifies the code for a login request created by [startLogin], and
  /// consumes the request.
  ///
  /// Can throw the following [EmailPasswordlessLoginServerException]
  /// subclasses:
  /// - [EmailPasswordlessTooManyVerificationAttemptsException] in case too many
  ///   attempts have been made for the login request or the email address.
  /// - [EmailPasswordlessLoginRequestNotFoundException] if the request does not
  ///   exist or has already been used.
  /// - [EmailPasswordlessInvalidVerificationCodeException] if the verification
  ///   code is not valid.
  /// - [EmailPasswordlessLoginRequestExpiredException] if the verification
  ///   code is correct, but the request has already expired.
  ///
  /// Attempts are recorded before the code is checked, in transactions of their
  /// own, so they can not be rolled back by anything that follows.
  ///
  /// The request is consumed in a transaction of its own that is committed
  /// before this method returns. A code can only be used once, also if it is
  /// verified concurrently: only one of the calls consumes the request, and
  /// the others fail with [EmailPasswordlessLoginRequestNotFoundException].
  /// As the code is used up when this method returns, a failure of any later
  /// step can not be used to try a code again.
  ///
  /// The code is checked with a slow hash, also if there is no request with the
  /// given ID, so that the time does not show whether the ID exists. This makes
  /// requests with random IDs as expensive for the server as requests with
  /// real IDs, which is the price of that uniformity. The number of requests
  /// that reach the hash is not limited per client.
  ///
  /// Returns the normalized email address that the request was created for.
  Future<String> verifyLoginCode(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    final request = await _getLoginRequest(
      session,
      loginRequestId,
      transaction: null,
    );

    if (request == null) {
      await _verificationCodeHash.validateHashFromString(
        secret: verificationCode,
        hashString: await _unmatchableHash,
      );

      throw EmailPasswordlessLoginRequestNotFoundException();
    }

    if (!await _failedLoginRateLimiter.tryRecordAttempt(
      session,
      key: request.email,
    )) {
      throw EmailPasswordlessTooManyVerificationAttemptsException();
    }

    if (!await _verificationRateLimiter.tryRecordAttempt(
      session,
      key: request.id!.uuid,
    )) {
      throw EmailPasswordlessTooManyVerificationAttemptsException();
    }

    final isCodeValid = await _verificationCodeHash.validateHashFromString(
      secret: verificationCode,
      hashString: request.challenge!.challengeCodeHash,
    );
    if (!isCodeValid) {
      throw EmailPasswordlessInvalidVerificationCodeException();
    }

    if (_isRequestExpired(request)) {
      await _deleteRequests(session, [request], null);
      throw EmailPasswordlessLoginRequestExpiredException();
    }

    await session.db.transaction((final transaction) async {
      // The request is deleted by the cascade of the foreign key. Only one of
      // concurrent calls deletes the row, the others find nothing to delete
      // once the first one has committed.
      final deletedChallenges = await SecretChallenge.db.deleteWhere(
        session,
        where: (final t) => t.id.equals(request.challengeId),
        transaction: transaction,
      );

      if (deletedChallenges.isEmpty) {
        throw EmailPasswordlessLoginRequestNotFoundException();
      }

      // The successful login clears the failures of the email address, so
      // that the count only accumulates over failures.
      await _failedLoginRateLimiter.deleteAttempts(
        session,
        key: request.email,
        transaction: transaction,
      );
      await _verificationRateLimiter.deleteAttempts(
        session,
        key: request.id!.uuid,
        transaction: transaction,
      );
    });

    return request.email;
  }

  /// Clears the count of failed code verifications for [email], which is done
  /// after a successful login so that the count only accumulates over failures.
  Future<void> clearFailedLoginAttempts(
    final Session session, {
    required String email,
    final Transaction? transaction,
  }) async {
    await _failedLoginRateLimiter.deleteAttempts(
      session,
      key: email.normalizedEmail,
      transaction: transaction,
    );
  }

  /// {@template email_passwordless_idp_login_util.delete_login_request_by_id}
  /// Deletes a login request by its ID.
  /// {@endtemplate}
  Future<void> deleteLoginRequestById(
    final Session session,
    final UuidValue loginRequestId, {
    required final Transaction transaction,
  }) async {
    final request = await EmailAccountLoginRequest.db.findById(
      session,
      loginRequestId,
      transaction: transaction,
    );

    if (request == null) return;

    await _deleteRequests(session, [request], transaction);
  }

  /// {@template email_passwordless_idp_login_util.delete_expired_login_requests}
  /// Deletes login requests that are older than
  /// [EmailPasswordlessIdpConfig.loginVerificationCodeLifetime].
  /// {@endtemplate}
  Future<void> deleteExpiredLoginRequests(
    final Session session, {
    required final Transaction transaction,
  }) async {
    final lastValidDateTime = clock.now().subtract(
      _config.loginVerificationCodeLifetime,
    );

    final expiredRequests = await EmailAccountLoginRequest.db.find(
      session,
      where: (final t) => t.createdAt < lastValidDateTime,
      transaction: transaction,
    );

    await _deleteRequests(session, expiredRequests, transaction);
  }

  /// {@template email_passwordless_idp_login_util.find_active_login_request}
  /// Checks whether a login request is still pending, and if so returns it.
  ///
  /// In case the request is expired this returns `null`.
  /// {@endtemplate}
  Future<EmailAccountLoginRequest?> findActiveLoginRequest(
    final Session session, {
    required final UuidValue loginRequestId,
    required final Transaction? transaction,
  }) async {
    final request = await EmailAccountLoginRequest.db.findById(
      session,
      loginRequestId,
      transaction: transaction,
    );

    if (request == null || _isRequestExpired(request)) {
      return null;
    }

    return request;
  }

  /// {@template email_passwordless_idp_login_util.delete_login_attempts}
  /// Deletes the recorded attempts to request a login code (when
  /// [loginRequests] is `true`), to verify a login code of an email address
  /// (when [failedLogins] is `true`), and to verify the code of a single login
  /// request (when [verifications] is `true`), that are older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// window that is checked when requesting or verifying a code, as configured
  /// in [EmailPasswordlessIdpConfig.loginRequestRateLimit] and
  /// [EmailPasswordlessIdpConfig.failedLoginRateLimit]. The attempts of a
  /// login request are not limited by a window, so those older than
  /// [EmailPasswordlessIdpConfig.loginVerificationCodeLifetime] are removed,
  /// as the request is useless by then.
  ///
  /// If [email] is provided, only attempts for the given email will be deleted,
  /// which for [verifications] are the attempts of its pending login request.
  /// {@endtemplate}
  Future<void> deleteLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    final String? email,
    final bool loginRequests = true,
    final bool failedLogins = true,
    final bool verifications = true,
    required final Transaction transaction,
  }) async {
    final key = email?.normalizedEmail;

    if (loginRequests) {
      await _loginRequestRateLimiter.deleteAttempts(
        session,
        olderThan: olderThan ?? _loginRequestRateLimiter.config.timeframe,
        key: key,
        transaction: transaction,
      );
    }

    if (failedLogins) {
      await _failedLoginRateLimiter.deleteAttempts(
        session,
        olderThan: olderThan ?? _failedLoginRateLimiter.config.timeframe,
        key: key,
        transaction: transaction,
      );
    }

    if (verifications) {
      if (key == null) {
        await _verificationRateLimiter.deleteAttempts(
          session,
          olderThan: olderThan ?? _config.loginVerificationCodeLifetime,
          transaction: transaction,
        );
      } else {
        final pendingRequest = await EmailAccountLoginRequest.db.findFirstRow(
          session,
          where: (final t) => t.email.equals(key),
          transaction: transaction,
        );

        if (pendingRequest != null) {
          await _verificationRateLimiter.deleteAttempts(
            session,
            olderThan: olderThan,
            key: pendingRequest.id!.uuid,
            transaction: transaction,
          );
        }
      }
    }
  }

  /// Deletes the pending request of [email], if there is one, and creates a
  /// new one with the given code hash.
  Future<EmailAccountLoginRequest> _replaceRequest(
    final Session session, {
    required final String email,
    required final String verificationCodeHash,
    required final Transaction transaction,
  }) async {
    final pendingRequest = await EmailAccountLoginRequest.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    if (pendingRequest != null) {
      if (_isWithinCooldown(pendingRequest)) {
        throw EmailPasswordlessResendCooldownException();
      }

      await _deleteRequests(session, [pendingRequest], transaction);
    }

    final challenge = await SecretChallenge.db.insertRow(
      session,
      SecretChallenge(challengeCodeHash: verificationCodeHash),
      transaction: transaction,
    );

    // NOTE: The UUID version of the ID is the same for every request, decoy or
    // not, as it is generated by the database.
    return await EmailAccountLoginRequest.db.insertRow(
      session,
      EmailAccountLoginRequest(
        email: email,
        challengeId: challenge.id!,
        createdAt: clock.now(),
      ),
      transaction: transaction,
    );
  }

  Future<void> _onRateLimitExceeded(
    final Session session,
    final String requestId,
  ) async {
    // Passing no transaction, so this will not be rolled back.
    final request = await EmailAccountLoginRequest.db.findById(
      session,
      UuidValue.withValidation(requestId),
    );

    if (request == null) return;

    await _deleteRequests(session, [request], null);
  }

  Future<EmailAccountLoginRequest?> _getLoginRequest(
    final Session session,
    final UuidValue loginRequestId, {
    required final Transaction? transaction,
  }) async {
    return await EmailAccountLoginRequest.db.findById(
      session,
      loginRequestId,
      transaction: transaction,
      include: EmailAccountLoginRequest.include(
        challenge: SecretChallenge.include(),
      ),
    );
  }

  bool _isRequestExpired(final EmailAccountLoginRequest request) {
    final requestExpiresAt = request.createdAt.add(
      _config.loginVerificationCodeLifetime,
    );
    return requestExpiresAt.isBefore(clock.now());
  }

  bool _isWithinCooldown(final EmailAccountLoginRequest request) {
    return !_isRequestExpired(request) &&
        request.createdAt.add(_config.resendCooldown).isAfter(clock.now());
  }

  /// Deletes the [requests] together with their challenges.
  ///
  /// Deleting a request would leave its challenge behind, and deleting the
  /// challenge deletes the request by the cascade of the foreign key.
  Future<void> _deleteRequests(
    final Session session,
    final List<EmailAccountLoginRequest> requests,
    final Transaction? transaction,
  ) async {
    if (requests.isEmpty) return;

    await SecretChallenge.db.deleteWhere(
      session,
      where: (final t) => t.id.inSet(
        requests.map((final request) => request.challengeId).toSet(),
      ),
      transaction: transaction,
    );
  }

  Future<void> _sendVerificationCode(
    final Session session, {
    required final SendPasswordlessLoginVerificationCodeFunction send,
    required final String email,
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    try {
      await send(
        session,
        email: email,
        loginRequestId: loginRequestId,
        verificationCode: verificationCode,
        transaction: null,
      );
    } catch (e, stackTrace) {
      // Best effort: the failure must not be visible to the caller, as it would
      // show that the email address is known (no code is sent for an unknown
      // address when sign-up is disabled).
      session.log(
        'Failed to send the login code for $email.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Configuration for the [EmailPasswordlessIdpLoginUtil] class.
class EmailPasswordlessIdpLoginUtilConfig {
  /// Function for validating the email address.
  final EmailValidationFunction validateEmail;

  /// Function for generating the login verification code.
  final String Function() loginVerificationCodeGenerator;

  /// The lifetime of the login verification code.
  final Duration loginVerificationCodeLifetime;

  /// The number of allowed attempts to verify the code of a login request.
  final int loginVerificationCodeAllowedAttempts;

  /// The rate limit for failed code verifications per email address.
  final RateLimit failedLoginRateLimit;

  /// The rate limit for login requests per email address.
  final RateLimit loginRequestRateLimit;

  /// The minimum time between two codes sent to the same email address.
  final Duration resendCooldown;

  /// Whether unknown email addresses can sign up.
  final bool allowSignUp;

  /// Function for sending the code to an email address without an account.
  final SendPasswordlessLoginVerificationCodeFunction
  sendSignUpVerificationCode;

  /// Function for sending the code to an email address with an account.
  final SendPasswordlessLoginVerificationCodeFunction
  sendSignInVerificationCode;

  /// Creates a new [EmailPasswordlessIdpLoginUtilConfig] instance.
  EmailPasswordlessIdpLoginUtilConfig({
    required this.validateEmail,
    required this.loginVerificationCodeGenerator,
    required this.loginVerificationCodeLifetime,
    required this.loginVerificationCodeAllowedAttempts,
    required this.failedLoginRateLimit,
    required this.loginRequestRateLimit,
    required this.resendCooldown,
    required this.allowSignUp,
    required this.sendSignUpVerificationCode,
    required this.sendSignInVerificationCode,
  });

  /// Creates a new [EmailPasswordlessIdpLoginUtilConfig] instance from an
  /// [EmailPasswordlessIdpConfig] instance.
  factory EmailPasswordlessIdpLoginUtilConfig.fromEmailPasswordlessIdpConfig(
    final EmailPasswordlessIdpConfig config,
  ) {
    return EmailPasswordlessIdpLoginUtilConfig(
      validateEmail: config.validateEmail,
      loginVerificationCodeGenerator: config.loginVerificationCodeGenerator,
      loginVerificationCodeLifetime: config.loginVerificationCodeLifetime,
      loginVerificationCodeAllowedAttempts:
          config.loginVerificationCodeAllowedAttempts,
      failedLoginRateLimit: config.failedLoginRateLimit,
      loginRequestRateLimit: config.loginRequestRateLimit,
      resendCooldown: config.resendCooldown,
      allowSignUp: config.allowSignUp,
      sendSignUpVerificationCode: config.sendSignUpVerificationCode,
      sendSignInVerificationCode: config.sendSignInVerificationCode,
    );
  }
}
