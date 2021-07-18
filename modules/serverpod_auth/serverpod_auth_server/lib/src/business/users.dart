import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Business logic for handling users.
class Users {
  /// Creates a new user and stores it in the database.
  static Future<UserInfo?> createUser(Session session, UserInfo userInfo) async {
    await session.db.insert(userInfo);
    if (userInfo.id != null)
      return userInfo;
    else
      return null;
  }

  /// Finds a user by its email address. Returns null if no user is found.
  static Future<UserInfo?> findUserByEmail(Session session, String email) async {
    return (await session.db.findSingleRow(
      tUserInfo,
      where: tUserInfo.email.equals(email),
    )) as UserInfo?;
  }

  /// Finds a user by its sign in identifier. For Google sign ins, this is the
  /// email address. For Apple sign ins, this is a unique identifying string.
  /// Returns null if no user is found.
  static Future<UserInfo?> findUserByIdentifier(Session session, String identifier) async {
    return (await session.db.findSingleRow(
      tUserInfo,
      where: tUserInfo.userIdentifier.equals(identifier),
    )) as UserInfo?;
  }

  /// Find a user by its id. Returns null if no user is found.
  static Future<UserInfo?> findUserByUserId(Session session, int userId) async {
    return (await session.db.findById(tUserInfo, userId)) as UserInfo?;
  }
}