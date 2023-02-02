// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'auth_key_manager.dart';
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
    _httpClient = http.Client();
  }

  Future<void> _initialize() async {
    _initialized = true;
  }

  @override
  Future<T> callServerEndpoint<T>(
      String endpoint, String method, Map<String, dynamic> args) async {
    if (!_initialized) await _initialize();

    String? data;
    try {
      var body =
          formatArgs(args, await authenticationKeyManager?.get(), method);
      var url = Uri.parse('$host$endpoint');

      var response = await _httpClient.post(
        url,
        body: body,
      );

      data = response.body;

      if (response.statusCode != 200) {
        _checkForServerException(data);
        throw (ServerpodClientException(data, response.statusCode));
      }

      if (T == getType<void>()) {
        return returnVoid() as T;
      } else {
        return parseData<T>(data, T, serializationManager);
      }
    } catch (e) {
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

  void _checkForServerException(String? data) {
    Map<String, dynamic> json = _safeMap(data) ?? {};
    bool isException = json['exception'] ?? false;
    if (!isException) return;
    String className = json['className'] ?? '';
    const baseException = ServerpodException();
    if (className == baseException.runtimeType.toString()) {
      throw baseException;
    } else {
      throw serializationManager.deserializeByClassName(json);
    }
  }

  Map<String, dynamic>? _safeMap(String? data) {
    try {
      if (data == null) return null;
      return jsonDecode(data);
    } catch (e) {
      print(e);
      return null;
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
