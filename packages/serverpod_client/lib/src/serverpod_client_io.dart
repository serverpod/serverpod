// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the io library
/// (for Flutter native apps).
abstract class ServerpodClient extends ServerpodClientShared {
  late HttpClient _httpClient;
  bool _initialized = false;
  void Function(Object error)? _onFailedCall;
  void Function()? _onSucceededCall;

  /// Creates a new ServerpodClient.
  ServerpodClient(
    super.host,
    super.serializationManager, {
    dynamic securityContext,
    super.authenticationKeyManager,
    super.logFailedCalls,
    super.streamingConnectionTimeout,
    super.connectionTimeout,
    void Function(Object error)? onFailedCall,
    void Function()? onSucceededCall,
  }) {
    assert(securityContext == null || securityContext is SecurityContext,
        'Context must be of type SecurityContext');
    _onFailedCall = onFailedCall;
    _onSucceededCall = onSucceededCall;

    // Setup client
    _httpClient = HttpClient(context: securityContext);
    _httpClient.connectionTimeout = connectionTimeout;

    // TODO: Generate working certificates
    _httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
//      print('Failed to verify server certificate');
//      print('pem: ${cert.pem}');
//      print('subject: ${cert.subject}');
//      print('issuer: ${cert.issuer}');
//      print('valid from: ${cert.startValidity}');
//      print('valid to: ${cert.endValidity}');
//      print('host: $host');
//      print('port: $port');
//      return false;
      if (logFailedCalls) {
        print('Failed to verify server certificate');
      }
      _onFailedCall?.call(Exception('Failed to verify server certificate'));
      return true;
    });
  }

  Future<void> _initialize() async {
    _initialized = true;
  }

  @override
  Future<T> callServerEndpoint<T>(
      String endpoint, String method, Map<String, dynamic> args) async {
    if (!_initialized) await _initialize();

    try {
      var body =
          formatArgs(args, await authenticationKeyManager?.get(), method);

      var url = Uri.parse('$host$endpoint');

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

      T result;
      if (T == getType<void>()) {
        result = returnVoid() as T;
      } else {
        result = parseData<T>(data, T, serializationManager);
      }
      _onSucceededCall?.call();
      return result;
    } catch (e) {
      if (logFailedCalls) {
        print('Failed call: $endpoint.$method');
        print('$e');
      }
      _onFailedCall?.call(e);

      rethrow;
    }
  }

  Future<String> _readResponse(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(const Utf8Decoder()).listen((String data) {
      contents.write(data);
    }, onDone: () //
        {
      var result = completer.complete(contents.toString());
      _onSucceededCall?.call();
      return result;
    }, onError: (e) {
      if (logFailedCalls) {
        print('Request failed with response code: ${response.statusCode}');
        print('$e');
      }
      _onFailedCall?.call(e);
    });
    return completer.future;
  }

  @override
  void close() {
    _httpClient.close();
    super.close();
  }
}
