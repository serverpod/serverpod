import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/email_string_extension.dart';

import '../../../../generated/protocol.dart';
import '../../../../utils/byte_data_extension.dart';
import '../../../../utils/secret_hash_util.dart';
import '../../../../utils/uint8list_extension.dart';
import '../../util/session_extension.dart';
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
class EmailIDPPasswordResetUtil {
  final SecretHashUtil _passwordHashUtil;
  final EmailIDPPasswordResetUtilsConfig _config;

  /// Creates a new [EmailIDPPasswordResetUtil] instance.
  EmailIDPPasswordResetUtil({
    required final EmailIDPPasswordResetUtilsConfig config,
    required final SecretHashUtil passwordHashUtils,
  })  : _config = config,
        _passwordHashUtil = passwordHashUtils;

  /// Returns the auth user ID for the successfully changed password.
  ///
  /// Can throw the following [EmailPasswordResetServerException] subclasses:
  /// - [EmailPasswordResetRequestNotFoundException] if no reset request could
  ///   be found for [passwordResetRequestId].
  /// - [EmailPasswordResetRequestExpiredException] if the reset request has
  ///   expired and has not been cleaned up yet.
  /// - [EmailPasswordResetPasswordPolicyViolationException] if the new password
  ///   does not comply with the configured password policy.
  /// - [EmailPasswordResetTooManyVerificationAttemptsException] if the user has
  ///   made too many attempts trying to complete the password reset.
  /// - [EmailPasswordResetInvalidVerificationCodeException] if the provided
  ///   [verificationCode] is not valid.
  ///
  /// In case of an invalid [verificationCode] or [passwordResetRequestId], the
  /// failed password reset completion will be logged to the database outside
  /// of the [transaction] and can not be rolled back.
  Future<UuidValue> completePasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final String newPassword,
    required final Transaction transaction,
  }) async {
    if (!_config.passwordValidationFunction(newPassword)) {
      throw EmailPasswordResetPasswordPolicyViolationException();
    }

    final resetRequest = await EmailAccountPasswordResetRequest.db.findById(
      session,
      passwordResetRequestId,
      include: EmailAccountPasswordResetRequest.include(
        challenge: SecretChallenge.include(),
      ),
      transaction: transaction,
    );

    if (resetRequest == null) {
      throw EmailPasswordResetRequestNotFoundException();
    }

    if (await _hasTooManyPasswordResetCompleteAttempts(
      session,
      passwordResetRequestId: resetRequest.id!,
    )) {
      await EmailAccountPasswordResetRequest.db.deleteRow(
        session,
        resetRequest,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailPasswordResetTooManyVerificationAttemptsException();
    }

    final challenge = resetRequest.getChallenge;

    if (!await _passwordHashUtil.validateHash(
      value: verificationCode,
      hash: challenge.challengeCodeHash.asUint8List,
      salt: challenge.challengeCodeSalt.asUint8List,
    )) {
      throw EmailPasswordResetInvalidVerificationCodeException();
    }

    if (resetRequest.isExpired(_config.passwordResetVerificationCodeLifetime)) {
      await EmailAccountPasswordResetRequest.db.deleteRow(
        session,
        resetRequest,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailPasswordResetRequestExpiredException();
    }

    await EmailAccountPasswordResetRequest.db.deleteRow(
      session,
      resetRequest,
      transaction: transaction,
    );

    final account = (await EmailAccount.db.findById(
      session,
      resetRequest.emailAccountId,
      transaction: transaction,
    ))!;

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

  /// Returns the credentials for setting the password for the password reset request.
  ///
  /// This method should only be called after the [startPasswordReset] method
  /// has been called successfully.
  ///
  /// The [verificationCode] returned from [startPasswordReset] is used to
  /// validate the password reset request.
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
  Future<SetPasswordCredentials> verifyPasswordResetCode(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    final resetRequest = await EmailAccountPasswordResetRequest.db.findById(
      session,
      passwordResetRequestId,
      include: EmailAccountPasswordResetRequest.include(
        challenge: SecretChallenge.include(),
        setPasswordChallenge: SecretChallenge.include(),
      ),
      transaction: transaction,
    );

    if (resetRequest == null) {
      throw EmailPasswordResetRequestNotFoundException();
    }

    if (await _hasTooManyPasswordResetCompleteAttempts(
      session,
      passwordResetRequestId: resetRequest.id!,
    )) {
      await EmailAccountPasswordResetRequest.db.deleteRow(
        session,
        resetRequest,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailPasswordResetTooManyVerificationAttemptsException();
    }

    if (resetRequest.isExpired(_config.passwordResetVerificationCodeLifetime)) {
      await EmailAccountPasswordResetRequest.db.deleteRow(
        session,
        resetRequest,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailPasswordResetRequestExpiredException();
    }

    if (resetRequest.isVerificationCodeUsed) {
      throw EmailPasswordResetVerificationCodeAlreadyUsedException();
    }

    final challenge = resetRequest.getChallenge;

    if (!await _passwordHashUtil.validateHash(
      value: verificationCode,
      hash: challenge.challengeCodeHash.asUint8List,
      salt: challenge.challengeCodeSalt.asUint8List,
    )) {
      throw EmailPasswordResetInvalidVerificationCodeException();
    }

    final setPasswordToken = _config.setPasswordTokenGenerator();
    final setPasswordTokenHash = await _passwordHashUtil.createHash(
      value: setPasswordToken,
    );

    final setPasswordChallenge = await SecretChallenge.db.insertRow(
      session,
      SecretChallenge(
        challengeCodeHash: setPasswordTokenHash.hash.asByteData,
        challengeCodeSalt: setPasswordTokenHash.salt.asByteData,
      ),
      transaction: transaction,
    );

    await EmailAccountPasswordResetRequest.db.updateRow(
      session,
      resetRequest.copyWith(
        setPasswordChallengeId: setPasswordChallenge.id!,
      ),
      transaction: transaction,
    );

    return (
      passwordResetRequestId: resetRequest.id!,
      verificationCode: setPasswordToken,
    );
  }

  /// Deletes password reset requests older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all expired password reset
  /// requests, as configured by the
  /// [EmailIDPConfig.passwordResetVerificationCodeLifetime].
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
  /// [EmailIDPConfig.maxPasswordResetAttempts].timeframe.
  ///
  /// If [email] is provided, only attempts for the given email will be deleted.
  Future<void> deletePasswordResetRequestAttempts(
    final Session session, {
    required Duration? olderThan,
    required final String? email,
    required final Transaction transaction,
  }) async {
    olderThan ??= _config.maxPasswordResetAttempts.timeframe;

    final lastValidDateTime = clock.now().subtract(olderThan);

    await EmailAccountPasswordResetRequestAttempt.db.deleteWhere(
      session,
      where: (final t) {
        var expression = t.attemptedAt < lastValidDateTime;
        if (email != null) {
          expression &= t.email.equals(email.normalizedEmail);
        }
        return expression;
      },
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
      null => HashResult.empty(),
      final String value => await _passwordHashUtil.createHash(value: value),
    };

    await EmailAccount.db.updateRow(
      session,
      emailAccount.copyWith(
        passwordHash: passwordHash.hash.asByteData,
        passwordSalt: passwordHash.salt.asByteData,
      ),
      transaction: transaction,
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
  /// Can throw [EmailPasswordResetTooManyAttemptsException] if the account
  /// email does not exist in the database.
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

    if (await _hasTooManyPasswordResetRequestAttempts(
      session,
      email: email,
    )) {
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

    final verificationCodeHash = await _passwordHashUtil.createHash(
      value: verificationCode,
    );

    final challenge = await SecretChallenge.db.insertRow(
      session,
      SecretChallenge(
        challengeCodeHash: verificationCodeHash.hash.asByteData,
        challengeCodeSalt: verificationCodeHash.salt.asByteData,
      ),
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

  Future<bool> _hasTooManyPasswordResetCompleteAttempts(
    final Session session, {
    required final UuidValue passwordResetRequestId,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    return session.db.transaction(
      (final transaction) async {
        await EmailAccountPasswordResetCompleteAttempt.db.insertRow(
          session,
          EmailAccountPasswordResetCompleteAttempt(
            ipAddress: session.remoteIpAddress,
            passwordResetRequestId: passwordResetRequestId,
          ),
          transaction: transaction,
        );

        final attempts =
            await EmailAccountPasswordResetCompleteAttempt.db.count(
          session,
          where: (final t) =>
              t.passwordResetRequestId.equals(passwordResetRequestId),
          transaction: transaction,
        );

        return attempts > _config.passwordResetVerificationCodeAllowedAttempts;
      },
    );
  }

  Future<bool> _hasTooManyPasswordResetRequestAttempts(
    final Session session, {
    required final String email,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    return session.db.transaction((final transaction) async {
      await EmailAccountPasswordResetRequestAttempt.db.insertRow(
        session,
        EmailAccountPasswordResetRequestAttempt(
          email: email,
          ipAddress: session.remoteIpAddress,
          attemptedAt: clock.now(),
        ),
        transaction: transaction,
      );

      final oldestRelevantAttemptTimestamp = clock.now().subtract(
            _config.maxPasswordResetAttempts.timeframe,
          );

      final recentRequests =
          await EmailAccountPasswordResetRequestAttempt.db.count(
        session,
        where: (final t) =>
            t.email.equals(email) &
            (t.attemptedAt > oldestRelevantAttemptTimestamp),
        transaction: transaction,
      );

      return recentRequests > _config.maxPasswordResetAttempts.maxAttempts;
    });
  }
}

/// Configuration options for the [EmailIDPPasswordResetUtil] class.
class EmailIDPPasswordResetUtilsConfig {
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

  /// Function for generating the set password token.
  final String Function() setPasswordTokenGenerator;

  /// Callback to be invoked for sending out the password reset verification code.
  final SendPasswordResetVerificationCodeFunction?
      sendPasswordResetVerificationCode;

  /// Creates a new [EmailIDPPasswordResetUtilsConfig] instance.
  EmailIDPPasswordResetUtilsConfig({
    required this.passwordValidationFunction,
    required this.passwordResetVerificationCodeAllowedAttempts,
    required this.passwordResetVerificationCodeLifetime,
    required this.onPasswordResetCompleted,
    required this.maxPasswordResetAttempts,
    required this.passwordResetVerificationCodeGenerator,
    required this.sendPasswordResetVerificationCode,
    required this.setPasswordTokenGenerator,
  });

  /// Creates a new [EmailIDPPasswordResetUtilsConfig] instance from an
  /// [EmailIDPConfig] instance.
  factory EmailIDPPasswordResetUtilsConfig.fromEmailIDPConfig(
      final EmailIDPConfig config) {
    return EmailIDPPasswordResetUtilsConfig(
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
      setPasswordTokenGenerator: config.setPasswordTokenGenerator,
    );
  }
}

extension on EmailAccountPasswordResetRequest {
  bool isExpired(final Duration passwordResetVerificationCodeLifetime) {
    final resetExpiresAt = createdAt.add(
      passwordResetVerificationCodeLifetime,
    );

    return resetExpiresAt.isBefore(clock.now());
  }

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

/// The credentials for setting the password for the password reset request.
typedef SetPasswordCredentials = ({
  UuidValue passwordResetRequestId,
  String verificationCode,
});
