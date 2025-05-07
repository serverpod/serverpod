import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';

/// Business logic for handling user profiles
abstract final class UserProfiles {
  /// Creates a new user and stores it in the database.
  static Future<UserProfile> createUserProfile(
    final Session session,
    UserProfile userProfile,
  ) async {
    userProfile = userProfile.copyWith(
      email: userProfile.email?.toLowerCase().trim(),
    );

    userProfile = (await UserProfileConfig.current.onBeforeUserProfileCreated
            ?.call(session, userProfile)) ??
        userProfile;

    userProfile = userProfile.id == null
        ? await UserProfile.db.insertRow(session, userProfile)
        : await UserProfile.db.updateRow(session, userProfile);

    await UserProfileConfig.current.onAfterUserProfileCreated?.call(
      session,
      userProfile,
    );

    return userProfile;
  }

  /// Finds a user profile by its email address.
  ///
  /// Returns `null` if no user profile with that email is found,
  /// or there already exist 2 or more with that email address.
  static Future<UserProfile?> maybeFindUserProfileByEmail(
    final Session session,
    String email,
  ) async {
    email = email.toLowerCase().trim();

    final profiles = await UserProfile.db.find(
      session,
      where: (final t) => t.email.equals(email),
    );

    return profiles.singleOrNull;
  }

  /// Find a user profile by the `AuthUser`'s ID.
  ///
  /// By default the result is cached locally on the server. You can configure the cache
  /// lifetime in [UserProfileConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  static Future<UserProfile> findUserProfileByUserId(
    final Session session,
    final UuidValue userId, {
    final bool useCache = true,
  }) async {
    return (await maybeFindUserByUserId(session, userId, useCache: useCache))!;
  }

  /// Looks for a user profile by the `AuthUser`'s ID.
  ///
  /// Returns `null` if no profile is found. By default the
  /// result is cached locally on the server. You can configure the cache
  /// lifetime in [UserProfileConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  static Future<UserProfile?> maybeFindUserByUserId(
    final Session session,
    final UuidValue authUserId, {
    final bool useCache = true,
  }) async {
    final cacheKey = _userProfileCacheKey(authUserId);
    UserProfile? userInfo;

    if (useCache) {
      userInfo = await session.caches.local.get<UserProfile>(cacheKey);
      if (userInfo != null) return userInfo;
    }

    userInfo = await UserProfile.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
    );

    if (useCache && userInfo != null) {
      await session.caches.local.put(
        cacheKey,
        userInfo,
        lifetime: UserProfileConfig.current.userInfoCacheLifetime,
      );
    }

    return userInfo;
  }

  /// Updates a users name.
  static Future<UserProfile> changeUserName(
    final Session session,
    final UuidValue userId,
    final String newUserName,
  ) async {
    var userProfile = await findUserProfileByUserId(
      session,
      userId,
      useCache: false,
    );

    userProfile.userName = newUserName;
    userProfile = await UserProfile.db.updateRow(session, userProfile);

    await UserProfileConfig.current.onAfterUserProfileUpdated?.call(
      session,
      userProfile,
    );

    await _invalidateCacheForUser(session, userId);

    return userProfile;
  }

  /// Updates a users name.
  static Future<UserProfile> changeFullName(
    final Session session,
    final UuidValue userId,
    final String newFullName,
  ) async {
    var userProfile = await findUserProfileByUserId(
      session,
      userId,
      useCache: false,
    );

    userProfile.fullName = newFullName;
    userProfile = await UserProfile.db.updateRow(session, userProfile);

    await UserProfileConfig.current.onAfterUserProfileUpdated?.call(
      session,
      userProfile,
    );

    await _invalidateCacheForUser(session, userId);

    return userProfile;
  }

  static String _userProfileCacheKey(
    /// ID of then [AuthUser]
    final UuidValue userId,
  ) {
    return 'serverpod_auth_profile_$userId';
  }

  /// Invalidates the cache for a user and makes sure the next time a user profile
  /// is fetched it's fresh from the database.
  static Future<void> _invalidateCacheForUser(
    final Session session,
    final UuidValue userId,
  ) async {
    final cacheKey = _userProfileCacheKey(userId);

    await session.caches.local.invalidateKey(cacheKey);
  }
}
