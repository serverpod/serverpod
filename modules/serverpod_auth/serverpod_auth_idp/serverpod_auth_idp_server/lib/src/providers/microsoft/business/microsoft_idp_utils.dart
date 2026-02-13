import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'microsoft_idp_config.dart';

/// Details of the Microsoft Account.
///
/// All nullable fields are not guaranteed to be available from Microsoft's API,
/// since the user may have a private email or limited profile information.
typedef MicrosoftAccountDetails = ({
  /// Microsoft's user identifier for this account.
  String userIdentifier,

  /// The email received from Microsoft (may be null if private).
  String? email,

  /// The user's name from Microsoft.
  String? name,

  /// The user's profile photo (only fetched if [MicrosoftIdpConfig.fetchProfilePhoto] is enabled).
  Uint8List? imageBytes,
});

/// Result of a successful authentication using Microsoft as identity provider.
typedef MicrosoftAuthSuccess = ({
  /// The ID of the `MicrosoftAccount` database entity.
  UuidValue microsoftAccountId,

  /// The ID of the associated `AuthUser`.
  UuidValue authUserId,

  /// Details of the Microsoft account.
  MicrosoftAccountDetails details,

  /// Whether the associated `AuthUser` was newly created during authentication.
  bool newAccount,

  /// The scopes granted to the associated `AuthUser`.
  Set<Scope> scopes,
});

/// Utility functions for the Microsoft identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [MicrosoftIdp] and
/// [MicrosoftIdpAdmin] should be sufficient.
class MicrosoftIdpUtils {
  /// Configuration for the Microsoft identity provider.
  final MicrosoftIdpConfig config;

  final AuthUsers _authUsers;

  /// Generic OAuth2 PKCE utility for token exchange.
  late final OAuth2PkceUtil _oauth2Util;

  /// Creates a new instance of [MicrosoftIdpUtils].
  MicrosoftIdpUtils({
    required this.config,
    required final AuthUsers authUsers,
  }) : _authUsers = authUsers {
    _oauth2Util = OAuth2PkceUtil(config: config.oauth2Config);
  }

  /// Exchanges an `authorization code` for an `access token`.
  ///
  /// This method exchanges the `authorization code` received from Microsoft's OAuth
  /// flow for an `access token` using PKCE. The [code] is the `authorization code`
  /// from the callback, and [codeVerifier] is the `PKCE code` verifier that was
  /// used to generate the code challenge.
  ///
  /// The [redirectUri] must match the redirect URI used in the authorization
  /// request.
  ///
  /// The [isWebPlatform] flag indicates whether the client is a web application.
  /// Microsoft requires the client secret only for confidential clients (web
  /// apps). Public clients (mobile, desktop) using PKCE must not include it.
  /// See [Microsoft OAuth2 documentation](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow#request-an-access-token-with-a-client_secret).
  ///
  /// This method delegates to the generic [OAuth2PkceUtil] for token exchange,
  /// using Microsoft-specific configuration.
  ///
  /// Throws [MicrosoftAccessTokenVerificationException] if the token exchange fails.
  Future<String> exchangeCodeForToken(
    final Session session, {
    required final String code,
    required final String codeVerifier,
    required final String redirectUri,
    required final bool isWebPlatform,
  }) async {
    try {
      final tokenResponse = await _oauth2Util.exchangeCodeForToken(
        code: code,
        codeVerifier: codeVerifier,
        redirectUri: redirectUri,
        includeClientSecret: isWebPlatform,
      );
      return tokenResponse.accessToken;
    } on OAuth2Exception catch (e) {
      session.log(e.toString(), level: LogLevel.debug);
      throw MicrosoftAccessTokenVerificationException();
    }
  }

