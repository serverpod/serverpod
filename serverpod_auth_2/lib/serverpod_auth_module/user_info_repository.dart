import 'package:serverpod_auth_2/serverpod_auth_module/user_info.dart';

/// The Serverpod-managed `UserInfo`
///
/// If the project defines a custom `UserInfo` extension, this commbines the two.
/// This is important such that all hooks properly fire and one can not (inadvertently) silently create users.
class UserInfoRepository<T extends UserInfo> {
  final users = <String, UserInfo>{};

  UserInfo createUser() {
    final user = UserInfo()..id = DateTime.now().microsecondsSinceEpoch;

    return users[user.id!.toString()] = user;
  }

  UserInfo getUser(String userInfoId) {
    return users[userInfoId]!;
  }
}
