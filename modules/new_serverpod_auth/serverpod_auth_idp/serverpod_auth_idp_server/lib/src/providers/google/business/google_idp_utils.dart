import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';

import '../../../generated/protocol.dart';
import 'google_idp_config.dart';

/// Details of the Google Account.
typedef GoogleAccountDetails = ({
  /// Google's user identifier for this account.
  String userIdentifier,

  /// The verified email received from Google.
  String email,

  /// The user's given name.
  String name,

  /// The user's full name.
  String fullName,

  /// The user's profile image URL.
  Uri? image,
});

/// Result of a successful authentication using Google as identity provider.
typedef GoogleAuthSuccess = ({
  /// The ID of the `GoogleAccount` database entity.
  UuidValue googleAccountId,

  /// The ID of the associated `AuthUser`.
  UuidValue authUserId,

  /// Details of the Google account.
  GoogleAccountDetails details,

  /// Whether the associated `AuthUser` was newly created during the
  bool newAccount,

  /// The scopes granted to the associated `AuthUser`.
  Set<Scope> scopes,
});

/// Utility functions for the Google identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [GoogleIDP] and
/// [GoogleIDPAdmin] should be sufficient.
class GoogleIDPUtils {
  /// The client secret used for the Google sign-in.
  final GoogleClientSecret clientSecret;

  /// Creates a new instance of [GoogleIDPUtils].
  GoogleIDPUtils({
    required this.clientSecret,
  });

  /// Authenticates a user using an ID token.
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  Future<GoogleAuthSuccess> authenticate(
    final Session session, {
    required final String idToken,
    required final Transaction? transaction,
  }) async {
    final accountDetails = await fetchAccountDetails(
      session,
      idToken: idToken,
    );

    var googleAccount = await GoogleAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        accountDetails.userIdentifier,
      ),
      transaction: transaction,
    );

    final createNewUser = googleAccount == null;

    final AuthUserModel authUser = switch (createNewUser) {
      true => await AuthUsers.create(
          session,
          transaction: transaction,
        ),
      false => await AuthUsers.get(
          session,
          authUserId: googleAccount!.authUserId,
          transaction: transaction,
        ),
    };

    if (createNewUser) {
      googleAccount = await linkGoogleAuthentication(
        session,
        authUserId: authUser.id,
        accountDetails: accountDetails,
        transaction: transaction,
      );
    }

    return (
      googleAccountId: googleAccount.id!,
      authUserId: googleAccount.authUserId,
      details: accountDetails,
      newAccount: createNewUser,
      scopes: authUser.scopes,
    );
  }

  /// Returns the account details for the given [idToken].
  Future<GoogleAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String idToken,
  }) async {
    final String clientId = clientSecret.clientId;

    // Verify the ID token with Google's servers.
    final response = await http.get(
      Uri.https(
        'www.googleapis.com',
        '/oauth2/v3/tokeninfo',
        {'id_token': idToken},
      ),
    );

    if (response.statusCode != 200) {
      session.log(
        'Invalid token response status: ${response.statusCode}',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      session.log(
        'Invalid token response, content was not a Map.',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    final issuer = data['iss'] as String?;
    if (issuer != 'accounts.google.com' &&
        issuer != 'https://accounts.google.com') {
      session.log(
        'Invalid token response, unexpected issuer "$issuer"',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    if (data['aud'] != clientId) {
      session.log(
        'Invalid token response, client ID does not match',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    final userId = data['sub'] as String?;
    final email = data['email'] as String?;
    final verifiedEmail = data['verified_email'] as bool? ??
        ((data['email_verified'] as String?) == 'true');
    final fullName = data['name'] as String?;
    final image = data['picture'] as String?;
    final name = data['given_name'] as String?;

    if (userId == null ||
        email == null ||
        verifiedEmail != true ||
        fullName == null ||
        image == null ||
        name == null) {
      session.log(
        'Invalid token response, missing required data: $data',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    return (
      userIdentifier: userId,
      email: email,
      name: name,
      fullName: fullName,
      image: Uri.tryParse(image),
    );
  }

  /// Adds a Google authentication to the given [authUserId].
  ///
  /// Returns the newly created Google account.
  Future<GoogleAccount> linkGoogleAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final GoogleAccountDetails accountDetails,
    final Transaction? transaction,
  }) async {
    return await GoogleAccount.db.insertRow(
      session,
      GoogleAccount(
        userIdentifier: accountDetails.userIdentifier,
        email: accountDetails.email.toLowerCase(),
        authUserId: authUserId,
      ),
      transaction: transaction,
    );
  }
}
