import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';

/// Configuration options for the user profile module.
class UserProfileConfig {
  /// The size of user images.
  ///
  /// Defaults to 256.
  final int userImageSize;

  /// The duration which user infos are cached locally in the server.
  ///
  /// Defaults to 1 minute.
  final Duration userInfoCacheLifetime;

  /// Generator used to produce default user images. By default a generator that
  /// mimics Google's default avatars is used.
  final UserImageGenerator userImageGenerator;

  /// The format used to store user images. Defaults to JPG images.
  final UserProfileImageType userImageFormat;

  /// The quality setting for images if JPG format is used.
  ///
  /// Defaults to 70.
  final int userImageQuality;

  /// The function used to fetch profile image by URL.
  ///
  /// Defaults to `http.get()`.
  final FutureOr<Uint8List> Function(Uri url) imageFetchFunc;

  /// Called when a user profile is about to be created.
  final BeforeUserProfileCreatedHandler? onBeforeUserProfileCreated;

  /// Called after a user profile has been created.
  final AfterUserProfileCreatedHandler? onAfterUserProfileCreated;

  /// Called before a user profile is about to be updated.
  ///
  /// This happens when the profile's user name, full name, or picture will be changed.
  final BeforeUserProfileUpdatedHandler? onBeforeUserProfileUpdated;

  /// Called whenever a user profile has been updated.
  ///
  /// This happens when the profile's user name, full name, or picture has been changed.
  final AfterUserProfileUpdatedHandler? onAfterUserProfileUpdated;

  /// Create a new user profile configuration.
  UserProfileConfig({
    this.userImageSize = 256,
    this.userInfoCacheLifetime = const Duration(minutes: 1),
    this.userImageGenerator = defaultUserImageGenerator,
    this.userImageFormat = UserProfileImageType.jpg,
    this.userImageQuality = 70,
    this.onBeforeUserProfileCreated,
    this.onAfterUserProfileCreated,
    this.onBeforeUserProfileUpdated,
    this.onAfterUserProfileUpdated,
    this.imageFetchFunc = _defaultImageFetch,
  });

  /// The current user profile module configuration.
  static UserProfileConfig current = UserProfileConfig();
}

/// Generates a default user image (avatar) for a user who hasn't uploaded a
/// user image.
typedef UserImageGenerator = Future<Image> Function(
  UserProfileModel userProfile,
);

/// Defines the format of stored user images.
enum UserProfileImageType {
  /// PNG image format.
  png,

  /// JPG image format.
  jpg,
}

/// Callback to be invoked with the new user profile data before it gets created.
typedef BeforeUserProfileCreatedHandler = FutureOr<UserProfileData> Function(
  Session session,
  UuidValue authUserId,
  UserProfileData userProfile, {
  required Transaction transaction,
});

/// Callback to be invoked with the new user profile after it has been created.
typedef AfterUserProfileCreatedHandler = FutureOr<void> Function(
  Session session,
  UserProfileModel userProfile, {
  required Transaction transaction,
});

/// Callback to be invoked with the new user profile before it will be updated.
typedef BeforeUserProfileUpdatedHandler = FutureOr<UserProfileData> Function(
  Session session,
  UuidValue authUserId,
  UserProfileData userProfile, {
  required Transaction transaction,
});

/// Callback to be invoked with the updated user profile after it has been updated.
typedef AfterUserProfileUpdatedHandler = FutureOr<void> Function(
  Session session,
  UserProfileModel userProfile, {
  required Transaction transaction,
});

Future<Uint8List> _defaultImageFetch(final Uri url) async {
  final result = await http.get(url);

  return result.bodyBytes;
}
