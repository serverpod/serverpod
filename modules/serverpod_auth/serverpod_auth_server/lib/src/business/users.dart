import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/business/config.dart';

import '../generated/protocol.dart';

/// Business logic for handling users.
class Users {
  /// Creates a new user and stores it in the database.
  static Future<UserInfo?> createUser(
    Session session,
    UserInfo userInfo, [
    String? authMethod,
  ]) async {
    if (AuthConfig.current.onUserWillBeCreated != null) {
      var approved = await AuthConfig.current.onUserWillBeCreated!(
        session,
        userInfo,
        authMethod,
      );
      if (!approved) return null;
    }

    userInfo = await UserInfo.db.insertRow(session, userInfo);
    if (userInfo.id != null) {
      if (AuthConfig.current.onUserCreated != null) {
        await AuthConfig.current.onUserCreated!(session, userInfo);
      }
      return userInfo;
    }
    return null;
  }

  /// Finds a user by its email address. Returns null if no user is found.
  static Future<UserInfo?> findUserByEmail(
      Session session, String email) async {
    return await UserInfo.db.findRow(
      session,
      where: (t) => t.email.equals(email),
    );
  }

  /// Finds a user by its sign in identifier. For Google sign ins, this is the
  /// email address. For Apple sign ins, this is a unique identifying string.
  /// Returns null if no user is found.
  static Future<UserInfo?> findUserByIdentifier(
      Session session, String identifier) async {
    return await UserInfo.db.findRow(
      session,
      where: (t) => t.userIdentifier.equals(identifier),
    );
  }

  /// Find a user by its id. Returns null if no user is found. By default the
  /// result is cached locally on the server. You can configure the cache
  /// lifetime in [AuthConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  static Future<UserInfo?> findUserByUserId(Session session, int userId,
      {bool useCache = true}) async {
    var cacheKey = 'serverpod_auth_userinfo_$userId';
    UserInfo? userInfo;

    if (useCache) {
      userInfo = await session.caches.local.get<UserInfo>(cacheKey);
      if (userInfo != null) return userInfo;
    }

    userInfo = await UserInfo.db.findById(session, userId);

    if (useCache && userInfo != null) {
      await session.caches.local.put(
        cacheKey,
        userInfo,
        lifetime: AuthConfig.current.userInfoCacheLifetime,
      );
    }

    return userInfo;
  }

  /// Updates a users name, returns null if unsuccessful.
  static Future<UserInfo?> changeUserName(
      Session session, int userId, String newUserName) async {
    var userInfo = await findUserByUserId(session, userId, useCache: false);
    if (userInfo == null) return null;

    userInfo.userName = newUserName;
    await UserInfo.db.updateRow(session, userInfo);

    if (AuthConfig.current.onUserUpdated != null) {
      await AuthConfig.current.onUserUpdated!(session, userInfo);
    }

    await invalidateCacheForUser(session, userId);
    return userInfo;
  }

  /// Updates the scopes a user can access.
  static Future<UserInfo?> updateUserScopes(
    Session session,
    int userId,
    Set<Scope> newScopes,
  ) async {
    var userInfo = await findUserByUserId(session, userId, useCache: false);
    if (userInfo == null) return null;

    var scopeStrs = <String>[];
    for (var scope in newScopes) {
      if (scope.name != null) scopeStrs.add(scope.name!);
    }
    userInfo.scopeNames = scopeStrs;
    await UserInfo.db.updateRow(session, userInfo);

    // Update all authentication keys too.
    var json = SerializationManager.encode(scopeStrs);
    await session.dbNext.dangerouslyQuery(
        'UPDATE serverpod_auth_key SET "scopeNames"=\'$json\' WHERE "userId" = $userId');

    if (AuthConfig.current.onUserUpdated != null) {
      await AuthConfig.current.onUserUpdated!(session, userInfo);
    }

    await invalidateCacheForUser(session, userId);
    return userInfo;
  }

  /// Invalidates the cache for a user and makes sure the next time a user info
  /// is fetched it's fresh from the database.
  static Future<void> invalidateCacheForUser(
      Session session, int userId) async {
    var cacheKey = 'serverpod_auth_userinfo_$userId';
    await session.caches.local.invalidateKey(cacheKey);
  }
}

/// Additional methods for [UserInfo].
extension UserInfoMethods on UserInfo {
  /// Invalidates the local cache for the user, and forces next lookup to get a
  /// fresh copy from the database.
  Future<void> invalidateCache(Session session) async {
    if (id == null) return;

    await Users.invalidateCacheForUser(session, id!);
  }

  /// Updates the name of this user, returns true if successful.
  Future<bool> changeUserName(Session session, String newUserName) async {
    if (id == null) return false;

    var updatedUser = await Users.changeUserName(session, id!, newUserName);
    if (updatedUser == null) return false;

    userName = newUserName;
    return true;
  }

  /// Returns a set containing the scopes this user has access to.
  Set<Scope> get scopes {
    var set = <Scope>{};
    for (var scopeStr in scopeNames) {
      set.add(Scope(scopeStr));
    }
    return set;
  }

  /// Updates the scopes for a user, returns true if successful.
  Future<bool> updateScopes(Session session, Set<Scope> newScopes) async {
    if (id == null) return false;

    var updatedUser = await Users.updateUserScopes(session, id!, newScopes);
    if (updatedUser == null) return false;

    scopeNames = updatedUser.scopeNames;
    return true;
  }
}
