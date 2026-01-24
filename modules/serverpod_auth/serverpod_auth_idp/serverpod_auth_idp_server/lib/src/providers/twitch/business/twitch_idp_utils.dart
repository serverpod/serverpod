import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'twitch_idp_config.dart';

/// Details of the Twitch Account.
///
/// All nullable fields are not guaranteed to be available from Twitch's API,
/// since the user may have a private email or limited profile information.
typedef TwitchAccountDetails = ({
  /// Twitch's user identifier for this account.
  String userIdentifier,

  String login,

  String displayName,

  /// The email received from Twitch (may be null if private).
  String? email,

  /// The user's profile image URI.
  Uri? profileImage,
});

/// Result of the code exchange process to be used for authorization
typedef TwitchTokenSuccess = ({
  String accessToken,

  int expiresIn,

  String refreshToken,

  Set<String> scope,

  String tokenType,
});

/// Result of a successful authentication using Twitch as identity provider.
typedef TwitchAuthSuccess = ({
  /// The ID of the `TwitchAccount` database entity.
  UuidValue twitchAccountId,

  /// The ID of the associated `AuthUser`.
  UuidValue authUserId,

  /// Details of the Twitch account.
  TwitchAccountDetails details,

  /// Whether the associated `AuthUser` was newly created during authentication.
  bool newAccount,

  /// The scopes granted to the associated `AuthUser`.
  Set<Scope> scopes,
});

/// Utility functions for the Twitch identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [TwitchIdp] and
/// [TwitchIdpAdmin] should be sufficient.
class TwitchIdpUtils {
  /// Configuration for the Twitch identity provider.
  final TwitchIdpConfig config;

  final AuthUsers _authUsers;

  /// Generic OAuth2 PKCE utility for token exchange.
  late final OAuth2PkceUtil _oauth2Util;

  /// Creates a new instance of [TwitchIdpUtils].
  TwitchIdpUtils({
    required this.config,
    required final AuthUsers authUsers,
  }) : _authUsers = authUsers {
    _oauth2Util = OAuth2PkceUtil(config: config.oauth2Config);
  }

  /// Exchanges an `authorization code` for an `access token`.
  ///
  /// This method exchanges the `authorization code` received from Twitch's OAuth
  /// flow for an `access token` using PKCE. The [code] is the `authorization code`
  /// from the callback, and [codeVerifier] is the `PKCE code` verifier that was
  /// used to generate the code challenge.
  ///
  /// The [redirectUri] must match the redirect URI used in the authorization
  /// request.
  ///
  /// This method delegates to the generic [OAuth2PkceUtil] for token exchange,
  /// using Twitch-specific configuration.
  ///
  /// Throws [TwitchAccessTokenVerificationException] if the token exchange fails.
  Future<TwitchTokenSuccess> exchangeCodeForToken(
    final Session session, {
    required final String code,
    required final String redirectUri,
  }) async {
    try {
      return await _oauth2Util.exchangeCodeForToken(
        code: code,
        redirectUri: redirectUri,
      );
    } on OAuth2Exception catch (e) {
      session.log(e.toString(), level: LogLevel.debug);
      throw TwitchAccessTokenVerificationException();
    }
  }

