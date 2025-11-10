import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';

/// Endpoint for read-only access to user profile information.
class UserProfileInfoEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the user profile of the current user.
  Future<UserProfileModel> get(final Session session) async {
    final authUserId = session.authenticated!.authUserId;

    final profile = await UserProfiles.findUserProfileByUserId(
      session,
      authUserId,
    );

    return profile;
  }
}

/// Base endpoint for user profile management.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class on your server.
abstract class UserProfileEditBaseEndpoint extends UserProfileInfoEndpoint {
  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  Future<UserProfileModel> removeUserImage(final Session session) async {
    final userId = session.authenticated!.authUserId;

    return UserProfiles.setDefaultUserImage(session, userId);
  }

  /// Sets a new user image for the signed in user.
  Future<UserProfileModel> setUserImage(
    final Session session,
    final ByteData image,
  ) async {
    final userId = session.authenticated!.authUserId;

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
    final userId = session.authenticated!.authUserId;

    return UserProfiles.changeUserName(session, userId, userName);
  }

  /// Changes the full name of a user.
  Future<UserProfileModel> changeFullName(
    final Session session,
    final String? fullName,
  ) async {
    final userId = session.authenticated!.authUserId;

    return UserProfiles.changeFullName(session, userId, fullName);
  }
}
