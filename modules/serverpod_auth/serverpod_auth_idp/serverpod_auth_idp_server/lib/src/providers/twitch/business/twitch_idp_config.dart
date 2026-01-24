import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import 'twitch_idp.dart';
import 'twitch_idp_utils.dart';

/// Function to be called to check whether a Twitch account details match the
/// requirements during registration.
typedef TwitchAccountDetailsValidation =
    void Function(TwitchAccountDetails accountDetails);

/// Function to be called to extract additional information from Twitch APIs
/// using the access token. The [session] and [transaction] can be used to
/// store additional information in the database.
typedef GetExtraTwitchInfoCallback =
    Future<void> Function(
      Session session, {
      required TwitchAccountDetails accountDetails,
      required String accessToken,
      required Transaction? transaction,
    });

/// Configuration for the Twitch identity provider.
///
/// This class implements both [IdentityProviderBuilder] and [OAuth2PkceServerConfig]
/// for generic OAuth2 PKCE token exchange.
class TwitchIdpConfig extends IdentityProviderBuilder<TwitchIdp> {
  /// The OAuth credentials used for Twitch sign-in.
  final TwitchOAuthCredentials oauthCredentials;

  /// OAuth2 PKCE server config for Twitch.
  late final OAuth2PkceServerConfig oauth2Config;

  /// Validation function for Twitch account details.
  ///
  /// This function should throw an exception if the account details do not
  /// match the requirements. If the function returns normally, the account
  /// is considered valid.
  ///
  /// It can be used to enforce additional requirements on the Twitch account
  /// details before allowing the user to sign in. Note that Twitch users
  /// can keep their email private, so email may be null even for valid
  /// accounts. Similarly, the name field is optional.
  ///
  /// To avoid blocking real users with private profiles from signing in,
  /// adjust your validation function with care.
  final TwitchAccountDetailsValidation twitchAccountDetailsValidation;

  /// Callback that can be used with the access token to extract additional
  /// information from Twitch.
  ///
  /// This callback is invoked during [TwitchIdpUtils.fetchAccountDetails],
  /// before the system determines if the user is new or returning. It runs on
  /// EVERY authentication attempt.
  ///
  /// **CRITICAL - Do NOT create these models in the callback:**
  /// - [TwitchAccount] - Breaks new account detection
  /// - [UserProfile] - Interferes with automatic profile creation
  /// - [AuthUser] - Already handled by the authentication flow
  ///
  /// Creating these models will cause the authentication flow in [TwitchIdp.login]
  /// to fail or skip critical steps like user profile creation.
  ///
  /// **Safe usage:** Store data in your own custom tables, linked by
  /// [TwitchAccountDetails.userIdentifier]. Keep operations lightweight.
  final GetExtraTwitchInfoCallback? getExtraTwitchInfoCallback;

  /// Creates a new instance of [TwitchIdpConfig].
  TwitchIdpConfig({
    required this.oauthCredentials,
    this.twitchAccountDetailsValidation = validateTwitchAccountDetails,
    this.getExtraTwitchInfoCallback,
  }) : oauth2Config = OAuth2PkceServerConfig(
         tokenEndpointUrl: Uri.https('id.twitch.tv', '/oauth2/token'),
         clientId: oauthCredentials.clientId,
         clientSecret: oauthCredentials.clientSecret,
         credentialsLocation: OAuth2CredentialsLocation.body,
         parseTokenResponse: parseTokenResponse,
       );

  /// Default validation function for extracting additional Twitch account details.
  ///
  /// This default implementation accepts all accounts as Twitch's optional
  /// fields (email) are intentionally optional for user privacy.
  /// Override this if you need to enforce specific requirements.
  static void validateTwitchAccountDetails(
    final TwitchAccountDetails accountDetails,
  ) {
    if (accountDetails.userIdentifier.isEmpty) {
      throw TwitchUserInfoMissingDataException();
    }
  }

