import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_test_server/src/web/routes/root.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

Future<Serverpod> run(
  final List<String> args, {
  final Directory? serverDirectory,
  final ServerpodConfig Function(ServerpodConfig)? configOverride,
}) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    serverDirectory: serverDirectory,
    configOverride: configOverride,
  );

  const universalHashPepper = 'test-pepper';

  AuthServices.set(
    tokenManagerBuilders: [
      ServerSideSessionsConfig(
        sessionKeyHashPepper: universalHashPepper,
      ),
      JwtConfig(
        refreshTokenHashPepper: universalHashPepper,
        algorithm: JwtAlgorithm.hmacSha512(
          SecretKey('test-private-key-for-HS512'),
        ),
      ),
    ],
    identityProviderBuilders: [
      EmailIdpConfig(
        secretHashPepper: pod.getPassword(
          'serverpod_auth_idp_email_secretHashPepper',
        )!,
      ),
    ],
  );

  pod.authenticationHandler = AuthServices.instance.authenticationHandler;

  // Setup a default page at the web root.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // Serve all files in the web/static relative directory under /.
  final root = Directory.fromUri(pod.serverDirectory.uri.resolve('web/static'));
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Start the server.
  await pod.start();
  return pod;
}
