import 'package:uuid/uuid_value.dart';

/// Exception which is thrown when a user's profile could not be found.
class UserProfileNotFoundException implements Exception {
  /// The ID of the [AuthUser] which does not have an attached profile.
  final UuidValue authUserId;

  /// Creates a new [UserProfileNotFoundException] object.
  UserProfileNotFoundException(this.authUserId);

  @override
  String toString() {
    return 'UserProfileNotFoundException: No user profile could be found for auth user "$authUserId"';
  }
}
