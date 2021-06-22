class AuthConfig {
  static AuthConfig _config = AuthConfig();

  static set(AuthConfig config) {
    _config = config;
  }

  static AuthConfig get current => _config;

  final int userImageSize;

  final UserImageType userImageFormat;

  final int userImageQuality;

  AuthConfig({
    this.userImageSize = 256,
    this.userImageFormat = UserImageType.jpg,
    this.userImageQuality = 70,
  });
}

enum UserImageType {
  png,
  jpg,
}