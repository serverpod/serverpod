// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AppleEndpoint extends Endpoint {
  Future<AuthenticationResponse> authenticate(Session session, ) async {
    return AuthenticationResponse(success: false);
  }
}