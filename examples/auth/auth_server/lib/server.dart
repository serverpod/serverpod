import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

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
  final serverSideSessionsConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: pod.getPassword(
      'serverSideSessionKeyHashPepper',
    )!,
  );

  final jwtTokenConfig = JwtConfig(
    refreshTokenHashPepper: pod.getPassword(
      'jwtRefreshTokenHashPepper',
    )!,
    algorithm: JwtAlgorithm.hmacSha512(
      SecretKey(pod.getPassword('jwtHmacSha512PrivateKey')!),
    ),
  );

  // Configure our identity providers.
  final googleIdpConfig = GoogleIdpConfig(
    clientSecret: GoogleClientSecret.fromJsonString(
      pod.getPassword('googleClientSecret')!,
    ),
  );

  final githubIdpConfig = GitHubIdpConfig(
    oauthCredentials: GitHubOAuthCredentials.fromJson({
      'clientId': pod.getPassword('githubClientId')!,
      'clientSecret': pod.getPassword('githubClientSecret')!,
    }),
  );

  final appleIdpConfig = AppleIdpConfig(
    serviceIdentifier: pod.getPassword('appleServiceIdentifier')!,
    bundleIdentifier: pod.getPassword('appleBundleIdentifier')!,
    redirectUri: pod.getPassword('appleRedirectUri')!,
    teamId: pod.getPassword('appleTeamId')!,
    keyId: pod.getPassword('appleKeyId')!,
    key: pod.getPassword('appleKey')!,
  );

  final emailIdpConfig = EmailIdpConfig(
    secretHashPepper: pod.getPassword('emailSecretHashPepper')!,
    sendRegistrationVerificationCode: _sendRegistrationCode,
    sendPasswordResetVerificationCode: _sendPasswordResetCode,
  );

  final githubIdpConfig = GitHubIdpConfig(
    oauthCredentials: GitHubOAuthCredentials.fromJson({
      'clientId': pod.getPassword('githubClientId')!,
      'clientSecret': pod.getPassword('githubClientSecret')!,
    }),
  );

  final passkeyIdpConfig = PasskeyIdpConfig(
    challengeLifetime: Duration(seconds: 30),
    hostname: 'localhost',
  );

  final anonymousIdpConfig = AnonymousIdpConfig();

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      serverSideSessionsConfig,
      jwtTokenConfig,
    ],
    identityProviderBuilders: [
      anonymousIdpConfig,
      googleIdpConfig,
      githubIdpConfig,
      appleIdpConfig,
      emailIdpConfig,
      githubIdpConfig,
      passkeyIdpConfig,
    ],
  );

  // Paths must match paths configured on Apple's developer portal. The values
  // below are the defaults if not provided.
  pod.configureAppleIdpRoutes(
    revokedNotificationRoutePath: '/hooks/apple-notification',
    webAuthenticationCallbackRoutePath: '/auth/callback',
  );

  // Start the server.
  await pod.start();
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIDP] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIDP] Password reset code ($email): $verificationCode');
}
