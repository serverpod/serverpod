import 'package:serverpod/serverpod.dart';

/// User ID extension for `AuthenticationInfo`
extension AuthenticationInfoUserId on AuthenticationInfo {
  /// Returns the `Uuid` user ID of the authenticated user.
  ///
  /// Assumes that the system uses `Uuid` user IDs, otherwise throws.
  UuidValue get userUuid {
    return UuidValue.withValidation(userIdentifier);
  }
}
