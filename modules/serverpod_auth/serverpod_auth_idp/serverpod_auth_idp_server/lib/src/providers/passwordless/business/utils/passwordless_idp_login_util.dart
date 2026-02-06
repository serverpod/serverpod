import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../passwordless_idp_config.dart';
import '../passwordless_idp_server_exceptions.dart';
import '../passwordless_idp_utils.dart';

/// {@template passwordless_idp_login_util}
/// Utility functions for passwordless login.
/// {@endtemplate}
class PasswordlessIdpLoginUtil {
  final PasswordlessIdpConfig _config;
  final Argon2HashUtil _hashUtil;
  late final SecretChallengeUtil<PasswordlessLoginRequest> _challengeUtil;
  late final DatabaseRateLimitedRequestAttemptUtil<String> _requestRateLimiter;

  /// Creates a new [PasswordlessIdpLoginUtil] instance.
  PasswordlessIdpLoginUtil({
    required final PasswordlessIdpConfig config,
    required final Argon2HashUtil hashUtil,
  }) : _config = config,
       _hashUtil = hashUtil {
    _challengeUtil = SecretChallengeUtil(
      hashUtil: _hashUtil,
      verificationConfig: _buildVerificationConfig(),
      completionConfig: _buildCompletionConfig(),
    );
    _requestRateLimiter = DatabaseRateLimitedRequestAttemptUtil(
      RateLimitedRequestAttemptConfig(
        domain: 'passwordless',
        source: 'login_request',
        maxAttempts: _config.loginRequestRateLimit.maxAttempts,
        timeframe: _config.loginRequestRateLimit.timeframe,
      ),
    );
  }

  /// Starts the login process.
  Future<UuidValue> startLogin(
    final Session session, {
    required final String handle,
    required final Transaction transaction,
  }) async {
    final normalizedHandle = _config.normalizeHandle(handle);
    if (normalizedHandle.isEmpty) {
      throw PasswordlessLoginInvalidException();
    }

    final nonce = _config.buildNonce(normalizedHandle);
    if (nonce.isEmpty) {
      throw PasswordlessLoginInvalidException();
    }

    if (await _requestRateLimiter.hasTooManyAttempts(session, nonce: nonce)) {
      throw PasswordlessLoginTooManyAttemptsException();
    }

    // Delete any existing request for the same nonce.
    final existingRequest = await PasswordlessLoginRequest.db.findFirstRow(
      session,
      where: (final t) => t.nonce.equals(nonce),
      transaction: transaction,
    );
    if (existingRequest != null) {
      await PasswordlessLoginRequest.db.deleteRow(
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

    final request = await PasswordlessLoginRequest.db.insertRow(
      session,
      PasswordlessLoginRequest(nonce: nonce, challengeId: challenge.id!),
      transaction: transaction,
    );

    await _config.sendLoginVerificationCode?.call(
      session,
      handle: normalizedHandle,
      requestId: request.id!,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return request.id!;
  }

  /// Verifies the login code and returns a completion token.
  Future<String> verifyLoginCode(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    return PasswordlessIdpUtils.withReplacedLoginException(
      () => _challengeUtil.verifyChallenge(
        session,
        requestId: loginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );
  }

  /// Completes the login process and returns the login request.
  Future<PasswordlessLoginRequest> completeLogin(
    final Session session, {
    required final String loginToken,
    required final Transaction transaction,
  }) async {
    return PasswordlessIdpUtils.withReplacedLoginException(
      () => _challengeUtil.completeChallenge(
        session,
        completionToken: loginToken,
        transaction: transaction,
      ),
    );
  }

  SecretChallengeVerificationConfig<PasswordlessLoginRequest>
  _buildVerificationConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'passwordless',
        source: 'login_verify',
        maxAttempts: _config.loginVerificationCodeAllowedAttempts,
        timeframe: _config.loginVerificationCodeLifetime,
      ),
    );

    return SecretChallengeVerificationConfig(
      getRequest:
          (
            final session,
            final requestId, {
            required final Transaction? transaction,
          }) {
            return PasswordlessLoginRequest.db.findById(
              session,
              requestId,
              transaction: transaction,
              include: PasswordlessLoginRequest.include(
                challenge: SecretChallenge.include(),
              ),
            );
          },
      isAlreadyUsed: (final request) => request.loginChallengeId != null,
      getChallenge: (final request) => request.challenge!,
      isExpired: (final request) => request.createdAt
          .add(_config.loginVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (final session, final request) async {
        await PasswordlessLoginRequest.db.deleteRow(session, request);
      },
      linkCompletionToken:
          (
            final session,
            final request,
            final completionChallenge, {
            required final transaction,
          }) async {
            final updated = await PasswordlessLoginRequest.db.updateWhere(
              session,
              columnValues: (final t) => [
                t.loginChallengeId(completionChallenge.id!),
              ],
              where: (final t) =>
                  t.id.equals(request.id!) & t.loginChallengeId.equals(null),
              transaction: transaction,
            );

            if (updated.isEmpty) {
              throw ChallengeAlreadyUsedException();
            }
          },
      rateLimiter: limiter,
    );
  }

  SecretChallengeCompletionConfig<PasswordlessLoginRequest>
  _buildCompletionConfig() {
    final limiter = DatabaseRateLimitedRequestAttemptUtil<UuidValue>(
      RateLimitedRequestAttemptConfig(
        domain: 'passwordless',
        source: 'login_complete',
        maxAttempts: _config.loginVerificationCodeAllowedAttempts,
        timeframe: _config.loginVerificationCodeLifetime,
      ),
    );

    return SecretChallengeCompletionConfig(
      getRequest:
          (
            final session,
            final requestId, {
            required final Transaction? transaction,
          }) {
            return PasswordlessLoginRequest.db.findById(
              session,
              requestId,
              transaction: transaction,
              include: PasswordlessLoginRequest.include(
                loginChallenge: SecretChallenge.include(),
              ),
            );
          },
      getCompletionChallenge: (final request) => request.loginChallenge,
      isExpired: (final request) => request.createdAt
          .add(_config.loginVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (final session, final request) async {
        await PasswordlessLoginRequest.db.deleteRow(session, request);
      },
      rateLimiter: limiter,
    );
  }
}
