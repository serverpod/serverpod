import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_profile_server/src/generated/protocol.dart';
import 'package:serverpod_auth_profile_server/src/util/user_profile_extension.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Business logic for handling user profiles
abstract final class UserProfiles {
  /// Creates a new user and stores it in the database.
  static Future<UserProfileModel> createUserProfile(
    final Session session,
    final UuidValue authUserId,
    UserProfileData userProfile, {
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint(
      (final transaction) async {
        final onBeforeUserProfileCreated =
            UserProfileConfig.current.onBeforeUserProfileCreated;
        if (onBeforeUserProfileCreated != null) {
          userProfile = await onBeforeUserProfileCreated(
            session,
            authUserId,
            userProfile,
            transaction: transaction,
          );
        }

        userProfile = userProfile.copyWith(
          email: userProfile.email?.toLowerCase().trim(),
        );

        final createdProfile = await UserProfile.db.insertRow(
          session,
          UserProfile(
            authUserId: authUserId,
            userName: userProfile.userName,
            fullName: userProfile.fullName,
            email: userProfile.email,
          ),
          transaction: transaction,
        );

        final createdProfileModel = createdProfile.toModel();

        await UserProfileConfig.current.onAfterUserProfileCreated?.call(
          session,
          createdProfileModel,
          transaction: transaction,
        );

        return createdProfileModel;
      },
      transaction: transaction,
    );
  }

  /// Find a user profile by the `AuthUser`'s ID.
  ///
  /// By default the result is cached locally on the server. You can configure the cache
  /// lifetime in [UserProfileConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  ///
  /// Throws a [UserProfileNotFoundException] in case no profile exists for the given [authUserId].
  static Future<UserProfileModel> findUserProfileByUserId(
    final Session session,
    final UuidValue authUserId, {
    final bool useCache = true,
    final Transaction? transaction,
  }) async {
    final profile = await maybeFindUserProfileByUserId(
      session,
      authUserId,
      useCache: useCache,
      transaction: transaction,
    );

    if (profile == null) {
      throw UserProfileNotFoundException(authUserId);
    }

    return profile;
  }

  /// Looks for a user profile by the `AuthUser`'s ID.
  ///
  /// Returns `null` if no profile is found. By default the
  /// result is cached locally on the server. You can configure the cache
  /// lifetime in [UserProfileConfig], or disable it on a call to call basis by
  /// setting [useCache] to false.
  ///
  /// In case a [transaction] is passed, the cache will not be used.
  static Future<UserProfileModel?> maybeFindUserProfileByUserId(
    final Session session,
    final UuidValue authUserId, {
    bool useCache = true,
    final Transaction? transaction,
  }) async {
    if (transaction != null) {
      useCache = false;
    }

    final cacheKey = _userProfileCacheKey(authUserId);
    UserProfileModel? userInfo;

    if (useCache) {
      userInfo = await session.caches.local.get<UserProfileModel>(cacheKey);
      if (userInfo != null) return userInfo;
    }

    final userProfile = await _maybeFindUserProfile(
      session,
      authUserId,
      transaction: transaction,
    );

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
    final String? newUserName, {
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      final userProfile = await _findUserProfile(
        session,
        authUserId,
        transaction: transaction,
      );

      userProfile.userName = newUserName;

      final updatedProfile = await _updateProfile(
        session,
        userProfile,
        transaction: transaction,
      );

      return updatedProfile.toModel();
    }, transaction: transaction);
  }

