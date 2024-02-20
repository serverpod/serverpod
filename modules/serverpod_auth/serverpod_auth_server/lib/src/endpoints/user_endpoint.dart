// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

import '../business/user_images.dart';

/// Endpoint with methods for managing the currently signed in user.
class UserEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  Future<bool> removeUserImage(Session session) async {
    var userId = await session.auth.authenticatedUserId;
    return await UserImages.setDefaultUserImage(session, userId!);
  }

  /// Sets a new user image for the signed in user.
  Future<bool> setUserImage(Session session, ByteData image) async {
    var userId = await session.auth.authenticatedUserId;
    return await UserImages.setUserImageFromBytes(
        session, userId!, image.buffer.asUint8List());
  }

  /// Changes the name of a user.
  Future<bool> changeUserName(Session session, String userName) async {
    userName = userName.trim();
    if (userName == '') return false;

    var userId = await session.auth.authenticatedUserId;
    if (userId == null) return false;

    return (await Users.changeUserName(session, userId, userName)) != null;
  }
}
