import 'package:clock/clock.dart';
import 'package:email_validator/email_validator.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/email_string_extension.dart';

import '../../../../../core.dart';
import '../../../../generated/protocol.dart';
import '../../../../utils/byte_data_extension.dart';
import '../../../../utils/secret_hash_util.dart';
import '../../../../utils/uint8list_extension.dart';
import '../../util/session_extension.dart';
import '../email_idp_config.dart';
import '../email_idp_server_exceptions.dart';

/// This describes the detailed status of the account creation operation.
///
/// In the general case the caller should take care not to leak this to clients,
/// such that outside clients can not use this result to determine whether a
/// specific account is registered on the server.
enum EmailAccountRequestResult {
  /// An account request has been created.
  accountRequestCreated,

  /// There is a pending account request for this email already.
  ///
  /// No account request has been created.
  emailAlreadyRequested,

  /// There an account for this email already.
  ///
  /// No account request has been created.
  emailAlreadyRegistered,

  /// The given email does not seem valid.
  ///
  /// No account request has been created.
  emailInvalid,
}

/// The result of the [EmailIDPAccountCreationUtil.startAccountCreation] operation.
///
/// This describes the detailed status of the operation to the caller.
///
/// In the general case the caller should take care not to leak this to clients,
/// such that outside clients can not use this result to determine whether a
/// specific account is registered on the server.
class EmailIDPAccountCreationResult {
  /// The result of the operation.
  final EmailAccountRequestResult result;

  /// The account request ID if the operation was successful.
  final UuidValue? accountRequestId;

  /// Creates a new [EmailIDPAccountCreationResult] with the result [EmailAccountRequestResult.accountRequestCreated].
  factory EmailIDPAccountCreationResult.accountRequestCreated(
    final UuidValue accountRequestId,
  ) {
    return EmailIDPAccountCreationResult._(
      result: EmailAccountRequestResult.accountRequestCreated,
      accountRequestId: accountRequestId,
    );
  }

  /// Creates a new [EmailIDPAccountCreationResult] with the result [EmailAccountRequestResult.emailAlreadyRegistered].
  factory EmailIDPAccountCreationResult.emailAlreadyRegistered() {
    return EmailIDPAccountCreationResult._(
      result: EmailAccountRequestResult.emailAlreadyRegistered,
      accountRequestId: null,
    );
  }

  /// Creates a new [EmailIDPAccountCreationResult] with the result [EmailAccountRequestResult.emailAlreadyRequested].
  factory EmailIDPAccountCreationResult.emailAlreadyRequested() {
    return EmailIDPAccountCreationResult._(
      result: EmailAccountRequestResult.emailAlreadyRequested,
      accountRequestId: null,
    );
  }

  /// Creates a new [EmailIDPAccountCreationResult] with the result [EmailAccountRequestResult.emailInvalid].
  factory EmailIDPAccountCreationResult.emailInvalid() {
    return EmailIDPAccountCreationResult._(
      result: EmailAccountRequestResult.emailInvalid,
      accountRequestId: null,
    );
  }

  EmailIDPAccountCreationResult._({
    required this.result,
    required this.accountRequestId,
  });
}

/// {@template email_idp_account_creation_util}
/// This class contains utility functions for the email identity provider
/// account creation.
///
/// The main entry point is the [startAccountCreation] method, which returns a
/// [EmailIDPAccountCreationResult] with the result of the operation.
///
/// This class also contains utility functions for administration tasks, such as
/// deleting expired account creations and verifying account creations.
///
/// {@endtemplate}
class EmailIDPAccountCreationUtil {
  final SecretHashUtil _hashUtils;
  final EmailIDPAccountCreationUtilsConfig _config;

  /// Creates a new [EmailIDPAccountCreationUtil] instance.
  EmailIDPAccountCreationUtil({
    required final EmailIDPAccountCreationUtilsConfig config,
    required final SecretHashUtil passwordHashUtils,
  })  : _config = config,
        _hashUtils = passwordHashUtils;

