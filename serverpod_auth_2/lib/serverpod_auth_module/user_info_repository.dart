import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/additional_data.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info.dart';

/// The Serverpod-managed `UserInfo`
///
/// If the project defines a custom `UserInfo` extension, this commbines the two.
/// This is important such that all hooks properly fire and one can not (inadvertently) silently create users.
class UserInfoRepository {
  UserInfoRepository({
    this.onBeforeUserCreate,
    this.onAfterUserCreate,
  });

  /// Callback to be invoked before a user is created
  ///
  /// This can then be used to create a new user object, pick an existing one (thus not actually creating a new one),
  /// or modify the developer-given one's properties
  // TODO: Would this need to provide access to the DB (via the current session?)?
  UserInfo? Function(UserInfo?, AdditionalData? additionalData)?
      onBeforeUserCreate;

  UserInfo Function(UserInfo, AdditionalData? additionalData)?
      onAfterUserCreate;

  @visibleForTesting
  final users = <int, UserInfo>{};

  UserInfo createUser(UserInfo? userInfo, AdditionalData? additionalData) {
    assert(userInfo?.id == null);

    var user = onBeforeUserCreate?.call(userInfo, additionalData) ?? UserInfo();
    if (user.id == null) {
      user.id = DateTime.now().microsecondsSinceEpoch;
      users[user.id!] = user;
    }

    return user;
  }

  UserInfo getUser(int userInfoId) {
    return users[userInfoId]!;
  }

  void updateUser(UserInfo userInfo) {
    assert(userInfo.id != null);

    users[userInfo.id!] = userInfo;
  }
}
