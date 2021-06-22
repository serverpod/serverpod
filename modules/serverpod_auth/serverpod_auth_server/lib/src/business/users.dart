import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class Users {
  static Future<UserInfo?> createUser(Session session, UserInfo userInfo) async {
    await session.db.insert(userInfo);
    if (userInfo.id != null)
      return userInfo;
    else
      return null;
  }

  static Future<UserInfo?> findUserByEmail(Session session, String email) async {
    return (await session.db.findSingleRow(
      tUserInfo,
      where: tUserInfo.email.equals(email),
    )) as UserInfo?;
  }

  static Future<UserInfo?> findUserByIdentifier(Session session, String identifier) async {
    return (await session.db.findSingleRow(
      tUserInfo,
      where: tUserInfo.userIdentifier.equals(identifier),
    )) as UserInfo?;
  }
}