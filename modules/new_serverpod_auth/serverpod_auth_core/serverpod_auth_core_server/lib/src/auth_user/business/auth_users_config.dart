import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Configuration options for the auth users module.
class AuthUsersConfig {
  /// Creates a new [AuthUsersConfig] instance.
  const AuthUsersConfig({
    this.onBeforeAuthUserCreated,
    this.onAfterAuthUserCreated,
    this.onUserMerged,
  });

  /// Called when an auth user is about to be created.
  final BeforeAuthUserCreatedHandler? onBeforeAuthUserCreated;

  /// Called when an auth user has been created.
  final AfterAuthUserCreatedHandler? onAfterAuthUserCreated;

  /// Called when two auth users are merged.
  final UserMergedHandler? onUserMerged;
}

/// Data to be created for an auth user.
typedef AuthUserToCreate = ({Set<Scope> scopes, bool blocked});

/// Callback to be invoked with the new auth user data before it gets created.
typedef BeforeAuthUserCreatedHandler =
    FutureOr<AuthUserToCreate> Function(
      Session session,
      Set<Scope> scopes,
      bool blocked, {
      required Transaction transaction,
    });

/// Callback to be invoked with the new auth user data after it has been created.
typedef AfterAuthUserCreatedHandler =
    FutureOr<void> Function(
      Session session,
      AuthUserModel authUser, {
      required Transaction transaction,
    });

/// Callback to be invoked when two auth users are merged.
typedef UserMergedHandler =
    FutureOr<void> Function(
      Session session,
      UuidValue sourceUserId,
      UuidValue targetUserId, {
      required Transaction transaction,
    });
