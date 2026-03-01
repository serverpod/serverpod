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
      final uuid = UuidValue.fromString(session.authenticated!.userIdentifier);
      await AuthServices.instance.userProfiles.removeUserImage(session, uuid);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Sets the user's profile image from binary data.
  Future<bool> setUserImage(
    final Session session,
    final ByteData image,
  ) async {
    try {
      final uuid = UuidValue.fromString(session.authenticated!.userIdentifier);
      await AuthServices.instance.userProfiles.setUserImageFromBytes(
        session,
        uuid,
        image.buffer.asUint8List(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Changes the user's display name.
  Future<bool> changeUserName(
    final Session session,
    final String userName,
  ) async {
    try {
      final uuid = UuidValue.fromString(session.authenticated!.userIdentifier);
      await AuthServices.instance.userProfiles.changeUserName(
        session,
        uuid,
        userName,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Changes the user's full name.
  Future<bool> changeFullName(
    final Session session,
    final String fullName,
  ) async {
    try {
      final uuid = UuidValue.fromString(session.authenticated!.userIdentifier);
      await AuthServices.instance.userProfiles.changeFullName(
        session,
        uuid,
        fullName,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
