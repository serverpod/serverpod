import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'auth_key_manager.dart';
import 'serverpod_client_exception.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

class ServerpodClient extends ServerpodClientShared {
  late HttpClient _httpClient;
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
    assert(context == null || context is SecurityContext);

    // Setup client
    _httpClient = HttpClient(context: context);
    _httpClient.connectionTimeout = Duration(seconds: 20);
    // TODO: Generate working certificates
    _httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) {
//      print('Failed to verify server certificate');
//      print('pem: ${cert.pem}');
//      print('subject: ${cert.subject}');
//      print('issuer: ${cert.issuer}');
//      print('valid from: ${cert.startValidity}');
//      print('valid to: ${cert.endValidity}');
//      print('host: $host');
//      print('port: $port');
//      return false;
      return true;
    });
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

      var request = await _httpClient.postUrl(url);
      request.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
      request.contentLength = utf8.encode(body).length;
      request.write(body);

      await request.flush();

      var response = await request.close(); // done instead of close() ?
      data = await _readResponse(response);

      if (response.statusCode != HttpStatus.ok) {
        throw(ServerpodClientException(data!, response.statusCode));
      }

      return parseData(data!, returnTypeName, serializationManager);
    }
    catch(e, stackTrace) {
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

  Future<dynamic> _readResponse(HttpClientResponse response) {
    var completer = Completer();
    var contents = StringBuffer();
    response.transform(Utf8Decoder()).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
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