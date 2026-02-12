import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../passwordless_idp_config.dart';
import '../passwordless_idp_server_exceptions.dart';
import '../passwordless_idp_utils.dart';
import 'passwordless_login_request_store.dart';

/// {@template passwordless_idp_login_util}
/// Utility functions for passwordless login.
/// {@endtemplate}
class PasswordlessIdpLoginUtil {
  final PasswordlessIdpConfig _config;
  final Argon2HashUtil _hashUtil;
  final PasswordlessLoginRequestStore _requestStore;
  late final SecretChallengeUtil<PasswordlessLoginRequestData> _challengeUtil;
  late final DatabaseRateLimitedRequestAttemptUtil<String> _requestRateLimiter;

  /// Creates a new [PasswordlessIdpLoginUtil] instance.
  PasswordlessIdpLoginUtil({
    required final PasswordlessIdpConfig config,
    required final Argon2HashUtil hashUtil,
    required final PasswordlessLoginRequestStore requestStore,
  }) : _config = config,
       _hashUtil = hashUtil,
       _requestStore = requestStore {
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

    await _requestStore.deleteByNonce(
      session,
      nonce: nonce,
      transaction: transaction,
    );

    final verificationCode = _config.loginVerificationCodeGenerator();
    final challenge = await _challengeUtil.createChallenge(
      session,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    final requestId = await _requestStore.createRequest(
      session,
      nonce: nonce,
      challengeId: challenge.id!,
      transaction: transaction,
    );

    await _config.sendLoginVerificationCode?.call(
      session,
      handle: normalizedHandle,
      requestId: requestId,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return requestId;
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

  /// Completes the login process and returns the login request data.
  Future<PasswordlessLoginRequestData> completeLogin(
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

  /// Deletes a login request by id.
  Future<bool> deleteRequest(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    return _requestStore.deleteById(
      session,
      requestId: requestId,
      transaction: transaction,
    );
  }

  SecretChallengeVerificationConfig<PasswordlessLoginRequestData>
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
            return _requestStore.getRequestForVerification(
              session,
              requestId: requestId,
              transaction: transaction,
            );
          },
      isAlreadyUsed: (final request) => request.loginChallengeId != null,
      getChallenge: (final request) {
        final challenge = request.challenge;
        if (challenge == null) {
          throw ChallengeRequestNotFoundException();
        }
        return challenge;
      },
      isExpired: (final request) => request.createdAt
          .add(_config.loginVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (final session, final request) async {
        await _requestStore.deleteById(
          session,
          requestId: request.id,
        );
      },
      linkCompletionToken:
          (
            final session,
            final request,
            final completionChallenge, {
            required final transaction,
          }) async {
            final updated = await _requestStore
                .linkCompletionChallengeAtomically(
                  session,
                  requestId: request.id,
                  completionChallengeId: completionChallenge.id!,
                  transaction: transaction,
                );
            if (!updated) {
              throw ChallengeAlreadyUsedException();
            }
          },
      rateLimiter: limiter,
    );
  }

  SecretChallengeCompletionConfig<PasswordlessLoginRequestData>
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
            return _requestStore.getRequestForCompletion(
              session,
              requestId: requestId,
              transaction: transaction,
            );
          },
      getCompletionChallenge: (final request) => request.loginChallenge,
      isExpired: (final request) => request.createdAt
          .add(_config.loginVerificationCodeLifetime)
          .isBefore(DateTime.now()),
      onExpired: (final session, final request) async {
        await _requestStore.deleteById(
          session,
          requestId: request.id,
        );
      },
      rateLimiter: limiter,
    );
  }
}
