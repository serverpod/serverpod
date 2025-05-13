import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// User profile management endpoint.
abstract class UserProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the user profile of the current user.
  Future<UserProfileModel> get(final Session session) async {
    final authUserId = (await session.authenticated)!.userUuid;

    final profile = await UserProfiles.findUserProfileByUserId(
      session,
      authUserId,
    );

    return profile;
  }

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  Future<UserProfileModel> removeUserImage(final Session session) async {
    final userId = (await session.authenticated)!.userUuid;

    return UserProfiles.setDefaultUserImage(session, userId);
  }

  /// Sets a new user image for the signed in user.
  Future<UserProfileModel> setUserImage(
    final Session session,
    final ByteData image,
  ) async {
    final userId = (await session.authenticated)!.userUuid;

    return UserProfiles.setUserImageFromBytes(
      session,
      userId,
      image.buffer.asUint8List(),
    );
  }

  /// Changes the name of a user.
  Future<UserProfileModel> changeUserName(
    final Session session,
    final String? userName,
  ) async {
    final userId = (await session.authenticated)!.userUuid;

    return UserProfiles.changeUserName(session, userId, userName);
  }

  /// Changes the full name of a user.
  Future<UserProfileModel> changeFullName(
    final Session session,
    final String? fullName,
  ) async {
    final userId = (await session.authenticated)!.userUuid;

    return UserProfiles.changeFullName(session, userId, fullName);
  }
}
