// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'serverpod_client_shared.dart';
import 'serverpod_client_shared_private.dart';

/// Handles communication with the server. Is typically overridden by
/// generated code to provide implementations of methods for calling the server.
/// This is the concrete implementation using the io library
/// (for Flutter native apps).
abstract class ServerpodClient extends ServerpodClientShared {
  final _dio = Dio();
  bool _initialized = false;

  /// Creates a new ServerpodClient.
  ServerpodClient(
    super.host,
    super.serializationManager, {
    dynamic securityContext,
    super.authenticationKeyManager,
    super.logFailedCalls,
    super.streamingConnectionTimeout,
    super.connectionTimeout,
  }) {
    assert(securityContext == null || securityContext is SecurityContext,
        'Context must be of type SecurityContext');

    // Setup client
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        var httpClient = HttpClient(context: securityContext);

        // TODO: Generate working certificates
        httpClient.badCertificateCallback =
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
          return true;
        });
        return httpClient;
      },
    );
    _dio.options.connectTimeout = connectionTimeout;
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

      var response = await _dio
          .post(
            '$host$endpoint',
            data: body,
            options: Options(
              contentType: 'application/json; charset=utf-8',
              headers: {Headers.contentLengthHeader: body.length},
              // Don't parse the JSON response, allow Serverpod to do it
              responseType: ResponseType.plain,
            ),
          )
          .timeout(connectionTimeout);

      var data = response.data.toString();

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
      if (logFailedCalls) {
        print('Failed call: $endpoint.$method');
        print('$e');
      }

      rethrow;
    }
  }

  @override
  void close() {
    _dio.close();
    super.close();
  }
}
