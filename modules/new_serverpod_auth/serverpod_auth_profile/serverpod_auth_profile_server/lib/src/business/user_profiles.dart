import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_profile_server/src/generated/protocol.dart';
import 'package:serverpod_auth_profile_server/src/util/user_profile_extension.dart';

/// Business logic for handling user profiles
abstract final class UserProfiles {
  /// Creates a new user and stores it in the database.
  ///
  /// In case the `onBeforeUserProfileCreated` hook redirects this creation onto an existing profile,
  /// no profile will be created, but the existing profile will be updated with the return value of the hook.
  static Future<UserProfileModel> createUserProfile(
    final Session session,
    UserProfileModel userProfile,
  ) async {
    userProfile = userProfile.copyWith(
      email: userProfile.email?.toLowerCase().trim(),
    );

    userProfile = (await UserProfileConfig.current.onBeforeUserProfileCreated
            ?.call(session, userProfile)) ??
        userProfile;

    if (userProfile.imageUrl != null) {
      throw Exception('An image can not be set when creating a user.');
    }

    final savedProfile = await UserProfile.db.insertRow(
      session,
      UserProfile(
        authUserId: userProfile.authUserId,
        userName: userProfile.userName,
        fullName: userProfile.fullName,
        email: userProfile.email,
      ),
    );

    userProfile = savedProfile.toModel(userProfile.authUserId);

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
  static Future<UserProfileModel?> maybeFindUserProfileByEmail(
    final Session session,
    String email,
  ) async {
    email = email.toLowerCase().trim();

    final profiles = await UserProfile.db.find(
      session,
      where: (final t) => t.email.equals(email),
    );

    final profile = profiles.singleOrNull;

    if (profile == null) {
      return null;
    }

    return profile.toModel(profile.authUserId);
  }

  /// Find a user profile by the `AuthUser`'s ID.
  ///
  /// By default the result is cached locally on the server. You can configure the cache
  /// lifetime in [UserProfileConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  static Future<UserProfileModel> findUserProfileByUserId(
    final Session session,
    final UuidValue authUserId, {
    final bool useCache = true,
  }) async {
    return (await maybeFindUserByUserId(session, authUserId,
        useCache: useCache))!;
  }

  /// Looks for a user profile by the `AuthUser`'s ID.
  ///
  /// Returns `null` if no profile is found. By default the
  /// result is cached locally on the server. You can configure the cache
  /// lifetime in [UserProfileConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  static Future<UserProfileModel?> maybeFindUserByUserId(
    final Session session,
    final UuidValue authUserId, {
    final bool useCache = true,
  }) async {
    final cacheKey = _userProfileCacheKey(authUserId);
    UserProfileModel? userInfo;

    if (useCache) {
      userInfo = await session.caches.local.get<UserProfileModel>(cacheKey);
      if (userInfo != null) return userInfo;
    }

    final userProfile = await _maybeFindUserProfile(session, authUserId);

    if (userProfile != null) {
      userInfo = userProfile.toModel(authUserId);
    }

    if (useCache && userInfo != null) {
      await session.caches.local.put(
        cacheKey,
        userInfo,
        lifetime: UserProfileConfig.current.userInfoCacheLifetime,
      );
    }

    return userInfo;
  }

  /// Updates a profiles's user name.
  static Future<UserProfileModel> changeUserName(
    final Session session,
    final UuidValue authUserId,
    final String newUserName,
  ) async {
    final userProfile = await _findUserProfile(
      session,
      authUserId,
    );

    userProfile.userName = newUserName;

    final updatedProfile = await _updateProfile(session, userProfile);

    return updatedProfile.toModel(authUserId);
  }

  /// Updates a profile's full name.
  static Future<UserProfileModel> changeFullName(
    final Session session,
    final UuidValue authUserId,
    final String newFullName,
  ) async {
    final userProfile = await _findUserProfile(
      session,
      authUserId,
    );

    userProfile.fullName = newFullName;

    final updatedProfile = await _updateProfile(session, userProfile);

    return updatedProfile.toModel(authUserId);
  }

  /// Updates a profile's image.
  @internal
  static Future<UserProfileModel> changeImage(
    final Session session,
    final UuidValue authUserId,
    final UserProfileImage? newImage,
  ) async {
    var userProfile = await _findUserProfile(
      session,
      authUserId,
    );

    userProfile.imageId = newImage?.id!;
    userProfile.image = newImage;

    userProfile = await _updateProfile(session, userProfile);

    return userProfile.toModel(authUserId);
  }

  /// Remove the user profile for the given [authUserId].
  ///
  /// In case the user did not have a profile, nothing is changed.
  static Future<void> deleteProfileForUser(
    final Session session,
    final UuidValue authUserId,
  ) async {
    await UserProfile.db.deleteWhere(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
    );

    await _invalidateCacheForUser(session, authUserId);
  }

  static Future<UserProfile> _updateProfile(
    final Session session,
    UserProfile userProfile,
  ) async {
    if (userProfile.imageId != null && userProfile.image == null) {
      throw Exception(
        'Can not update profile with an `imageId` when the full `image` is not set.',
      );
    }
    if (userProfile.imageId != userProfile.image?.id) {
      throw Exception(
        'Can not update profile when `imageId` and `image` do not point to the same entity.',
      );
    }

    final modelBeforeChange = userProfile.toModel(userProfile.authUserId);
    final modifiedProfile = await UserProfileConfig
        .current.onBeforeUserProfileUpdated
        ?.call(session, modelBeforeChange);
    if (modifiedProfile != null) {
      if (modifiedProfile.imageUrl != modelBeforeChange.imageUrl) {
        throw Exception(
          "The profile's `imageUrl` must not be changed by the `onBeforeUserProfileUpdated` hook",
        );
      }

      userProfile = userProfile.copyWith(
        userName: modifiedProfile.userName,
        fullName: modifiedProfile.fullName,
        email: modifiedProfile.email,
      );
    }

    userProfile = await UserProfile.db.updateRow(
      session,
      userProfile,
    );

    await UserProfileConfig.current.onAfterUserProfileUpdated?.call(
      session,
      userProfile.toModel(userProfile.authUserId),
    );

    await _invalidateCacheForUser(session, userProfile.authUserId);

    return userProfile;
  }

  static String _userProfileCacheKey(
    /// ID of then [AuthUser]
    final UuidValue authUserId,
  ) {
    return 'serverpod_auth_profile_$authUserId';
  }

  /// Invalidates the cache for a user and makes sure the next time a user profile
  /// is fetched it's fresh from the database.
  static Future<void> _invalidateCacheForUser(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final cacheKey = _userProfileCacheKey(authUserId);

    await session.caches.local.invalidateKey(cacheKey);
  }

  static Future<UserProfile?> _maybeFindUserProfile(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final userProfile = await UserProfile.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      include: UserProfile.include(
        image: UserProfileImage.include(),
      ),
    );

    return userProfile;
  }

  static Future<UserProfile> _findUserProfile(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final userProfile = await _maybeFindUserProfile(session, authUserId);

    if (userProfile == null) {
      throw Exception('Did not find profile for user "$authUserId"');
    }

    return userProfile;
  }
}
