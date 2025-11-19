import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_new_auth_test_server/src/web/routes/root.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(final List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  const universalHashPepper = 'test-pepper';
  final authConfig = AuthServices.set(
    primaryTokenManager: AuthSessionsTokenManagerFactory(
      AuthSessionsConfig(sessionKeyHashPepper: universalHashPepper),
    ),
    identityProviders: [
      EmailIdentityProviderFactory(
        EmailIDPConfig(
          secretHashPepper: pod.getPassword(
            'serverpod_auth_idp_email_secretHashPepper',
          )!,
        ),
      ),
    ],
    additionalTokenManagers: [
      AuthenticationTokensTokenManagerFactory(
        AuthenticationTokenConfig(
          refreshTokenHashPepper: universalHashPepper,
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
        ),
      ),
    ],
  );

  pod.authenticationHandler = authConfig.authenticationHandler;

  // Setup a default page at the web root.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // Serve all files in the web/static relative directory under /.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root), '/**');

  // Start the server.
  await pod.start();
}