  /// Completes the account creation process by creating a new authentication
  /// user and linking the account request to it.
  ///
  /// Returns the result of the operation with the ID of the new authentication
  /// user and the email address used during registration.
  ///
  /// Internally this will first verify the verification code via
  /// [verifyAccountRequest], then create a new [AuthUser] and finally link the
  /// email account to it via [finalizeAccountRequest].
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailAccountRequestNotFoundException] if the request does not exist.
  /// - [EmailAccountRequestVerificationExpiredException] if the request is
  ///   completed with the correct verification code, but has already expired.
  /// - [EmailAccountRequestVerificationTooManyAttemptsException] in case the
  ///   user has made too many attempts to verify the account.
  /// - [EmailAccountRequestInvalidVerificationCodeException] if the provided
  ///   verification code is not valid.
  ///
  /// In case of an invalid [verificationCode], the failed attempt will be
  /// logged to the database outside of the [transaction] and can not be rolled
  /// back.
  Future<EmailIDPCompleteAccountCreationResult> completeAccountCreation(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    final verifiedAccountRequest = await verifyAccountRequest(
      session,
      accountRequestId: accountRequestId,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final newUser = await AuthUsers.create(
      session,
      transaction: transaction,
    );
    final authUserId = newUser.id;

    await finalizeAccountRequest(
      session,
      accountRequestId: verifiedAccountRequest.id!,
      authUserId: authUserId,
      transaction: transaction,
    );

    return EmailIDPCompleteAccountCreationResult._(
      authUserId: authUserId,
      email: verifiedAccountRequest.email,
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
    final passwordHash = password != null
        ? await _hashUtils.createHash(
            value: password,
          )
        : HashResult.empty();

    final account = await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: email.normalizedEmail,
        passwordHash: passwordHash.hash.asByteData,
        passwordSalt: passwordHash.salt.asByteData,
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

  /// Finalize the account request by creating a new email account and linking
  /// it to the authentication user.
  ///
  /// The [accountRequestId] must be the ID of a verified account request.
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailAccountRequestNotFoundException] if the request does not exist or
  ///   has already been completed.
  /// - [EmailAccountRequestNotVerifiedException] if the request has not been
  ///   verified.
  ///
  /// Returns the `ID` of the new email authentication, and the email address
  /// used during registration.
  Future<EmailIDPFinalizeAccountRequestResult> finalizeAccountRequest(
    final Session session, {
    required final UuidValue accountRequestId,

    /// Authentication user ID this account should be linked up with
    required final UuidValue authUserId,
    required final Transaction transaction,
  }) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      transaction: transaction,
    );

    if (request == null) {
      throw EmailAccountRequestNotFoundException();
    }

    if (request.verifiedAt == null) {
      throw EmailAccountRequestNotVerifiedException();
    }

    await EmailAccountRequest.db.deleteRow(
      session,
      request,
      transaction: transaction,
    );

    final account = await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: request.email,
        passwordHash: request.passwordHash,
        passwordSalt: request.passwordSalt,
      ),
      transaction: transaction,
    );

    return EmailIDPFinalizeAccountRequestResult._(
      accountId: account.id!,
      email: request.email,
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

    if (request == null) return null;

    if (request.isExpired(_config.registrationVerificationCodeLifetime)) {
      return null;
    }

    return request;
  }

  /// {@template email_idp_account_creation_util.start_account_creation}
  /// Returns the result of the operation and a process ID for the account
  /// request.
  ///
  /// If the `result` is [EmailAccountRequestResult.accountRequestCreated], an
  /// account request has been created and a verification email has been sent.
  /// In all other cases, `accountRequestId` will be `null`.
  ///
  /// The caller should ensure that the actual result does not leak to the
  /// outside client. Instead clients generally should always see a message like
  /// "If this email was not registered already, a new account has been created
  /// and a verification email has been sent". This prevents the endpoint from
  /// being misused to scan for registered/valid email addresses.
  ///
  /// The caller might decide to initiate a password reset (via email, not in
  /// the client response), to help users which try to register but already have
  /// an account.
  ///
  /// Can throw an [EmailPasswordPolicyViolationException] if the password does
  /// not meet the password policy.
  ///
  /// In the success case of [EmailAccountRequestResult.accountRequestCreated],
  /// the caller may store additional information attached to the
  /// `accountRequestId`, which will be returned from [verifyAccountRequest]
  /// later on.
  /// {@endtemplate}
  Future<EmailIDPAccountCreationResult> startAccountCreation(
    final Session session, {
    required String email,
    required final String password,
    required final Transaction transaction,
  }) async {
    if (!_config.passwordValidationFunction(password)) {
      throw EmailPasswordPolicyViolationException();
    }

    email = email.normalizedEmail;

    if (!EmailValidator.validate(email)) {
      return EmailIDPAccountCreationResult.emailInvalid();
    }

    final existingAccountCount = await EmailAccount.db.count(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );
    if (existingAccountCount > 0) {
      return EmailIDPAccountCreationResult.emailAlreadyRegistered();
    }

    final verificationCode = _config.registrationVerificationCodeGenerator();

    final pendingAccountRequest = await EmailAccountRequest.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );
    if (pendingAccountRequest != null) {
      if (pendingAccountRequest.createdAt.isBefore(clock.now().subtract(
            _config.registrationVerificationCodeLifetime,
          ))) {
        await EmailAccountRequest.db.deleteRow(
          session,
          pendingAccountRequest,
          transaction: transaction,
        );
      } else {
        return EmailIDPAccountCreationResult.emailAlreadyRequested();
      }
    }

    final passwordHash = await _hashUtils.createHash(
      value: password,
    );
    final verificationCodeHash = await _hashUtils.createHash(
      value: verificationCode,
    );

    final challenge = await EmailAccountChallenge.db.insertRow(
      session,
      EmailAccountChallenge(
        challengeCodeHash: verificationCodeHash.hash.asByteData,
        challengeCodeSalt: verificationCodeHash.salt.asByteData,
      ),
      transaction: transaction,
    );

    final emailAccountRequest = await EmailAccountRequest.db.insertRow(
      session,
      EmailAccountRequest(
        email: email,
        passwordHash: passwordHash.hash.asByteData,
        passwordSalt: passwordHash.salt.asByteData,
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

    return EmailIDPAccountCreationResult.accountRequestCreated(
      emailAccountRequest.id!,
    );
  }

  /// Checks whether the verification code matches the pending account creation
  /// request.
  ///
  /// If this returns successfully, this means [finalizeAccountRequest] can be
  /// called.
  ///
  /// Can throw the following [EmailAccountRequestServerException] subclasses:
  /// - [EmailAccountRequestNotFoundException] if the request does not exist or
  ///   has already been completed.
  /// - [EmailAccountRequestVerificationExpiredException] if the request is
  ///   completed with the correct verification code, but has already expired.
  ///   but has not been cleaned up yet.
  /// - [EmailAccountRequestVerificationTooManyAttemptsException] in case the
  ///   user has made too many attempts to verify the account.
  /// - [EmailAccountRequestInvalidVerificationCodeException] if the provided
  ///   verification code is not valid.
  ///
  /// In case of an invalid [verificationCode], the failed attempt will be
  /// logged to the database outside of the [transaction] and can not be rolled
  /// back.
  Future<EmailAccountRequest> verifyAccountRequest(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      include: EmailAccountRequest.include(
        challenge: EmailAccountChallenge.include(),
      ),
      transaction: transaction,
    );

    if (request == null) {
      throw EmailAccountRequestNotFoundException();
    }

    if (await _hasTooManyEmailAccountCompletionAttempts(
      session,
      emailAccountRequestId: request.id!,
    )) {
      await EmailAccountRequest.db.deleteRow(
        session,
        request,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailAccountRequestVerificationTooManyAttemptsException();
    }

    final challenge = request.getChallenge;

    if (!await _hashUtils.validateHash(
      value: verificationCode,
      hash: challenge.challengeCodeHash.asUint8List,
      salt: challenge.challengeCodeSalt.asUint8List,
    )) {
      throw EmailAccountRequestInvalidVerificationCodeException();
    }

    if (request.isExpired(_config.registrationVerificationCodeLifetime)) {
      await EmailAccountRequest.db.deleteRow(
        session,
        request,
        // passing no transaction, so this will not be rolled back
      );
      throw EmailAccountRequestVerificationExpiredException();
    }

    await EmailAccountRequest.db.updateRow(
      session,
      request.copyWith(verifiedAt: clock.now()),
      transaction: transaction,
    );

    return request;
  }

  Future<bool> _hasTooManyEmailAccountCompletionAttempts(
    final Session session, {
    required final UuidValue emailAccountRequestId,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    return session.db.transaction((final transaction) async {
      await EmailAccountRequestCompletionAttempt.db.insertRow(
        session,
        EmailAccountRequestCompletionAttempt(
          ipAddress: session.remoteIpAddress,
          emailAccountRequestId: emailAccountRequestId,
        ),
        transaction: transaction,
      );

      final recentRequests =
          await EmailAccountRequestCompletionAttempt.db.count(
        session,
        where: (final t) =>
            t.emailAccountRequestId.equals(emailAccountRequestId),
        transaction: transaction,
      );

      return recentRequests >
          _config.registrationVerificationCodeAllowedAttempts;
    });
  }

  /// Gets a verified email account request by its ID.
  ///
  /// Throws an [EmailAccountRequestNotFoundException] if the request does not
  /// exist.
  /// Throws an [EmailAccountRequestNotVerifiedException] if the request has not
  /// been verified.
  Future<EmailAccountRequest> getVerifiedEmailAccountRequestById(
    final Session session, {
    required final UuidValue accountRequestId,
    required final Transaction? transaction,
  }) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      transaction: transaction,
    );

    if (request == null) {
      throw EmailAccountRequestNotFoundException();
    }

    if (!request.isVerified) {
      throw EmailAccountRequestNotVerifiedException();
    }

    return request;
  }
}