  /// Default Twitch access token parser for OAuth2PkceServerConfig.
  static TwitchTokenSuccess parseTokenResponse(
    final Map<String, dynamic> responseBody,
  ) {
    final error = responseBody['error'] as String?;
    if (error != null) {
      final errorDescription = responseBody['error_description'] as String?;
      throw OAuth2InvalidResponseException(
        'Invalid response from Twitch:'
        ' $error${errorDescription != null ? ' - $errorDescription' : ''}',
      );
    }

    final accessToken = responseBody['access_token'] as String?;
    if (accessToken == null) {
      throw const OAuth2MissingAccessTokenException(
        'No access token in Twitch response',
      );
    }

    final expiresIn = responseBody['expires_in'] as int;
    final refreshToken = responseBody['refresh_token'] as String;
    final scope = responseBody['scope'] as List<dynamic>;
    final tokenType = responseBody['token_type'] as String;

    return (
      accessToken: accessToken,
      expiresIn: expiresIn,
      refreshToken: refreshToken,
      scope: scope,
      tokenType: tokenType,
    );
  }

  @override
  TwitchIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return TwitchIdp(
      this,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Creates a new [TwitchIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
///
/// The following keys must be present in the `passwords.yaml` file:
/// - `twitchClientId`: The OAuth client ID from Twitch
/// - `twitchClientSecret`: The OAuth client secret from Twitch
///
/// Example `passwords.yaml`:
/// ```yaml
/// twitchClientId: 'your-twitch-oauth-client-id'
/// twitchClientSecret: 'your-twitch-oauth-client-secret'
/// ```
class TwitchIdpConfigFromPasswords extends TwitchIdpConfig {
  /// Creates a new [TwitchIdpConfigFromPasswords] instance.
  TwitchIdpConfigFromPasswords()
    : super(
        oauthCredentials: TwitchOAuthCredentials._(
          clientId: Serverpod.instance.getPasswordOrThrow('twitchClientId'),
          clientSecret: Serverpod.instance.getPasswordOrThrow(
            'twitchClientSecret',
          ),
        ),
      );
}

/// Contains the credentials of your Twitch Application.
/// The Twitch Application can be created from Twitch's console settings at:
/// https://dev.twitch.tv/console/apps
final class TwitchOAuthCredentials {
  /// The OAuth client ID from Twitch.
  final String clientId;

  /// The OAuth client secret from Twitch.
  final String clientSecret;

  /// Private constructor to initialize the object.
  const TwitchOAuthCredentials._({
    required this.clientId,
    required this.clientSecret,
  });

  /// Creates a new instance of [TwitchOAuthCredentials] from a JSON map.
  /// Expects the JSON to have the following structure:
  ///
  /// Example:
  /// {
  ///   "clientId": "your-twitch-oauth-client-id",
  ///   "clientSecret": "your-twitch-oauth-client-secret"
  /// }
  ///
  factory TwitchOAuthCredentials.fromJson(final Map<String, dynamic> json) {
    final clientId = json['clientId'] as String?;
    if (clientId == null) {
      throw const FormatException('Missing "clientId"');
    }

    final clientSecret = json['clientSecret'] as String?;
    if (clientSecret == null) {
      throw const FormatException('Missing "clientSecret"');
    }

    return TwitchOAuthCredentials._(
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }

  /// Creates a new instance of [TwitchOAuthCredentials] from a JSON string.
  /// The string is expected to follow the format described in
  /// [TwitchOAuthCredentials.fromJson].
  factory TwitchOAuthCredentials.fromJsonString(final String jsonString) {
    final data = jsonDecode(jsonString);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Not a JSON (map) object');
    }

    return TwitchOAuthCredentials.fromJson(data);
  }

  /// Creates a new instance of [TwitchOAuthCredentials] from a JSON file.
  /// The file is expected to follow the format described in
  /// [TwitchOAuthCredentials.fromJson].
  factory TwitchOAuthCredentials.fromJsonFile(final File file) {
    final jsonString = file.readAsStringSync();
    return TwitchOAuthCredentials.fromJsonString(jsonString);
  }
}
