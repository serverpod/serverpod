import '../../generated/protocol.dart';

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
