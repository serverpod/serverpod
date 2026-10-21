import 'package:clock/clock.dart';
import 'package:email_validator/email_validator.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../util/email_string_extension.dart';
import '../email_idp_config.dart';
import '../email_idp_server_exceptions.dart';
import 'secret_challenge_exception_mapping.dart';

/// {@template email_idp_otp_login_util}
/// This class contains utility functions for passwordless logins with a
/// one-time password (OTP) sent to the user's email.
///
/// The flow is:
/// 1. [startOtpLogin] creates a login request and sends a one-time password to
///    the email, regardless of whether an account is registered for it.
/// 2. [verifyOtpLoginCode] verifies the one-time password and returns a token
///    together with whether an account exists for the email.
/// 3. Either [completeOtpLogin] signs in the existing account, or
///    [completeOtpRegistration] creates a new account for the verified email.
///
/// Errors are reported with the same [EmailAccountRequestServerException]
/// subclasses as the registration flow.
/// {@endtemplate}
class EmailIdpOtpLoginUtil {
  final Argon2HashUtil _passwordHashUtil;
  final EmailIdpOtpLoginUtilsConfig _config;
  final AuthUsers _authUsers;
  final DatabaseRateLimiter _rateLimitUtil;
  late final SecretChallengeUtil<EmailAccountOtpLoginRequest> _challengeUtil;

  /// Creates a new [EmailIdpOtpLoginUtil] instance.
  EmailIdpOtpLoginUtil({
    required final EmailIdpOtpLoginUtilsConfig config,
    required final Argon2HashUtil passwordHashUtils,
    required final AuthUsers authUsers,
    final Argon2HashUtil? verificationCodeHash,
    final Argon2HashUtil? completionTokenHash,
  }) : _config = config,
       _passwordHashUtil = passwordHashUtils,
       _authUsers = authUsers,
       _rateLimitUtil = DatabaseRateLimiter(
         RateLimiterConfig(
           domain: 'email',
           source: 'otp_login',
           maxAttempts: config.maxOtpLoginAttempts.maxAttempts,
           timeframe: config.maxOtpLoginAttempts.timeframe,
         ),
       ) {
    _challengeUtil = SecretChallengeUtil(
      hashUtil: verificationCodeHash ?? passwordHashUtils,
      completionTokenHash: completionTokenHash,
      verificationConfig: _getVerificationConfig(),
      completionConfig: _getCompletionConfig(),
    );
  }

