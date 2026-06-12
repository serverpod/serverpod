import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../common/id_token_verifier/id_token_verifier_config.dart';
import '../../../utils/get_passwords_extension.dart';
import 'google_idp.dart';
import 'google_idp_utils.dart';

/// Function to be called to check whether a Google account details match the
/// requirements during registration.
typedef GoogleAccountDetailsValidation =
    void Function(
      GoogleAccountDetails accountDetails,
    );

/// Function to be called to extract additional information from Google APIs
/// using the access token. The [session] and [transaction] can be used to
/// store additional information in the database.
typedef GetExtraGoogleInfoCallback =
    Future<void> Function(
      Session session, {
      required GoogleAccountDetails accountDetails,
      required String accessToken,
      required Transaction? transaction,
    });

/// Callback to be invoked after a new Google account has been created and
/// linked to an auth user. The [session] and [transaction] can be used to
/// perform additional database operations.
typedef AfterGoogleAccountCreatedFunction =
    FutureOr<void> Function(
      Session session,
      AuthUserModel authUser,
      GoogleAccount googleAccount, {
      required Transaction? transaction,
    });

/// Configuration for the Google identity provider.
class GoogleIdpConfig extends IdentityProviderBuilder<GoogleIdp> {
  /// The client secret used for the Google sign-in.
  final GoogleClientSecret clientSecret;

  /// Validation function for Google account details.
  ///
  /// This function should throw an exception if the account details do not
  /// match the requirements. If the function returns normally, the account
  /// is considered valid.
  ///
  /// It can be used to enforce additional requirements on the Google account
  /// details before allowing the user to sign in. These details will be
  /// extracted using the `people` API and may not be available if the user has
  /// not granted the app access to their profile or if the user is part of an
  /// organization that has restricted access to the profile information. Note
  /// that even `verifiedEmail` is not guaranteed to be true (e.g. accounts
  /// created from developers.google.com).
  ///
  /// To avoid blocking real users (from privacy-restricted workspaces, accounts
  /// without avatars, unverified secondary emails) from signing in, adjust your
  /// validation function with care.
  final GoogleAccountDetailsValidation googleAccountDetailsValidation;

  /// Callback that can be used with the access token to extract additional
  /// information from Google APIs.
  final GetExtraGoogleInfoCallback? getExtraGoogleInfoCallback;

  /// Callback to be invoked after a new Google account has been created
  /// and linked to an auth user.
  ///
  /// This can be used to perform additional setup tasks after the Google
  /// account has been created and linked.
  final AfterGoogleAccountCreatedFunction? onAfterGoogleAccountCreated;

  /// Tolerance for clock skew when validating Google ID token timestamps.
  final Duration clockSkewTolerance;

  /// Creates a new instance of [GoogleIdpConfig].
  const GoogleIdpConfig({
    required this.clientSecret,
    this.googleAccountDetailsValidation = validateGoogleAccountDetails,
    this.getExtraGoogleInfoCallback,
    this.onAfterGoogleAccountCreated,
    this.clockSkewTolerance = defaultIdTokenClockSkewTolerance,
  });

  /// Default validation function for extracted Google account details.
  static void validateGoogleAccountDetails(
    final GoogleAccountDetails accountDetails,
  ) {
    if (accountDetails.name == null ||
        accountDetails.fullName == null ||
        accountDetails.verifiedEmail != true) {
      throw GoogleUserInfoMissingDataException();
    }
  }

  /// Parses Google's OAuth2 token response.
  ///
  /// Google returns a JSON object containing `access_token` and `id_token`
  /// fields when the `openid` scope is requested. The `id_token` is preserved
  /// in [OAuth2PkceTokenResponse.raw] for subsequent JWKS verification.
  static OAuth2PkceTokenResponse parseTokenResponse(
    final Map<String, dynamic> responseBody,
  ) {
    final error = responseBody['error'] as String?;
    if (error != null) {
      final description = responseBody['error_description'] as String?;
      throw OAuth2InvalidResponseException(
        'Google OAuth error: $error'
        '${description != null ? ' - $description' : ''}',
      );
    }

    final accessToken = responseBody['access_token'] as String?;
    if (accessToken == null) {
      throw const OAuth2MissingAccessTokenException(
        'Missing access_token in Google token response',
      );
    }

    return OAuth2PkceTokenResponse(accessToken: accessToken, raw: responseBody);
  }

