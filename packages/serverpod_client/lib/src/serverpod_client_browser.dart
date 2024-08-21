import 'dart:async';

import 'package:http/http.dart' as http;

import 'serverpod_client_exception.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

/// Handles communication with the server.
/// This is the concrete implementation using the http library
/// (for Flutter web).
class ServerpodClientRequestDelegateImpl
    extends ServerpodClientRequestDelegate {
  final ServerpodClientShared _client;
  late http.Client _httpClient;

  /// Creates a new ServerpodClientRequestDelegateImpl.
  ServerpodClientRequestDelegateImpl(ServerpodClientShared client)
      : _client = client {
    _httpClient = http.Client();
  }

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
  }) async {
    try {
      var response = await _httpClient
          .post(
            url,
            body: body,
          )
          .timeout(_client.connectionTimeout);

      var data = response.body;

      if (response.statusCode != 200) {
        throw getExceptionFrom(
          data: data,
          serializationManager: _client.serializationManager,
          statusCode: response.statusCode,
        );
      }

      return data;
    } on http.ClientException catch (e) {
      var message = 'Unknown server response code. ($e)';
      throw (ServerpodClientException(message, -1));
    }
  }

  /// Closes the connection to the server.
  @override
  void close() {
    _httpClient.close();
  }
}
