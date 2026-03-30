import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../passwordless_idp_config.dart';
import '../passwordless_idp_server_exceptions.dart';
import 'passwordless_login_request_store.dart';

/// {@template passwordless_idp_login_util}
/// Internal utility for passwordless login flows.
///
/// Directly uses [Argon2HashUtil] and [DatabaseRateLimitedRequestAttemptUtil]
/// without the two-step [SecretChallengeUtil] pattern, because the
/// passwordless flow does not need a separate completion phase.
/// {@endtemplate}
class PasswordlessIdpLoginUtil<THandle> {
  final PasswordlessIdpConfig<THandle> _config;
  final Argon2HashUtil _hashUtil;
  final GenericPasswordlessLoginRequestStore _requestStore;
  final DatabaseRateLimitedRequestAttemptUtil<String> _requestRateLimiter;
  final DatabaseRateLimitedRequestAttemptUtil<UuidValue> _verifyRateLimiter;

  /// Creates a new [PasswordlessIdpLoginUtil] instance.
  PasswordlessIdpLoginUtil({
    required final PasswordlessIdpConfig<THandle> config,
  }) : _config = config,
       _hashUtil = _createHashUtil(config),
       _requestStore = const GenericPasswordlessLoginRequestStore(),
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
       );

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
    required final Transaction transaction,
  }) async {
    final THandle typedHandle;
    final String serializedHandle;
    try {
      typedHandle = _config.deserializeHandle(handle);
      serializedHandle = _config.serializeHandle(typedHandle);
    } on FormatException {
      throw PasswordlessLoginInvalidException();
    }

    if (await _requestRateLimiter.hasTooManyAttempts(
      session,
      nonce: serializedHandle,
    )) {
      throw PasswordlessLoginTooManyAttemptsException();
    }

    await _requestStore.deleteByHandle(
      session,
      serializedHandle: serializedHandle,
      transaction: transaction,
    );

    final verificationCode = _config.loginVerificationCodeGenerator();
    final verificationCodeHash = await _hashUtil.createHashFromString(
      secret: verificationCode,
    );

    final challenge = await SecretChallenge.db.insertRow(
      session,
      SecretChallenge(challengeCodeHash: verificationCodeHash),
      transaction: transaction,
    );

    final requestId = await _requestStore.createRequest(
      session,
      serializedHandle: serializedHandle,
      challengeId: challenge.id!,
      transaction: transaction,
    );

    await _config.sendLoginVerificationCode?.call(
      session,
      handle: typedHandle,
      requestId: requestId,
      verificationCode: verificationCode,
      transaction: transaction,
    );

    return requestId;
  }

  /// Verifies the login code and completes the login in a single step.
  ///
  /// Expired requests are rejected (and removed) before running Argon2 hash
  /// verification on the code.
  ///
  /// Returns the request data on success after deleting the request row within
  /// [transaction]. Once that transaction commits, the request cannot be
  /// reused.
  Future<PasswordlessLoginRequestData> verifyAndCompleteLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
    required final Transaction transaction,
  }) async {
    if (await _verifyRateLimiter.hasTooManyAttempts(
      session,
      nonce: loginRequestId,
    )) {
      throw PasswordlessLoginTooManyAttemptsException();
    }

    final request = await _requestStore.getRequestWithChallenge(
      session,
      requestId: loginRequestId,
      transaction: transaction,
    );
    if (request == null) {
      throw PasswordlessLoginNotFoundException();
    }

    final challenge = request.challenge;
    if (challenge == null) {
      throw PasswordlessLoginNotFoundException();
    }

    if (_isExpired(request)) {
      await _requestStore.deleteById(
        session,
        requestId: request.id,
        transaction: transaction,
      );
      throw PasswordlessLoginExpiredException();
    }

    if (!await _hashUtil.validateHashFromString(
      secret: verificationCode,
      hashString: challenge.challengeCodeHash,
    )) {
      throw PasswordlessLoginInvalidException();
    }

    final deleted = await _requestStore.deleteById(
      session,
      requestId: request.id,
      transaction: transaction,
    );
    if (!deleted) {
      throw PasswordlessLoginNotFoundException();
    }

    return request;
  }

  bool _isExpired(final PasswordlessLoginRequestData request) {
    return request.createdAt
        .add(_config.loginVerificationCodeLifetime)
        .isBefore(clock.now());
  }

  // 19MiB memory cost as recommended by OWASP:
  // https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#argon2id
  static Argon2HashUtil _createHashUtil(
    final PasswordlessIdpConfig<dynamic> config,
  ) {
    return Argon2HashUtil(
      hashPepper: config.secretHashPepper,
      fallbackHashPeppers: config.fallbackSecretHashPeppers,
      hashSaltLength: config.secretHashSaltLength,
      parameters: Argon2HashParameters(memory: 19456),
    );
  }
}
