import 'dart:isolate';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
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

    userProfile = savedProfile.toModel();

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

    return profile.toModel();
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
      userInfo = userProfile.toModel();
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

    return updatedProfile.toModel();
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

    return updatedProfile.toModel();
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

// #region Profile images

  /// Sets a user's image from the provided [url].
  ///
  /// The image is downloaded, stored in the cloud and associated with the user.
  static Future<UserProfileModel> setUserImageFromUrl(
    final Session session,
    final UuidValue authUserId,
    final Uri url,
  ) async {
    final result = await http.get(url);
    final bytes = result.bodyBytes;

    return setUserImageFromBytes(session, authUserId, bytes);
  }

  /// Sets a user's image from image data.
  ///
  /// The image is resized before being stored in the cloud and associated with the user.
  static Future<UserProfileModel> setUserImageFromBytes(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes,
  ) async {
    final reEncodedImageBytes = await Isolate.run(() async {
      var image = decodeImage(imageBytes)!;

      final imageSize = UserProfileConfig.current.userImageSize;
      if (image.width != imageSize || image.height != imageSize) {
        image = copyResizeCropSquare(
          image,
          size: imageSize,
          interpolation: Interpolation.average,
        );
      }

      return _encodeImage(image);
    });

    return _setUserImage(session, authUserId, reEncodedImageBytes);
  }

  /// Sets a user's image to the default image for that user.
  static Future<UserProfileModel> setDefaultUserImage(
    final Session session,
    final UuidValue authUserId,
  ) async {
    final userProfile = await UserProfiles.findUserProfileByUserId(
      session,
      authUserId,
    );

    final image =
        await UserProfileConfig.current.userImageGenerator(userProfile);
    final imageBytes = await Isolate.run(() => _encodeImage(image));

    return _setUserImage(session, authUserId, imageBytes);
  }

  static Uint8List _encodeImage(final Image image) =>
      switch (UserProfileConfig.current.userImageFormat) {
        UserProfileImageType.jpg => encodeJpg(
            image,
            quality: UserProfileConfig.current.userImageQuality,
          ),
        UserProfileImageType.png => encodePng(image),
      };

  static Future<UserProfileModel> _setUserImage(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes,
  ) async {
    // Find the latest version of the user image if any.
    final oldImageRef = await UserProfileImage.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      orderBy: (final t) => t.version,
      orderDescending: true,
    );

    // Add one to the version number or create a new version 1.
    final version = (oldImageRef?.version ?? 0) + 1;

    String pathExtension;
    if (UserProfileConfig.current.userImageFormat == UserProfileImageType.jpg) {
      pathExtension = '.jpg';
    } else {
      pathExtension = '.png';
    }

    // Store the image.
    final path = 'serverpod/user_images/$authUserId-$version$pathExtension';
    await session.storage.storeFile(
      storageId: 'public',
      path: path,
      byteData: ByteData.view(imageBytes.buffer),
    );
    final publicUrl = (await session.storage.getPublicUrl(
      storageId: 'public',
      path: path,
    ))!;

    return setUserImageFromOwnedUrl(session, authUserId, version, publicUrl);
  }

  /// Sets the profile image to the given URL, which is presumed to be owned by this application.
  @visibleForTesting
  static Future<UserProfileModel> setUserImageFromOwnedUrl(
    final Session session,
    final UuidValue authUserId,
    final int version,
    final Uri publicUrl,
  ) async {
    var profileImage = UserProfileImage(
      authUserId: authUserId,
      version: version,
      url: publicUrl,
    );

    profileImage = await UserProfileImage.db.insertRow(session, profileImage);

    var userProfile = await _findUserProfile(
      session,
      authUserId,
    );

    userProfile.imageId = profileImage.id!;
    userProfile.image = profileImage;

    userProfile = await _updateProfile(session, userProfile);

    return userProfile.toModel();
  }
// #endregion

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

    final modelBeforeChange = userProfile.toModel();
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

    await _invalidateCacheForUser(session, userProfile.authUserId);

    await UserProfileConfig.current.onAfterUserProfileUpdated?.call(
      session,
      userProfile.toModel(),
    );

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
