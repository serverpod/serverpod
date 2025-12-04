import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../util/email_string_extension.dart';
import '../email_idp_config.dart';
import '../email_idp_server_exceptions.dart';

/// {@template email_idp_password_reset_util}
/// Class for handling password reset operations in the email account module.
///
/// The main entry point is the [startPasswordReset] method, which can be used
/// to start a password reset process.
///
/// This class also contains utility functions for administration tasks, such as
/// deleting expired password reset requests and password reset attempts.
/// {@endtemplate}
class EmailIdpPasswordResetUtil {
  final Argon2HashUtil _passwordHashUtil;
  final EmailIdpPasswordResetUtilsConfig _config;
  final DatabaseRateLimitedRequestAttemptUtil<String> _rateLimitUtil;
  late final SecretChallengeUtil<EmailAccountPasswordResetRequest>
  _challengeUtil;

  /// Creates a new [EmailIdpPasswordResetUtil] instance.
  EmailIdpPasswordResetUtil({
    required final EmailIdpPasswordResetUtilsConfig config,
    required final Argon2HashUtil passwordHashUtils,
  }) : _config = config,
       _passwordHashUtil = passwordHashUtils,
       _rateLimitUtil = DatabaseRateLimitedRequestAttemptUtil(
         RateLimitedRequestAttemptConfig(
           domain: 'email',
           source: 'password_reset',
           maxAttempts: config.maxPasswordResetAttempts.maxAttempts,
           timeframe: config.maxPasswordResetAttempts.timeframe,
         ),
       ) {
    _challengeUtil = SecretChallengeUtil(
      hashUtil: passwordHashUtils,
      verificationConfig: _getVerificationConfig(),
      completionConfig: _getCompletionConfig(),
    );
  }

