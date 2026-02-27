import '../../../../../core.dart';
import 'passwordless_idp_config.dart';
import 'passwordless_idp_server_exceptions.dart';
import 'utils/passwordless_idp_login_util.dart';

/// Passwordless authentication utilities.
///
/// This class provides atomic building blocks for composing custom authentication
/// flows.
///
/// - [hashUtil] - Utilities for hashing verification codes
/// - [login] - Utilities for logging in users
class PasswordlessIdpUtils<TNonce> {
  /// General hash util for the passwordless provider.
  final Argon2HashUtil hashUtil;

  /// {@macro passwordless_idp_login_util}
  late final PasswordlessIdpLoginUtil<TNonce> login;

  /// Creates a new instance of [PasswordlessIdpUtils].
  PasswordlessIdpUtils({
    required final PasswordlessIdpConfig<TNonce> config,
  }) : hashUtil = Argon2HashUtil(
         hashPepper: config.secretHashPepper,
         fallbackHashPeppers: config.fallbackSecretHashPeppers,
         hashSaltLength: config.secretHashSaltLength,
         // Keep this in line with other IDP providers.
         parameters: Argon2HashParameters(memory: 19456),
       ) {
    login = PasswordlessIdpLoginUtil(
      config: config,
      hashUtil: hashUtil,
      requestStore: config.loginRequestStore,
    );
  }

  /// Wraps a function to convert challenge exceptions to passwordless login
  /// exceptions.
  static Future<T> withReplacedLoginException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on ChallengeExpiredException {
      throw PasswordlessLoginExpiredException();
    } on ChallengeRateLimitExceededException {
      throw PasswordlessLoginTooManyAttemptsException();
    } on ChallengeInvalidCompletionTokenException catch (_) {
      throw PasswordlessLoginNotFoundException();
    } on ChallengeInvalidVerificationCodeException catch (_) {
      throw PasswordlessLoginInvalidException();
    } on ChallengeNotVerifiedException {
      throw PasswordlessLoginNotFoundException();
    } on ChallengeRequestNotFoundException {
      throw PasswordlessLoginNotFoundException();
    } on ChallengeAlreadyUsedException {
      throw PasswordlessLoginNotFoundException();
    }
  }

  /// Wraps a function to convert server-side passwordless exceptions to
  /// client-serializable exceptions.
  static Future<T> withReplacedServerPasswordlessException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on PasswordlessServerException catch (e) {
      switch (e) {
        case PasswordlessLoginServerException():
          throw PasswordlessLoginException(reason: e.reason);
      }
    }
  }
}

extension on PasswordlessLoginServerException {
  PasswordlessLoginExceptionReason get reason {
    switch (this) {
      case PasswordlessLoginInvalidException():
      case PasswordlessLoginNotFoundException():
        return PasswordlessLoginExceptionReason.invalid;
      case PasswordlessLoginTooManyAttemptsException():
        return PasswordlessLoginExceptionReason.tooManyAttempts;
      case PasswordlessLoginExpiredException():
        return PasswordlessLoginExceptionReason.expired;
    }
  }
}