  /// Updates a profile's full name.
  static Future<UserProfileModel> changeFullName(
    final Session session,
    final UuidValue authUserId,
    final String? newFullName, {
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      final userProfile = await _findUserProfile(
        session,
        authUserId,
        transaction: transaction,
      );

      userProfile.fullName = newFullName;

      final updatedProfile = await _updateProfile(
        session,
        userProfile,
        transaction: transaction,
      );

      return updatedProfile.toModel();
    }, transaction: transaction);
  }

  /// Remove the user profile, incl. images, for the given [authUserId].
  ///
  /// In case the user did not have a profile, nothing is changed.
  ///
  /// Returns successfully if the profile data could was removed from the database,
  /// even if some profile images could not be deleted.
  ///
  /// In case the `transaction` is later rolled back, the deleted images will
  /// still be missing from the storage.
  static Future<void> deleteProfileForUser(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      final profile = await UserProfile.db.findFirstRow(
        session,
        where: (final t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      );

      if (profile == null) {
        return;
      }

      final images = await UserProfileImage.db.find(
        session,
        where: (final t) => t.userProfileId.equals(profile.id!),
        transaction: transaction,
      );

      // This also deletes the user profile images
      await UserProfile.db.deleteWhere(
        session,
        where: (final t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      );

      await _invalidateCacheForUser(session, authUserId);

      for (final image in images) {
        try {
          await session.storage.deleteFile(
            storageId: image.storageId,
            path: image.path,
          );
        } catch (e, stackTrace) {
          session.log(
            'Failed to delete user image from storage',
            level: LogLevel.error,
            exception: e,
            stackTrace: stackTrace,
          );
        }
      }
    }, transaction: transaction);
  }

// #region Profile images

  static Future<UserProfileImage> _createImageFromUrl(
    final Session session,
    final UuidValue authUserId,
    final Uri url, {
    required final Transaction transaction,
  }) async {
    final bytes = await UserProfileConfig.current.imageFetchFunc(url);

    return _createImageFromBytes(
      session,
      authUserId,
      bytes,
      transaction: transaction,
    );
  }

  static Future<UserProfileImage> _createImageFromBytes(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes, {
    required final Transaction transaction,
  }) async {
    final userProfile = await _findUserProfile(
      session,
      authUserId,
      transaction: transaction,
    );

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

    final imageId = generateRandomString(6);

    String pathExtension;
    if (UserProfileConfig.current.userImageFormat == UserProfileImageType.jpg) {
      pathExtension = '.jpg';
    } else {
      pathExtension = '.png';
    }

    const storageId = 'public';
    final path = 'serverpod/user_images/$authUserId-$imageId$pathExtension';
    await session.storage.storeFile(
      storageId: storageId,
      path: path,
      byteData: ByteData.view(reEncodedImageBytes.buffer),
    );
    final publicUrl = (await session.storage.getPublicUrl(
      storageId: storageId,
      path: path,
    ))!;

    final profileImage = UserProfileImage(
      userProfileId: userProfile.id!,
      storageId: storageId,
      path: path,
      url: publicUrl,
    );

    return UserProfileImage.db.insertRow(
      session,
      profileImage,
      transaction: transaction,
    );
  }

  /// Sets a user's image from the provided [url].
  ///
  /// The image is downloaded, stored in the cloud and associated with the user.
  static Future<UserProfileModel> setUserImageFromUrl(
    final Session session,
    final UuidValue authUserId,
    final Uri url, {
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      final image = await _createImageFromUrl(
        session,
        authUserId,
        url,
        transaction: transaction,
      );

      return _setUserImage(
        session,
        authUserId,
        image,
        transaction: transaction,
      );
    }, transaction: transaction);
  }

  /// Sets a user's image from image data.
  ///
  /// The image is resized before being stored in the cloud and associated with the user.
  static Future<UserProfileModel> setUserImageFromBytes(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes, {
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      final image = await _createImageFromBytes(
        session,
        authUserId,
        imageBytes,
        transaction: transaction,
      );

      return _setUserImage(
        session,
        authUserId,
        image,
        transaction: transaction,
      );
    }, transaction: transaction);
  }

  /// Sets a user's image to the default image for that user.
  static Future<UserProfileModel> setDefaultUserImage(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint(
      (final transaction) async {
        final userProfile = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
          transaction: transaction,
        );

        final image = await defaultUserImageGenerator(userProfile);

        final imageBytes = await _encodeImage(image);

        return setUserImageFromBytes(
          session,
          authUserId,
          imageBytes,
          transaction: transaction,
        );
      },
      transaction: transaction,
    );
  }

  static Future<UserProfileModel> _setUserImage(
    final Session session,
    final UuidValue authUserId,
    final UserProfileImage image, {
    required final Transaction transaction,
  }) async {
    var userProfile = await _findUserProfile(
      session,
      authUserId,
      transaction: transaction,
    );

    userProfile.imageId = image.id!;
    userProfile.image = image;

    userProfile = await _updateProfile(
      session,
      userProfile,
      transaction: transaction,
    );

    return userProfile.toModel();
  }

