import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import 'github_idp.dart';
import 'github_idp_utils.dart';

/// Function to be called to check whether a GitHub account details match the
/// requirements during registration.
typedef GitHubAccountDetailsValidation =
    void Function(GitHubAccountDetails accountDetails);

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
///
/// This class implements both [IdentityProviderBuilder] and [OAuth2PkceServerConfig]
/// for generic OAuth2 PKCE token exchange.
class GitHubIdpConfig extends IdentityProviderBuilder<GitHubIdp> {
  /// The client ID from your GitHub OAuth App.
  final String clientId;

  /// The client secret from your GitHub OAuth App.
  final String clientSecret;

  /// OAuth2 PKCE server config for GitHub.
  late final OAuth2PkceServerConfig oauth2Config;

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
  /// information from GitHub.
  ///
  /// This callback is invoked during [GitHubIdpUtils.fetchAccountDetails],
  /// before the system determines if the user is new or returning. It runs on
  /// EVERY authentication attempt.
  ///
  /// **CRITICAL - Do NOT create these models in the callback:**
  /// - [GitHubAccount] - Breaks new account detection
  /// - [UserProfile] - Interferes with automatic profile creation
  /// - [AuthUser] - Already handled by the authentication flow
  ///
  /// Creating these models will cause the authentication flow in [GitHubIdp.login]
  /// to fail or skip critical steps like user profile creation.
  ///
  /// **Safe usage:** Store data in your own custom tables, linked by
  /// [GitHubAccountDetails.userIdentifier]. Keep operations lightweight.
  final GetExtraGitHubInfoCallback? getExtraGitHubInfoCallback;

  /// Creates a new instance of [GitHubIdpConfig].
  GitHubIdpConfig({
    required this.clientId,
    required this.clientSecret,
    this.githubAccountDetailsValidation = validateGitHubAccountDetails,
    this.getExtraGitHubInfoCallback,
  }) : oauth2Config = OAuth2PkceServerConfig(
         tokenEndpointUrl: Uri.https('github.com', '/login/oauth/access_token'),
         clientId: clientId,
         clientSecret: clientSecret,
         credentialsLocation: OAuth2CredentialsLocation.body,
         parseAccessToken: parseAccessToken,
       );

  /// Default validation function for extracting additional GitHub account details.
  ///
  /// This default implementation accepts all accounts as GitHub's optional
  /// fields (email, name) are intentionally optional for user privacy.
  /// Override this if you need to enforce specific requirements.
  static void validateGitHubAccountDetails(
    final GitHubAccountDetails accountDetails,
  ) {
    if (accountDetails.userIdentifier.isEmpty) {
      throw GitHubUserInfoMissingDataException();
    }
  }

  /// Default GitHub access token parser for OAuth2PkceServerConfig.
  static String parseAccessToken(final Map<String, dynamic> responseBody) {
    final error = responseBody['error'] as String?;
    if (error != null) {
      final errorDescription = responseBody['error_description'] as String?;
      throw OAuth2InvalidResponseException(
        'Invalid response from GitHub:'
        ' $error${errorDescription != null ? ' - $errorDescription' : ''}',
      );
    }
    final accessToken = responseBody['access_token'] as String?;
    if (accessToken == null) {
      throw const OAuth2MissingAccessTokenException(
        'No access token in GitHub response',
      );
    }
    return accessToken;
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
/// - `githubClientId`: The client ID from your GitHub OAuth App
/// - `githubClientSecret`: The client secret from your GitHub OAuth App
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
        clientId: Serverpod.instance.getPasswordOrThrow('githubClientId'),
        clientSecret: Serverpod.instance.getPasswordOrThrow(
          'githubClientSecret',
        ),
      );
}
