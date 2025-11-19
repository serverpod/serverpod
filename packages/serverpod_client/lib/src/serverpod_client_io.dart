import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  late HttpClient _httpClient;

  /// Creates a new ServerpodClientRequestDelegateImpl.
  ServerpodClientRequestDelegateImpl({
    required this.connectionTimeout,
    required this.serializationManager,
    dynamic securityContext,
  }) {
    assert(
      securityContext == null || securityContext is SecurityContext,
      'Context must be of type SecurityContext',
    );

    // Setup client
    _httpClient = HttpClient(context: securityContext);
    _httpClient.connectionTimeout = connectionTimeout;
  }

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
  }) async {
    try {
      var request = await _httpClient.postUrl(url);
      request.headers.contentType = ContentType(
        'application',
        'json',
        charset: 'utf-8',
      );
      request.contentLength = utf8.encode(body).length;
      if (authenticationValue != null) {
        request.headers.add(
          HttpHeaders.authorizationHeader,
          authenticationValue,
        );
      }
      request.write(body);

      await request.flush();

      var response = await request.close().timeout(connectionTimeout);

      var data = await _readResponse(response);

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
    }
  }

  Future<String> _readResponse(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response
        .transform(const Utf8Decoder())
        .listen(
          (String data) {
            contents.write(data);
          },
          onDone:
              () //
              {
                return completer.complete(contents.toString());
              },
        );
    return completer.future;
  }

  @override
  void close() {
    _httpClient.close();
  }
}
