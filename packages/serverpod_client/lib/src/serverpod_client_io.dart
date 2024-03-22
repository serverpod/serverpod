// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'auth_key_manager.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the io library
/// (for Flutter native apps).
abstract class ServerpodClient extends ServerpodClientShared {
  late HttpClient _httpClient;
  bool _initialized = false;

  /// Creates a new ServerpodClient.
  ServerpodClient(
    String host,
    SerializationManager serializationManager, {
    dynamic context,
    AuthenticationKeyManager? authenticationKeyManager,
    bool logFailedCalls = true,
  }) : super(
          host,
          serializationManager,
          authenticationKeyManager: authenticationKeyManager,
          logFailedCalls: logFailedCalls,
        ) {
    assert(context == null || context is SecurityContext);

    // Setup client
    _httpClient = HttpClient(context: context);
    _httpClient.connectionTimeout = const Duration(seconds: 20);
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

      var response = await request.close(); // done instead of close() ?
      var data = await _readResponse(response);

      if (response.statusCode != HttpStatus.ok) {
        throw getExceptionFrom(
          data: data,
          serializationManager: serializationManager,
          statusCode: response.statusCode,
        );
      }

      if (T == getType<void>()) {
        return returnVoid() as T;
      } else {
        return parseData<T>(data, T, serializationManager);
      }
    } catch (e) {
      if (logFailedCalls) {
        print('Failed call: $endpoint.$method');
        print('$e');
      }

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
