import 'dart:typed_data';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_profile_server/src/generated/protocol.dart';
import 'package:serverpod_auth_profile_server/src/util/user_profile_extension.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// User profile management endpoint.
abstract class UserProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the user profile of the current user.
  Future<UserProfileModel> get(final Session session) async {
    final authUserId = (await session.authenticated)!.userUuid;

    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      include: UserProfile.include(image: UserProfileImage.include()),
    );

    return profile.toModel(authUserId);
  }

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  Future<void> removeUserImage(final Session session) async {
    if (!UserProfileConfig.current.userCanEditUserImage) {
      throw AccessDeniedException(message: 'User image change is disabled.');
    }

    final userId = (await session.authenticated)!.userUuid;

    await UserProfileImages.setDefaultUserImage(session, userId);
  }

  /// Sets a new user image for the signed in user.
  Future<void> setUserImage(final Session session, final ByteData image) async {
    if (!UserProfileConfig.current.userCanEditUserImage) {
      throw AccessDeniedException(message: 'User image change is disabled.');
    }

    final userId = (await session.authenticated)!.userUuid;

    await UserProfileImages.setUserImageFromBytes(
      session,
      userId,
      image.buffer.asUint8List(),
    );
  }

  /// Changes the name of a user.
  Future<void> changeUserName(
    final Session session,
    final String userName,
  ) async {
    if (!UserProfileConfig.current.userCanEditUserName) {
      throw AccessDeniedException(message: 'Username change is disabled.');
    }

    final trimmedUserName = userName.trim();
    if (trimmedUserName == '') {
      throw ArgumentError.value(
        userName,
        'userName',
        'User name must not be an empty or whitespace-only string.',
      );
    }

    final userId = (await session.authenticated)!.userUuid;

    await UserProfiles.changeUserName(session, userId, trimmedUserName);
  }

  /// Changes the full name of a user.
  Future<void> changeFullName(
    final Session session,
    final String fullName,
  ) async {
    if (!UserProfileConfig.current.userCanEditFullName) {
      throw AccessDeniedException(
        message: 'Fullname change is disabled.',
      );
    }

    final trimmedFullName = fullName.trim();
    if (trimmedFullName == '') {
      throw ArgumentError.value(
        fullName,
        'fullName',
        'Full name must not be an empty or whitespace-only string.',
      );
    }

    final userId = (await session.authenticated)!.userUuid;

    await UserProfiles.changeFullName(session, userId, trimmedFullName);
  }
}
