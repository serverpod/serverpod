import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:serverpod_client/serverpod_client.dart';

import 'serverpod_client_shared_private.dart';

/// Handles communication with the server.
/// This is the concrete implementation using the io library
/// (for Flutter native apps).
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
    assert(
      securityContext == null || securityContext is SecurityContext,
      'Context must be of type SecurityContext',
    );
    assert(
      httpClientOverride == null || securityContext == null,
      'httpClientOverride and securityContext cannot both be set. '
      'Configure the security context on the httpClientOverride directly.',
    );

    if (httpClientOverride != null) {
      _httpClient = httpClientOverride;
    } else {
      final inner = HttpClient(context: securityContext as SecurityContext?);
      inner.connectionTimeout = connectionTimeout;
      _httpClient = IOClient(inner);
    }
  }

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
  }) async {
    try {
      final response = await _httpClient
          .post(
            url,
            body: body,
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.toString(),
              HttpHeaders.authorizationHeader: ?authenticationValue,
            },
          )
          .timeout(connectionTimeout);

      final data = response.body;

      if (response.statusCode != HttpStatus.ok) {
        throw getExceptionFrom(
          data: data,
          serializationManager: serializationManager,
          statusCode: response.statusCode,
        );
      }

      return data;
    } on SocketException catch (e) {
      throw ServerpodClientException(e.toString(), -1);
    } on http.ClientException catch (e) {
      var message = 'Unknown server response code. ($e)';
      throw ServerpodClientException(message, -1);
    }
  }

  @override
  void close() {
    _httpClient.close();
  }
}