/// Configuration for the [EmailIDPAccountCreationUtil] class.
class EmailIDPAccountCreationUtilsConfig {
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

  /// Creates a new [EmailIDPAccountCreationUtilsConfig] instance.
  EmailIDPAccountCreationUtilsConfig({
    required this.passwordValidationFunction,
    required this.registrationVerificationCodeGenerator,
    required this.registrationVerificationCodeLifetime,
    required this.registrationVerificationCodeAllowedAttempts,
    required this.sendRegistrationVerificationCode,
  });

  /// Creates a new [EmailIDPAccountCreationUtilsConfig] instance from an
  /// [EmailIDPConfig] instance.
  factory EmailIDPAccountCreationUtilsConfig.fromEmailIDPConfig(
      final EmailIDPConfig config) {
    return EmailIDPAccountCreationUtilsConfig(
      passwordValidationFunction: config.passwordValidationFunction,
      registrationVerificationCodeGenerator:
          config.registrationVerificationCodeGenerator,
      registrationVerificationCodeLifetime:
          config.registrationVerificationCodeLifetime,
      registrationVerificationCodeAllowedAttempts:
          config.registrationVerificationCodeAllowedAttempts,
      sendRegistrationVerificationCode: config.sendRegistrationVerificationCode,
    );
  }
}

