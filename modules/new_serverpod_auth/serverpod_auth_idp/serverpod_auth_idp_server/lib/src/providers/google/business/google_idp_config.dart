import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

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

/// Configuration for the Google identity provider.
class GoogleIDPConfig {
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

  /// Creates a new instance of [GoogleIDPConfig].
  GoogleIDPConfig({
    required this.clientSecret,
    this.googleAccountDetailsValidation = validateGoogleAccountDetails,
    this.getExtraGoogleInfoCallback,
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
