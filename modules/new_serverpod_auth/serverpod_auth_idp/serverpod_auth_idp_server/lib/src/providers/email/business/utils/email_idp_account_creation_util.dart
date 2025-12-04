import 'package:clock/clock.dart';
import 'package:email_validator/email_validator.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../util/email_string_extension.dart';
import '../email_idp_config.dart';
import '../email_idp_server_exceptions.dart';

/// {@template email_idp_account_creation_util}
/// This class contains utility functions for the email identity provider
/// account creation.
///
/// The main entry point is the [startRegistration] method, which returns a
/// [UuidValue] with the ID of the account request.
///
/// This class also contains utility functions for administration tasks, such as
/// deleting expired account creations and verifying account creations.
///
/// {@endtemplate}
class EmailIdpAccountCreationUtil {
  final Argon2HashUtil _hashUtils;
  final EmailIdpAccountCreationUtilsConfig _config;
  final AuthUsers _authUsers;
  late final SecretChallengeUtil<EmailAccountRequest> _challengeUtil;

  /// Creates a new [EmailIdpAccountCreationUtil] instance.
  EmailIdpAccountCreationUtil({
    required final EmailIdpAccountCreationUtilsConfig config,
    required final Argon2HashUtil passwordHashUtils,
    required final AuthUsers authUsers,
  }) : _config = config,
       _authUsers = authUsers,
       _hashUtils = passwordHashUtils {
    _challengeUtil = SecretChallengeUtil(
      verificationConfig: _getVerificationConfig(),
      completionConfig: _getCompletionConfig(),
      hashUtil: passwordHashUtils,
    );
  }

  /// {@template email_idp_account_creation_util.start_account_creation}
  /// Starts the account creation process for creating a new email account.
  ///
  /// Given a valid email address, this method will create a new account request
  /// and call [sendRegistrationVerificationCode] with a verification code and
  /// the account request ID. The verification code together with the account
  /// request ID should be used to verify the account request via
  /// [verifyRegistrationCode].
  ///
  /// The method will throw the following [EmailAccountRequestServerException]
  /// subclasses:
  /// - [EmailAccountRequestInvalidEmailException] if the email address is not valid.
  /// - [EmailAccountAlreadyRegisteredException] if the email address is already registered.
  /// - [EmailAccountRequestAlreadyExistsException] if an account request already exists for the email address.
  ///
  /// It is important that the caller does not leak the existence of the
  /// account request to the outside client.
  ///
  /// If successful, this method returns the ID of the account request.
  /// This can be used in as a reference to add additional information to the
  /// account once it has been completed.
  /// {@endtemplate}
  Future<UuidValue> startRegistration(
    final Session session, {
    required String email,
    required final Transaction transaction,
  }) async {
    email = email.normalizedEmail;

    if (!EmailValidator.validate(email)) {
      throw EmailAccountRequestInvalidEmailException();
    }

    final existingAccountCount = await EmailAccount.db.count(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );
    if (existingAccountCount > 0) {
      throw EmailAccountAlreadyRegisteredException();
    }

    final verificationCode = _config.registrationVerificationCodeGenerator();

    final pendingAccountRequest = await EmailAccountRequest.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );
    if (pendingAccountRequest != null) {
      if (pendingAccountRequest.createdAt.isBefore(
        clock.now().subtract(
          _config.registrationVerificationCodeLifetime,
        ),
      )) {
        await EmailAccountRequest.db.deleteRow(
          session,
          pendingAccountRequest,
          transaction: transaction,
        );
      } else {
        throw EmailAccountRequestAlreadyExistsException();
      }
    }

    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final emailAccountRequest = await EmailAccountRequest.db.insertRow(
      session,
      EmailAccountRequest(
        email: email,
        challengeId: challenge.id!,
        createdAt: clock.now(),
      ),
      transaction: transaction,
    );

    _config.sendRegistrationVerificationCode?.call(
      session,
      email: email,
      accountRequestId: emailAccountRequest.id!,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return emailAccountRequest.id!;
  }

