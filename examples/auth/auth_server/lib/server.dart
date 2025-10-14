import 'package:serverpod/serverpod.dart';

import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: AuthSessions.authenticationHandler,
  );

  AuthServices.initialize(
    googleIDPConfig: GoogleIDPConfig(
      clientSecret: GoogleClientSecret.fromJsonString(
        pod.getPassword('googleClientSecret')!,
      ),
    ),
  );

  // Start the server.
  await pod.start();
}
