import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_profile_server/src/generated/user_profile.dart';

/// Extensions method to convert [UserProfile] to model.
extension UserProfileToUserProfileModel on UserProfile? {
  /// Returns the model of the database entity.
  ///
  /// If the profile is null, all fields other than the auth user ID will be `null`.
  UserProfileModel toModel(final UuidValue authUserId) {
    return UserProfileModel(
      authUserId: authUserId,
      userName: this?.userName,
      fullName: this?.fullName,
      email: this?.email,
      imageUrl: this?.image?.url,
    );
  }
}
