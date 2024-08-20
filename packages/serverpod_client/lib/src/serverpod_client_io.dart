// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_client/serverpod_client.dart';

import 'serverpod_client_shared_private.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the io library
/// (for Flutter native apps).
abstract class ServerpodClient extends ServerpodClientShared {
  late HttpClient _httpClient;

  /// Creates a new ServerpodClient.
  ServerpodClient(
    super.host,
    super.serializationManager, {
    dynamic securityContext,
    super.authenticationKeyManager,
    super.logFailedCalls,
    super.streamingConnectionTimeout,
    super.connectionTimeout,
    super.onFailedCall,
    super.onSucceededCall,
    super.disconnectStreamsOnLostInternetConnection,
  }) {
    assert(securityContext == null || securityContext is SecurityContext,
        'Context must be of type SecurityContext');

    // Setup client
    _httpClient = HttpClient(context: securityContext);
    _httpClient.connectionTimeout = connectionTimeout;
  }

  @override
  Future<String> callServerEndpointImpl<T>(
    Uri url, {
    required String body,
  }) async {
    var request = await _httpClient.postUrl(url);
    request.headers.contentType =
        ContentType('application', 'json', charset: 'utf-8');
    request.contentLength = utf8.encode(body).length;
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
    super.close();
  }
}
