import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'auth_key_manager.dart';

typedef void ServerpodClientErrorCallback(Error e);

class ServerpodClient {
  final AuthenticationKeyManager authenticationKeyManager;

  final String host;
  final SerializationManager serializationManager;
  HttpClient _httpClient;
  String _authorizationKey;
  bool _initialized = false;
  ServerpodClientErrorCallback errorHandler;

  ServerpodClient(this.host, this.serializationManager, {SecurityContext context, this.errorHandler, this.authenticationKeyManager}) {
    _httpClient = HttpClient(context: context);
    _httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) {
      print('Failed to verify server certificate');
      print('pem: ${cert.pem}');
      print('subject: ${cert.subject}');
      print('issuer: ${cert.issuer}');
      print('valid from: ${cert.startValidity}');
      print('valid to: ${cert.endValidity}');
      print('host: $host');
      print('port: $port');
      return false;
    });
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

      HttpClientRequest request = await _httpClient.postUrl(url);
      request.contentLength = utf8.encode(body).length;
      request.write(body);

      await request.flush();

      HttpClientResponse response = await request.close(); // done instead of close() ?
      String data = await _readResponse(response);

      // TODO: Support more types!
      if (returnTypeName == 'int')
        return int.tryParse(data);
      else if (returnTypeName == 'String')
        return data;

      return serializationManager.createEntityFromSerialization(
          jsonDecode(data));
    }
    catch(e) {
      if (errorHandler != null)
        errorHandler(e);
      else
        rethrow;
    }
  }

  Future<dynamic> _readResponse(HttpClientResponse response) {
    var completer = new Completer();
    var contents = new StringBuffer();
    response.transform(Utf8Decoder()).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
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