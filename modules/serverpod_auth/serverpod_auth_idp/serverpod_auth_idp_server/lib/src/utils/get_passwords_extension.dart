import 'package:serverpod/serverpod.dart';

import 'password_not_found_exception.dart';

/// Convenience helpers for retrieving passwords with clearer errors.
extension GetPasswordsExtension on Serverpod {
  /// Returns the password for [key] or throws a [PasswordNotFoundException]
  /// if it is missing.
  String getPasswordOrThrow(final String key) {
    final password = getPassword(key);
    if (password == null) {
      throw PasswordNotFoundException(key);
    }
    return password;
  }
}
