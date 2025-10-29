import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

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
  );

  final authConfig = AuthConfig.set(
    primaryTokenManager: AuthSessionsTokenManager(
      config: AuthSessionConfig(
        sessionKeyHashPepper: 'test-pepper',
      ),
    ),
    identityProviders: [],
  );

  pod.authenticationHandler = authConfig.authenticationHandler;

  AuthServices.initialize(
    googleIDPConfig: GoogleIDPConfig(
      clientSecret: GoogleClientSecret.fromJsonString(
        pod.getPassword('googleClientSecret')!,
      ),
    ),
    appleIDPConfig: AppleIDPConfig(
      serviceIdentifier: pod.getPassword('appleServiceIdentifier')!,
      bundleIdentifier: pod.getPassword('appleBundleIdentifier')!,
      redirectUri: pod.getPassword('appleRedirectUri')!,
      teamId: pod.getPassword('appleTeamId')!,
      keyId: pod.getPassword('appleKeyId')!,
      key: pod.getPassword('appleKey')!,
    ),
    emailIDPConfig: EmailIDPConfig(
      passwordHashPepper: pod.getPassword('emailPasswordHashPepper')!,
    ),
    tokenManager: authConfig.tokenManager,
  );

  pod.webServer.addRoute(
    AuthServices.instance.appleIDP.revokedNotificationRoute(),
    '/hooks/apple-notification',
  );

  // Start the server.
  await pod.start();
}
