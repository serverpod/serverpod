import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'serverpod_client_exception.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';
import 'auth_key_manager.dart';

class ServerpodClient extends ServerpodClientShared {
  late http.Client _httpClient;
  String? _authorizationKey;
  bool _initialized = false;

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

  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args) async {
    if (!_initialized)
      await _initialize();

    String? data;
    try {
      String body = formatArgs(args, _authorizationKey, method);
      Uri url = Uri.parse('$host$endpoint');

      http.Response response = await _httpClient.post(
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
        String message = data == null ? 'Likely internal server error.' : data;
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

  Future<Null> setAuthorizationKey(String authorizationKey) async {
    _authorizationKey = authorizationKey;

    if (authenticationKeyManager != null)
      await authenticationKeyManager!.put(authorizationKey);
  }

  void close() {
    _httpClient.close();
  }
}