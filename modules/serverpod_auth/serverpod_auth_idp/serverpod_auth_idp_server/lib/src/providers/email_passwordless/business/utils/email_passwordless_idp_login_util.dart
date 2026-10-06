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
/// {@endtemplate}
class EmailPasswordlessIdpLoginUtil {
  final EmailPasswordlessIdpLoginUtilConfig _config;
  final Argon2HashUtil _verificationCodeHash;
  late final SecretChallengeUtil<EmailAccountLoginRequest> _challengeUtil;
  late final DatabaseRateLimiter _loginRequestRateLimiter;
  late final DatabaseRateLimiter _failedLoginRateLimiter;

  /// A hash of a code that is never valid, used to spend the time of a code
  /// verification when there is no real code to verify against.
  late final Future<String> _unmatchableHash = _verificationCodeHash
      .createHashFromString(secret: const Uuid().v4());

  /// Creates a new [EmailPasswordlessIdpLoginUtil] instance.
  EmailPasswordlessIdpLoginUtil({
    required final EmailPasswordlessIdpLoginUtilConfig config,
    required final Argon2HashUtil verificationCodeHash,
    final Argon2HashUtil? completionTokenHash,
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
    _challengeUtil = SecretChallengeUtil(
      verificationConfig: _getVerificationConfig(),
      completionConfig: _getCompletionConfig(),
      hashUtil: verificationCodeHash,
      completionTokenHash: completionTokenHash,
    );
  }

  /// {@template email_passwordless_idp_login_util.start_login}
  /// Starts a passwordless login for [email].
  ///
  /// Creates a login request with a fresh verification code and sends the code
  /// with [EmailPasswordlessIdpConfig.sendSignInVerificationCode] if an account
  /// exists for the email address, or with
  /// [EmailPasswordlessIdpConfig.sendSignUpVerificationCode] if not.
  /// The code together with the returned request ID is used with
  /// [verifyLoginCode].
  ///
  /// The method will throw the following
  /// [EmailPasswordlessLoginServerException] subclasses:
  /// - [EmailPasswordlessInvalidEmailException] if the email address is not
  ///   valid.
  /// - [EmailPasswordlessLoginRequestRateLimitedException] if too many requests
  ///   have been made for the email address.
  ///
  /// The method returns a request ID that looks the same, but that can never be
  /// completed, in these cases, so that the outside client can not use the
  /// response to determine whether an account exists:
  /// - The email address has no account and
  ///   [EmailPasswordlessIdpConfig.allowSignUp] is `false`. Nothing is sent.
  /// - A request was already created for the email address less than
  ///   [EmailPasswordlessIdpConfig.resendCooldown] ago, and
  ///   [EmailPasswordlessIdpConfig.allowSignUp] is `false`. Nothing is sent
  ///   and the pending request remains untouched. If sign-up is allowed the ID
  ///   of the pending request is returned instead, as every email address has a
  ///   pending request then.
  ///
  /// Failures of the send callbacks are logged and are not propagated to the
  /// caller.
  /// {@endtemplate}
  Future<UuidValue> startLogin(
    final Session session, {
    required String email,
    required final Transaction transaction,
  }) async {
    email = email.normalizedEmail;

    if (!_config.validateEmail(email)) {
      throw EmailPasswordlessInvalidEmailException();
    }

    if (!await _loginRequestRateLimiter.tryRecordAttempt(
      session,
      key: email,
    )) {
      throw EmailPasswordlessLoginRequestRateLimitedException();
    }

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    final verificationCode = _config.loginVerificationCodeGenerator();

    if (account == null && !_config.allowSignUp) {
      session.log(
        'Not sending a login code to $email, reason: email does not exist and sign-up is not allowed',
        level: LogLevel.debug,
      );

      // Spends the time that hashing the code would take for a real request.
      await _verificationCodeHash.createHashFromString(
        secret: verificationCode,
      );

      // NOTE: It is necessary to keep the version of the uuid in sync with the
      // one used by the [EmailAccountLoginRequest] model to prevent attackers
      // from using the difference on the version bit of the uuid to determine
      // whether an email is registered or not.
      return const Uuid().v7obj();
    }

    final pendingRequest = await EmailAccountLoginRequest.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    if (pendingRequest != null) {
      final isThrottled =
          !_isRequestExpired(pendingRequest) &&
          pendingRequest.createdAt
              .add(_config.resendCooldown)
              .isAfter(clock.now());

      if (isThrottled) {
        session.log(
          'Not sending a login code to $email, reason: resend cooldown has not elapsed',
          level: LogLevel.debug,
        );

        // Handing out the ID of the pending request when sign-up is disabled
        // would show that the email address has an account, as the response
        // for unknown addresses is a new random ID on every call.
        return _config.allowSignUp ? pendingRequest.id! : const Uuid().v7obj();
      }

      await _deleteRequests(session, [pendingRequest], transaction);
    }

    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final request = await EmailAccountLoginRequest.db.insertRow(
      session,
      EmailAccountLoginRequest(
        email: email,
        challengeId: challenge.id!,
        createdAt: clock.now(),
      ),
      transaction: transaction,
    );

    await _sendVerificationCode(
      session,
      send: account == null
          ? _config.sendSignUpVerificationCode
          : _config.sendSignInVerificationCode,
      email: email,
      loginRequestId: request.id!,
      verificationCode: verificationCode,
      transaction: transaction,
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
  /// Failed attempts are logged to the database outside of the [transaction]
  /// and can not be rolled back.
  ///
  /// The request is deleted within the [transaction]. A code can only be used
  /// once, also if it is verified concurrently: only one of the transactions
  /// succeeds. As the code is used up once the [transaction] is committed, the
  /// caller should commit it before the account is resolved, so that a failure
  /// of any later step can not be used to try a code again.
  ///
  /// Returns the normalized email address that the request was created for.
  Future<String> verifyLoginCode(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    final request = await _getLoginRequest(
      session,
      loginRequestId,
      transaction: transaction,
    );

    if (request == null) {
      // Spends the time that verifying a code would take for a real request.
      await _verificationCodeHash.validateHashFromString(
        secret: verificationCode,
        hashString: await _unmatchableHash,
      );
    } else if (!await _failedLoginRateLimiter.tryRecordAttempt(
      session,
      key: request.email,
    )) {
      throw EmailPasswordlessTooManyVerificationAttemptsException();
    }

    await _withReplacedSecretChallengeException(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: loginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );

    if (request == null) {
      throw EmailPasswordlessLoginRequestNotFoundException();
    }

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
  /// [loginRequests] is `true`) and to verify a login code (when
  /// [failedLogins] is `true`) that are older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// window that is checked when requesting or verifying a code, as configured
  /// in [EmailPasswordlessIdpConfig.loginRequestRateLimit] and
  /// [EmailPasswordlessIdpConfig.failedLoginRateLimit].
  ///
  /// If [email] is provided, only attempts for the given email will be deleted.
  /// {@endtemplate}
  Future<void> deleteLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    final String? email,
    final bool loginRequests = true,
    final bool failedLogins = true,
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
  }

  SecretChallengeVerificationConfig<EmailAccountLoginRequest>
  _getVerificationConfig() {
    return SecretChallengeVerificationConfig(
      rateLimiter: DatabaseRateLimiter(
        RateLimiterConfig(
          domain: 'email_passwordless',
          source: 'login_verification',
          maxAttempts: _config.loginVerificationCodeAllowedAttempts,
          onRateLimitExceeded: _onRateLimitExceeded,
        ),
      ),
      getRequest: _getLoginRequest,
      // Requests are deleted when used, so a used request is never found.
      isAlreadyUsed: (final request) => false,
      getChallenge: (final request) => request.challenge!,
      isExpired: _isRequestExpired,
      onExpired: (final session, final request) =>
          _deleteRequests(session, [request], null),
      linkCompletionToken: _consumeRequest,
    );
  }

  /// Completion tokens are not used by the passwordless login, as a request is
  /// consumed by the verification of its code.
  SecretChallengeCompletionConfig<EmailAccountLoginRequest>
  _getCompletionConfig() {
    return SecretChallengeCompletionConfig(
      getRequest: _getLoginRequest,
      getCompletionChallenge: (final request) => null,
      isExpired: _isRequestExpired,
      onExpired: (final session, final request) =>
          _deleteRequests(session, [request], null),
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

  /// Consumes the request by deleting it, instead of linking a completion
  /// token to it.
  ///
  /// Only one concurrent verification can delete the challenge row, the others
  /// find nothing to delete once the first one has committed, and fail.
  Future<void> _consumeRequest(
    final Session session,
    final EmailAccountLoginRequest request,
    final SecretChallenge completionChallenge, {
    required final Transaction? transaction,
  }) async {
    // The completion challenge is not used, so it must not be left behind.
    await SecretChallenge.db.deleteRow(
      session,
      completionChallenge,
      transaction: transaction,
    );

    // The request is deleted by the cascade of the foreign key.
    final deletedChallenges = await SecretChallenge.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(request.challengeId),
      transaction: transaction,
    );

    if (deletedChallenges.isEmpty) {
      throw ChallengeAlreadyUsedException();
    }
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
    required final Transaction transaction,
  }) async {
    // The savepoint lets a failing callback not break the transaction that
    // creates the request.
    final savepoint = await transaction.createSavepoint();
    try {
      await send(
        session,
        email: email,
        loginRequestId: loginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      );
      await savepoint.release();
    } catch (e, stackTrace) {
      await savepoint.rollback();

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

  /// Replaces challenge-related exceptions by passwordless-specific exceptions.
  Future<T> _withReplacedSecretChallengeException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on SecretChallengeException catch (e) {
      throw switch (e) {
        ChallengeRequestNotFoundException() ||
        ChallengeAlreadyUsedException() ||
        ChallengeNotVerifiedException() =>
          EmailPasswordlessLoginRequestNotFoundException(),
        ChallengeInvalidVerificationCodeException() ||
        ChallengeInvalidCompletionTokenException() =>
          EmailPasswordlessInvalidVerificationCodeException(),
        ChallengeExpiredException() =>
          EmailPasswordlessLoginRequestExpiredException(),
        ChallengeRateLimitExceededException() =>
          EmailPasswordlessTooManyVerificationAttemptsException(),
      };
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