  @override
  GoogleIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return GoogleIdp(
      this,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }

  /// OAuth2 PKCE server configuration for the web sign-in flow.
  ///
  /// Used by [GoogleIdpUtils.exchangeCodeForToken] to exchange an authorization
  /// code received from the browser for Google access and ID tokens.
  OAuth2PkceServerConfig get oauth2PkceServerConfig => OAuth2PkceServerConfig(
    tokenEndpointUrl: Uri.https('oauth2.googleapis.com', '/token'),
    clientId: clientSecret.clientId,
    clientSecret: clientSecret.clientSecret,
    credentialsLocation: OAuth2CredentialsLocation.body,
    parseTokenResponse: parseTokenResponse,
  );
}

/// Creates a new [GoogleIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
class GoogleIdpConfigFromPasswords extends GoogleIdpConfig {
  /// Creates a new [GoogleIdpConfigFromPasswords] instance.
  GoogleIdpConfigFromPasswords({
    super.googleAccountDetailsValidation,
    super.getExtraGoogleInfoCallback,
    super.onAfterGoogleAccountCreated,
    super.clockSkewTolerance,
  }) : super(
         clientSecret: GoogleClientSecret.fromJsonString(
           Serverpod.instance.getPasswordOrThrow('googleClientSecret'),
         ),
       );
}

/// Contains information about the credentials for the server to access Google's
/// APIs. The secrets are typically loaded from
/// `config/google_client_secret.json`. The file can be downloaded from Google's
/// cloud console.
final class GoogleClientSecret {
  /// The client identifier.
  final String clientId;

  /// The client secret.
  final String clientSecret;

  /// List of redirect uris.
  final List<String> redirectUris;

  /// Private constructor to initialize the object.
  GoogleClientSecret._({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUris,
  });

  /// Creates a new instance of [GoogleClientSecret] from a JSON map.
  /// Expects the JSON to match the structure of the file downloaded from
  /// Google's cloud console.
  ///
  /// Example:
  /// {
  ///   "web": {
  ///     "client_id": "your-client-id.apps.googleusercontent.com",
  ///     "client_secret": "your-client-secret",
  ///     "redirect_uris": [
  ///       "http://localhost:8080/auth/google/callback",
  ///       "https://your-production-domain.com/auth/google/callback"
  ///     ]
  ///     ...
  /// }
  ///
  factory GoogleClientSecret.fromJson(final Map<String, dynamic> json) {
    if (json['web'] == null) {
      throw const FormatException('Missing "web" section');
    }

    final web = json['web'] as Map;

    final webClientId = web['client_id'] as String?;
    if (webClientId == null) {
      throw const FormatException('Missing "client_id"');
    }

    final webClientSecret = web['client_secret'] as String?;
    if (webClientSecret == null) {
      throw const FormatException('Missing "client_secret"');
    }

    final webRedirectUris = web['redirect_uris'] as List<dynamic>?;
    if (webRedirectUris == null) {
      throw const FormatException('Missing "redirect_uris"');
    }

    return GoogleClientSecret._(
      clientId: webClientId,
      clientSecret: webClientSecret,
      redirectUris: webRedirectUris.cast<String>(),
    );
  }

  /// Creates a new instance of [GoogleClientSecret] from a JSON string.
  /// The string is expected to follow the format described in
  /// [GoogleClientSecret.fromJson].
  factory GoogleClientSecret.fromJsonString(final String jsonString) {
    final data = jsonDecode(jsonString);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Not a JSON (map) object');
    }

    return GoogleClientSecret.fromJson(data);
  }

  /// Creates a new instance of [GoogleClientSecret] from a JSON file.
  /// The file is expected to follow the format described in
  /// [GoogleClientSecret.fromJson].
  factory GoogleClientSecret.fromJsonFile(final File file) {
    final jsonString = file.readAsStringSync();
    return GoogleClientSecret.fromJsonString(jsonString);
  }
}
