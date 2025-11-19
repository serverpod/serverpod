import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
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

  // Configure our token managers.
  final authSessionsConfig = AuthSessionsConfig(
    sessionKeyHashPepper: pod.getPassword('authSessionsSessionKeyHashPepper')!,
  );

  final authenticationTokenConfig = AuthenticationTokenConfig(
    refreshTokenHashPepper: pod.getPassword(
      'authenticationTokenRefreshTokenHashPepper',
    )!,
    algorithm: AuthenticationTokenAlgorithm.hmacSha512(
      SecretKey(pod.getPassword('authenticationTokenPrivateKey')!),
    ),
  );

  // Configure our identity providers.
  final googleIDPConfig = GoogleIDPConfig(
    clientSecret: GoogleClientSecret.fromJsonString(
      pod.getPassword('googleClientSecret')!,
    ),
  );

  final appleIDPConfig = AppleIDPConfig(
    serviceIdentifier: pod.getPassword('appleServiceIdentifier')!,
    bundleIdentifier: pod.getPassword('appleBundleIdentifier')!,
    redirectUri: pod.getPassword('appleRedirectUri')!,
    teamId: pod.getPassword('appleTeamId')!,
    keyId: pod.getPassword('appleKeyId')!,
    key: pod.getPassword('appleKey')!,
  );

  final emailIDPConfig = EmailIDPConfig(
    secretHashPepper: pod.getPassword('emailSecretHashPepper')!,
    sendRegistrationVerificationCode:
        (
          session, {
          required accountRequestId,
          required email,
          required verificationCode,
          required transaction,
        }) {
          // NOTE: Here you call your mail service to send the verification code to
          // the user. For testing, we will just log the verification code.
          session.log(
            '[EmailIDP] Registration code ($email): $verificationCode',
          );
        },
    sendPasswordResetVerificationCode:
        (
          session, {
          required email,
          required passwordResetRequestId,
          required verificationCode,
          required transaction,
        }) {
          // NOTE: Here you call your mail service to send the verification code to
          // the user. For testing, we will just log the verification code.
          session.log(
            '[EmailIDP] Password reset code ($email): $verificationCode',
          );
        },
  );

  final passkeyIDPConfig = PasskeyIDPConfig(
    challengeLifetime: Duration(seconds: 30),
    hostname: 'localhost',
  );

  final authServices = AuthServices.set(
    primaryTokenManager: AuthSessionsTokenManagerFactory(authSessionsConfig),
    identityProviders: [
      GoogleIdentityProviderFactory(googleIDPConfig),
      AppleIdentityProviderFactory(appleIDPConfig),
      EmailIdentityProviderFactory(emailIDPConfig),
      PasskeyIdentityProviderFactory(passkeyIDPConfig),
    ],
    additionalTokenManagers: [
      AuthenticationTokensTokenManagerFactory(
        authenticationTokenConfig,
      ),
    ],
  );

  pod.authenticationHandler = authServices.authenticationHandler;

  pod.webServer
    ..addRoute(
      AuthServices.instance.appleIDP.revokedNotificationRoute(),
      '/hooks/apple-notification', // must match path configured on apple
    )
    ..addRoute(
      AuthServices.instance.appleIDP.webAuthenticationCallbackRoute(),
      '/auth/callback', // must match path configured on apple
    );

  // Start the server.
  await pod.start();
}
