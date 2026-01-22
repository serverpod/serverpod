import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'github_idp_config.dart';

/// Details of the GitHub Account.
///
/// All nullable fields are not guaranteed to be available from GitHub's API,
/// since the user may have a private email or limited profile information.
typedef GitHubAccountDetails = ({
  /// GitHub's user identifier for this account.
  String userIdentifier,

  /// The email received from GitHub (may be null if private).
  String? email,

  /// The user's name from GitHub.
  String? name,

  /// The user's profile image URL.
  Uri? image,
});

/// Result of a successful authentication using GitHub as identity provider.
typedef GitHubAuthSuccess = ({
  /// The ID of the `GitHubAccount` database entity.
  UuidValue githubAccountId,

  /// The ID of the associated `AuthUser`.
  UuidValue authUserId,

  /// Details of the GitHub account.
  GitHubAccountDetails details,

  /// Whether the associated `AuthUser` was newly created during authentication.
  bool newAccount,

  /// The scopes granted to the associated `AuthUser`.
  Set<Scope> scopes,
});

/// Utility functions for the GitHub identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [GitHubIdp] and
/// [GitHubIdpAdmin] should be sufficient.
class GitHubIdpUtils {
  /// Configuration for the GitHub identity provider.
  final GitHubIdpConfig config;

  final AuthUsers _authUsers;

  /// Generic OAuth2 PKCE utility for token exchange.
  late final OAuth2PkceUtil _oauth2Util;

  /// Creates a new instance of [GitHubIdpUtils].
  GitHubIdpUtils({
    required this.config,
    required final AuthUsers authUsers,
  }) : _authUsers = authUsers {
    _oauth2Util = OAuth2PkceUtil(config: config.oauth2Config);
  }

  /// Exchanges an `authorization code` for an `access token`.
  ///
  /// This method exchanges the `authorization code` received from GitHub's OAuth
  /// flow for an `access token` using PKCE. The [code] is the `authorization code`
  /// from the callback, and [codeVerifier] is the `PKCE code` verifier that was
  /// used to generate the code challenge.
  ///
  /// The [redirectUri] must match the redirect URI used in the authorization
  /// request.
  ///
  /// This method delegates to the generic [OAuth2PkceUtil] for token exchange,
  /// using GitHub-specific configuration.
  ///
  /// Throws [GitHubAccessTokenVerificationException] if the token exchange fails.
  Future<String> exchangeCodeForToken(
    final Session session, {
    required final String code,
    required final String codeVerifier,
    required final String redirectUri,
  }) async {
    try {
      return await _oauth2Util.exchangeCodeForToken(
        code: code,
        codeVerifier: codeVerifier,
        redirectUri: redirectUri,
      );
    } on OAuth2Exception catch (e) {
      session.log(e.toString(), level: LogLevel.debug);
      throw GitHubAccessTokenVerificationException();
    }
  }

  /// Authenticates a user using an `access token`.
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  ///
  /// The [transaction] parameter can be used to perform the database operations
  /// within an existing transaction.
  Future<GitHubAuthSuccess> authenticate(
    final Session session, {
    required final String accessToken,
    required final Transaction? transaction,
  }) async {
    final accountDetails = await fetchAccountDetails(
      session,
      accessToken: accessToken,
    );

    var githubAccount = await GitHubAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        accountDetails.userIdentifier,
      ),
      transaction: transaction,
    );

    final createNewUser = githubAccount == null;

    final AuthUserModel authUser = switch (createNewUser) {
      true => await _authUsers.create(
        session,
        transaction: transaction,
      ),
      false => await _authUsers.get(
        session,
        authUserId: githubAccount!.authUserId,
        transaction: transaction,
      ),
    };

    if (createNewUser) {
      githubAccount = await linkGitHubAuthentication(
        session,
        authUserId: authUser.id,
        accountDetails: accountDetails,
        transaction: transaction,
      );
    }

    return (
      githubAccountId: githubAccount.id!,
      authUserId: githubAccount.authUserId,
      details: accountDetails,
      newAccount: createNewUser,
      scopes: authUser.scopes,
    );
  }

  /// Returns the account details for the given [accessToken].
  ///
  /// This method calls GitHub's user API.
  ///
  /// Throws [GitHubAccessTokenVerificationException] if the user info retrieval fails.
  Future<GitHubAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String accessToken,
  }) async {
    // More info on the user API:
    // https://docs.github.com/en/rest/users/users#get-the-authenticated-user
    final response = await http.get(
      Uri.https('api.github.com', '/user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode != 200) {
      session.logAndThrow(
        'Failed to verify access token from GitHub: ${response.statusCode}',
      );
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      session.logAndThrow('Invalid user info from GitHub: $e');
    }

    GitHubAccountDetails details;
    try {
      details = _parseAccountDetails(data);
    } catch (e) {
      session.logAndThrow('Invalid user info from GitHub: $e');
    }

    try {
      final getExtraInfoCallback = config.getExtraGitHubInfoCallback;
      if (getExtraInfoCallback != null) {
        await getExtraInfoCallback(
          session,
          accountDetails: details,
          accessToken: accessToken,
          transaction: null,
        );
      }
    } catch (e) {
      session.logAndThrow('Failed to get extra GitHub account info: $e');
    }

    return details;
  }

  GitHubAccountDetails _parseAccountDetails(final Map<String, dynamic> data) {
    final userId = data['id'];
    final email = data['email'] as String?;
    final name = data['name'] as String?;
    final avatarUrl = data['avatar_url'] as String?;

    if (userId == null) {
      throw GitHubUserInfoMissingDataException();
    }

    final details = (
      userIdentifier: userId.toString(),
      email: email?.toLowerCase(),
      name: name,
      image: avatarUrl != null ? Uri.tryParse(avatarUrl) : null,
    );

    try {
      config.githubAccountDetailsValidation(details);
    } catch (e) {
      throw GitHubUserInfoMissingDataException();
    }

    return details;
  }

  /// Adds a GitHub authentication to the given [authUserId].
  ///
  /// Returns the newly created GitHub account.
  ///
  /// The [transaction] parameter can be used to perform the database operations
  /// within an existing transaction.
  Future<GitHubAccount> linkGitHubAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final GitHubAccountDetails accountDetails,
    final Transaction? transaction,
  }) async {
    return await GitHubAccount.db.insertRow(
      session,
      GitHubAccount(
        userIdentifier: accountDetails.userIdentifier,
        email: accountDetails.email,
        authUserId: authUserId,
      ),
      transaction: transaction,
    );
  }
}

extension on Session {
  Never logAndThrow(final String message) {
    log(message, level: LogLevel.debug);
    throw GitHubAccessTokenVerificationException();
  }
}

/// Exception thrown when the user info from GitHub is missing required data.
class GitHubUserInfoMissingDataException implements Exception {}