  /// {@template email_idp_otp_login_util.start_otp_login}
  /// Starts a passwordless login by sending a one-time password to [email].
  ///
  /// A login request is created whether or not an account is registered for
  /// the email, so the response does not reveal which emails are registered.
  /// Any previous login request for the same email is replaced.
  ///
  /// Each request is logged to the database outside of the [transaction] and
  /// can not be rolled back, so the throttling will always be enforced.
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailAccountRequestInvalidEmailException] if the email is not valid.
  /// - [EmailAccountRequestVerificationTooManyAttemptsException] if too many
  ///   one-time passwords have been requested for the email.
  ///
  /// The code is sent with [EmailIdpConfig.sendOtpLoginVerificationCode], or,
  /// if it is not set, with [EmailIdpConfig.sendRegistrationVerificationCode],
  /// passing the ID of the login request as its `accountRequestId`. Throws a
  /// [StateError] if neither is configured, instead of creating a request
  /// whose code never reaches the user.
  ///
  /// Returns the ID of the login request, to be passed to
  /// [verifyOtpLoginCode] together with the one-time password.
  /// {@endtemplate}
  Future<UuidValue> startOtpLogin(
    final Session session, {
    required String email,
    required final Transaction transaction,
  }) async {
    if (_config.sendOtpLoginVerificationCode == null &&
        _config.sendRegistrationVerificationCode == null) {
      throw StateError(
        'Passwordless email logins need a sender for the one-time passwords. '
        'Configure `EmailIdpConfig.sendOtpLoginVerificationCode`, or use '
        '`ServerpodCloudEmailIdpConfig`, when exposing an endpoint extending '
        '`EmailOtpIdpBaseEndpoint`.',
      );
    }

    email = email.normalizedEmail;

    if (!EmailValidator.validate(email)) {
      throw EmailAccountRequestInvalidEmailException();
    }

    if (!await _rateLimitUtil.tryRecordAttempt(session, key: email)) {
      throw EmailAccountRequestVerificationTooManyAttemptsException();
    }

    await EmailAccountOtpLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    final verificationCode = _config.otpLoginVerificationCodeGenerator();

    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final request = await EmailAccountOtpLoginRequest.db.insertRow(
      session,
      EmailAccountOtpLoginRequest(
        email: email,
        challengeId: challenge.id!,
        createdAt: clock.now(),
      ),
      transaction: transaction,
    );

    await _sendVerificationCode(
      session,
      email: email,
      otpLoginRequestId: request.id!,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return request.id!;
  }

  bool _hasLoggedRegistrationSenderFallback = false;

  Future<void> _sendVerificationCode(
    final Session session, {
    required final String email,
    required final UuidValue otpLoginRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    final sendOtpLoginVerificationCode = _config.sendOtpLoginVerificationCode;
    if (sendOtpLoginVerificationCode != null) {
      await sendOtpLoginVerificationCode(
        session,
        email: email,
        otpLoginRequestId: otpLoginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      );
      return;
    }

    if (!_hasLoggedRegistrationSenderFallback) {
      _hasLoggedRegistrationSenderFallback = true;
      session.log(
        '`EmailIdpConfig.sendOtpLoginVerificationCode` is not set, so '
        'one-time passwords are sent with `sendRegistrationVerificationCode`, '
        'passing the OTP login request ID as `accountRequestId`. If your '
        'registration emails use `accountRequestId`, e.g. in links to complete '
        'a registration, set `sendOtpLoginVerificationCode`.',
        level: LogLevel.warning,
      );
    }

    await _config.sendRegistrationVerificationCode!(
      session,
      email: email,
      accountRequestId: otpLoginRequestId,
      verificationCode: verificationCode,
      transaction: transaction,
    );
  }

  /// {@template email_idp_otp_login_util.verify_otp_login_code}
  /// Verifies the one-time password sent by [startOtpLogin].
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailAccountRequestVerificationTooManyAttemptsException] if the user
  ///   has made too many attempts to verify the code.
  /// - [EmailAccountRequestNotFoundException] if the request does not exist.
  /// - [EmailAccountRequestVerificationCodeAlreadyUsedException] if the code
  ///   has already been used.
  /// - [EmailAccountRequestInvalidVerificationCodeException] if the code is
  ///   not valid.
  /// - [EmailAccountRequestVerificationExpiredException] if the code is
  ///   correct, but the request has already expired.
  ///
  /// In case of an invalid [verificationCode], the failed attempt will be
  /// logged to the database outside of the [transaction] and can not be rolled
  /// back.
  ///
  /// Returns the token to complete the flow with either [completeOtpLogin] or
  /// [completeOtpRegistration], depending on
  /// [EmailAccountOtpVerificationResult.accountExists].
  /// {@endtemplate}
  Future<EmailAccountOtpVerificationResult> verifyOtpLoginCode(
    final Session session, {
    required final UuidValue otpLoginRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    final token = await withEmailAccountRequestExceptions(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: otpLoginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );

    // The request is known to exist, since the challenge was just verified.
    final request = (await EmailAccountOtpLoginRequest.db.findById(
      session,
      otpLoginRequestId,
      transaction: transaction,
    ))!;

    final account = await _findAccount(
      session,
      email: request.email,
      transaction: transaction,
    );

    return EmailAccountOtpVerificationResult(
      token: token,
      accountExists: account != null,
      allowPassword: _config.allowPasswordOnOtpRegistration,
    );
  }

  /// {@template email_idp_otp_login_util.complete_otp_login}
  /// Completes a passwordless login for an existing account.
  ///
  /// Given a token returned by [verifyOtpLoginCode] for an email with a
  /// registered account, this consumes the login request and returns the ID of
  /// the auth user to sign in.
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailAccountRequestInvalidVerificationCodeException] if the
  ///   [otpLoginToken] is not valid.
  /// - [EmailAccountRequestNotFoundException] if the request does not exist,
  ///   or if no account is registered for the email.
  /// - [EmailAccountRequestNotVerifiedException] if the request has not been
  ///   verified yet.
  /// - [EmailAccountRequestVerificationExpiredException] if the request has
  ///   already expired.
  /// {@endtemplate}
  Future<UuidValue> completeOtpLogin(
    final Session session, {
    required final String otpLoginToken,
    required final Transaction transaction,
  }) async {
    final request = await _completeChallenge(
      session,
      token: otpLoginToken,
      transaction: transaction,
    );

    final account = await _findAccount(
      session,
      email: request.email,
      transaction: transaction,
    );
    if (account == null) {
      throw EmailAccountRequestNotFoundException();
    }

    await _deleteCompletedRequest(
      session,
      request,
      transaction: transaction,
    );

    return account.authUserId;
  }

  /// {@template email_idp_otp_login_util.complete_otp_registration}
  /// Completes a passwordless login for an email without an account, by
  /// creating a new auth user and an email account for the verified email.
  ///
  /// The caller is responsible for ensuring the user accepted the terms before
  /// calling this method.
  ///
  /// If [password] is given it is checked against the password policy and set
  /// for the account. If it is `null`, the account is created without a
  /// password and can only be used with one-time passwords until a password is
  /// set through a password reset.
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailPasswordPolicyViolationException] if a password is given while
  ///   [EmailIdpConfig.allowPasswordOnOtpRegistration] is `false`, or if it
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestInvalidVerificationCodeException] if the
  ///   [otpLoginToken] is not valid.
  /// - [EmailAccountRequestNotFoundException] if the request does not exist.
  /// - [EmailAccountRequestNotVerifiedException] if the request has not been
  ///   verified yet.
  /// - [EmailAccountRequestVerificationExpiredException] if the request has
  ///   already expired.
  /// - [EmailAccountAlreadyRegisteredException] if an account was registered
  ///   for the email in the meantime.
  /// {@endtemplate}
  Future<EmailIdpCompleteOtpRegistrationResult> completeOtpRegistration(
    final Session session, {
    required final String otpLoginToken,
    required final String? password,
    required final Transaction transaction,
  }) async {
    if (password != null) {
      if (!_config.allowPasswordOnOtpRegistration ||
          !_config.passwordValidationFunction(password)) {
        throw EmailPasswordPolicyViolationException();
      }
    }

    final request = await _completeChallenge(
      session,
      token: otpLoginToken,
      transaction: transaction,
    );

    if (await _findAccount(
          session,
          email: request.email,
          transaction: transaction,
        ) !=
        null) {
      throw EmailAccountAlreadyRegisteredException();
    }

    await _deleteCompletedRequest(
      session,
      request,
      transaction: transaction,
    );

    final newUser = await _authUsers.create(
      session,
      transaction: transaction,
    );

    final passwordHash = password == null
        ? ''
        : await _passwordHashUtil.createHashFromString(secret: password);

    final emailAccount = await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: newUser.id,
        email: request.email,
        passwordHash: passwordHash,
      ),
      transaction: transaction,
    );

    await _config.onAfterAccountCreated?.call(
      session,
      email: emailAccount.email,
      authUserId: emailAccount.authUserId,
      emailAccountId: emailAccount.id!,
      transaction: transaction,
    );

    return EmailIdpCompleteOtpRegistrationResult._(
      authUserId: newUser.id,
      otpLoginRequestId: request.id!,
      email: request.email,
      scopes: newUser.scopes,
    );
  }

  /// {@template email_idp_otp_login_util.delete_expired_otp_login_requests}
  /// Deletes expired one-time password login requests.
  /// {@endtemplate}
  Future<void> deleteExpiredOtpLoginRequests(
    final Session session, {
    required final Transaction transaction,
  }) async {
    final lastValidDateTime = clock.now().subtract(
      _config.otpLoginVerificationCodeLifetime,
    );

    await EmailAccountOtpLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.createdAt < lastValidDateTime,
      transaction: transaction,
    );
  }

  /// {@template email_idp_otp_login_util.delete_otp_login_attempts}
  /// Deletes the log of one-time password requests.
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// window checked by [startOtpLogin], as configured in
  /// [EmailIdpConfig.maxOtpLoginAttempts].
  ///
  /// If [email] is provided, only attempts for the given email will be deleted.
  /// This is useful to allow a user to request a new one-time password even
  /// though they hit the rate limit.
  /// {@endtemplate}
  Future<void> deleteOtpLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    final String? email,
    required final Transaction transaction,
  }) async {
    await _rateLimitUtil.deleteAttempts(
      session,
      olderThan: olderThan ?? _rateLimitUtil.config.timeframe,
      key: email?.normalizedEmail,
      transaction: transaction,
    );
  }

  Future<EmailAccount?> _findAccount(
    final Session session, {
    required final String email,
    required final Transaction transaction,
  }) {
    return EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );
  }

  /// Deletes a completed [request] together with the log of one-time
  /// passwords requested for its email.
  ///
  /// Clearing the log on success keeps [EmailIdpConfig.maxOtpLoginAttempts] a
  /// limit on codes that are not used, so users signing in repeatedly are not
  /// locked out. Only the owner of the email can complete a request, so codes
  /// requested by others still count towards the limit.
  ///
  /// Throws an [EmailAccountRequestNotFoundException] if the request was
  /// already deleted by a concurrent completion, so that each verified code
  /// completes a single login.
  Future<void> _deleteCompletedRequest(
    final Session session,
    final EmailAccountOtpLoginRequest request, {
    required final Transaction transaction,
  }) async {
    final deleted = await EmailAccountOtpLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(request.id!),
      transaction: transaction,
    );
    if (deleted.isEmpty) {
      throw EmailAccountRequestNotFoundException();
    }
    await _rateLimitUtil.deleteAttempts(
      session,
      key: request.email,
      transaction: transaction,
    );
  }

  Future<EmailAccountOtpLoginRequest> _completeChallenge(
    final Session session, {
    required final String token,
    required final Transaction transaction,
  }) {
    return withEmailAccountRequestExceptions(
      () => _challengeUtil.completeChallenge(
        session,
        completionToken: token,
        transaction: transaction,
      ),
    );
  }

  SecretChallengeVerificationConfig<EmailAccountOtpLoginRequest>
  _getVerificationConfig() {
    return SecretChallengeVerificationConfig(
      rateLimiter: DatabaseRateLimiter(
        RateLimiterConfig(
          domain: 'email',
          source: 'otp_login_verification',
          maxAttempts: _config.otpLoginVerificationCodeAllowedAttempts,
          onRateLimitExceeded: (final session, final key) =>
              _onRateLimitExceeded(session, UuidValue.withValidation(key)),
        ),
      ),
      getRequest: _getRequest,
      isAlreadyUsed: (final request) => request.completeChallenge != null,
      getChallenge: (final request) {
        final challenge = request.challenge;
        if (challenge == null) {
          throw StateError('Challenge is required for OTP login verification');
        }
        return challenge;
      },
      isExpired: _isRequestExpired,
      onExpired: EmailAccountOtpLoginRequest.db.deleteRow,
      linkCompletionToken: _linkCompleteChallenge,
    );
  }

  SecretChallengeCompletionConfig<EmailAccountOtpLoginRequest>
  _getCompletionConfig() {
    return SecretChallengeCompletionConfig(
      getRequest: _getRequest,
      getCompletionChallenge: (final request) => request.completeChallenge,
      isExpired: _isRequestExpired,
      onExpired: EmailAccountOtpLoginRequest.db.deleteRow,
    );
  }

  Future<void> _onRateLimitExceeded(
    final Session session,
    final UuidValue requestId,
  ) async {
    await EmailAccountOtpLoginRequest.db.deleteWhere(
      session,
      // Only delete requests that have not been verified yet.
      where: (final t) =>
          t.id.equals(requestId) & t.completeChallengeId.equals(null),
      // passing no transaction, so this will not be rolled back
    );
  }

  Future<EmailAccountOtpLoginRequest?> _getRequest(
    final Session session,
    final UuidValue requestId, {
    required final Transaction? transaction,
  }) {
    return EmailAccountOtpLoginRequest.db.findById(
      session,
      requestId,
      transaction: transaction,
      include: EmailAccountOtpLoginRequest.include(
        challenge: SecretChallenge.include(),
        completeChallenge: SecretChallenge.include(),
      ),
    );
  }

  bool _isRequestExpired(final EmailAccountOtpLoginRequest request) {
    final expiresAt = request.createdAt.add(
      _config.otpLoginVerificationCodeLifetime,
    );
    return expiresAt.isBefore(clock.now());
  }

  /// Links the completion challenge to the login request.
  ///
  /// Throws [EmailAccountRequestVerificationCodeAlreadyUsedException] if a
  /// completion challenge has already been linked.
  Future<void> _linkCompleteChallenge(
    final Session session,
    final EmailAccountOtpLoginRequest request,
    final SecretChallenge completeChallenge, {
    required final Transaction? transaction,
  }) async {
    final updated = await EmailAccountOtpLoginRequest.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.completeChallengeId(completeChallenge.id!),
      ],
      where: (final t) =>
          t.id.equals(request.id!) & t.completeChallengeId.equals(null),
      transaction: transaction,
    );

    if (updated.isEmpty) {
      throw EmailAccountRequestVerificationCodeAlreadyUsedException();
    }
  }
}