  /// Sends out a password reset email for the given account, if it exists and
  /// returns a password reset request ID, which can be used to complete the
  /// reset.
  ///
  /// Each reset request will be logged to the database outside of the
  /// [transaction] and can not be rolled back, so the throttling will always be
  /// enforced.
  ///
  /// Can throw [EmailPasswordResetTooManyAttemptsException] if the user has
  /// made too many attempts to request a password reset.
  ///
  /// Can throw [EmailPasswordResetEmailNotFoundException] if the email account
  /// does not exist. In this case, the caller should not expose this detail to
  /// the client, so that this method can not be misused to check which emails
  /// are registered.
  Future<UuidValue> startPasswordReset(
    final Session session, {
    required String email,
    required final Transaction transaction,
  }) async {
    email = email.normalizedEmail;

    if (await _rateLimitUtil.hasTooManyAttempts(session, nonce: email)) {
      throw EmailPasswordResetTooManyAttemptsException();
    }

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    if (account == null) {
      throw EmailPasswordResetEmailNotFoundException();
    }

    await deletePasswordResetRequests(
      session,
      olderThan: Duration.zero,
      emailAccountId: account.id!,
      transaction: transaction,
    );

    final verificationCode = _config.passwordResetVerificationCodeGenerator();

    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final resetRequest = await EmailAccountPasswordResetRequest.db.insertRow(
      session,
      EmailAccountPasswordResetRequest(
        emailAccountId: account.id!,
        challengeId: challenge.id!,
        createdAt: clock.now(),
      ),
      transaction: transaction,
    );

    final passwordResetRequestId = resetRequest.id!;
    _config.sendPasswordResetVerificationCode?.call(
      session,
      email: email,
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return passwordResetRequestId;
  }

  /// Returns the credentials for setting the password for the password reset request.
  ///
  /// This method should only be called after the [startPasswordReset] method
  /// has been called successfully.
  ///
  /// The method returns a [completePasswordResetToken] that can be used to
  /// complete the password reset.
  ///
  /// Can throw the following [EmailPasswordResetServerException] subclasses:
  /// - [EmailPasswordResetRequestNotFoundException] if no reset request could
  ///   be found for [passwordResetRequestId].
  /// - [EmailPasswordResetRequestExpiredException] if the reset request has
  ///   expired and has not been cleaned up yet.
  /// - [EmailPasswordResetVerificationCodeAlreadyUsedException] if the
  ///    verification code has already been used.
  /// - [EmailPasswordResetTooManyVerificationAttemptsException] if the user has
  ///   made too many attempts trying to complete the password reset.
  /// - [EmailPasswordResetInvalidVerificationCodeException] if the provided
  ///   [verificationCode] is not valid.
  ///
  /// In case of an invalid [verificationCode] or [passwordResetRequestId], the
  /// failed password reset completion will be logged to the database outside
  /// of the [transaction] and can not be rolled back.
  Future<String> verifyPasswordResetCode(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    return await withReplacedSecretChallengeException(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: passwordResetRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );
  }

  /// Returns the auth user ID for the successfully changed password.
  ///
  /// This method should only be called after the [verifyPasswordResetCode]
  /// method has been called successfully.
  ///
  /// The method takes the [completePasswordResetToken] returned from
  /// [verifyPasswordResetCode] and uses it to complete the password reset.
  ///
  /// Can throw the following [EmailPasswordResetServerException] subclasses:
  /// - [EmailPasswordResetRequestNotFoundException] if no reset request could
  ///   be found for [passwordResetRequestId].
  /// - [EmailPasswordResetNotVerifiedException] if the set
  ///   password token has not been set.
  /// - [EmailPasswordResetRequestExpiredException] if the reset request has
  ///   expired and has not been cleaned up yet.
  /// - [EmailPasswordResetPasswordPolicyViolationException] if the new password
  ///   does not comply with the configured password policy.
  /// - [EmailPasswordResetTooManyVerificationAttemptsException] if the user has
  ///   made too many attempts trying to complete the password reset.
  /// - [EmailPasswordResetInvalidVerificationCodeException] if the provided
  ///   [verificationCode] is not valid.
  Future<UuidValue> completePasswordReset(
    final Session session, {
    required final String completePasswordResetToken,
    required final String newPassword,
    required final Transaction transaction,
  }) async {
    if (!_config.passwordValidationFunction(newPassword)) {
      throw EmailPasswordResetPasswordPolicyViolationException();
    }

    final resetRequest = await withReplacedSecretChallengeException(
      () => _challengeUtil.completeChallenge(
        session,
        completionToken: completePasswordResetToken,
        transaction: transaction,
      ),
    );

    await EmailAccountPasswordResetRequest.db.deleteRow(
      session,
      resetRequest,
      transaction: transaction,
    );

    final account = (await EmailAccount.db.findById(
      session,
      resetRequest.emailAccountId,
      transaction: transaction,
    ));
    if (account == null) {
      throw EmailPasswordResetEmailNotFoundException();
    }

    await setPassword(
      session,
      emailAccount: account,
      password: newPassword,
      transaction: transaction,
    );

    // Call the password reset completion callback
    _config.onPasswordResetCompleted?.call(
      session,
      emailAccountId: account.id!,
      transaction: transaction,
    );

    return account.authUserId;
  }

  /// Deletes password reset requests older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all expired password reset
  /// requests, as configured by the
  /// [EmailIdpConfig.passwordResetVerificationCodeLifetime].
  ///
  /// If [emailAccountId] is provided, only requests for the given email account
  /// will be deleted.
  Future<void> deletePasswordResetRequests(
    final Session session, {
    required Duration? olderThan,
    required final UuidValue? emailAccountId,
    required final Transaction transaction,
  }) async {
    olderThan ??= _config.passwordResetVerificationCodeLifetime;

    final lastValidDateTime = clock.now().subtract(olderThan);

    await EmailAccountPasswordResetRequest.db.deleteWhere(
      session,
      where: (final t) {
        var expression = t.createdAt < lastValidDateTime;
        if (emailAccountId != null) {
          expression &= t.emailAccountId.equals(emailAccountId);
        }
        return expression;
      },
      transaction: transaction,
    );
  }

  /// Deletes password reset request attempts older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// window that is checked upon password reset requests, as configured in
  /// [EmailIdpConfig.maxPasswordResetAttempts].timeframe.
  ///
  /// If [email] is provided, only attempts for the given email will be deleted.
  Future<void> deletePasswordResetRequestAttempts(
    final Session session, {
    required final Duration? olderThan,
    required final String? email,
    required final Transaction transaction,
  }) async {
    await _rateLimitUtil.deleteAttempts(
      session,
      olderThan: olderThan,
      nonce: email,
      transaction: transaction,
    );
  }

  /// Sets the password for the authentication belonging to the given email
  /// account.
  ///
  /// The [password] argument is not checked against the configured password
  /// policy.
  ///
  /// If [password] is `null`, an empty password hash will be set making it
  /// impossible to login with the email account.
  Future<void> setPassword(
    final Session session, {
    required final EmailAccount emailAccount,
    required final String? password,
    required final Transaction transaction,
  }) async {
    final passwordHash = switch (password) {
      null => '',
      final String value => await _passwordHashUtil.createHashFromString(
        secret: value,
      ),
    };

    await EmailAccount.db.updateRow(
      session,
      emailAccount.copyWith(
        passwordHash: passwordHash,
      ),
      transaction: transaction,
    );
  }

  SecretChallengeVerificationConfig<EmailAccountPasswordResetRequest>
  _getVerificationConfig() {
    return SecretChallengeVerificationConfig<EmailAccountPasswordResetRequest>(
      rateLimiter: DatabaseRateLimitedRequestAttemptUtil(
        RateLimitedRequestAttemptConfig(
          domain: 'email',
          source: 'password_reset_complete',
          maxAttempts: _config.passwordResetVerificationCodeAllowedAttempts,
          onRateLimitExceeded: _onRateLimitExceeded,
        ),
      ),
      getRequest: _getPasswordResetRequest,
      isAlreadyUsed: (final request) => request.isVerificationCodeUsed,
      getChallenge: (final request) => request.getChallenge,
      isExpired: _isRequestExpired,
      onExpired: EmailAccountPasswordResetRequest.db.deleteRow,
      linkCompletionToken: _linkSetPasswordChallenge,
    );
  }

  SecretChallengeCompletionConfig<EmailAccountPasswordResetRequest>
  _getCompletionConfig() {
    return SecretChallengeCompletionConfig<EmailAccountPasswordResetRequest>(
      getRequest: _getPasswordResetRequest,
      getCompletionChallenge: (final request) => request.setPasswordChallenge!,
      isExpired: _isRequestExpired,
      onExpired: EmailAccountPasswordResetRequest.db.deleteRow,
    );
  }

  Future<void> _onRateLimitExceeded(
    final Session session,
    final UuidValue requestId,
  ) async {
    await EmailAccountPasswordResetRequest.db.deleteWhere(
      session,
      // Only delete requests that have not been verified yet.
      // This ensures we don't delete requests if verifyPasswordResetCode is
      // accidentally called again.
      where: (final t) =>
          t.id.equals(requestId) & t.setPasswordChallengeId.equals(null),
      // passing no transaction, so this will not be rolled back
    );
  }

  Future<EmailAccountPasswordResetRequest?> _getPasswordResetRequest(
    final Session session,
    final UuidValue requestId, {
    required final Transaction? transaction,
  }) async {
    return await EmailAccountPasswordResetRequest.db.findById(
      session,
      requestId,
      include: EmailAccountPasswordResetRequest.include(
        challenge: SecretChallenge.include(),
        setPasswordChallenge: SecretChallenge.include(),
      ),
      transaction: transaction,
    );
  }

  bool _isRequestExpired(final EmailAccountPasswordResetRequest request) {
    final requestExpiresAt = request.createdAt.add(
      _config.passwordResetVerificationCodeLifetime,
    );
    return requestExpiresAt.isBefore(clock.now());
  }

  /// Links a set password challenge to the password reset request.
  ///
  /// Will throw [EmailPasswordResetVerificationCodeAlreadyUsedException]
  /// if the challenge has already been linked.
  Future<void> _linkSetPasswordChallenge(
    final Session session,
    final EmailAccountPasswordResetRequest request,
    final SecretChallenge setPasswordChallenge, {
    required final Transaction? transaction,
  }) async {
    final updated = await EmailAccountPasswordResetRequest.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.setPasswordChallengeId(setPasswordChallenge.id!),
      ],
      where: (final t) =>
          t.id.equals(request.id!) & t.setPasswordChallengeId.equals(null),
      transaction: transaction,
    );

