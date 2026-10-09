# Setting up authentication

One-time work. Projects created with `serverpod create` already have all of this done, pre-configured with email.

## Adding the packages

Projects created without auth need these dependencies added, pinned to the Serverpod version: `serverpod_auth_idp_server` (server), `serverpod_auth_idp_client` (client), `serverpod_auth_idp_flutter` (Flutter app). Then `dart pub get`, generate, and run the migration workflow — the module adds tables. See [Serverpod Modules](../../serverpod-modules/SKILL.md).

## Initializing the services

Authentication services are initialized in `server.dart`, before `pod.start()`:

```dart
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

pod.initializeAuthServices(
  tokenManagerBuilders: [
    // Issues and validates the authentication keys. Reads its secrets from
    // `config/passwords.yaml` (jwtHmacSha512PrivateKey, jwtRefreshTokenHashPepper).
    JwtConfigFromPasswords(),
  ],
  identityProviderBuilders: [
    // Email/password. Verification codes are logged to the console in
    // development and sent through Serverpod Cloud in staging/production.
    // Use `EmailIdpConfigFromPasswords` for a custom email provider.
    ServerpodCloudEmailIdpConfig(appDisplayName: 'My project'),
  ],
);
```

## Wiring the Flutter client

The client must be created with a `FlutterAuthSessionManager`, otherwise
`client.auth` throws a `StateError`. Call `initialize()` once at startup to
restore a previously signed-in user:

```dart
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

client = Client(serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor()
  ..authSessionManager = FlutterAuthSessionManager();

client.auth.initialize();
```

## Passwordless email

To let users sign in with a code sent by email instead of a password, add `ServerpodCloudEmailPasswordlessIdpConfig(appDisplayName: ...)` (or `EmailPasswordlessIdpConfigFromPasswords` for a custom email provider) from `package:serverpod_auth_idp_server/providers/email_passwordless.dart` to `identityProviderBuilders`, and expose an endpoint extending `EmailPasswordlessIdpBaseEndpoint`. It adds a table, so run the migration workflow. Accounts are created on the first successful sign-in unless `allowSignUp` is `false`. When the server exposes both the email/password and the passwordless endpoints, the Flutter `SignInWidget` shows only the email/password one unless `disableEmailSignInWidget` is set.

## Social sign-ins

Each provider needs the user to configure it outside the project (e.g. the GCP console or the Apple developer portal). Follow the official setup guide:

- [Anonymous](https://docs.serverpod.dev/concepts/authentication/providers/anonymous/setup)
- [Email (pre-configured)](https://docs.serverpod.dev/concepts/authentication/providers/email/setup)
- [Google](https://docs.serverpod.dev/concepts/authentication/providers/google/setup)
- [Apple](https://docs.serverpod.dev/concepts/authentication/providers/apple/setup)
- [Facebook](https://docs.serverpod.dev/concepts/authentication/providers/facebook/setup)
- [Firebase](https://docs.serverpod.dev/concepts/authentication/providers/firebase/setup)
- [GitHub](https://docs.serverpod.dev/concepts/authentication/providers/github/setup)
- [Microsoft](https://docs.serverpod.dev/concepts/authentication/providers/microsoft/setup)
- [Passkey](https://docs.serverpod.dev/concepts/authentication/providers/passkey/setup)
- [Custom (write your own)](https://docs.serverpod.dev/concepts/authentication/providers/custom-providers/overview)

## Legacy module

Projects still on the legacy `serverpod_auth` module (the one with `UserInfo`) can migrate through the `serverpod_auth_bridge` module, which converts legacy sessions and imports legacy passwords. Do not mix the two modules in new code.
