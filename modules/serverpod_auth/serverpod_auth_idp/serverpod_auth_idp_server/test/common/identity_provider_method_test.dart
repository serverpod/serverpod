import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/facebook.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/providers/microsoft.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:test/test.dart';

void main() {
  const AuthUsers authUsers = AuthUsers();

  group('Given the bundled identity providers,', () {
    late AnonymousIdp anonymousIdp;
    late AppleIdp appleIdp;
    late EmailIdp emailIdp;
    late FacebookIdp facebookIdp;
    late FirebaseIdp firebaseIdp;
    late GitHubIdp githubIdp;
    late GoogleIdp googleIdp;
    late MicrosoftIdp microsoftIdp;
    late PasskeyIdp passkeyIdp;

    setUp(() {
      final tokenManager = ServerSideSessionsTokenManager(
        config: ServerSideSessionsConfig(
          sessionKeyHashPepper: 'test-session-key-hash-pepper',
        ),
        authUsers: authUsers,
      );

      anonymousIdp = AnonymousIdp(
        const AnonymousIdpConfig(),
        tokenManager: tokenManager,
        authUsers: authUsers,
      );

      appleIdp = AppleIdp(
        const AppleIdpConfig(
          serviceIdentifier: 'test-service-identifier',
          bundleIdentifier: 'test-bundle-identifier',
          redirectUri: 'https://example.com/callback',
          teamId: 'test-team-id',
          keyId: 'test-key-id',
          key: 'test-key',
        ),
        tokenManager: tokenManager,
        authUsers: authUsers,
      );

      emailIdp = EmailIdp(
        const EmailIdpConfig(secretHashPepper: 'test-secret-hash-pepper'),
        tokenManager: tokenManager,
        authUsers: authUsers,
      );

      facebookIdp = FacebookIdp(
        const FacebookIdpConfig(
          appId: 'test-app-id',
          appSecret: 'test-app-secret',
        ),
        tokenManager: tokenManager,
        authUsers: authUsers,
      );

      firebaseIdp = FirebaseIdp(
        const FirebaseIdpConfig(
          credentials: FirebaseServiceAccountCredentials(
            projectId: 'test-project-id',
          ),
        ),
        tokenIssuer: tokenManager,
        authUsers: authUsers,
      );

      githubIdp = GitHubIdp(
        GitHubIdpConfig(
          clientId: 'test-client-id',
          clientSecret: 'test-client-secret',
        ),
        tokenIssuer: tokenManager,
        authUsers: authUsers,
      );

      googleIdp = GoogleIdp(
        GoogleIdpConfig(
          clientSecret: GoogleClientSecret.fromJson({
            'web': {
              'client_id': 'test-client-id',
              'client_secret': 'test-client-secret',
              'redirect_uris': <String>[],
            },
          }),
        ),
        tokenIssuer: tokenManager,
        authUsers: authUsers,
      );

      microsoftIdp = MicrosoftIdp(
        MicrosoftIdpConfig(
          clientId: 'test-client-id',
          clientSecret: 'test-client-secret',
          fetchProfilePhoto: false,
        ),
        tokenIssuer: tokenManager,
        authUsers: authUsers,
      );

      passkeyIdp = PasskeyIdp(
        const PasskeyIdpConfig(hostname: 'localhost'),
        tokenManager: tokenManager,
        authUsers: authUsers,
      );
    });

    test(
      'when reading their authentication methods, '
      'then each provider returns its stable method identifier.',
      () {
        expect(
          {
            AnonymousIdp: anonymousIdp.method,
            AppleIdp: appleIdp.method,
            EmailIdp: emailIdp.method,
            FacebookIdp: facebookIdp.method,
            FirebaseIdp: firebaseIdp.method,
            GitHubIdp: githubIdp.method,
            GoogleIdp: googleIdp.method,
            MicrosoftIdp: microsoftIdp.method,
            PasskeyIdp: passkeyIdp.method,
          },
          {
            AnonymousIdp: 'anonymous',
            AppleIdp: 'apple',
            EmailIdp: 'email',
            FacebookIdp: 'facebook',
            FirebaseIdp: 'firebase',
            GitHubIdp: 'github',
            GoogleIdp: 'google',
            MicrosoftIdp: 'microsoft',
            PasskeyIdp: 'passkey',
          },
        );
      },
    );
  });
}