/// The result of the [EmailIDPAccountCreationUtil.completeAccountCreation] operation.
class EmailIDPCompleteAccountCreationResult {
  /// The ID of the new authentication user.
  final UuidValue authUserId;

  /// The scopes of the new authentication user.
  final Set<Scope> scopes;

  /// The email address used during registration.
  final String email;

  EmailIDPCompleteAccountCreationResult._({
    required this.authUserId,
    required this.email,
    required this.scopes,
  });
}

/// The result of the [EmailIDPAccountCreationUtil.finalizeAccountRequest] operation.
///
/// This describes the detailed status of the operation to the caller.
///
/// In the general case the caller should take care not to leak this to clients,
/// such that outside clients can not use this result to determine whether a
/// specific account is registered on the server.
class EmailIDPFinalizeAccountRequestResult {
  /// The ID of the new email authentication.
  final UuidValue accountId;

  /// The email address used during registration.
  final String email;

  EmailIDPFinalizeAccountRequestResult._({
    required this.accountId,
    required this.email,
  });
}

extension on EmailAccountRequest {
  bool isExpired(final Duration registrationVerificationCodeLifetime) {
    final requestExpiresAt = createdAt.add(
      registrationVerificationCodeLifetime,
    );

    return requestExpiresAt.isBefore(clock.now());
  }

  EmailAccountChallenge get getChallenge {
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
  bool get isVerified => verifiedAt != null;
}
