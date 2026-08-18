---
name: serverpod-auth
description: Serverpod authentication — signing in users, checking whether they are authenticated, assigning scopes (e.g. admin). Use when adding features that require the user to be signed in.
---

# Serverpod Authentication

Serverpod has authentication built in. Projects created with `serverpod create` have it enabled by default (unless `--no-auth`, or the project has no database), pre-configured with email. Most social sign-ins are supported (Apple, Google, GitHub, Facebook, Microsoft, etc) but need configuration.

## Packages

Projects created without auth need these dependencies added, pinned to the Serverpod version: `serverpod_auth_idp_server` (server), `serverpod_auth_idp_client` (client), `serverpod_auth_idp_flutter` (Flutter app). Then `dart pub get`, generate, and run the migration workflow — the module adds tables. See [Serverpod Modules](../serverpod-modules/SKILL.md).

In server application code, import `package:serverpod_auth_idp_server/core.dart` and `package:serverpod_auth_idp_server/providers/<provider>.dart`. Do NOT import `package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart` — that library exists for the code generator.

Projects still on the legacy `serverpod_auth` module (the one with `UserInfo`) migrate through the experimental `serverpod_auth_bridge` module, which converts legacy sessions and imports legacy passwords. Do not mix the two modules in new code.

## Server setup

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

## Flutter app

The client must be created with a `FlutterAuthSessionManager`, otherwise `client.auth` throws a `StateError`. Call `initialize()` once at startup to restore a previously signed-in user:

```dart
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

client = Client(serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor()
  ..authSessionManager = FlutterAuthSessionManager();

client.auth.initialize();
```

Then use `SignInWidget`. It provides its own Material surface, so it also renders
correctly when mixed with non-Material design systems. Simplified example:

```dart
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

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
              onAuthenticated: () {
                _showSnackBar(message: 'User authenticated.');
              },
              onError: (error) {
                _showSnackBar(message: 'Authentication failed: $error');
              },
            ),
          );
  }
}
```

**Check signed-in state**: `_isSignedIn = client.auth.isAuthenticated;`
**Sign out**: `client.auth.signOutAllDevices()` or `client.auth.signOutDevice()`
**Get user profile (email, full name, etc)**: `final userProfile = await client.modules.serverpod_auth_core.userProfileInfo.get()`

## Server-side

### Require the user to be signed in or have a specific scope

```dart
class MyEndpoint extends Endpoint {
  // Require the user to be signed in to access methods in this endpoint.
  @override
  bool get requireLogin => true;

  // Require the user to have the admin scope.
  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  // This method can only be accessed if the user is admin.
  Future<void> myMethod(Session session) async {
    ...
  }
  ...
}
```

### User id and info

```dart
import 'package:serverpod_auth_idp_server/core.dart';

// Get authenticated user's ID.
final userIdUuidValue = session.authenticated?.authUserId;

// Get the user profile (full name, email, etc)
var userProfile = await session.authenticated?.userProfile(session);

// Find a user profile by email.
final profiles = await AuthServices.instance.userProfiles.admin
    .listUserProfiles(
      session,
      email: email.toLowerCase(),
      limit: 1,
    );
final userProfile = profiles.firstOrNull;

// Get authentication info for user id (for editing scopes, etc).
final authUsers = AuthServices.instance.authUsers;
final authUser = await authUsers.get(
  session,
  authUserId: userProfile.authUserId,
);
```

### Attaching additional info to a user

Create a model:

```yaml
class: MyDomainData
table: my_domain_data
fields:
  ### The [AuthUser] this profile belongs to
  authUser: module:serverpod_auth_core:AuthUser?, relation(onDelete=Cascade)
  additionalInfo: String

indexes:
  auth_user_id_unique_idx:
    fields: authUserId
    unique: true
```

Find the info:

```dart
final authUserId = session.authenticated?.authUserId;
final additionalInfo = await MyDomainData.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(authUserId!),
);
```

### Managing scopes

```dart
import 'package:serverpod_auth_idp_server/core.dart';

// Update a user's scope.
await AuthServices.instance.authUsers.update(
  session,
  authUserId: authUserId,
  scopes: {Scope.admin},
);

// Use custom scope.
class CustomScope extends Scope {
  const CustomScope(String name) : super(name);

  static const userRead = CustomScope('userRead');
  static const userWrite = CustomScope('userWrite');
}
```

### Enable editing user profile (from the client)

```dart
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

class UserProfileEditEndpoint extends UserProfileEditBaseEndpoint {}
```

### Social sign-ins

Requires set up by the user to configure (e.g., GCP console or Apple developer portal). Use official docs as reference. Supported:

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