// #endregion

  static Future<UserProfile> _updateProfile(
    final Session session,
    UserProfile userProfile, {
    required final Transaction transaction,
  }) async {
    if (userProfile.imageId != userProfile.image?.id) {
      throw ArgumentError.value(
        userProfile,
        'userProfile',
        '`image.id` and `imageId` do not match. To update a profile in the database and get the fully hydrated object, both need to be set accordingly.',
      );
    }
    if (userProfile.image != null &&
        userProfile.image!.userProfileId != userProfile.id) {
      throw ArgumentError.value(
        userProfile,
        'userProfile',
        'The given image belongs to user ${userProfile.image!.userProfileId} and thus can not be used on the profile of user ${userProfile.id}',
      );
    }

    final modifiedProfile =
        await UserProfileConfig.current.onBeforeUserProfileUpdated?.call(
      session,
      userProfile.authUserId,
      userProfile.toProfileData(),
      transaction: transaction,
    );

    if (modifiedProfile != null) {
      userProfile = userProfile.copyWith(
        userName: modifiedProfile.userName,
        fullName: modifiedProfile.fullName,
        email: modifiedProfile.email?.toLowerCase().trim(),
      );
    }

    userProfile = await UserProfile.db.updateRow(
      session,
      userProfile,
      transaction: transaction,
    );

    await _invalidateCacheForUser(session, userProfile.authUserId);

    await UserProfileConfig.current.onAfterUserProfileUpdated?.call(
      session,
      userProfile.toModel(),
      transaction: transaction,
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
    final UuidValue authUserId, {
    required final Transaction? transaction,
  }) async {
    final userProfile = await UserProfile.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      include: UserProfile.include(
        image: UserProfileImage.include(),
      ),
      transaction: transaction,
    );

    return userProfile;
  }

  static Future<UserProfile> _findUserProfile(
    final Session session,
    final UuidValue authUserId, {
    required final Transaction transaction,
  }) async {
    final userProfile = await _maybeFindUserProfile(
      session,
      authUserId,
      transaction: transaction,
    );

    if (userProfile == null) {
      throw UserProfileNotFoundException(authUserId);
    }

    return userProfile;
  }

  static Future<Uint8List> _encodeImage(final Image image) {
    return Isolate.run(
      () => switch (UserProfileConfig.current.userImageFormat) {
        UserProfileImageType.jpg => encodeJpg(
            image,
            quality: UserProfileConfig.current.userImageQuality,
          ),
        UserProfileImageType.png => encodePng(image),
      },
    );
  }
}

extension on Session {
  /// Runs the closure [f] in isolation, inside the parent [Transaction] (if any).
  ///
  /// Either creates a new transaction for [f],
  /// or creates a savepoint inside the given transaction,
  /// and would discard any modifications if [f] fails.
  Future<R> transactionOrSavepoint<R>(
    final TransactionFunction<R> f, {
    required Transaction? transaction,
  }) async {
    // Use the implicit transaction from tests
    // ignore: invalid_use_of_visible_for_testing_member
    transaction ??= this.transaction;

    if (transaction == null) {
      return db.transaction(f);
    }

    Savepoint? savepoint;
    try {
      savepoint = await transaction.createSavepoint();

      final result = await f(transaction);

      await savepoint.release();

      return result;
    } catch (_) {
      try {
        await savepoint?.rollback();
      } catch (e, stackTrace) {
        log(
          'Failed to roll back to savepoint.',
          exception: e,
          stackTrace: stackTrace,
        );
      }

      rethrow;
    }
  }
}