/// Configuration for the [EmailIdpOtpLoginUtil] class.
class EmailIdpOtpLoginUtilsConfig {
  /// Function for generating the one-time password.
  final String Function() otpLoginVerificationCodeGenerator;

  /// The lifetime of the one-time password.
  final Duration otpLoginVerificationCodeLifetime;

  /// The number of allowed attempts to verify a one-time password.
  final int otpLoginVerificationCodeAllowedAttempts;

  /// The rate limit for requesting one-time passwords for the same email.
  final RateLimit maxOtpLoginAttempts;

  /// Function for sending the one-time password.
  final SendOtpLoginVerificationCodeFunction? sendOtpLoginVerificationCode;

  /// Function for sending the one-time password when
  /// [sendOtpLoginVerificationCode] is not set.
  final SendRegistrationVerificationCodeFunction?
  sendRegistrationVerificationCode;

  /// Whether a password may be set when creating an account.
  final bool allowPasswordOnOtpRegistration;

  /// Function for validating the password.
  final PasswordValidationFunction passwordValidationFunction;

  /// Callback to be invoked after a new email account has been created.
  final AfterAccountCreatedFunction? onAfterAccountCreated;

  /// Creates a new [EmailIdpOtpLoginUtilsConfig] instance.
  EmailIdpOtpLoginUtilsConfig({
    required this.otpLoginVerificationCodeGenerator,
    required this.otpLoginVerificationCodeLifetime,
    required this.otpLoginVerificationCodeAllowedAttempts,
    required this.maxOtpLoginAttempts,
    required this.sendOtpLoginVerificationCode,
    required this.sendRegistrationVerificationCode,
    required this.allowPasswordOnOtpRegistration,
    required this.passwordValidationFunction,
    required this.onAfterAccountCreated,
  });

