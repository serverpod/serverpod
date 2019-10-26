import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'auth_key_manager.dart';

typedef void ServerpodClientErrorCallback(var e, StackTrace stackTrace);

class ServerpodClient {
  final AuthenticationKeyManager authenticationKeyManager;

  final String host;
  final SerializationManager serializationManager;
  http.Client _httpClient;
  String _authorizationKey;
  bool _initialized = false;
  ServerpodClientErrorCallback errorHandler;

  ServerpodClient(this.host, this.serializationManager, {this.errorHandler, this.authenticationKeyManager, dynamic context}) {
    _httpClient = http.Client();
    assert(host.endsWith('/'), 'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'), 'host must include protocol, eg: https://example.com/');
  }

  Future<Null> _initialize() async {
    if (authenticationKeyManager != null)
      _authorizationKey = await authenticationKeyManager.get();

    _initialized = true;
  }

  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args) async {
    if (!_initialized)
      await _initialize();

    String data;
    try {
      var formattedArgs = <String, String>{};

      for (var argName in args.keys) {
        var value = args[argName];
        if (value != null) {
          formattedArgs[argName] = value.toString();
        }
      }

      if (_authorizationKey != null)
        formattedArgs['auth'] = _authorizationKey;

      formattedArgs['method'] = method;

      String body = jsonEncode(formattedArgs);

      Uri url = Uri.parse('$host$endpoint');

      print('POST');
      print('url: $url');
      print('body: $body');

      http.Response response = await _httpClient.post(
        url,
        body: body,
      );

      print('response status: ${response.statusCode}');
      print('response body: ${response.body}');

      String data = response.body;

      // TODO: Support more types!
      if (returnTypeName == 'int')
        return int.tryParse(data);
      else if (returnTypeName == 'String')
        return data;

      return serializationManager.createEntityFromSerialization(
          jsonDecode(data));
    }
    catch(e, stackTrace) {
      print('Failed call: $endpoint.$method');
      print('data: $data');

      if (errorHandler != null)
        errorHandler(e, stackTrace);
      else
        rethrow;
    }
  }

  Future<Null> setAuthorizationKey(String authorizationKey) async {
    _authorizationKey = authorizationKey;

    if (authenticationKeyManager != null)
      await authenticationKeyManager.put(authorizationKey);
  }

  void close() {
    _httpClient.close();
  }
}