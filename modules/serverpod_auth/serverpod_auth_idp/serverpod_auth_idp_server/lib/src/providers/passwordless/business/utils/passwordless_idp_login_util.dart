import 'dart:convert' show jsonEncode;

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../passwordless_idp_config.dart';
import '../passwordless_idp_server_exceptions.dart';
import 'passwordless_login_request_store.dart';

/// {@template passwordless_idp_login_util}
/// Internal utility for passwordless login flows.
///
/// Uses [SecretChallengeUtil] for shared challenge creation, verification, and
/// rate limiting while consuming passwordless login requests immediately after
/// successful verification.
/// {@endtemplate}
class PasswordlessIdpLoginUtil {
  final PasswordlessIdpConfig _config;
  final Argon2HashUtil _hashUtil;
  late final SecretChallengeUtil<PasswordlessLoginRequestData> _challengeUtil;
  final PasswordlessLoginRequestStore _requestStore;
  final DatabaseRateLimitedRequestAttemptUtil<String> _requestRateLimiter;
  final DatabaseRateLimitedRequestAttemptUtil<UuidValue> _verifyRateLimiter;

  /// Creates a new [PasswordlessIdpLoginUtil] instance.
  PasswordlessIdpLoginUtil({
    required final PasswordlessIdpConfig config,
  }) : _config = config,
       // 19MiB memory cost as recommended by OWASP:
       // https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#argon2id
       _hashUtil = Argon2HashUtil(
         hashPepper: config.secretHashPepper,
         fallbackHashPeppers: config.fallbackSecretHashPeppers,
         hashSaltLength: config.secretHashSaltLength,
         parameters: Argon2HashParameters(memory: 19456),
       ),
       _requestStore = const PasswordlessLoginRequestStore(),
       _requestRateLimiter = DatabaseRateLimitedRequestAttemptUtil(
         RateLimitedRequestAttemptConfig<String>(
           domain: 'passwordless',
           source: 'login_request',
           maxAttempts: config.loginRequestRateLimit.maxAttempts,
           timeframe: config.loginRequestRateLimit.timeframe,
         ),
       ),
       _verifyRateLimiter = DatabaseRateLimitedRequestAttemptUtil(
         RateLimitedRequestAttemptConfig(
           domain: 'passwordless',
           source: 'login_verify',
           maxAttempts: config.loginVerificationCodeAllowedAttempts,
           timeframe: config.loginVerificationCodeLifetime,
         ),
       ) {
    _challengeUtil = SecretChallengeUtil.forConsumption(
      hashUtil: _hashUtil,
      consumptionConfig: SecretChallengeConsumptionConfig(
        getRequest:
            (
              final session,
              final requestId, {
              required final transaction,
            }) {
              return _requestStore.getRequestWithChallenge(
                session,
                requestId: requestId,
                transaction: transaction,
              );
            },
        getChallenge: (final request) => request.challenge,
        isExpired: _isExpired,
        onExpired: (final session, final request) async {
          await session.db.transaction(
            (final transaction) => _requestStore.deleteById(
              session,
              requestId: request.id,
              transaction: transaction,
            ),
          );
        },
        consumeRequest:
            (
              final session,
              final request, {
              required final transaction,
            }) {
              return _requestStore.deleteById(
                session,
                requestId: request.id,
                transaction: transaction,
              );
            },
        rateLimiter: _verifyRateLimiter,
      ),
    );
  }

  /// {@template passwordless_idp_login_util.delete_incomplete_login_attempts}
  /// Cleans up passwordless login state older than [olderThan].
  ///
  /// This removes pending passwordless login requests, their associated
  /// verification challenges, and both login request and verification attempts.
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// windows checked upon login request creation and login verification, and
  /// all pending login requests that have outlived
  /// [PasswordlessIdpConfig.loginVerificationCodeLifetime].
  /// {@endtemplate}
  Future<void> deleteIncompleteLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    required final Transaction transaction,
  }) async {
    await _requestRateLimiter.deleteAttempts(
      session,
      olderThan: olderThan,
      transaction: transaction,
    );
    await _verifyRateLimiter.deleteAttempts(
      session,
      olderThan: olderThan,
      transaction: transaction,
    );
    await _requestStore.deleteCreatedBefore(
      session,
      createdBefore: clock.now().subtract(
        olderThan ?? _config.loginVerificationCodeLifetime,
      ),
      transaction: transaction,
    );
  }

  /// Starts the login process.
  Future<UuidValue> startLogin(
    final Session session, {
    required final String handle,
    required final String? handleType,
    required final Transaction transaction,
  }) async {
    final rateLimitNonce = _loginRequestRateLimitNonce(
      handle: handle,
      handleType: handleType,
    );

    if (await _requestRateLimiter.hasTooManyAttempts(
      session,
      nonce: rateLimitNonce,
    )) {
      throw PasswordlessLoginTooManyAttemptsException();
    }

    await _requestStore.deleteByHandle(
      session,
      handle: handle,
      handleType: handleType,
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
      handle: handle,
      handleType: handleType,
      challengeId: challenge.id!,
      transaction: transaction,
    );

    await _config.sendLoginVerificationCode?.call(
      session,
      handle: handle,
      handleType: handleType,
      requestId: requestId,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return requestId;
  }

  /// Verifies the login code and consumes the request in one step.
  ///
  /// Rate limiting for verification attempts uses
  /// [PasswordlessIdpConfig.loginVerificationCodeAllowedAttempts] and
  /// [PasswordlessIdpConfig.loginVerificationCodeLifetime].
  ///
  /// On success, deletes the request row within [transaction]. After it commits,
  /// that login request id cannot be reused.
  ///
  /// Expired requests are deleted in a separate committed transaction before
  /// [PasswordlessLoginExpiredException] is thrown.
  Future<PasswordlessLoginRequestData> verifyAndCompleteLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    return _withReplacedSecretChallengeException(
      () => _challengeUtil.verifyAndConsumeChallenge(
        session,
        requestId: loginRequestId,
        verificationCode: verificationCode,
        transaction: transaction,
      ),
    );
  }

  bool _isExpired(final PasswordlessLoginRequestData request) {
    return request.createdAt
        .add(_config.loginVerificationCodeLifetime)
        .isBefore(clock.now());
  }

  String _loginRequestRateLimitNonce({
    required final String handle,
    required final String? handleType,
  }) {
    return jsonEncode([handle, handleType]);
  }

  Future<T> _withReplacedSecretChallengeException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on SecretChallengeException catch (e) {
      throw switch (e) {
        ChallengeRequestNotFoundException() =>
          PasswordlessLoginNotFoundException(),
        ChallengeInvalidVerificationCodeException() =>
          PasswordlessLoginInvalidException(),
        ChallengeExpiredException() => PasswordlessLoginExpiredException(),
        ChallengeRateLimitExceededException() =>
          PasswordlessLoginTooManyAttemptsException(),
        // These exceptions are not expected from the one-step consume flow, but
        // are mapped for exhaustive handling of SecretChallengeException.
        ChallengeAlreadyUsedException() ||
        ChallengeNotVerifiedException() ||
        ChallengeInvalidCompletionTokenException() =>
          PasswordlessLoginInvalidException(),
      };
    }
  }
}
