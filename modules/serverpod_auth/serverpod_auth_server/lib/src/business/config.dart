import 'package:image/image.dart';
import 'package:serverpod_auth_server/module.dart';

import 'user_images.dart';

enum UserImageType {
  png,
  jpg,
}

typedef UserImageGenerator = Future<Image> Function(UserInfo userInfo);

class AuthConfig {
  static AuthConfig _config = AuthConfig();

  static set(AuthConfig config) {
    _config = config;
  }

  static AuthConfig get current => _config;

  final bool userCanEditUserImage;

  final bool userCanEditUserName;

  final bool userCanEditFullName;

  final bool userCanSeeUserName;

  final bool userCanSeeFullName;

  final bool enableUserImages;

  final bool importUserImagesFromGoogleSignIn;

  final int userImageSize;

  final UserImageType userImageFormat;

  final int userImageQuality;

  final UserImageGenerator userImageGenerator;

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
  });
}
