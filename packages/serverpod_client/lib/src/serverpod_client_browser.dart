// ignore_for_file: avoid_print

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'serverpod_client_exception.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the http library
/// (for Flutter web).
abstract class ServerpodClient extends ServerpodClientShared {
  late http.Client _httpClient;
  bool _initialized = false;

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
  }) {
    _httpClient = http.Client();
  }

  Future<void> _initialize() async {
    _initialized = true;
  }

  @override
  Future<T> callServerEndpoint<T>(
      String endpoint, String method, Map<String, dynamic> args) async {
    if (!_initialized) await _initialize();

    var callContext = MethodCallContext(
      endpointName: endpoint,
      methodName: method,
      arguments: args,
    );
    String? data;
    try {
      var body =
          formatArgs(args, await authenticationKeyManager?.get(), method);
      var url = Uri.parse('$host$endpoint');

      var response = await _httpClient
          .post(
            url,
            body: body,
          )
          .timeout(connectionTimeout);

      data = response.body;

      if (response.statusCode != 200) {
        throw getExceptionFrom(
          data: data,
          serializationManager: serializationManager,
          statusCode: response.statusCode,
        );
      }

      T result;
      if (T == getType<void>()) {
        result = returnVoid() as T;
      } else {
        result = parseData<T>(data, T, serializationManager);
      }

      onSucceededCall?.call(callContext);
      return result;
    } catch (e, s) {
      onFailedCall?.call(callContext, e, s);

      if (e is http.ClientException) {
        var message = data ?? 'Unknown server response code. ($e)';
        throw (ServerpodClientException(message, -1));
      }

      if (logFailedCalls) {
        print('Failed call: $endpoint.$method');
        print('$e');
      }
      rethrow;
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