  /// Creates a new [EmailIdpOtpLoginUtilsConfig] instance from an
  /// [EmailIdpConfig] instance.
  factory EmailIdpOtpLoginUtilsConfig.fromEmailIdpConfig(
    final EmailIdpConfig config,
  ) {
    return EmailIdpOtpLoginUtilsConfig(
      otpLoginVerificationCodeGenerator:
          config.otpLoginVerificationCodeGenerator,
      otpLoginVerificationCodeLifetime: config.otpLoginVerificationCodeLifetime,
      otpLoginVerificationCodeAllowedAttempts:
          config.otpLoginVerificationCodeAllowedAttempts,
      maxOtpLoginAttempts: config.maxOtpLoginAttempts,
      sendOtpLoginVerificationCode: config.sendOtpLoginVerificationCode,
      sendRegistrationVerificationCode: config.sendRegistrationVerificationCode,
      allowPasswordOnOtpRegistration: config.allowPasswordOnOtpRegistration,
      passwordValidationFunction: config.passwordValidationFunction,
      onAfterAccountCreated: config.onAfterAccountCreated,
    );
  }
}

/// The result of the [EmailIdpOtpLoginUtil.completeOtpRegistration] operation.
class EmailIdpCompleteOtpRegistrationResult {
  /// The ID of the new authentication user.
  final UuidValue authUserId;

  /// The ID of the login request that was completed.
  final UuidValue otpLoginRequestId;

  /// The scopes of the new authentication user.
  final Set<Scope> scopes;

  /// The email address of the new account.
  final String email;

  EmailIdpCompleteOtpRegistrationResult._({
    required this.authUserId,
    required this.otpLoginRequestId,
    required this.email,
    required this.scopes,
  });
}