  /// Method for verifying the account request code returned by [startRegistration].
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailAccountRequestVerificationTooManyAttemptsException] in case the
  ///   user has made too many attempts to verify the account.
  /// - [EmailAccountRequestNotFoundException] if the request does not exist or
  ///   has already been completed.
  /// - [EmailAccountRequestVerificationCodeAlreadyUsedException] if the
  ///   verification code has already been used.
  /// - [EmailAccountRequestInvalidVerificationCodeException] if the provided
  ///   verification code is not valid.
  /// - [EmailAccountRequestVerificationExpiredException] if the request is
  ///   completed with the correct verification code, but has already expired.
  ///   but has not been cleaned up yet.
  ///
  /// In case of an invalid [verificationCode], the failed attempt will be
  /// logged to the database outside of the [transaction] and can not be rolled
  /// back.
  ///
  /// Successfully verifying the account request code will return a token that
  /// can be used to complete the account creation process via
  /// [completeAccountCreation].
  Future<String> verifyRegistrationCode(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    return await withReplacedSecretChallengeException(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: accountRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );
  }

  /// The last step in the account creation process.
  ///
  /// Given a token returned by [verifyRegistrationCode], this method will
  /// complete the account creation process by creating a new authentication
  /// user and linking the account request to it.
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailPasswordPolicyViolationException] if the password does not comply
  ///   with the password policy.
  /// - [EmailAccountRequestInvalidVerificationCodeException] if the provided
  ///   [completeAccountCreationToken] is not valid.
  /// - [EmailAccountRequestNotFoundException] if the request does not exist.
  /// - [EmailAccountRequestNotVerifiedException] if the request has not been verified yet.
  /// - [EmailAccountRequestVerificationExpiredException] if the request is
  ///   completed with the correct verification code, but has already expired.
  /// - [EmailAccountRequestVerificationTooManyAttemptsException] in case the
  ///   user has made too many attempts to verify the account.
  ///
  /// Returns the result of the operation with the ID of the new authentication
  /// user, the account request ID and the email address used during registration.
  ///
  /// The account request will be deleted after successful completion.
  ///
  /// In case of an invalid [completeAccountCreationToken], the failed attempt will be
  /// logged to the database outside of the [transaction] and can not be rolled
  /// back.
  Future<EmailIdpCompleteAccountCreationResult> completeAccountCreation(
    final Session session, {
    required final String completeAccountCreationToken,
    required final String password,
    required final Transaction transaction,
  }) async {
    if (!_config.passwordValidationFunction(password)) {
      throw EmailPasswordPolicyViolationException();
    }

    final request = await withReplacedSecretChallengeException(
      () => _challengeUtil.completeChallenge(
        session,
        completionToken: completeAccountCreationToken,
        transaction: transaction,
      ),
    );

    await EmailAccountRequest.db.deleteRow(
      session,
      request,
      transaction: transaction,
    );

    final newUser = await _authUsers.create(
      session,
      transaction: transaction,
    );

    final passwordHash = await _hashUtils.createHashFromString(
      secret: password,
    );

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

    return EmailIdpCompleteAccountCreationResult._(
      authUserId: newUser.id,
      accountRequestId: request.id!,
      email: request.email,
      scopes: newUser.scopes,
    );
  }

  /// {@template email_idp_account_creation_util.create_email_authentication}
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
  /// {@endtemplate}
  Future<UuidValue> createEmailAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final String email,
    required final String? password,
    required final Transaction transaction,
  }) async {
    final passwordHash = switch (password) {
      final String password => await _hashUtils.createHashFromString(
        secret: password,
      ),
      null => '',
    };

    final account = await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: email.normalizedEmail,
        passwordHash: passwordHash,
      ),
      transaction: transaction,
    );

    return account.id!;
  }

  /// {@template email_idp_account_creation_util.delete_email_account_request_by_id}
  /// Deletes an account request by its ID.
  /// {@endtemplate}
  Future<void> deleteEmailAccountRequestById(
    final Session session,
    final UuidValue accountRequestId, {
    required final Transaction transaction,
  }) async {
    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(accountRequestId),
      transaction: transaction,
    );
  }

  /// {@template email_idp_account_creation_util.delete_expired_account_requests}
  /// Deletes expired account creation requests.
  /// {@endtemplate}
  Future<void> deleteExpiredAccountRequests(
    final Session session, {
    required final Transaction transaction,
  }) async {
    final lastValidDateTime = clock.now().subtract(
      _config.registrationVerificationCodeLifetime,
    );

    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final t) => t.createdAt < lastValidDateTime,
      transaction: transaction,
    );
  }

  /// {@template email_idp_account_creation_util.find_active_email_account_request}
  /// Checks whether an email account request is still pending, and if so
  /// returns the associated request.
  ///
  /// In case the registration is expired this returns `null`.
  /// {@endtemplate}
  Future<EmailAccountRequest?> findActiveEmailAccountRequest(
    final Session session, {
    required final UuidValue accountRequestId,
    required final Transaction? transaction,
  }) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      transaction: transaction,
    );

    if (request == null || _isRequestExpired(request)) {
      return null;
    }

    return request;
  }

  SecretChallengeVerificationConfig<EmailAccountRequest>
  _getVerificationConfig() {
    return SecretChallengeVerificationConfig(
      rateLimiter: DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
        RateLimitedRequestAttemptConfig(
          domain: 'email',
          source: 'account_creation_verification',
          maxAttempts: _config.registrationVerificationCodeAllowedAttempts,
          onRateLimitExceeded: _onRateLimitExceeded,
        ),
      ),
      getRequest: _getAccountRequest,
      isAlreadyUsed: (final request) => request.isRequestVerified,
      getChallenge: (final request) => request.getChallenge,
      isExpired: _isRequestExpired,
      onExpired: EmailAccountRequest.db.deleteRow,
      linkCompletionToken: _linkCreateAccountChallenge,
    );
  }

  SecretChallengeCompletionConfig<EmailAccountRequest> _getCompletionConfig() {
    return SecretChallengeCompletionConfig(
      getRequest: _getAccountRequest,
      getCompletionChallenge: (final request) => request.createAccountChallenge,
      isExpired: _isRequestExpired,
      onExpired: EmailAccountRequest.db.deleteRow,
    );
  }

  Future<void> _onRateLimitExceeded(
    final Session session,
    final UuidValue requestId,
  ) async {
    await EmailAccountRequest.db.deleteWhere(
      session,
      // Only delete requests that have not been verified yet.
      // This ensures we don't delete requests if verifyAccountRequestCode is
      // accidentally called again.
      where: (final t) =>
          t.id.equals(requestId) & t.createAccountChallengeId.equals(null),
      // passing no transaction, so this will not be rolled back
    );
  }

  Future<EmailAccountRequest?> _getAccountRequest(
    final Session session,
    final UuidValue accountRequestId, {
    required final Transaction? transaction,
  }) async {
    return await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      transaction: transaction,
      include: EmailAccountRequest.include(
        challenge: SecretChallenge.include(),
        createAccountChallenge: SecretChallenge.include(),
      ),
    );
  }

  bool _isRequestExpired(final EmailAccountRequest request) {
    final requestExpiresAt = request.createdAt.add(
      _config.registrationVerificationCodeLifetime,
    );
    return requestExpiresAt.isBefore(clock.now());
  }

  /// Links a create account challenge to the account request.
  ///
  /// Will throw [EmailAccountRequestVerificationCodeAlreadyUsedException]
  /// if the challenge has already been linked.
  Future<void> _linkCreateAccountChallenge(
    final Session session,
    final EmailAccountRequest request,
    final SecretChallenge createAccountChallenge, {
    required final Transaction? transaction,
  }) async {
    final updated = await EmailAccountRequest.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.createAccountChallengeId(createAccountChallenge.id!),
      ],
      where: (final t) =>
          t.id.equals(request.id!) & t.createAccountChallengeId.equals(null),
      transaction: transaction,
    );

    if (updated.isEmpty) {
      throw EmailAccountRequestVerificationCodeAlreadyUsedException();
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
          EmailAccountRequestNotFoundException(),
        ChallengeAlreadyUsedException() =>
          EmailAccountRequestVerificationCodeAlreadyUsedException(),
        ChallengeInvalidVerificationCodeException() =>
          EmailAccountRequestInvalidVerificationCodeException(),
        ChallengeExpiredException() =>
          EmailAccountRequestVerificationExpiredException(),
        ChallengeNotVerifiedException() =>
          EmailAccountRequestNotVerifiedException(),
        ChallengeInvalidCompletionTokenException() =>
          EmailAccountRequestInvalidVerificationCodeException(),
        ChallengeRateLimitExceededException() =>
          EmailAccountRequestVerificationTooManyAttemptsException(),
      };
    }
  }
}

