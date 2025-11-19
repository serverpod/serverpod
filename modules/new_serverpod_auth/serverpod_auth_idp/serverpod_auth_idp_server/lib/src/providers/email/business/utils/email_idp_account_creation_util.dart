import 'dart:convert';

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

/// {@template email_idp_account_creation_util}
/// This class contains utility functions for the email identity provider
/// account creation.
///
/// The main entry point is the [startRegistration] method, which returns a
/// [EmailIDPAccountCreationResult] with the result of the operation.
///
/// This class also contains utility functions for administration tasks, such as
/// deleting expired account creations and verifying account creations.
///
/// {@endtemplate}
class EmailIDPAccountCreationUtil {
  final SecretHashUtil _hashUtils;
  final EmailIDPAccountCreationUtilsConfig _config;
  final AuthUsers _authUsers;

  /// Creates a new [EmailIDPAccountCreationUtil] instance.
  EmailIDPAccountCreationUtil({
    required final EmailIDPAccountCreationUtilsConfig config,
    required final SecretHashUtil passwordHashUtils,
    required final AuthUsers authUsers,
  }) : _config = config,
       _authUsers = authUsers,
       _hashUtils = passwordHashUtils;

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

    final verificationCodeHash = await _hashUtils.createHash(
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
    if (await _hasTooManyEmailAccountCompletionAttempts(
      session,
      emailAccountRequestId: accountRequestId,
    )) {
      await EmailAccountRequest.db.deleteWhere(
        session,
        // Only delete requests that have not been verified yet.
        // This ensures we don't delete requests if verifyAccountRequestCode is
        // accidentally called again.
        where: (final t) =>
            t.id.equals(accountRequestId) &
            t.createAccountChallengeId.equals(null),
        // passing no transaction, so this will not be rolled back
      );

      throw EmailAccountRequestVerificationTooManyAttemptsException();
    }

    final request = await _getAccountRequest(
      session,
      accountRequestId,
      transaction,
    );

    if (request.isRequestVerified) {
      throw EmailAccountRequestVerificationCodeAlreadyUsedException();
    }

    final challenge = request.getChallenge;
    await _validateHash(verificationCode, challenge);

    if (request.isExpired(_config.registrationVerificationCodeLifetime)) {
      await EmailAccountRequest.db.deleteRow(
        session,
        request,
        // passing no transaction, so this will not be rolled back
      );
      throw EmailAccountRequestVerificationExpiredException();
    }

    final createAccountToken = const Uuid().v4();
    final createAccountTokenHash = await _hashUtils.createHash(
      value: createAccountToken,
    );

    await _insertCreateAccountChallenge(
      session,
      transaction: transaction,
      accountRequestId: accountRequestId,
      createAccountTokenHash: createAccountTokenHash,
    );

    return _encodeCreateAccountToken(accountRequestId, createAccountToken);
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
  Future<EmailIDPCompleteAccountCreationResult> completeAccountCreation(
    final Session session, {
    required final String completeAccountCreationToken,
    required final String password,
    required final Transaction transaction,
  }) async {
    if (!_config.passwordValidationFunction(password)) {
      throw EmailPasswordPolicyViolationException();
    }

    final credentials = _tryDecodeCompleteAccountCreationToken(
      completeAccountCreationToken,
    );
    if (credentials == null) {
      throw EmailAccountRequestInvalidVerificationCodeException();
    }

    final request = await _getAccountRequest(
      session,
      credentials.requestId,
      transaction,
    );

    final createAccountChallenge = request.createAccountChallenge;
    if (createAccountChallenge == null) {
      throw EmailAccountRequestNotVerifiedException();
    }

    await _validateHash(
      credentials.verificationCode,
      createAccountChallenge,
    );

    if (request.isExpired(_config.registrationVerificationCodeLifetime)) {
      await EmailAccountRequest.db.deleteRow(
        session,
        request,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailAccountRequestVerificationExpiredException();
    }

    await EmailAccountRequest.db.deleteRow(
      session,
      request,
      transaction: transaction,
    );

    final newUser = await _authUsers.create(
      session,
      transaction: transaction,
    );

    final passwordHash = await _hashUtils.createHash(
      value: password,
    );

    await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: newUser.id,
        email: request.email,
        passwordHash: passwordHash.hash.asByteData,
        passwordSalt: passwordHash.salt.asByteData,
      ),
      transaction: transaction,
    );

    return EmailIDPCompleteAccountCreationResult._(
      authUserId: newUser.id,
      accountRequestId: request.id!,
      email: request.email,
      scopes: newUser.scopes,
    );
  }

