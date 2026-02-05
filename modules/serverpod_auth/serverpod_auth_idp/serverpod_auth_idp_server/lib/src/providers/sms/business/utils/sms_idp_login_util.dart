import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../sms_idp_config.dart';
import '../sms_idp_server_exceptions.dart';
import '../sms_idp_utils.dart';

/// {@template sms_idp_login_util}
/// Utility functions for SMS login.
/// {@endtemplate}
class SmsIdpLoginUtil {
  final SmsIdpConfig _config;
  final Argon2HashUtil _hashUtil;
  late final SecretChallengeUtil<SmsLoginRequest> _challengeUtil;
  late final DatabaseRateLimitedRequestAttemptUtil<String> _requestRateLimiter;

  /// Creates a new [SmsIdpLoginUtil] instance.
  SmsIdpLoginUtil({
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
        source: 'login_request',
        maxAttempts: _config.loginRequestRateLimit.maxAttempts,
        timeframe: _config.loginRequestRateLimit.timeframe,
      ),
    );
  }

  /// Starts the login process.
  Future<UuidValue> startLogin(
    Session session, {
    required String phone,
    required Transaction transaction,
  }) async {
    final normalized = _config.phoneIdStore.normalizePhone(phone);
    if (normalized.isEmpty) {
      throw SmsLoginInvalidCredentialsException();
    }
    final phoneHash = _config.phoneIdStore.hashPhone(normalized);

    if (await _requestRateLimiter.hasTooManyAttempts(
      session,
      nonce: phoneHash,
    )) {
      throw SmsLoginTooManyAttemptsException();
    }

    await _requestRateLimiter.recordAttempt(session, nonce: phoneHash);

    // Delete any existing request for this phone
    final existingRequest = await SmsLoginRequest.db.findFirstRow(
      session,
      where: (t) => t.phoneHash.equals(phoneHash),
      transaction: transaction,
    );
    if (existingRequest != null) {
      await SmsLoginRequest.db.deleteRow(
        session,
        existingRequest,
        transaction: transaction,
      );
    }

    final verificationCode = _config.loginVerificationCodeGenerator();
    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final request = await SmsLoginRequest.db.insertRow(
      session,
      SmsLoginRequest(phoneHash: phoneHash, challengeId: challenge.id!),
      transaction: transaction,
    );

    await _config.sendLoginVerificationCode?.call(
      session,
      phone: normalized,
      requestId: request.id!,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return request.id!;
  }

  /// Verifies the login code and returns a result with completion token.
  Future<SmsVerifyLoginResult> verifyLoginCode(
    Session session, {
    required UuidValue loginRequestId,
    required String verificationCode,
    required Transaction transaction,
  }) async {
    final token = await SmsIdpUtils.withReplacedLoginException(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: loginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );

    // Check if password is needed for new user auto-registration
    bool needsPassword = false;
    if (_config.requirePasswordOnUnregisteredLogin) {
      final request = await SmsLoginRequest.db.findById(
        session,
        loginRequestId,
        transaction: transaction,
      );
      if (request != null) {
        final existingAuthUserId = await _config.phoneIdStore
            .findAuthUserIdByPhoneHash(
              session,
              phoneHash: request.phoneHash,
              transaction: transaction,
            );
        needsPassword = existingAuthUserId == null;
      }
    }

    return SmsVerifyLoginResult(token: token, needsPassword: needsPassword);
  }

  /// Completes the login process and returns the login request.
  Future<SmsLoginRequest> completeLogin(
    Session session, {
    required String loginToken,
    required Transaction transaction,
  }) async {
    return SmsIdpUtils.withReplacedLoginException(
      () => _challengeUtil.completeChallenge(
        session,
        completionToken: loginToken,
        transaction: transaction,
      ),
    );
  }

  SecretChallengeVerificationConfig<SmsLoginRequest>
  _buildVerificationConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'login_verify',
        maxAttempts: _config.loginVerificationCodeAllowedAttempts,
        timeframe: _config.loginVerificationCodeLifetime,
      ),
    );

    return SecretChallengeVerificationConfig(
      getRequest: (session, requestId, {required transaction}) async {
        return SmsLoginRequest.db.findById(
          session,
          requestId,
          transaction: transaction,
          include: SmsLoginRequest.include(
            challenge: SecretChallenge.include(),
          ),
        );
      },
      isAlreadyUsed: (request) => request.loginChallengeId != null,
      getChallenge: (request) => request.challenge!,
      isExpired: (request) => request.createdAt
          .add(_config.loginVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (session, request) async {
        await SmsLoginRequest.db.deleteRow(session, request);
      },
      linkCompletionToken:
          (
            session,
            request,
            completionChallenge, {
            required transaction,
          }) async {
            if (request.loginChallengeId != null) {
              throw ChallengeAlreadyUsedException();
            }
            await SmsLoginRequest.db.updateRow(
              session,
              request.copyWith(loginChallengeId: completionChallenge.id),
              transaction: transaction,
            );
          },
      rateLimiter: limiter,
    );
  }

  SecretChallengeCompletionConfig<SmsLoginRequest> _buildCompletionConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'sms',
        source: 'login_complete',
        maxAttempts: _config.loginVerificationCodeAllowedAttempts,
        timeframe: _config.loginVerificationCodeLifetime,
      ),
    );
    return SecretChallengeCompletionConfig(
      getRequest: (session, requestId, {required transaction}) async {
        return SmsLoginRequest.db.findById(
          session,
          requestId,
          transaction: transaction,
          include: SmsLoginRequest.include(
            loginChallenge: SecretChallenge.include(),
          ),
        );
      },
      getCompletionChallenge: (request) => request.loginChallenge,
      isExpired: (request) => request.createdAt
          .add(_config.loginVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (session, request) async {
        await SmsLoginRequest.db.deleteRow(session, request);
      },
      rateLimiter: limiter,
    );
  }
}
