import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../sms_idp_config.dart';
import '../sms_idp_server_exceptions.dart';
import '../sms_idp_utils.dart';

/// {@template sms_idp_bind_util}
/// Utility functions for binding phones to existing users.
/// {@endtemplate}
class SmsIdpBindUtil {
  final SmsIdpConfig _config;
  final Argon2HashUtil _hashUtil;
  late final SecretChallengeUtil<SmsBindRequest> _challengeUtil;
  late final DatabaseRateLimitedRequestAttemptUtil<String> _requestRateLimiter;

  /// Creates a new [SmsIdpBindUtil] instance.
  SmsIdpBindUtil({
    required SmsIdpConfig config,
    required Argon2HashUtil hashUtil,
  }) : _config = config,
       _hashUtil = hashUtil {
    _challengeUtil = SecretChallengeUtil(
      hashUtil: _hashUtil,
      verificationConfig: _buildVerificationConfig(),
      completionConfig: _buildCompletionConfig(),
    );
    _requestRateLimiter = DatabaseRateLimitedRequestAttemptUtil(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'bind_request',
        maxAttempts: _config.bindRequestRateLimit.maxAttempts,
        timeframe: _config.bindRequestRateLimit.timeframe,
      ),
    );
  }

  /// Starts the phone binding process.
  Future<UuidValue> startBind(
    Session session, {
    required UuidValue authUserId,
    required String phone,
    required Transaction transaction,
  }) async {
    final normalized = _config.phoneIdStore.normalizePhone(phone);
    if (normalized.isEmpty) {
      throw SmsPhoneBindInvalidException();
    }
    final phoneHash = _config.phoneIdStore.hashPhone(normalized);
    final nonce = '$authUserId:$phoneHash';

    if (await _requestRateLimiter.hasTooManyAttempts(session, nonce: nonce)) {
      throw SmsPhoneBindTooManyAttemptsException();
    }
    await _requestRateLimiter.recordAttempt(session, nonce: nonce);

    // Delete any existing request for this user and phone
    final existing = await SmsBindRequest.db.findFirstRow(
      session,
      where: (t) =>
          t.authUserId.equals(authUserId) & t.phoneHash.equals(phoneHash),
      transaction: transaction,
    );
    if (existing != null) {
      await SmsBindRequest.db.deleteRow(
        session,
        existing,
        transaction: transaction,
      );
    }

    final verificationCode = _config.bindVerificationCodeGenerator();
    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final request = await SmsBindRequest.db.insertRow(
      session,
      SmsBindRequest(
        authUserId: authUserId,
        phoneHash: phoneHash,
        challengeId: challenge.id!,
      ),
      transaction: transaction,
    );

    await _config.sendBindVerificationCode?.call(
      session,
      phone: normalized,
      requestId: request.id!,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return request.id!;
  }

  /// Verifies the bind code and returns a completion token.
  Future<String> verifyBindCode(
    Session session, {
    required UuidValue bindRequestId,
    required String verificationCode,
    required Transaction transaction,
  }) async {
    return SmsIdpUtils.withReplacedBindException(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: bindRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );
  }

  /// Completes the bind process and returns the bind request.
  Future<SmsBindRequest> completeBind(
    Session session, {
    required String bindToken,
    required Transaction transaction,
  }) async {
    return SmsIdpUtils.withReplacedBindException(
      () => _challengeUtil.completeChallenge(
        session,
        completionToken: bindToken,
        transaction: transaction,
      ),
    );
  }

  SecretChallengeVerificationConfig<SmsBindRequest> _buildVerificationConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'bind_verify',
        maxAttempts: _config.bindVerificationCodeAllowedAttempts,
        timeframe: _config.bindVerificationCodeLifetime,
      ),
    );

    return SecretChallengeVerificationConfig(
      getRequest: (session, requestId, {required transaction}) async {
        return SmsBindRequest.db.findById(
          session,
          requestId,
          transaction: transaction,
          include: SmsBindRequest.include(challenge: SecretChallenge.include()),
        );
      },
      isAlreadyUsed: (request) => request.bindChallengeId != null,
      getChallenge: (request) => request.challenge!,
      isExpired: (request) => request.createdAt
          .add(_config.bindVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (session, request) async {
        await SmsBindRequest.db.deleteRow(session, request);
      },
      linkCompletionToken:
          (
            session,
            request,
            completionChallenge, {
            required transaction,
          }) async {
            if (request.bindChallengeId != null) {
              throw ChallengeAlreadyUsedException();
            }
            await SmsBindRequest.db.updateRow(
              session,
              request.copyWith(bindChallengeId: completionChallenge.id),
              transaction: transaction,
            );
          },
      rateLimiter: limiter,
    );
  }

  SecretChallengeCompletionConfig<SmsBindRequest> _buildCompletionConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'bind_complete',
        maxAttempts: _config.bindVerificationCodeAllowedAttempts,
        timeframe: _config.bindVerificationCodeLifetime,
      ),
    );

    return SecretChallengeCompletionConfig(
      getRequest: (session, requestId, {required transaction}) async {
        return SmsBindRequest.db.findById(
          session,
          requestId,
          transaction: transaction,
          include: SmsBindRequest.include(
            bindChallenge: SecretChallenge.include(),
          ),
        );
      },
      getCompletionChallenge: (request) => request.bindChallenge,
      isExpired: (request) => request.createdAt
          .add(_config.bindVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (session, request) async {
        await SmsBindRequest.db.deleteRow(session, request);
      },
      rateLimiter: limiter,
    );
  }
}
