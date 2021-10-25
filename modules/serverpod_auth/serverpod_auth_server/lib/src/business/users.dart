import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/business/config.dart';
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

  /// Find a user by its id. Returns null if no user is found. By default the
  /// result is cached locally on the server. You can configure the cache
  /// lifetime in [AuthConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  static Future<UserInfo?> findUserByUserId(Session session, int userId, {bool useCache = true}) async {
    final cacheKey = 'serverpod_auth_userinfo_$userId';
    UserInfo? userInfo;

    if (useCache) {
      userInfo = await session.caches.local.get(cacheKey) as UserInfo?;
      if (userInfo != null)
        return userInfo;
    }

    userInfo = (await session.db.findById(tUserInfo, userId)) as UserInfo?;

    if (useCache && userInfo != null) {
      await session.caches.local.put(
        cacheKey, userInfo,
        lifetime: AuthConfig.current.userInfoCacheLifetime,
      );
    }

    return userInfo;
  }

  static Future<UserInfo?> changeUserName(Session session, String userName) async {
    var userId = await session.auth.authenticatedUserId;
    if (userId == null)
      return null;

    var userInfo = await findUserByUserId(session, userId );
    if (userInfo == null)
      return null;

    userInfo.userName = userName;
    await session.db.update(userInfo);

    return userInfo;
  }
}