/// Configuration for the [EmailIdpAccountCreationUtil] class.
class EmailIdpAccountCreationUtilsConfig {
  /// Callback to be invoked after a new email account has been created.
  final AfterAccountCreatedFunction? onAfterAccountCreated;

  /// Function for validating the password.
  final PasswordValidationFunction passwordValidationFunction;

  /// Function for generating the registration verification code.
  final String Function() registrationVerificationCodeGenerator;

  /// The lifetime of the registration verification code.
  final Duration registrationVerificationCodeLifetime;

  /// The number of allowed attempts to verify the registration code.
  final int registrationVerificationCodeAllowedAttempts;

  /// Function for sending the registration verification code.
  final SendRegistrationVerificationCodeFunction?
  sendRegistrationVerificationCode;

  /// Creates a new [EmailIdpAccountCreationUtilsConfig] instance.
  EmailIdpAccountCreationUtilsConfig({
    required this.passwordValidationFunction,
    required this.registrationVerificationCodeGenerator,
    required this.registrationVerificationCodeLifetime,
    required this.registrationVerificationCodeAllowedAttempts,
    required this.sendRegistrationVerificationCode,
    required this.onAfterAccountCreated,
  });

  /// Creates a new [EmailIdpAccountCreationUtilsConfig] instance from an
  /// [EmailIdpConfig] instance.
  factory EmailIdpAccountCreationUtilsConfig.fromEmailIdpConfig(
    final EmailIdpConfig config,
  ) {
    return EmailIdpAccountCreationUtilsConfig(
      passwordValidationFunction: config.passwordValidationFunction,
      registrationVerificationCodeGenerator:
          config.registrationVerificationCodeGenerator,
      registrationVerificationCodeLifetime:
          config.registrationVerificationCodeLifetime,
      registrationVerificationCodeAllowedAttempts:
          config.registrationVerificationCodeAllowedAttempts,
      sendRegistrationVerificationCode: config.sendRegistrationVerificationCode,
      onAfterAccountCreated: config.onAfterAccountCreated,
    );
  }
}

