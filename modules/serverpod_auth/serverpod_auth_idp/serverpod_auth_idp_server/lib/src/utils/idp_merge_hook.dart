import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

/// A default merge hook that attempts to migrate accounts for all known IDPs.
///
/// This hook calls the `migrate` method for:
/// - [AppleIdp]
/// - [FirebaseIdp]
/// - [GitHubIdp]
/// - [EmailIdp]
/// - [GoogleIdp]
///
/// Use this in your [UserMergeConfig] if you want to automatically migrate
/// data for these providers when merging users.
Future<void> defaultIdpMergeHook(
  final Session session, {
  required final UuidValue userToKeepId,
  required final UuidValue userToRemoveId,
  required final Transaction transaction,
}) async {
  await AppleIdp.migrate(
    session,
    userToKeepId: userToKeepId,
    userToRemoveId: userToRemoveId,
    transaction: transaction,
  );
  await FirebaseIdp.migrate(
    session,
    userToKeepId: userToKeepId,
    userToRemoveId: userToRemoveId,
    transaction: transaction,
  );
  await GitHubIdp.migrate(
    session,
    userToKeepId: userToKeepId,
    userToRemoveId: userToRemoveId,
    transaction: transaction,
  );
  await EmailIdp.migrate(
    session,
    userToKeepId: userToKeepId,
    userToRemoveId: userToRemoveId,
    transaction: transaction,
  );
  await GoogleIdp.migrate(
    session,
    userToKeepId: userToKeepId,
    userToRemoveId: userToRemoveId,
    transaction: transaction,
  );
}
