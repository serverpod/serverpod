import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'serverpod_client_exception.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';
import 'auth_key_manager.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the http library
/// (for Flutter web).
abstract class ServerpodClient extends ServerpodClientShared {
  late http.Client _httpClient;
  String? _authorizationKey;
  bool _initialized = false;

  /// Creates a new ServerpodClient.
  ServerpodClient(String host, SerializationManager serializationManager, {
    dynamic context,
    ServerpodClientErrorCallback? errorHandler,
    AuthenticationKeyManager? authenticationKeyManager,
    bool logFailedCalls=true,
  }) : super(host, serializationManager,
    errorHandler: errorHandler,
    authenticationKeyManager: authenticationKeyManager,
    logFailedCalls: logFailedCalls,
  ) {
    _httpClient = http.Client();
  }

  Future<Null> _initialize() async {
    if (authenticationKeyManager != null)
      _authorizationKey = await authenticationKeyManager!.get();

    _initialized = true;
  }

  @override
  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args) async {
    if (!_initialized)
      await _initialize();

    String? data;
    try {
      var body = formatArgs(args, _authorizationKey, method);
      var url = Uri.parse('$host$endpoint');

      var response = await _httpClient.post(
        url,
        body: body,
      );

      data = response.body;

      if (response.statusCode != 200) {
        throw(ServerpodClientException(data, response.statusCode));
      }

      return parseData(data, returnTypeName, serializationManager);
    }
    catch(e, stackTrace) {
      if (e is http.ClientException) {
        print('Failed call: $endpoint.$method');
        var message = data ?? 'Likely internal server error.';
        print(message);
        throw(ServerpodClientException(message, 500));
      }

      if (logFailedCalls) {
        print('Failed call: $endpoint.$method');
        print('$e');
      }

      if (errorHandler != null)
        errorHandler!(e, stackTrace);
      else
        rethrow;
    }
  }

  /// Sets the authorization key to manage user sign-ins.
  Future<Null> setAuthorizationKey(String authorizationKey) async {
    _authorizationKey = authorizationKey;

    if (authenticationKeyManager != null)
      await authenticationKeyManager!.put(authorizationKey);
  }

  /// Closes the connection to the server.
  void close() {
    _httpClient.close();
  }
}