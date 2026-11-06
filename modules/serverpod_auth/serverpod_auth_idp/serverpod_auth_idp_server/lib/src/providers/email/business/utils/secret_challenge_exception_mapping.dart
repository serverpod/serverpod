import '../../../../../core.dart';
import '../email_idp_server_exceptions.dart';

/// Runs [fn], replacing challenge-related exceptions by the email account
/// request exceptions used for registrations and passwordless logins.
Future<T> withEmailAccountRequestExceptions<T>(
  Future<T> Function() fn,
) => _withReplacedSecretChallengeException(
  fn,
  (e) => switch (e) {
    ChallengeRequestNotFoundException() =>
      EmailAccountRequestNotFoundException(),
    ChallengeAlreadyUsedException() =>
      EmailAccountRequestVerificationCodeAlreadyUsedException(),
    ChallengeInvalidVerificationCodeException() =>
      EmailAccountRequestInvalidVerificationCodeException(),
    ChallengeExpiredException() =>
      EmailAccountRequestVerificationExpiredException(),
    ChallengeNotVerifiedException() =>
      EmailAccountRequestNotVerifiedException(),
    ChallengeInvalidCompletionTokenException() =>
      EmailAccountRequestInvalidVerificationCodeException(),
    ChallengeRateLimitExceededException() =>
      EmailAccountRequestVerificationTooManyAttemptsException(),
  },
);

/// Runs [fn], replacing challenge-related exceptions by the password reset
/// exceptions.
Future<T> withEmailPasswordResetExceptions<T>(
  Future<T> Function() fn,
) => _withReplacedSecretChallengeException(
  fn,
  (e) => switch (e) {
    ChallengeRequestNotFoundException() =>
      EmailPasswordResetRequestNotFoundException(),
    ChallengeAlreadyUsedException() =>
      EmailPasswordResetVerificationCodeAlreadyUsedException(),
    ChallengeInvalidVerificationCodeException() =>
      EmailPasswordResetInvalidVerificationCodeException(),
    ChallengeExpiredException() => EmailPasswordResetRequestExpiredException(),
    ChallengeNotVerifiedException() => EmailPasswordResetNotVerifiedException(),
    ChallengeInvalidCompletionTokenException() =>
      EmailPasswordResetInvalidVerificationCodeException(),
    ChallengeRateLimitExceededException() =>
      EmailPasswordResetTooManyVerificationAttemptsException(),
  },
);

Future<T> _withReplacedSecretChallengeException<T>(
  Future<T> Function() fn,
  EmailServerException Function(SecretChallengeException e) replace,
) async {
  try {
    return await fn();
  } on SecretChallengeException catch (e) {
    throw replace(e);
  }
}