/// The result of the [EmailIdpAccountCreationUtil.completeAccountCreation] operation.
class EmailIdpCompleteAccountCreationResult {
  /// The ID of the new authentication user.
  final UuidValue authUserId;

  /// The ID of the account request that was completed.
  final UuidValue accountRequestId;

  /// The scopes of the new authentication user.
  final Set<Scope> scopes;

  /// The email address used during registration.
  final String email;

  EmailIdpCompleteAccountCreationResult._({
    required this.authUserId,
    required this.accountRequestId,
    required this.email,
    required this.scopes,
  });
}

/// The result of the [EmailIdpAccountCreationUtil.completeAccountCreation] operation.
///
/// This describes the detailed status of the operation to the caller.
///
/// In the general case the caller should take care not to leak this to clients,
/// such that outside clients can not use this result to determine whether a
/// specific account is registered on the server.
class EmailIdpCompleteAccountRequestResult {
  /// The ID of the new email authentication.
  final UuidValue accountId;

  /// The email address used during registration.
  final String email;

  EmailIdpCompleteAccountRequestResult._({
    required this.accountId,
    required this.email,
  });
}

extension on EmailAccountRequest {
  SecretChallenge get getChallenge {
    if (challenge == null) {
      throw StateError(
        'Challenge is required for account request verification',
      );
    }

    return challenge!;
  }
}

/// Extension methods for [EmailAccountRequest].
extension EmailAccountRequestExtension on EmailAccountRequest {
  /// Checks whether the account request has been verified.
  bool get isRequestVerified => createAccountChallenge != null;
}
