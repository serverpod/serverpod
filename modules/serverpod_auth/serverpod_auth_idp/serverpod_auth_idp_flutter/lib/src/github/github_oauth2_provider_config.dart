import '../common/oauth2_pkce/oauth2_pkce_config.dart';

/// GitHub-specific OAuth2 PKCE configuration.
///
/// Provides GitHub-specific settings for the OAuth2 authorization flow,
/// including the authorization endpoint and client configuration.
class GitHubOAuth2ProviderConfig extends OAuth2PkceProviderConfig {
  @override
  final String clientId;

  @override
  final String redirectUri;

  @override
  final String callbackUrlScheme;

  /// Creates a new [GitHubOAuth2ProviderConfig].
  GitHubOAuth2ProviderConfig({
    required this.clientId,
    required this.redirectUri,
    required this.callbackUrlScheme,
  });

  @override
  Uri get authorizationEndpoint =>
      Uri.https('github.com', '/login/oauth/authorize');
}
