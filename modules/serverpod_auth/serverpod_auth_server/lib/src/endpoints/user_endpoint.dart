// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../business/user_images.dart';
import '../generated/protocol.dart';
import '../business/users.dart';

class UserEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<bool> removeUserImage(Session session) async {
    var userId = await session.auth.authenticatedUserId;
    return await UserImages.setDefaultUserImage(session, userId!);
  }

  Future<bool> setUserImage(Session session, ByteData image) async {
    var userId = await session.auth.authenticatedUserId;
    return await UserImages.setUserImageFromBytes(session, userId!, image.buffer.asUint8List());
  }
}