    if (updated.isEmpty) {
      throw EmailPasswordResetVerificationCodeAlreadyUsedException();
    }
  }

  /// Replaces challenge-related exceptions by email-specific exceptions.
  Future<T> withReplacedSecretChallengeException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on SecretChallengeException catch (e) {
      throw switch (e) {
        ChallengeRequestNotFoundException() =>
          EmailPasswordResetRequestNotFoundException(),
        ChallengeAlreadyUsedException() =>
          EmailPasswordResetVerificationCodeAlreadyUsedException(),
        ChallengeInvalidVerificationCodeException() =>
          EmailPasswordResetInvalidVerificationCodeException(),
        ChallengeExpiredException() =>
          EmailPasswordResetRequestExpiredException(),
        ChallengeNotVerifiedException() =>
          EmailPasswordResetNotVerifiedException(),
        ChallengeInvalidCompletionTokenException() =>
          EmailPasswordResetInvalidVerificationCodeException(),
        ChallengeRateLimitExceededException() =>
          EmailPasswordResetTooManyVerificationAttemptsException(),
      };
    }
  }
}

/// Configuration options for the [EmailIdpPasswordResetUtil] class.
class EmailIdpPasswordResetUtilsConfig {
  /// Function for validating the password.
  final PasswordValidationFunction passwordValidationFunction;

