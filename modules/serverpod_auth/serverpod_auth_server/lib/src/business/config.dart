import 'package:image/image.dart';
import 'package:serverpod_auth_server/module.dart';

import 'user_images.dart';

/// Defines the format of stored user images.
enum UserImageType {
  /// PNG image format.
  png,

  /// JPG image format.
  jpg,
}

/// Generates a default user image (avatar) for a user that hasn't uploaded a
/// user image.
typedef UserImageGenerator = Future<Image> Function(UserInfo userInfo);

/// Configuration options for the Auth module.
class AuthConfig {
  static AuthConfig _config = AuthConfig();

  /// Updates the configuration used by the Auth module.
  static void set(AuthConfig config) {
    _config = config;
  }

  /// Gets the current Auth module configuration.
  static AuthConfig get current => _config;

  /// True if users can update their profile images.
  final bool userCanEditUserImage;

  /// True if users can edit their user names.
  final bool userCanEditUserName;

  /// True if users can edit their full name.
  final bool userCanEditFullName;

  /// True if users can view their user name.
  final bool userCanSeeUserName;

  /// True if users can view their full name.
  final bool userCanSeeFullName;

  /// True if user images are enabled.
  final bool enableUserImages;

  /// True if user images should be imported when signing in with Google.
  final bool importUserImagesFromGoogleSignIn;

  /// The size of user images. Defaults to 256.
  final int userImageSize;

  /// The format used to store user images. Defaults to JPG images.
  final UserImageType userImageFormat;

  /// The quality setting for images if JPG format is used.
  final int userImageQuality;

  /// Generator used to produce default user images. By default a generator that
  /// mimics Google's default avatars is used.
  final UserImageGenerator userImageGenerator;

  final Duration userInfoCacheLifetime;

  /// Creates a new Auth configuration. Use the [set] method to replace the
  /// default settings.
  AuthConfig({
    this.enableUserImages = true,
    this.importUserImagesFromGoogleSignIn = true,
    this.userImageSize = 256,
    this.userImageFormat = UserImageType.jpg,
    this.userImageQuality = 70,
    this.userImageGenerator = defaultUserImageGenerator,
    this.userCanEditUserImage = true,
    this.userCanEditUserName = true,
    this.userCanEditFullName = false,
    this.userCanSeeUserName = true,
    this.userCanSeeFullName = true,
    this.userInfoCacheLifetime = const Duration(minutes: 1),
  });
}
