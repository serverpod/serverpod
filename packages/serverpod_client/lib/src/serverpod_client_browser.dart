// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'serverpod_client_exception.dart';
import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the http library
/// (for Flutter web).
abstract class ServerpodClient extends ServerpodClientShared {
  final _dio = Dio();

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
  });

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

      var response = await _dio
          .post(
            '$host$endpoint',
            data: body,
          )
          .timeout(connectionTimeout);

      data = response.data.toString();

      if (response.statusCode != HttpStatus.ok) {
        throw getExceptionFrom(
          data: data,
          serializationManager: serializationManager,
          statusCode: response.statusCode ?? HttpStatus.badRequest,
        );
      }

      if (T == getType<void>()) {
        return returnVoid() as T;
      } else {
        return parseData<T>(data, T, serializationManager);
      }
    } catch (e) {
      if (e is DioException) {
        var message = data ?? 'Unknown server response code. ($e)';
        throw (ServerpodClientException(message, e.response?.statusCode ?? -1));
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
    _dio.close();
    super.close();
  }
}
