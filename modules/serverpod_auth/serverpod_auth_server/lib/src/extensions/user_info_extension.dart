import 'package:serverpod_auth_server/module.dart';

/// Convenience methods for the [UserInfo] class.
extension UserInfoExtension on UserInfo {
  /// Returns an object with only the information that can safely be shared
  /// publicly for the user.
  UserInfoPublic toPublic({
    bool includeUserId = true,
    bool includeFullName = true,
  }) {
    return UserInfoPublic(
      id: includeUserId ? id : null,
      userName: userName,
      fullName: includeFullName ? fullName : null,
      created: created,
      imageUrl: imageUrl,
    );
  }
}
