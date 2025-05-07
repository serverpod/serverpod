import 'package:serverpod/serverpod.dart';

/// User session ID extension for `AuthenticationInfo`
extension AuthenticationInfoUserId on AuthenticationInfo {
  /// Returns the auth session ID of the authenticated user.
  ///
  /// Assumes that the `authId` is set and the system uses `Uuid` auth session IDs, otherwise throws.
  UuidValue get authSessionId {
    return UuidValue.fromString(authId!);
  }
}
