import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import 'github_idp.dart';
import 'github_idp_utils.dart';

/// Function to be called to check whether a GitHub account details match the
/// requirements during registration.
typedef GitHubAccountDetailsValidation =
    void Function(
      GitHubAccountDetails accountDetails,
    );

/// Function to be called to extract additional information from GitHub APIs
/// using the access token. The [session] and [transaction] can be used to
/// store additional information in the database.
typedef GetExtraGitHubInfoCallback =
    Future<void> Function(
      Session session, {
      required GitHubAccountDetails accountDetails,
      required String accessToken,
      required Transaction? transaction,
    });

/// Configuration for the GitHub identity provider.
class GitHubIdpConfig extends IdentityProviderBuilder<GitHubIdp> {
  /// The OAuth credentials used for GitHub sign-in.
  final GitHubOAuthCredentials oauthCredentials;

  /// Validation function for GitHub account details.
  ///
  /// This function should throw an exception if the account details do not
  /// match the requirements. If the function returns normally, the account
  /// is considered valid.
  ///
  /// It can be used to enforce additional requirements on the GitHub account
  /// details before allowing the user to sign in. Note that GitHub users
  /// can keep their email private, so email may be null even for valid
  /// accounts. Similarly, the name field is optional.
  ///
  /// To avoid blocking real users with private profiles from signing in,
  /// adjust your validation function with care.
  final GitHubAccountDetailsValidation githubAccountDetailsValidation;

  /// Callback that can be used with the access token to extract additional
  /// information from GitHub APIs.
  final GetExtraGitHubInfoCallback? getExtraGitHubInfoCallback;

  /// Creates a new instance of [GitHubIdpConfig].
  const GitHubIdpConfig({
    required this.oauthCredentials,
    this.githubAccountDetailsValidation = validateGitHubAccountDetails,
    this.getExtraGitHubInfoCallback,
  });

  /// Default validation function for extracted GitHub account details.
  ///
  /// This default implementation accepts all accounts as GitHub's optional
  /// fields (email, name) are intentionally optional for user privacy.
  /// Override this if you need to enforce specific requirements.
  static void validateGitHubAccountDetails(
    final GitHubAccountDetails accountDetails,
  ) {
    // No validation by default - email and name are optional by design
    // Users can override this to enforce requirements if needed
  }

  @override
  GitHubIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return GitHubIdp(
      this,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Creates a new [GitHubIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
///
/// The following keys must be present in the `passwords.yaml` file:
/// - `githubClientId`: The OAuth client ID from GitHub
/// - `githubClientSecret`: The OAuth client secret from GitHub
///
/// Example `passwords.yaml`:
/// ```yaml
/// githubClientId: 'your-github-oauth-client-id'
/// githubClientSecret: 'your-github-oauth-client-secret'
/// ```
class GitHubIdpConfigFromPasswords extends GitHubIdpConfig {
  /// Creates a new [GitHubIdpConfigFromPasswords] instance.
  GitHubIdpConfigFromPasswords()
    : super(
        oauthCredentials: GitHubOAuthCredentials._(
          clientId: Serverpod.instance.getPasswordOrThrow('githubClientId'),
          clientSecret: Serverpod.instance.getPasswordOrThrow(
            'githubClientSecret',
          ),
        ),
      );
}

/// Contains information about the OAuth credentials for the server to access
/// GitHub's APIs. The OAuth App credentials can be created from GitHub's
/// developer settings at:
/// https://github.com/settings/developers
final class GitHubOAuthCredentials {
  /// The OAuth client ID from GitHub.
  final String clientId;

  /// The OAuth client secret from GitHub.
  final String clientSecret;

  /// Private constructor to initialize the object.
  const GitHubOAuthCredentials._({
    required this.clientId,
    required this.clientSecret,
  });

  /// Creates a new instance of [GitHubOAuthCredentials] from a JSON map.
  /// Expects the JSON to have the following structure:
  ///
  /// Example:
  /// {
  ///   "clientId": "your-github-oauth-client-id",
  ///   "clientSecret": "your-github-oauth-client-secret"
  /// }
  ///
  factory GitHubOAuthCredentials.fromJson(final Map<String, dynamic> json) {
    final clientId = json['clientId'] as String?;
    if (clientId == null) {
      throw const FormatException('Missing "clientId"');
    }

    final clientSecret = json['clientSecret'] as String?;
    if (clientSecret == null) {
      throw const FormatException('Missing "clientSecret"');
    }

    return GitHubOAuthCredentials._(
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }

  /// Creates a new instance of [GitHubOAuthCredentials] from a JSON string.
  /// The string is expected to follow the format described in
  /// [GitHubOAuthCredentials.fromJson].
  factory GitHubOAuthCredentials.fromJsonString(final String jsonString) {
    final data = jsonDecode(jsonString);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Not a JSON (map) object');
    }

    return GitHubOAuthCredentials.fromJson(data);
  }

  /// Creates a new instance of [GitHubOAuthCredentials] from a JSON file.
  /// The file is expected to follow the format described in
  /// [GitHubOAuthCredentials.fromJson].
  factory GitHubOAuthCredentials.fromJsonFile(final File file) {
    final jsonString = file.readAsStringSync();
    return GitHubOAuthCredentials.fromJsonString(jsonString);
  }
}
