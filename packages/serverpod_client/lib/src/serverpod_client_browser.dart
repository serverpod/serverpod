import 'dart:async';

import 'package:http/http.dart' as http;

import 'serverpod_client_exception.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the http library
/// (for Flutter web).
abstract class ServerpodClient extends ServerpodClientShared {
  late http.Client _httpClient;

  /// Creates a new ServerpodClient.
  ServerpodClient(
    super.host,
    super.serializationManager, {
    super.securityContext,
    super.authenticationKeyManager,
    super.logFailedCalls,
    super.streamingConnectionTimeout,
    super.connectionTimeout,
    super.onFailedCall,
    super.onSucceededCall,
    super.disconnectStreamsOnLostInternetConnection,
  }) {
    _httpClient = http.Client();
  }

  @override
  Future<String> callServerEndpointImpl<T>(
    Uri url, {
    required String body,
  }) async {
    try {
      var response = await _httpClient
          .post(
            url,
            body: body,
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
      throw (ServerpodClientException(message, -1));
    }
  }

  /// Sets the authorization key to manage user sign-ins.
  Future<void> setAuthorizationKey(String authorizationKey) async {
    if (authenticationKeyManager != null) {
      await authenticationKeyManager!.put(authorizationKey);
    }
  }

  /// Closes the connection to the server.
  @override
  void close() {
    _httpClient.close();
    super.close();
  }
}
