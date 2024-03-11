import 'package:image/image.dart';
import 'package:serverpod/server.dart';
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

/// Callback for user info being updated.
typedef UserInfoUpdateCallback = Future<void> Function(
    Session session, UserInfo userInfo);

/// Callback for user creation.
typedef UserInfoCreationCallback = Future<bool> Function(
    Session session, UserInfo userInfo, String? method);

/// Callback for emailing password resets.
typedef SendPasswordResetEmailCallback = Future<bool> Function(
    Session session, UserInfo userInfo, String validationCode);

/// Callback for emailing validation codes at account setup.
typedef SendValidationEmailCallback = Future<bool> Function(
    Session session, String email, String validationCode);

/// Configuration options for the Auth module.
class AuthConfig {
  static AuthConfig _config = AuthConfig();

  /// Updates the configuration used by the Auth module.
  static void set(AuthConfig config) {
    _config = config;
  }

  /// Gets the current Auth module configuration.
  static AuthConfig get current => _config;

  /// Max allowed failed email sign in attempts within the reset period.
  /// Defaults to 5. (By default, a user can make 5 sign in attempts within a
  /// 5 minute window.)
  final int maxAllowedEmailSignInAttempts;

  /// The reset period for email sign in attempts. Defaults to 5 minutes.
  final Duration emailSignInFailureResetTime;

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

  /// The duration which user infos are cached locally in the server. Default
  /// is 1 minute.
  final Duration userInfoCacheLifetime;

  /// Called when a user is about to be created, gives a chance to abort the
  /// creation by returning false.
  final UserInfoCreationCallback? onUserWillBeCreated;

  /// Called after a user has been created. Listen to this callback if you need
  /// to do additional setup.
  final UserInfoUpdateCallback? onUserCreated;

  /// Called whenever a user has been updated. This can be when the user name
  /// is changed or if the user uploads a new profile picture.
  final UserInfoUpdateCallback? onUserUpdated;

  /// Called when a user should be sent a reset code by email.
  final SendPasswordResetEmailCallback? sendPasswordResetEmail;

  /// Called when a user should be sent a validation code on account setup.
  final SendValidationEmailCallback? sendValidationEmail;

  /// The time for password resets to be valid. Default is one day.
  final Duration passwordResetExpirationTime;

  /// True if the server should use the accounts email address as part of the
  /// salt when storing password hashes (strongly recommended). Default is true.
  final bool extraSaltyHash;

  /// Firebase service account key JSON file. Generate and download from the
  /// Firebase console.
  final String firebaseServiceAccountKeyJson;

  /// The maximum length of passwords when signing up with email.
  /// Default is 128 characters.
  final int maxPasswordLength;

  /// The minimum length of passwords when signing up with email.
  /// Default is 8 characters.
  final int minPasswordLength;

  /// True if unsecure random number generation is allowed. If set to false, an
  /// error will be thrown if the platform does not support secure random number
  /// generation. Default is true but will be changed to false in Serverpod 2.0.
  final bool allowUnsecureRandom;

  /// Creates a new Auth configuration. Use the [set] method to replace the
  /// default settings. Defaults to `config/firebase_service_account_key.json`.
  AuthConfig({
    this.maxAllowedEmailSignInAttempts = 5,
    this.emailSignInFailureResetTime = const Duration(minutes: 5),
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
    this.onUserWillBeCreated,
    this.onUserCreated,
    this.onUserUpdated,
    this.sendPasswordResetEmail,
    this.sendValidationEmail,
    this.passwordResetExpirationTime = const Duration(hours: 24),
    this.extraSaltyHash = true,
    this.firebaseServiceAccountKeyJson =
        'config/firebase_service_account_key.json',
    this.maxPasswordLength = 128,
    this.minPasswordLength = 8,
    this.allowUnsecureRandom = true,
  });
}
