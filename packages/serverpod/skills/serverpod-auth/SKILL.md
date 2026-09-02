---
name: serverpod-auth
description: Serverpod authentication — signing in users, checking whether they are authenticated, assigning scopes (e.g. admin). Use when adding features that require the user to be signed in.
---

# Serverpod Authentication

Serverpod has authentication built in. Projects created with `serverpod create` have it enabled by default (unless `--no-auth`, or the project has no database), pre-configured with email and already wired up in `lib/server.dart` and in the Flutter app.

In server application code, import `package:serverpod_auth_idp_server/core.dart` and `package:serverpod_auth_idp_server/providers/<provider>.dart`. Do NOT import `package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart` — that library exists for the code generator.

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

## Relic HTML (document login)

SAS must be the **primary** token manager and `authCookie` must be set (with `allowedOrigins`). Call after `initializeAuthServices` and before `pod.start()`:

```yaml
authCookie:
  secure: false          # http://localhost only
  # sameSite: lax        # default; strict is rejected (OAuth return GET drops the state cookie)
allowedOrigins:
  - http://localhost:8082
```

```yaml
# config/passwords.yaml — dedicated HMAC key, do not reuse sessionKeyHashPepper
shared:
  webAuthOAuthStatePepper: 'a long random secret'
```

```dart
pod.configureWebAuthRoutes(loginSuccessPath: '/account');
pod.webServer.addMiddleware(
  requireLogin(redirectTo: '/auth/login'),
  '/account',
);
```

Do **not** mount `requireLogin` at `/` — it wraps `/auth/*` and health probes.

Login hub is `GET/POST /auth/login`. Providers that are registered on `AuthServices` also mount `/auth/google`, `/auth/github`, `/auth/microsoft`, `/auth/apple`. HTML Google callback is `/auth/google/callback` (not Flutter's `/auth/callback`). HTML Apple is `POST /auth/apple/web/callback` (HMAC'd `state` form field; Lax cookies are not sent on Apple `form_post`).

Same-site SAS cookie is how a website and Flutter cookie-mode can share a login. JWT Flutter clients will not pick up the Relic cookie.

Relic POSTs outside `/auth/*` are not form-CSRF'd; prefer GET pages plus Origin. Cookie-less homemade login POSTs are login-CSRF-able — use `configureWebAuthRoutes`.

If the API host ≠ the web host, set `authCookie.domain` and list **both** origins. Register both Flutter and HTML redirect URIs at each provider. Out of scope: email register/reset HTML, Facebook HTML, JWT-in-cookie.

## Flutter app

Use `SignInWidget` to sign the user in. It provides its own Material surface, so it also renders correctly when mixed with non-Material design systems:

```dart
SignInWidget(
  client: client,
  onAuthenticated: () => _showSnackBar(message: 'User authenticated.'),
  onError: (error) => _showSnackBar(message: 'Authentication failed: $error'),
)
```

- **Signed-in state**: `client.auth.isAuthenticated`. Rebuild on changes by listening to `client.auth.authInfoListenable` (a `ValueListenable<AuthSuccess?>`, so `ValueListenableBuilder` works too), and remove the listener in `dispose`.
- **Sign out**: `client.auth.signOutAllDevices()` or `client.auth.signOutDevice()`.
- **User profile (email, full name, etc)**: `await client.modules.serverpod_auth_core.userProfileInfo.get()`.

## More

- [`references/setup.md`](references/setup.md) — adding the auth packages to a project created without auth, initializing the services in `server.dart`, wiring the Flutter client, configuring social sign-ins, migrating off the legacy `serverpod_auth` module.
- [`references/user-management.md`](references/user-management.md) — attaching your own data to a user, editing scopes, letting the client edit its profile.
