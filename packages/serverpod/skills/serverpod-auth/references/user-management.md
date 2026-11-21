# User management

Reference for the [Serverpod Authentication](../SKILL.md) skill.

## Attaching additional info to a user

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

## Managing scopes

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

## Enable editing user profile (from the client)

```dart
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

class UserProfileEditEndpoint extends UserProfileEditBaseEndpoint {}
```

## Linking accounts and merging user data

Signed-in users (including anonymous/guest users) can link additional sign-in methods to their account. If the new sign-in method is brand new, it is linked directly to the current `AuthUser`. If it already belongs to another `AuthUser`, the user can be prompted to merge the two accounts.

### Server: `AccountMergeConfig`

Configure `accountMergeConfig` in `pod.initializeAuthServices(...)` to move or merge application-specific rows from `userToRemoveId` to `userToKeepId` inside the merge transaction:

```dart
pod.initializeAuthServices(
  tokenManagerBuilders: [/* ... */],
  identityProviderBuilders: [/* ... */],
  accountMergeConfig: AccountMergeConfig(
    applicationMergeHandler: (
      Session session, {
      required UuidValue userToKeepId,
      required UuidValue userToRemoveId,
      required Transaction transaction,
    }) async {
      await MyDomainData.db.updateWhere(
        session,
        where: (t) => t.authUserId.equals(userToRemoveId),
        columnValues: (t) => [t.authUserId(userToKeepId)],
        transaction: transaction,
      );
    },
  ),
);
```

- Core auth data (`AuthUser` scopes/blocked state, `RefreshToken`, `ServerSideSession`, `UserProfile`, and built-in IDP records) is merged automatically.
- Linking a brand-new credential does **not** require `applicationMergeHandler`, whereas merging two pre-existing accounts rejects the merge unless `applicationMergeHandler` (or `AccountMergeConfig.custom`) is configured.

### Flutter: `AccountLinkingController`

Pass an `AccountLinkingController` to `SignInWidget` (or an individual provider widget such as `EmailSignInWidget`, `EmailOtpSignInWidget`, or `GoogleSignInWidget`) while the user is signed in:

```dart
final linkingController = AccountLinkingController(
  client: client,
  confirmMerge: (AccountLinkConflict conflict) async {
    // Show a confirmation dialog using `conflict.profile` and `conflict.createdAt`.
    return await showCombineAccountsDialog(context, conflict) ?? false;
  },
  onLinked: () {
    // Close the linking UI and refresh `client.auth.idp.getConnectedIdps()`.
  },
  onCancelled: () => Navigator.of(context).pop(),
  onError: (Object error) => showError(error),
);

SignInWidget(
  client: client,
  accountLinking: linkingController,
)
```

To inspect which providers are currently linked to the signed-in account, call `await client.auth.idp.getConnectedIdps()`.