  /// Authenticates a user using an `access token`.
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  ///
  /// The [transaction] parameter can be used to perform the database operations
  /// within an existing transaction.
  Future<TwitchAuthSuccess> authenticate(
    final Session session, {
    required final TwitchTokenSuccess tokenSuccessResponse,
    required final Transaction? transaction,
  }) async {
    final accountDetails = await fetchAccountDetails(
      session,
      accessToken: tokenSuccessResponse.accessToken,
    );

    var twitchAccount = await TwitchAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        accountDetails.userIdentifier,
      ),
      transaction: transaction,
    );

    final createNewUser = twitchAccount == null;

    final AuthUserModel authUser = switch (createNewUser) {
      true => await _authUsers.create(
        session,
        transaction: transaction,
      ),
      false => await _authUsers.get(
        session,
        authUserId: twitchAccount!.authUserId,
        transaction: transaction,
      ),
    };

    twitchAccount = await createOrUpdateTwitchAccount(
      session,
      newAccount: createNewUser,
      authUserId: authUser.id,
      twitchAccountDetails: accountDetails,
      tokenResponse: tokenSuccessResponse,
      transaction: transaction,
    );

    return (
      twitchAccountId: twitchAccount.id!,
      authUserId: twitchAccount.authUserId,
      details: accountDetails,
      newAccount: createNewUser,
      scopes: authUser.scopes,
    );
  }

  /// Returns the account details for the given [accessToken].
  ///
  /// This method calls Twitch's user API.
  ///
  /// Throws [TwitchAccessTokenVerificationException] if the user info retrieval fails.
  Future<TwitchAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String accessToken,
  }) async {
    // More info on the user API:
    // https://docs.twitch.com/en/rest/users/users#get-the-authenticated-user
    final response = await http.get(
      Uri.https('api.twitch.tv', '/helix/users'),
      headers: {
        'Client-ID': config.oauthCredentials.clientId,
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/vnd.twitchtv.v5+json',
      },
    );

    if (response.statusCode != 200) {
      session.logAndThrow(
        'Failed to verify access token from Twitch: ${response.statusCode}',
      );
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      session.logAndThrow('Invalid user info from Twitch: $e');
    }

    TwitchAccountDetails details;
    try {
      details = _parseAccountDetails(data);
    } catch (e) {
      session.logAndThrow('Invalid user info from Twitch: $e');
    }

    try {
      final getExtraInfoCallback = config.getExtraTwitchInfoCallback;
      if (getExtraInfoCallback != null) {
        await getExtraInfoCallback(
          session,
          accountDetails: details,
          accessToken: accessToken,
          transaction: null,
        );
      }
    } catch (e) {
      session.logAndThrow('Failed to get extra Twitch account info: $e');
    }

    return details;
  }

  TwitchAccountDetails _parseAccountDetails(final Map<String, dynamic> data) {
    final userId = data['id'];
    final login = data['login'] as String;
    final displayName = data['displayName'] as String;
    final email = data['email'] as String?;
    final profileImageUrl = data['profile_image_url'] as String?;

    if (userId == null) {
      throw TwitchUserInfoMissingDataException();
    }

    final details = (
      displayName: displayName,
      email: email?.toLowerCase(),
      login: login,
      profileImage: profileImageUrl != null
          ? Uri.tryParse(profileImageUrl)
          : null,
      userIdentifier: userId.toString(),
    );

    try {
      config.twitchAccountDetailsValidation(details);
    } catch (e) {
      throw TwitchUserInfoMissingDataException();
    }

    return details;
  }

  /// Links a [TwitchAccount] to an existing AuthUser.
  /// If a user account already exists update the database entry to get sure
  /// twitch data is up to date.
  /// Returns the created [TwitchAccount].
  /// Throws an exception if the operation fails.
  Future<TwitchAccount> createOrUpdateTwitchAccount(
    final Session session, {
    required final bool newAccount,
    required final UuidValue authUserId,
    required final TwitchAccountDetails twitchAccountDetails,
    required final TwitchTokenSuccess tokenResponse,
    final Transaction? transaction,
  }) async {
    return switch (newAccount) {
      true => await TwitchAccount.db.insertRow(
        session,
        TwitchAccount(
          userIdentifier: twitchAccountDetails.userIdentifier,
          login: twitchAccountDetails.login,
          displayName: twitchAccountDetails.displayName,
          email: twitchAccountDetails.email,
          accessToken: tokenResponse.accessToken,
          expiresIn: tokenResponse.expiresIn,
          refreshToken: tokenResponse.refreshToken,
          authUserId: authUserId,
        ),
        transaction: transaction,
      ),
      false => (await TwitchAccount.db.updateWhere(
        session,
        columnValues: (final a) => [
          a.login(twitchAccountDetails.login),
          a.displayName(twitchAccountDetails.displayName),
          a.email(twitchAccountDetails.email),
          a.accessToken(tokenResponse.accessToken),
          a.refreshToken(tokenResponse.refreshToken),
          a.expiresIn(tokenResponse.expiresIn),
        ],
        limit: 1,
        where: (final a) => a.userIdentifier.equals(
          twitchAccountDetails.userIdentifier,
        ),
      )).first,
    };
  }
}

extension on Session {
  Never logAndThrow(final String message) {
    log(message, level: LogLevel.debug);
    throw TwitchAccessTokenVerificationException();
  }
}

/// Exception thrown when the user info from Twitch is missing required data.
class TwitchUserInfoMissingDataException implements Exception {}
