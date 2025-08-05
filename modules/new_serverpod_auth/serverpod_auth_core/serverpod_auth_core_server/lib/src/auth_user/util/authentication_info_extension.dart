import 'package:serverpod/serverpod.dart';

/// `AuthUser` ID extension for `AuthenticationInfo`
extension AuthenticationInfoAuthUserId on AuthenticationInfo {
  /// Returns the `Uuid` user ID of the authenticated user.
  ///
  /// Assumes that the system uses `Uuid` user IDs, otherwise throws.
  UuidValue get authUserId {
    return UuidValue.withValidation(userIdentifier);
  }
}
