import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'firebase_idp_utils.dart';

/// Admin operations for the Firebase identity provider.
///
/// These methods are intended for administrative use to manage Firebase-backed
/// accounts.
class FirebaseIdpAdmin {
  /// Utility functions for the Firebase identity provider.
  final FirebaseIdpUtils utils;

  /// Creates a new instance of [FirebaseIdpAdmin].
  FirebaseIdpAdmin({
    required this.utils,
  });

  /// Finds a Firebase account by email.
  ///
  /// Returns `null` if no account with the given email exists.
  /// The email lookup is case-insensitive.
  Future<FirebaseAccount?> findAccountByEmail(
    Session session, {
    required String email,
    Transaction? transaction,
  }) async {
    return await FirebaseAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email.toLowerCase()),
      transaction: transaction,
    );
  }

  /// Finds a Firebase account by auth user ID.
  ///
  /// Returns `null` if no account with the given auth user ID exists.
  Future<FirebaseAccount?> findAccountByAuthUserId(
    Session session, {
    required UuidValue authUserId,
    Transaction? transaction,
  }) async {
    return await FirebaseAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
  }

  /// Deletes a Firebase account by user identifier (Firebase UID).
  ///
  /// Returns the deleted account, or `null` if no account was found.
  ///
  /// Note: This only removes the Firebase authentication link. The associated
  /// [AuthUser] is not deleted. To fully delete a user, use the auth core
  /// admin functions.
  Future<FirebaseAccount?> deleteFirebaseAccount(
    Session session, {
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    final accounts = await FirebaseAccount.db.deleteWhere(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );
    return accounts.firstOrNull;
  }

  /// Deletes a Firebase account by auth user ID.
  ///
  /// Returns the deleted account, or `null` if no account was found.
  ///
  /// Note: This only removes the Firebase authentication link. The associated
  /// [AuthUser] is not deleted. To fully delete a user, use the auth core
  /// admin functions.
  Future<FirebaseAccount?> deleteFirebaseAccountByAuthUserId(
    Session session, {
    required UuidValue authUserId,
    Transaction? transaction,
  }) async {
    final accounts = await FirebaseAccount.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    return accounts.firstOrNull;
  }

  /// Adds a Firebase authentication to the given [authUserId].
  ///
  /// Returns the newly created Firebase account.
  Future<FirebaseAccount> linkFirebaseAuthentication(
    Session session, {
    required UuidValue authUserId,
    required FirebaseAccountDetails accountDetails,
    Transaction? transaction,
  }) async {
    return utils.linkFirebaseAuthentication(
      session,
      authUserId: authUserId,
      accountDetails: accountDetails,
      transaction: transaction,
    );
  }

  /// Returns the account details for the given [idToken].
  Future<FirebaseAccountDetails> fetchAccountDetails(
    Session session, {
    required String idToken,
  }) async {
    return utils.fetchAccountDetails(
      session,
      idToken: idToken,
    );
  }

  /// Returns the `AuthUser` id for the Firebase user id, if any.
  static Future<UuidValue?> findUserByFirebaseUserId(
    Session session, {
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    final account = await FirebaseAccount.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return account?.authUserId;
  }
}