  /// Authenticates a user using an `access token`.
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  ///
  /// The [transaction] parameter can be used to perform the database operations
  /// within an existing transaction.
  Future<MicrosoftAuthSuccess> authenticate(
    final Session session, {
    required final String accessToken,
    required final Transaction? transaction,
  }) async {
    final accountDetails = await fetchAccountDetails(
      session,
      accessToken: accessToken,
    );

    var microsoftAccount = await MicrosoftAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        accountDetails.userIdentifier,
      ),
      transaction: transaction,
    );

    final createNewUser = microsoftAccount == null;

    final AuthUserModel authUser = switch (createNewUser) {
      true => await _authUsers.create(
        session,
        transaction: transaction,
      ),
      false => await _authUsers.get(
        session,
        authUserId: microsoftAccount!.authUserId,
        transaction: transaction,
      ),
    };

    if (createNewUser) {
      microsoftAccount = await linkMicrosoftAuthentication(
        session,
        authUserId: authUser.id,
        accountDetails: accountDetails,
        transaction: transaction,
      );
    }

    return (
      microsoftAccountId: microsoftAccount.id!,
      authUserId: microsoftAccount.authUserId,
      details: accountDetails,
      newAccount: createNewUser,
      scopes: authUser.scopes,
    );
  }

  /// Returns the account details for the given [accessToken].
  ///
  /// This method calls Microsoft Graph API to get user information.
  /// If [MicrosoftIdpConfig.fetchProfilePhoto] is enabled, it also fetches
  /// the user's profile photo.
  ///
  /// Throws [MicrosoftAccessTokenVerificationException] if the user info retrieval fails.
  Future<MicrosoftAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String accessToken,
  }) async {
    final response = await http.get(
      Uri.https('graph.microsoft.com', '/v1.0/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      session.logAndThrow(
        'Failed to verify access token from Microsoft: ${response.statusCode}',
      );
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      session.logAndThrow('Invalid user info from Microsoft: $e');
    }

    MicrosoftAccountDetails details;
    try {
      details = _parseAccountDetails(data);
    } catch (e) {
      session.logAndThrow('Invalid user info from Microsoft: $e');
    }

    Uint8List? imageBytes;
    if (config.fetchProfilePhoto) {
      try {
        imageBytes = await _fetchProfilePhoto(
          session,
          accessToken: accessToken,
        );
      } catch (e) {
        session.log(
          'Failed to fetch Microsoft profile photo: $e',
          level: LogLevel.debug,
        );
      }
    }

    details = (
      userIdentifier: details.userIdentifier,
      email: details.email,
      name: details.name,
      imageBytes: imageBytes,
    );

    try {
      final getExtraInfoCallback = config.getExtraMicrosoftInfoCallback;
      if (getExtraInfoCallback != null) {
        await getExtraInfoCallback(
          session,
          accountDetails: details,
          accessToken: accessToken,
          transaction: null,
        );
      }
    } catch (e) {
      session.logAndThrow('Failed to get extra Microsoft account info: $e');
    }

    return details;
  }

  Future<Uint8List?> _fetchProfilePhoto(
    final Session session, {
    required final String accessToken,
  }) async {
    final response = await http.get(
      Uri.https('graph.microsoft.com', '/v1.0/me/photo/\$value'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    return null;
  }

  MicrosoftAccountDetails _parseAccountDetails(
    final Map<String, dynamic> data,
  ) {
    final userId = data['id'];
    final email =
        data['mail'] as String? ?? data['userPrincipalName'] as String?;
    final name = data['displayName'] as String?;

    if (userId == null) {
      throw MicrosoftUserInfoMissingDataException();
    }

    final details = (
      userIdentifier: userId.toString(),
      email: email?.toLowerCase(),
      name: name,
      imageBytes: null,
    );

    try {
      config.microsoftAccountDetailsValidation(details);
    } catch (e) {
      throw MicrosoftUserInfoMissingDataException();
    }

    return details;
  }

  /// Adds a Microsoft authentication to the given [authUserId].
  ///
  /// Returns the newly created Microsoft account.
  ///
  /// The [transaction] parameter can be used to perform the database operations
  /// within an existing transaction.
  Future<MicrosoftAccount> linkMicrosoftAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final MicrosoftAccountDetails accountDetails,
    final Transaction? transaction,
  }) async {
    return await MicrosoftAccount.db.insertRow(
      session,
      MicrosoftAccount(
        userIdentifier: accountDetails.userIdentifier,
        email: accountDetails.email,
        authUserId: authUserId,
      ),
      transaction: transaction,
    );
  }

  /// Returns the possible [MicrosoftAccount] associated with a session.
  Future<MicrosoftAccount?> getAccount(final Session session) {
    return switch (session.authenticated) {
      null => Future.value(null),
      _ => MicrosoftAccount.db.findFirstRow(
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
    throw MicrosoftAccessTokenVerificationException();
  }
}

/// Exception thrown when the user info from Microsoft is missing required data.
class MicrosoftUserInfoMissingDataException implements Exception {}
