import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

/// Extensions method to convert a [UserProfile] to its model.
extension UserProfileToUserProfileModel on UserProfile {
  /// Returns the model of the database entity.
  UserProfileModel toModel() {
    return UserProfileModel(
      authUserId: authUserId,
      userName: userName,
      fullName: fullName,
      email: email,
      imageUrl: image?.url,
    );
  }
}

/// Extensions method to convert a [UserProfile] to its core data representation.
extension UserProfileToUserProfileData on UserProfile {
  /// Returns the model of the database entity.
  UserProfileData toProfileData() {
    return UserProfileData(
      userName: userName,
      fullName: fullName,
      email: email,
    );
  }
}

/// Extensions method on the AuthenticationInfo to get the user profile.
extension AuthenticationInfoUserProfile on AuthenticationInfo {
  /// Returns the user profile of the authenticated user.
  Future<UserProfileModel?> userProfile(final Session session) async {
    return await AuthServices.instance.userProfiles.findUserProfileByUserId(
      session,
      authUserId,
    );
  }
}
