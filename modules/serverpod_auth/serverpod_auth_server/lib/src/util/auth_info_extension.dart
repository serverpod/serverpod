import 'package:serverpod/serverpod.dart';

/// User ID extension for `AuthenticationInfo`
extension AuthenticationInfoUserId on AuthenticationInfo {
  /// Returns the `int` user ID of the authenticated user.
  ///
  /// Assumes that the system uses `int` user IDs, otherwise throws.
  int get userId {
    return int.parse(userIdentifier, radix: 10);
  }
}
