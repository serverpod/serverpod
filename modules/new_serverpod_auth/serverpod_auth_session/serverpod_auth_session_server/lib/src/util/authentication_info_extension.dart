import 'package:serverpod/serverpod.dart';

/// User session ID extension for `AuthenticationInfo`
extension AuthenticationInfoUserId on AuthenticationInfo {
  /// Returns the `Uuid` user session ID of the authenticated user.
  ///
  /// Assumes that the `authId` is set and the system uses `Uuid` user session IDs, otherwise throws.
  UuidValue get userSessionUuid {
    return UuidValue.fromString(authId!);
  }
}
