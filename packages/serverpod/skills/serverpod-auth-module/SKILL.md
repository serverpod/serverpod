---
name: serverpod-auth-module
description: Add Serverpod authentication — serverpod_auth_idp packages, initializeAuthServices, identity providers (Email, Google, Apple, etc.), Flutter sign-in UI, migrations. Use when adding authentication or a new social sign-in to a Serverpod project.
---

# Serverpod Authentication Module

The **serverpod_auth** module (Serverpod 3) provides **token managers** (JWT, server-side sessions) and **identity providers** (Email, Google, Apple, GitHub, Facebook, Microsoft, Passkey, Firebase, Anonymous).

## 1. Dependencies

For new projects, the auth module is installed by default with the email identity provider (idp). Use the same pinned Serverpod version for all packages.

**Server** `pubspec.yaml`:

```yaml
dependencies:
  serverpod: 3.3.1
  serverpod_auth_idp_server: 3.3.1
```

**Client** `pubspec.yaml`:

```yaml
dependencies:
  serverpod_client: 3.3.1
  serverpod_auth_idp_client: 3.3.1
```

**Flutter** `pubspec.yaml`:

```yaml
dependencies:
  serverpod_flutter: 3.3.1
  serverpod_auth_idp_flutter: 3.3.1
  # Optional per provider:
  # serverpod_auth_idp_flutter_facebook: 3.3.1
  # serverpod_auth_idp_flutter_firebase: 3.3.1
```

Run `dart pub get` in each package, then `serverpod generate` from server directory or root.

## 2. Expose provider endpoints

Create an endpoint class per provider under server `lib/src/` (e.g. `lib/src/auth/email_idp_endpoint.dart`):

```dart
import 'package:serverpod_auth_idp_server/providers/email.dart';

class EmailIdpEndpoint extends EmailIdpBaseEndpoint {}
```

Other providers: extend `GoogleIdpBaseEndpoint`, `AppleIdpBaseEndpoint`, `GitHubIdpBaseEndpoint`, `FacebookIdpBaseEndpoint`, `MicrosoftIdpBaseEndpoint`, `PasskeyIdpBaseEndpoint`, `FirebaseIdpBaseEndpoint` (from `package:serverpod_auth_idp_server/providers/<name>.dart`). No extra logic needed unless overriding.

Run `serverpod generate`.

## 3. Initialize auth services

Call `pod.initializeAuthServices(...)` before `pod.start()`:

```dart
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

void run(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
    ],
  );

  await pod.start();
}

void _sendRegistrationCode(Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  session.log('[EmailIdp] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  session.log('[EmailIdp] Password reset code ($email): $verificationCode');
}
```

In production, replace logging with actual email sending and use explicit config classes:

```dart
final jwtConfig = JwtConfig(
  refreshTokenHashPepper: pod.getPassword('jwtRefreshTokenHashPepper')!,
  algorithm: JwtAlgorithm.hmacSha512(
    SecretKey(pod.getPassword('jwtHmacSha512PrivateKey')!)),
);

final emailConfig = EmailIdpConfig(
  secretHashPepper: pod.getPassword('emailSecretHashPepper')!,
  sendRegistrationVerificationCode: _sendRegistrationCode,
  sendPasswordResetVerificationCode: _sendPasswordResetCode,
);

pod.initializeAuthServices(
  tokenManagerBuilders: [jwtConfig],
  identityProviderBuilders: [emailConfig],
);
```

Keys for auth are kept in `config/passwords.yaml` and automatically managed if deploying to Serverpod Cloud.

### Token managers

- **JWT:** `JwtConfigFromPasswords()` or `JwtConfig(...)` — stateless
- **Server-side sessions:** `ServerSideSessionsConfig(sessionKeyHashPepper: ...)` — revocable
- Can use both simultaneously

### Apple Sign In

```dart
pod.configureAppleIdpRoutes(
  revokedNotificationRoutePath: '/hooks/apple-notification',
  webAuthenticationCallbackRoutePath: '/auth/callback',
);
```

## 4. Migrations

```bash
# Create models, database bindings, and generate code
serverpod generate
```

```bash
# Create migration
serverpod create-migration
```

```bash
# Apply migration and start server locally (done by user)
serverpod run start
```

## 5. Flutter client setup

```dart
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

client = Client(serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor()
  ..authSessionManager = FlutterAuthSessionManager();

client.auth.initialize();
```

## 6. Sign-in UI

```dart
SignInScreen(
  child: YourHomeScreen(
    onSignOut: () async {
      await client.auth.signOutDevice();
    },
  ),
)
```

Example `sign_in_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';

class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn
        ? widget.child
        : Center(
            child: SignInWidget(
              client: client,
              onAuthenticated: () {},
            ),
          );
  }
}
```

## Generator nickname (optional)

In `config/generator.yaml`: `modules: { serverpod_auth_idp: { nickname: auth } }`. Then reference types as `module:auth:AuthUser` in `.spy.yaml`.

## Legacy auth

Old packages (`serverpod_auth_server`, `serverpod_auth_client`, `serverpod_auth_shared_flutter`) are Serverpod 2-era. New projects should use `serverpod_auth_idp`. For migration from legacy, use `serverpod_auth_bridge` and `serverpod_auth_migration`.
