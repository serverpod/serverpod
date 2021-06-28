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

  final int userImageSize;

  final UserImageType userImageFormat;

  final int userImageQuality;

  final UserImageGenerator userImageGenerator;

  AuthConfig({
    this.userImageSize = 256,
    this.userImageFormat = UserImageType.jpg,
    this.userImageQuality = 70,
    this.userImageGenerator = defaultUserImageGenerator,
  });
}
