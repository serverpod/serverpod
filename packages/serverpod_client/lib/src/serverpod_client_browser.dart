import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_client/serverpod_client.dart';

import 'serverpod_client_shared_private.dart';

/// Handles communication with the server.
/// This is the concrete implementation using the http library
/// (for Flutter web).
class ServerpodClientRequestDelegateImpl
    extends ServerpodClientRequestDelegate {
  /// The timeout for the connection and the requests.
  final Duration connectionTimeout;

  /// The serialization manager used to serialize and deserialize data.
  final SerializationManager serializationManager;

  late http.Client _httpClient;

  /// Creates a new ServerpodClientRequestDelegateImpl.
  ServerpodClientRequestDelegateImpl({
    required this.connectionTimeout,
    required this.serializationManager,
    dynamic securityContext,
    http.Client? httpClientOverride,
  }) {
    _httpClient = httpClientOverride ?? http.Client();
  }

  @override
  bool get supportsCookieAuth => true;

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
    bool useCookieAuth = false,
  }) async {
    try {
      if (useCookieAuth) {
        // Send the auth cookie with the request and accept Set-Cookie back.
        var client = _httpClient;
        if (client is BrowserClient) client.withCredentials = true;
      }
      var response = await _httpClient
          .post(
            url,
            body: body,
            headers: {
              'authorization': ?authenticationValue,
              if (useCookieAuth) webAuthModeHeaderName: webAuthModeCookie,
            },
          )
          .timeout(connectionTimeout);

      var data = response.body;

      if (response.statusCode != 200) {
        throw getExceptionFrom(
          data: data,
          serializationManager: serializationManager,
          statusCode: response.statusCode,
        );
      }

      return data;
    } on http.ClientException catch (e) {
      var message = 'Unknown server response code. ($e)';
      throw ServerpodClientException(message, -1);
    }
  }

  /// Closes the connection to the server.
  @override
  void close() {
    _httpClient.close();
  }
}
