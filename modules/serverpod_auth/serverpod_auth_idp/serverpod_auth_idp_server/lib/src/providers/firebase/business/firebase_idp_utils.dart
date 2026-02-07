import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../common/id_token_verifier/id_token_verifier.dart';
import 'firebase_id_token_config.dart';
import 'firebase_idp_config.dart';

/// Details of the Firebase Account.
///
/// Some fields may be null depending on the authentication provider used
/// within Firebase (e.g., phone auth may not have email).
typedef FirebaseAccountDetails = ({
  /// Firebase's user identifier for this account.
  String userIdentifier,

  /// The email received from Firebase (may be null for phone auth).
  String? email,

  /// The user's full name (display name).
  String? fullName,

  /// The user's profile image URL.
  Uri? image,

  /// Whether the email is verified.
  bool? verifiedEmail,

  /// The phone number (only present for phone authentication).
  String? phone,
});

/// Result of a successful authentication using Firebase as identity provider.
typedef FirebaseAuthSuccess = ({
  /// The ID of the `FirebaseAccount` database entity.
  UuidValue firebaseAccountId,

  /// The ID of the associated `AuthUser`.
  UuidValue authUserId,

  /// Details of the Firebase account.
  FirebaseAccountDetails details,

  /// Whether the associated `AuthUser` was newly created during the
  /// authentication.
  bool newAccount,

  /// The scopes granted to the associated `AuthUser`.
  Set<Scope> scopes,
});

/// Utility functions for the Firebase identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [FirebaseIdp] and
/// [FirebaseIdpAdmin] should be sufficient.
class FirebaseIdpUtils {
  /// Configuration for the Firebase identity provider.
  final FirebaseIdpConfig config;

  final AuthUsers _authUsers;

  /// Creates a new instance of [FirebaseIdpUtils].
  FirebaseIdpUtils({
    required this.config,
    required final AuthUsers authUsers,
  }) : _authUsers = authUsers;

  /// Authenticates a user using an ID token.
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  Future<FirebaseAuthSuccess> authenticate(
    final Session session, {
    required final String idToken,
    required final Transaction? transaction,
  }) async {
    final accountDetails = await fetchAccountDetails(
      session,
      idToken: idToken,
    );

    var firebaseAccount = await FirebaseAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        accountDetails.userIdentifier,
      ),
      transaction: transaction,
    );

    final createNewUser = firebaseAccount == null;

    final AuthUserModel authUser = switch (createNewUser) {
      true => await _authUsers.create(
        session,
        transaction: transaction,
      ),
      false => await _authUsers.get(
        session,
        authUserId: firebaseAccount!.authUserId,
        transaction: transaction,
      ),
    };

    if (createNewUser) {
      firebaseAccount = await linkFirebaseAuthentication(
        session,
        authUserId: authUser.id,
        accountDetails: accountDetails,
        transaction: transaction,
      );
    }

    return (
      firebaseAccountId: firebaseAccount.id!,
      authUserId: firebaseAccount.authUserId,
      details: accountDetails,
      newAccount: createNewUser,
      scopes: authUser.scopes,
    );
  }

  /// Returns the account details for the given [idToken].
  Future<FirebaseAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String idToken,
  }) async {
    final String projectId = config.credentials.projectId;

    Map<String, dynamic> data;
    try {
      data = await IdTokenVerifier.verifyOAuth2Token(
        idToken,
        config: FirebaseIdTokenConfig(projectId: projectId),
        audience: projectId,
      );
    } catch (e, stackTrace) {
      session.log(
        'Firebase token verification failed: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      session.logAndThrow('Failed to verify ID token from Firebase');
    }

    FirebaseAccountDetails details;
    try {
      details = _parseAccountDetails(data);
    } catch (e) {
      session.logAndThrow('Invalid user info from Firebase: $e');
    }

    return details;
  }

  FirebaseAccountDetails _parseAccountDetails(final Map<String, dynamic> data) {
    final userId = data['sub'] as String?;
    final email = data['email'] as String?;
    final fullName = data['name'] as String?;
    final image = data['picture'] as String?;
    final verifiedEmail = data['email_verified'] as bool?;
    final phone = data['phone_number'] as String?;

    if (userId == null || userId.isEmpty) {
      throw FirebaseUserInfoMissingDataException();
    }

    final details = (
      userIdentifier: userId,
      email: email,
      fullName: fullName,
      image: image != null ? Uri.tryParse(image) : null,
      verifiedEmail: verifiedEmail,
      phone: phone,
    );

    try {
      config.firebaseAccountDetailsValidation(details);
    } catch (e) {
      throw FirebaseUserInfoMissingDataException();
    }

    return details;
  }

  /// Adds a Firebase authentication to the given [authUserId].
  ///
  /// Returns the newly created Firebase account.
  Future<FirebaseAccount> linkFirebaseAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final FirebaseAccountDetails accountDetails,
    final Transaction? transaction,
  }) async {
    return await FirebaseAccount.db.insertRow(
      session,
      FirebaseAccount(
        userIdentifier: accountDetails.userIdentifier,
        email: accountDetails.email?.toLowerCase(),
        phone: accountDetails.phone,
        authUserId: authUserId,
      ),
      transaction: transaction,
    );
  }

  /// Returns the possible [FirebaseAccount] associated with an session.
  Future<FirebaseAccount?> getAccount(final Session session) {
    return switch (session.authenticated) {
      null => Future.value(null),
      _ => FirebaseAccount.db.findFirstRow(
        session,
        where: (final t) => t.authUserId.equals(
          session.authenticated!.authUserId,
        ),
      ),
    };
  }
}

extension on Session {
  Never logAndThrow(final String message) {
    log(message, level: LogLevel.debug);
    throw FirebaseIdTokenVerificationException();
  }
}
