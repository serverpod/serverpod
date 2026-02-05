import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../storage/phone_id_store.dart';
import '../sms_idp_config.dart';
import '../sms_idp_server_exceptions.dart';
import '../sms_idp_utils.dart';

/// {@template sms_idp_account_creation_util}
/// Utility functions for SMS account creation.
///
/// The main entry point is the [startRegistration] method, which returns a
/// [UuidValue] with the ID of the account request.
/// {@endtemplate}
class SmsIdpAccountCreationUtil {
  final SmsIdpConfig _config;
  final AuthUsers _authUsers;
  final Argon2HashUtil _hashUtil;
  late final SecretChallengeUtil<SmsAccountRequest> _challengeUtil;
  late final DatabaseRateLimitedRequestAttemptUtil<String> _requestRateLimiter;

  /// Creates a new [SmsIdpAccountCreationUtil] instance.
  SmsIdpAccountCreationUtil({
    required SmsIdpConfig config,
    required AuthUsers authUsers,
    required Argon2HashUtil hashUtil,
  }) : _config = config,
       _authUsers = authUsers,
       _hashUtil = hashUtil {
    _challengeUtil = SecretChallengeUtil(
      hashUtil: _hashUtil,
      verificationConfig: _buildVerificationConfig(),
      completionConfig: _buildCompletionConfig(),
    );
    _requestRateLimiter = DatabaseRateLimitedRequestAttemptUtil(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'registration_request',
        maxAttempts: _config.registrationRequestRateLimit.maxAttempts,
        timeframe: _config.registrationRequestRateLimit.timeframe,
      ),
    );
  }

  /// Starts the registration process for a new SMS account.
  Future<UuidValue> startRegistration(
    Session session, {
    required String phone,
    required Transaction transaction,
  }) async {
    final normalized = _config.phoneIdStore.normalizePhone(phone);
    if (normalized.isEmpty) {
      throw SmsAccountRequestNotFoundException();
    }
    final phoneHash = _config.phoneIdStore.hashPhone(normalized);

    if (await _requestRateLimiter.hasTooManyAttempts(
      session,
      nonce: phoneHash,
    )) {
      throw SmsAccountRequestVerificationTooManyAttemptsException();
    }

    final existingAccount = await _config.phoneIdStore
        .findAuthUserIdByPhoneHash(
          session,
          phoneHash: phoneHash,
          transaction: transaction,
        );
    if (existingAccount != null) {
      throw SmsAccountAlreadyRegisteredException();
    }

    await _requestRateLimiter.recordAttempt(session, nonce: phoneHash);

    // Delete any existing request for this phone
    final existingRequest = await SmsAccountRequest.db.findFirstRow(
      session,
      where: (t) => t.phoneHash.equals(phoneHash),
      transaction: transaction,
    );
    if (existingRequest != null) {
      await SmsAccountRequest.db.deleteRow(
        session,
        existingRequest,
        transaction: transaction,
      );
    }

    final verificationCode = _config.registrationVerificationCodeGenerator();
    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final request = await SmsAccountRequest.db.insertRow(
      session,
      SmsAccountRequest(phoneHash: phoneHash, challengeId: challenge.id!),
      transaction: transaction,
    );

    await _config.sendRegistrationVerificationCode?.call(
      session,
      phone: normalized,
      requestId: request.id!,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return request.id!;
  }

  /// Verifies the registration code and returns a completion token.
  Future<String> verifyRegistrationCode(
    Session session, {
    required UuidValue accountRequestId,
    required String verificationCode,
    required Transaction transaction,
  }) async {
    return SmsIdpUtils.withReplacedAccountRequestException(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: accountRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );
  }

  /// Completes the account creation process.
  Future<SmsAccountCreationResult> completeAccountCreation(
    Session session, {
    required String registrationToken,
    required String phone,
    required String password,
    required Transaction transaction,
  }) async {
    if (!_config.passwordValidationFunction(password)) {
      throw SmsPasswordPolicyViolationException();
    }

    final request = await SmsIdpUtils.withReplacedAccountRequestException(
      () => _challengeUtil.completeChallenge(
        session,
        completionToken: registrationToken,
        transaction: transaction,
      ),
    );

    final normalized = _config.phoneIdStore.normalizePhone(phone);
    final phoneHash = _config.phoneIdStore.hashPhone(normalized);
    if (phoneHash != request.phoneHash) {
      throw SmsAccountRequestNotFoundException();
    }

    await SmsAccountRequest.db.deleteRow(
      session,
      request,
      transaction: transaction,
    );

    final authUser = await _authUsers.create(session, transaction: transaction);

    final passwordHash = await _hashUtil.createHashFromString(secret: password);
    await SmsAccount.db.insertRow(
      session,
      SmsAccount(authUserId: authUser.id, passwordHash: passwordHash),
      transaction: transaction,
    );

    try {
      await _config.phoneIdStore.bindPhone(
        session,
        authUserId: authUser.id,
        phone: normalized,
        allowRebind: false,
        transaction: transaction,
      );
    } on PhoneAlreadyBoundException {
      throw SmsAccountRequestNotFoundException();
    } on PhoneRebindNotAllowedException {
      throw SmsAccountRequestNotFoundException();
    }

    await _config.onAfterAccountCreated?.call(
      session,
      authUserId: authUser.id,
      transaction: transaction,
    );
    await _config.onAfterPhoneBound?.call(
      session,
      authUserId: authUser.id,
      transaction: transaction,
    );

    return SmsAccountCreationResult(
      authUserId: authUser.id,
      scopes: authUser.scopes,
    );
  }

  SecretChallengeVerificationConfig<SmsAccountRequest>
  _buildVerificationConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'registration_verify',
        maxAttempts: _config.registrationVerificationCodeAllowedAttempts,
        timeframe: _config.registrationVerificationCodeLifetime,
      ),
    );

    return SecretChallengeVerificationConfig(
      getRequest: (session, requestId, {required transaction}) async {
        return SmsAccountRequest.db.findById(
          session,
          requestId,
          transaction: transaction,
          include: SmsAccountRequest.include(
            challenge: SecretChallenge.include(),
          ),
        );
      },
      isAlreadyUsed: (request) => request.createAccountChallengeId != null,
      getChallenge: (request) => request.challenge!,
      isExpired: (request) => request.createdAt
          .add(_config.registrationVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (session, request) async {
        await SmsAccountRequest.db.deleteRow(session, request);
      },
      linkCompletionToken:
          (
            session,
            request,
            completionChallenge, {
            required transaction,
          }) async {
            if (request.createAccountChallengeId != null) {
              throw ChallengeAlreadyUsedException();
            }
            await SmsAccountRequest.db.updateRow(
              session,
              request.copyWith(
                createAccountChallengeId: completionChallenge.id,
              ),
              transaction: transaction,
            );
          },
      rateLimiter: limiter,
    );
  }

  SecretChallengeCompletionConfig<SmsAccountRequest> _buildCompletionConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'registration_complete',
        maxAttempts: _config.registrationVerificationCodeAllowedAttempts,
        timeframe: _config.registrationVerificationCodeLifetime,
      ),
    );
    return SecretChallengeCompletionConfig(
      getRequest: (session, requestId, {required transaction}) async {
        return SmsAccountRequest.db.findById(
          session,
          requestId,
          transaction: transaction,
          include: SmsAccountRequest.include(
            createAccountChallenge: SecretChallenge.include(),
          ),
        );
      },
      getCompletionChallenge: (request) => request.createAccountChallenge,
      isExpired: (request) => request.createdAt
          .add(_config.registrationVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (session, request) async {
        await SmsAccountRequest.db.deleteRow(session, request);
      },
      rateLimiter: limiter,
    );
  }
}

/// Result of a successful account creation.
class SmsAccountCreationResult {
  /// The ID of the created auth user.
  final UuidValue authUserId;

  /// The scopes granted to the user.
  final Set<Scope> scopes;

  /// Creates a new [SmsAccountCreationResult].
  SmsAccountCreationResult({required this.authUserId, required this.scopes});
}