  Future<EmailAccountRequest> _getAccountRequest(
    final Session session,
    final UuidValue accountRequestId,
    final Transaction transaction,
  ) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      transaction: transaction,
      include: EmailAccountRequest.include(
        challenge: SecretChallenge.include(),
        createAccountChallenge: SecretChallenge.include(),
      ),
    );

    if (request == null) {
      throw EmailAccountRequestNotFoundException();
    }

    return request;
  }

  Future<void> _validateHash(
    final String verificationCode,
    final SecretChallenge challenge,
  ) async {
    if (!await _hashUtils.validateHash(
      value: verificationCode,
      hash: challenge.challengeCodeHash.asUint8List,
      salt: challenge.challengeCodeSalt.asUint8List,
    )) {
      throw EmailAccountRequestInvalidVerificationCodeException();
    }
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

  /// Inserts a new create account challenge and updates the account request
  /// to link to it.
  ///
  /// Will throw [EmailPasswordResetVerificationCodeAlreadyUsedException]
  /// if the verification has already been set.
  Future<void> _insertCreateAccountChallenge(
    final Session session, {
    required final Transaction transaction,
    required final UuidValue accountRequestId,
    required final HashResult createAccountTokenHash,
  }) async {
    final savePoint = await transaction.createSavepoint();
    final createAccountChallenge = await SecretChallenge.db.insertRow(
      session,
      SecretChallenge(
        challengeCodeHash: createAccountTokenHash.hash.asByteData,
        challengeCodeSalt: createAccountTokenHash.salt.asByteData,
      ),
      transaction: transaction,
    );

    final updated = await EmailAccountRequest.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.createAccountChallengeId(createAccountChallenge.id!),
      ],
      where: (final t) =>
          t.id.equals(accountRequestId) &
          t.createAccountChallengeId.equals(null),
      transaction: transaction,
    );

    if (updated.isEmpty) {
      await savePoint.rollback();
      throw EmailAccountRequestVerificationCodeAlreadyUsedException();
    }

    await savePoint.release();
  }

  String _encodeCreateAccountToken(
    final UuidValue requestId,
    final String createAccountToken,
  ) {
    return base64Encode(
      utf8.encode('$requestId:$createAccountToken'),
    );
  }

  CompleteAccountCreationCredentials? _tryDecodeCompleteAccountCreationToken(
    final String token,
  ) {
    final String decoded;
    try {
      decoded = utf8.decode(base64Decode(token));
    } catch (e) {
      return null;
    }

    final parts = decoded.split(':');
    if (parts.length != 2) {
      return null;
    }

    final UuidValue requestId;
    try {
      requestId = UuidValue.withValidation(parts[0]);
    } catch (e) {
      return null;
    }

    return (
      requestId: requestId,
      verificationCode: parts[1],
    );
  }

  Future<bool> _hasTooManyEmailAccountCompletionAttempts(
    final Session session, {
    required final UuidValue emailAccountRequestId,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    return session.db.transaction((final transaction) async {
      final savePoint = await transaction.createSavepoint();
      await EmailAccountRequestCompletionAttempt.db.insertRow(
        session,
        EmailAccountRequestCompletionAttempt(
          ipAddress: session.remoteIpAddress,
          emailAccountRequestId: emailAccountRequestId,
        ),
        transaction: transaction,
      );

      final recentRequests = await EmailAccountRequestCompletionAttempt.db
          .count(
            session,
            where: (final t) =>
                t.emailAccountRequestId.equals(emailAccountRequestId),
            transaction: transaction,
          );

      if (recentRequests >
          _config.registrationVerificationCodeAllowedAttempts) {
        await savePoint.rollback();
        return true;
      }

      await savePoint.release();

      return false;
    });
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
    final EmailIDPConfig config,
  ) {
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

  /// The ID of the account request that was completed.
  final UuidValue accountRequestId;

  /// The scopes of the new authentication user.
  final Set<Scope> scopes;

  /// The email address used during registration.
  final String email;

  EmailIDPCompleteAccountCreationResult._({
    required this.authUserId,
    required this.accountRequestId,
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

/// The credentials for completing the account creation process.
typedef CompleteAccountCreationCredentials = ({
  UuidValue requestId,
  String verificationCode,
});
