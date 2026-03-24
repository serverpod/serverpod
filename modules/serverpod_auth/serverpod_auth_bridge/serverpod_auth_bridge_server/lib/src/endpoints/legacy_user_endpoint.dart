import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Proxy endpoint for legacy user profile operations (image, name changes).
class LegacyUserEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Removes the user's profile image.
  Future<bool> removeUserImage(final Session session) async {
    try {
      await AuthServices.instance.userProfiles.removeUserImage(
        session,
        session._authenticatedUserId,
      );
      return true;
    } catch (e, stackTrace) {
      session.log(
        'Failed to remove legacy user image.',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      return false;
    }
  }

  /// Sets the user's profile image from binary data.
  Future<bool> setUserImage(
    final Session session,
    final ByteData image,
  ) async {
    try {
      await AuthServices.instance.userProfiles.setUserImageFromBytes(
        session,
        session._authenticatedUserId,
        image.buffer.asUint8List(),
      );
      return true;
    } catch (e, stackTrace) {
      session.log(
        'Failed to set legacy user image.',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      return false;
    }
  }

  /// Changes the user's display name.
  Future<bool> changeUserName(
    final Session session,
    final String userName,
  ) async {
    try {
      await AuthServices.instance.userProfiles.changeUserName(
        session,
        session._authenticatedUserId,
        userName,
      );
      return true;
    } catch (e, stackTrace) {
      session.log(
        'Failed to change legacy user name.',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      return false;
    }
  }

  /// Changes the user's full name.
  Future<bool> changeFullName(
    final Session session,
    final String fullName,
  ) async {
    try {
      await AuthServices.instance.userProfiles.changeFullName(
        session,
        session._authenticatedUserId,
        fullName,
      );
      return true;
    } catch (e, stackTrace) {
      session.log(
        'Failed to change legacy full name.',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      return false;
    }
  }
}

extension on Session {
  UuidValue get _authenticatedUserId =>
      UuidValue.withValidation(authenticated!.userIdentifier);
}
