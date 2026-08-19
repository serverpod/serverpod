import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// The type of transactional email to send via [ServerpodCloudEmailClient].
enum ServerpodCloudEmailType {
  /// Verification code for the email address verification during sign-up.
  signup('signup'),

  /// Verification code for a password reset ("lost password") flow.
  lostpassword('lostpassword')
  ;

  const ServerpodCloudEmailType(this.wireValue);

  /// The value sent in the `emailType` field of the request body.
  final String wireValue;
}

/// Thrown when the Serverpod Cloud email service rejects a send request or
/// responds with an unexpected status code.
class ServerpodCloudEmailException implements Exception {
  /// The HTTP status code returned by the service.
  final int statusCode;

  /// The error message returned by the service, if one could be parsed.
  final String? message;

  /// Creates a new [ServerpodCloudEmailException].
  ServerpodCloudEmailException(this.statusCode, this.message);

  @override
  String toString() =>
      'ServerpodCloudEmailException($statusCode): ${message ?? 'unknown error'}';
}

/// Client for the Serverpod Cloud transactional email service.
///
/// Sends sign-up and password-reset verification emails on behalf of a
/// Serverpod Cloud project by calling `POST {baseUrl}/api/email/send`.
class ServerpodCloudEmailClient {
  /// The default base URL of the Serverpod Cloud email service.
  static const defaultBaseUrl = 'https://emails.serverpod.dev';

  /// The default maximum time to wait for the service to respond.
  static const defaultTimeout = Duration(seconds: 30);

  /// The base URL of the email service.
  final String baseUrl;

  /// The maximum time to wait for the service to respond before failing.
  ///
  /// This bounds how long a send can block; relevant because the send is awaited
  /// inside the database transaction of the registration/password-reset flow.
  final Duration timeout;

  final http.Client _httpClient;

  /// Creates a new [ServerpodCloudEmailClient].
  ///
  /// Pass [httpClient] to inject a custom HTTP client (e.g. for testing),
  /// [baseUrl] to target a different service endpoint (defaults to
  /// [defaultBaseUrl]), and [timeout] to bound the request duration (defaults to
  /// [defaultTimeout]).
  ServerpodCloudEmailClient({
    this.baseUrl = defaultBaseUrl,
    this.timeout = defaultTimeout,
    final http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Sends a transactional email through the Serverpod Cloud email service.
  ///
  /// Throws a [ServerpodCloudEmailException] if the service does not respond
  /// with a `200` status code.
  Future<void> sendEmail({
    required final String token,
    required final ServerpodCloudEmailType emailType,
    required final String email,
    required final String projectName,
    required final String authCode,
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('$baseUrl/api/email/send'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'token': token,
            'emailType': emailType.wireValue,
            'email': email,
            'projectName': projectName,
            'authCode': authCode,
          }),
        )
        .timeout(timeout);

    if (response.statusCode == 200) {
      return;
    }

    throw ServerpodCloudEmailException(
      response.statusCode,
      _tryParseError(response.body),
    );
  }

  /// Closes the underlying HTTP client and frees its resources.
  void close() => _httpClient.close();

  static String? _tryParseError(final String body) {
    if (body.isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['error'] is String) {
        return decoded['error'] as String;
      }
    } catch (_) {
      // Body was not the expected `{"error": "..."}` shape; fall back to the
      // raw body below.
    }
    return body;
  }
}