  /// The number of allowed attempts to verify the password reset code.
  final int passwordResetVerificationCodeAllowedAttempts;

  /// The lifetime of the password reset verification code.
  final Duration passwordResetVerificationCodeLifetime;

  /// Callback to be invoked after a password reset is successfully completed.
  final OnPasswordResetCompletedFunction? onPasswordResetCompleted;

  /// The maximum number of password reset attempts allowed within the timeframe.
  final RateLimit maxPasswordResetAttempts;

  /// Function for generating the password reset verification code.
  final String Function() passwordResetVerificationCodeGenerator;

  /// Callback to be invoked for sending out the password reset verification code.
  final SendPasswordResetVerificationCodeFunction?
  sendPasswordResetVerificationCode;

  /// Creates a new [EmailIdpPasswordResetUtilsConfig] instance.
  EmailIdpPasswordResetUtilsConfig({
    required this.passwordValidationFunction,
    required this.passwordResetVerificationCodeAllowedAttempts,
    required this.passwordResetVerificationCodeLifetime,
    required this.onPasswordResetCompleted,
    required this.maxPasswordResetAttempts,
    required this.passwordResetVerificationCodeGenerator,
    required this.sendPasswordResetVerificationCode,
  });

  /// Creates a new [EmailIdpPasswordResetUtilsConfig] instance from an
  /// [EmailIdpConfig] instance.
  factory EmailIdpPasswordResetUtilsConfig.fromEmailIdpConfig(
    final EmailIdpConfig config,
  ) {
    return EmailIdpPasswordResetUtilsConfig(
      passwordValidationFunction: config.passwordValidationFunction,
      passwordResetVerificationCodeAllowedAttempts:
          config.passwordResetVerificationCodeAllowedAttempts,
      passwordResetVerificationCodeLifetime:
          config.passwordResetVerificationCodeLifetime,
      onPasswordResetCompleted: config.onPasswordResetCompleted,
      maxPasswordResetAttempts: config.maxPasswordResetAttempts,
      passwordResetVerificationCodeGenerator:
          config.passwordResetVerificationCodeGenerator,
      sendPasswordResetVerificationCode:
          config.sendPasswordResetVerificationCode,
    );
  }
}

extension on EmailAccountPasswordResetRequest {
  SecretChallenge get getChallenge {
    if (challenge == null) {
      throw StateError(
        'Challenge is required for password reset verification',
      );
    }

    return challenge!;
  }

  bool get isVerificationCodeUsed => setPasswordChallenge != null;
}
