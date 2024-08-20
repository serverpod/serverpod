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
  final ServerpodClientShared _client;
  late HttpClient _httpClient;

  /// Creates a new ServerpodClientRequestDelegateImpl.
  ServerpodClientRequestDelegateImpl(ServerpodClientShared client)
      : _client = client {
    assert(
        _client.securityContext == null ||
            _client.securityContext is SecurityContext,
        'Context must be of type SecurityContext');

    // Setup client
    _httpClient = HttpClient(context: _client.securityContext);
    _httpClient.connectionTimeout = _client.connectionTimeout;
  }

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
  }) async {
    var request = await _httpClient.postUrl(url);
    request.headers.contentType =
        ContentType('application', 'json', charset: 'utf-8');
    request.contentLength = utf8.encode(body).length;
    request.write(body);

    await request.flush();

    var response = await request.close().timeout(_client.connectionTimeout);

    var data = await _readResponse(response);

    if (response.statusCode != HttpStatus.ok) {
      throw getExceptionFrom(
        data: data,
        serializationManager: _client.serializationManager,
        statusCode: response.statusCode,
      );
    }

    return data;
  }

  Future<String> _readResponse(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(const Utf8Decoder()).listen((String data) {
      contents.write(data);
    }, onDone: () //
        {
      return completer.complete(contents.toString());
    });
    return completer.future;
  }

  @override
  void close() {
    _httpClient.close();
  }
}
