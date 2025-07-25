import 'package:serverpod/serverpod.dart';

/// User ID extension for `AuthenticationInfo`.
extension AuthenticationInfoUserId on AuthenticationInfo {
  /// Returns the `int` user ID of the authenticated user.
  ///
  /// Assumes that the system uses `int` user IDs, otherwise throws.
  int get userId {
    final userId = int.tryParse(userIdentifier, radix: 10);
    if (userId == null) {
      throw FormatException(
        'Expected `AuthenticationInfo.userIdentifier` to represent an int, got: "$userIdentifier"',
      );
    }

    return userId;
  }
}
