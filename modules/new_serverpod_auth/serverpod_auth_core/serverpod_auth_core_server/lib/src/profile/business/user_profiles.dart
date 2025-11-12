import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../generated/protocol.dart';
import '../util/user_profile_extension.dart';
import 'exceptions.dart';
import 'user_profile_config.dart';

part 'user_profiles_admin.dart';

/// Business logic for handling user profiles
final class UserProfiles {
  /// Collection of admin-related functions.
  final UserProfilesAdmin admin = const UserProfilesAdmin._();

  /// The user profile configuration.
  final UserProfileConfig config;

  /// Creates a new [UserProfiles] instance.
  const UserProfiles({
    this.config = const UserProfileConfig(),
  });

  /// Creates a new user profile and stores it in the database.
  Future<UserProfileModel> createUserProfile(
    final Session session,
    final UuidValue authUserId,
    UserProfileData userProfile, {
    final Transaction? transaction,
    final UserImageSource? imageSource,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final onBeforeUserProfileCreated = config.onBeforeUserProfileCreated;
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

        final createdProfileModel = switch (imageSource) {
          null => createdProfile.toModel(),
          _ => await _setUserImage(
            session,
            authUserId,
            imageSource,
            transaction: transaction,
          ),
        };

        await config.onAfterUserProfileCreated?.call(
          session,
          createdProfileModel,
          transaction: transaction,
        );

        return createdProfileModel;
      },
    );
  }

  /// Find a user profile by the `AuthUser`'s ID.
  ///
  /// Throws a [UserProfileNotFoundException] in case no profile exists for the given [authUserId].
  Future<UserProfileModel> findUserProfileByUserId(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    final profile = await maybeFindUserProfileByUserId(
      session,
      authUserId,
      transaction: transaction,
    );

    if (profile == null) {
      throw UserProfileNotFoundException(authUserId);
    }

    return profile;
  }

  /// Looks for a user profile by the `AuthUser`'s ID.
  Future<UserProfileModel?> maybeFindUserProfileByUserId(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    final userProfile = await _maybeFindUserProfile(
      session,
      authUserId,
      transaction: transaction,
    );

    return userProfile?.toModel();
  }

  /// Updates a profiles's user name.
  Future<UserProfileModel> changeUserName(
    final Session session,
    final UuidValue authUserId,
    final String? newUserName, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
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
      },
    );
  }

  /// Updates a profile's full name.
  Future<UserProfileModel> changeFullName(
    final Session session,
    final UuidValue authUserId,
    final String? newFullName, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
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
      },
    );
  }

  /// Remove the user profile, incl. images, for the given [authUserId].
  ///
  /// In case the user did not have a profile, nothing is changed.
  ///
  /// Returns successfully if the profile data was removed from the database,
  /// even if some profile images could not be deleted from the file storage.
  ///
  /// In case the `transaction` is later rolled back, the deleted images will
  /// still be missing from the storage.
  Future<void> deleteProfileForUser(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
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

        // This also deletes the user profile image entries from the database
        await UserProfile.db.deleteWhere(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
          transaction: transaction,
        );

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
      },
    );
  }

  // #region Profile images

  Future<UserProfileImage> _createImageFromUrl(
    final Session session,
    final UuidValue authUserId,
    final Uri url, {
    required final Transaction transaction,
    required final UserProfile userProfile,
  }) async {
    final bytes = await config.imageFetchFunc(url);

    return _createImageFromBytes(
      session,
      authUserId,
      bytes,
      transaction: transaction,
      userProfile: userProfile,
    );
  }

  Future<UserProfileImage> _createImageFromBytes(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes, {
    required final Transaction transaction,
    required final UserProfile userProfile,
  }) async {
    final reEncodedImageBytes = await Isolate.run(() async {
      var image = decodeImage(imageBytes)!;

      final imageSize = config.userImageSize;
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
    if (config.userImageFormat == UserProfileImageType.jpg) {
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
  Future<UserProfileModel> setUserImageFromUrl(
    final Session session,
    final UuidValue authUserId,
    final Uri url, {
    final Transaction? transaction,
  }) async => _setUserImage(
    session,
    authUserId,
    UserImageFromUrl(url),
    transaction: transaction,
  );

  /// Sets a user's image from image data.
  ///
  /// The image is resized before being stored in the cloud and associated with the user.
  Future<UserProfileModel> setUserImageFromBytes(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes, {
    final Transaction? transaction,
  }) async => _setUserImage(
    session,
    authUserId,
    UserImageFromBytes(imageBytes),
    transaction: transaction,
  );

  /// Sets a user's image to the default image for that user.
  Future<UserProfileModel> setDefaultUserImage(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final userProfile = await findUserProfileByUserId(
          session,
          authUserId,
          transaction: transaction,
        );

        final image = await config.userImageGenerator(
          userProfile,
          config.userImageSize,
        );

        final imageBytes = await _encodeImage(image);

        return setUserImageFromBytes(
          session,
          authUserId,
          imageBytes,
          transaction: transaction,
        );
      },
    );
  }

  /// Removes a user's image, setting it to null.
  ///
  /// If the user had an existing image, it is deleted from storage.
  /// The user profile will have no image URL after this operation.
  Future<UserProfileModel> removeUserImage(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final userProfile = await _findUserProfile(
          session,
          authUserId,
          transaction: transaction,
        );

        // Store the old image for deletion
        final oldImage = userProfile.image;

        // Clear the image reference
        userProfile.imageId = null;
        userProfile.image = null;

        final updatedProfile = await _updateProfile(
          session,
          userProfile,
          transaction: transaction,
        );

        // Delete the old image from storage if it existed
        if (oldImage != null) {
          try {
            await session.storage.deleteFile(
              storageId: oldImage.storageId,
              path: oldImage.path,
            );
          } catch (e, stackTrace) {
            session.log(
              'Failed to delete user image from storage',
              level: LogLevel.error,
              exception: e,
              stackTrace: stackTrace,
            );
          }

          // Delete the image record from the database
          await UserProfileImage.db.deleteRow(
            session,
            oldImage,
            transaction: transaction,
          );
        }

        return updatedProfile.toModel();
      },
    );
  }

  Future<UserProfileModel> _setUserImage(
    final Session session,
    final UuidValue authUserId,
    final UserImageSource imageSource, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final userProfile = await _findUserProfile(
          session,
          authUserId,
          transaction: transaction,
        );

        final image = switch (imageSource) {
          UserImageFromUrl() => await _createImageFromUrl(
            session,
            authUserId,
            imageSource.url,
            transaction: transaction,
            userProfile: userProfile,
          ),
          UserImageFromBytes() => await _createImageFromBytes(
            session,
            authUserId,
            imageSource.bytes,
            transaction: transaction,
            userProfile: userProfile,
          ),
        };

        userProfile.imageId = image.id!;
        userProfile.image = image;

        final updatedProfile = await _updateProfile(
          session,
          userProfile,
          transaction: transaction,
        );

        return updatedProfile.toModel();
      },
    );
  }

  // #endregion

  Future<UserProfile> _updateProfile(
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

    final modifiedProfile = await config.onBeforeUserProfileUpdated?.call(
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

    await config.onAfterUserProfileUpdated?.call(
      session,
      userProfile.toModel(),
      transaction: transaction,
    );

    return userProfile;
  }

  Future<UserProfile?> _maybeFindUserProfile(
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

  Future<UserProfile> _findUserProfile(
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

  Future<Uint8List> _encodeImage(final Image image) {
    return Isolate.run(
      () => switch (config.userImageFormat) {
        UserProfileImageType.jpg => encodeJpg(
          image,
          quality: config.userImageQuality,
        ),
        UserProfileImageType.png => encodePng(image),
      },
    );
  }
}

/// Source of a user image.
///
/// Can either be a [UserImageFromUrl] or [UserImageFromBytes].
sealed class UserImageSource {}

/// User image source from a URL.
final class UserImageFromUrl extends UserImageSource {
  /// The URL to fetch the image from.
  final Uri url;

  /// Creates a new [UserImageFromUrl] instance.
  UserImageFromUrl(this.url);

  /// Creates a new [UserImageFromUrl] instance by parsing the given [url] string.
  factory UserImageFromUrl.parse(final String url) {
    return UserImageFromUrl(Uri.parse(url));
  }
}

/// User image source from raw bytes.
final class UserImageFromBytes extends UserImageSource {
  /// The image bytes.
  final Uint8List bytes;

  /// Creates a new [UserImageFromBytes] instance.
  UserImageFromBytes(this.bytes);
}
