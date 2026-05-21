import '../../../../core.dart';
import 'passwordless_idp_server_exceptions.dart';

/// Passwordless authentication utilities.
///
/// Provides the [withReplacedServerPasswordlessException] helper that maps
/// internal server exceptions to client-safe [PasswordlessLoginException]s.
class PasswordlessIdpUtils {
  /// Replaces server-side exceptions by client-side exceptions, hiding details
  /// that could leak login-request information.
  static Future<T> withReplacedServerPasswordlessException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on PasswordlessLoginServerException catch (e) {
      throw PasswordlessLoginException(reason: e._reason);
    }
  }
}

extension on PasswordlessLoginServerException {
  PasswordlessLoginExceptionReason get _reason {
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
