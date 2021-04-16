import 'dart:io';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'endpoint_dispatch.dart';
import 'future_call.dart';
import 'future_call_manager.dart';
import 'serverpod.dart';
import '../authentication/authentication_info.dart';
import '../cache/caches.dart';
import '../database/database_config.dart';
import 'package:serverpod/src/server/health_check.dart';

class Server {
  final Serverpod serverpod;
  final int serverId;
  final int port;
  final String runMode;
  DatabaseConfig databaseConnection;
  final SerializationManager serializationManager;
  final AuthenticationHandler? authenticationHandler;
  final Caches caches;
  final String name;
  final SecurityContext? securityContext;
  final EndpointDispatch endpoints;

  bool _running = false;
  bool get running => _running;
  
  late final HttpServer _httpServer;
  HttpServer get httpServer => _httpServer;

  late final FutureCallManager _futureCallManager;

  List<String>? whitelistedExternalCalls;

  Server({
    required this.serverpod,
    required this.serverId,
    required this.port,
    required this.serializationManager,
    required this.databaseConnection,
    Map<String, String>? passwords,
    required this.runMode,
    this.authenticationHandler,
    String? name,
    required this.caches,
    this.securityContext,
    this.whitelistedExternalCalls,
    required this.endpoints,
  }) :
    this.name = name ?? 'Server id $serverId'
  {
    // Setup future calls
    _futureCallManager = FutureCallManager(this, serializationManager);
  }

  void registerFutureCall(FutureCall call, String name) {
    _futureCallManager.addFutureCall(call, name);
  }

  void callWithDelay(String callName, SerializableEntity? object, Duration delay) {
    assert(_running, 'Server is not running, call start() before using future calls');
    _futureCallManager.scheduleFutureCall(callName, object, DateTime.now().add(delay), serverId);
  }

  Future<void> start() async {
    if (securityContext != null) {
      HttpServer.bindSecure(InternetAddress.anyIPv6, port, securityContext!).then(
      _runServer,
      onError: (e, StackTrace stackTrace) {
        stderr.writeln('Internal server error.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      });
    }
    else {
      HttpServer.bind(InternetAddress.anyIPv6, port).then(
      _runServer,
      onError: (e, StackTrace stackTrace) {
        stderr.writeln('Internal server error.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      });
    }

    // Start future calls
    _futureCallManager.start();

    _running = true;
    print('$name listening on port ${port}');
  }

  void _runServer(HttpServer httpServer) {
    _httpServer = httpServer;
    httpServer.autoCompress = true;
    httpServer.listen(
          (HttpRequest request) {
        try {
          _handleRequest(request);
        }
        catch(e, t) {
          print(e);
          print(t);
        }
      },
      onError: (e, StackTrace stackTrace) {
        stderr.writeln('Internal server error.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      },
    ).onDone(() {
      print('$name stopped');
    });
  }

  Future<void> _handleRequest(HttpRequest request) async {
    Uri uri;

    try {
      uri = request.requestedUri;
    }
    catch(e) {
      if (serverpod.runtimeSettings.logMalformedCalls)
        print('Malformed call, invalid uri from ${request.connectionInfo!.remoteAddress.address}');

      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }

    if (uri.path == '/') {
      // Perform health checks
      var checks = await performHealthChecks(this.serverpod);
      var issues = <String>[];
      var allOk = true;
      for (var metric in checks.metrics) {
        if (!metric.isHealthy) {
          allOk = false;
          issues.add('${metric.name}: ${metric.value}');
        }
      }

      if (allOk)
        request.response.writeln('OK ${DateTime.now().toUtc()}');
      else
        request.response.writeln('SADNESS ${DateTime.now().toUtc()}');
      for (var issue in issues)
        request.response.writeln(issue);

      request.response.close();
      return;
    }

    // TODO: Limit check external calls
//    bool checkLength = true;
//    if (whitelistedExternalCalls != null && whitelistedExternalCalls.contains(uri.path))
//      checkLength = false;
//
//    if (checkLength) {
//      // Check size of the request
//      int contentLength = request.contentLength;
//      if (contentLength == -1 ||
//          contentLength > serverpod.config.maxRequestSize) {
//        if (serverpod.runtimeSettings.logMalformedCalls)
//          logDebug('Malformed call, invalid content length ($contentLength): $uri');
//        request.response.statusCode = HttpStatus.badRequest;
//        request.response.close();
//        return;
//      }
//    }

    String? body;
    try {
      body = await _readBody(request);
    }
    catch (e, stackTrace) {
      stderr.writeln('Internal server error.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }

    var result = await _handleUriCall(uri, body!, request);

    if (result is ResultInvalidParams) {
      if (serverpod.runtimeSettings.logMalformedCalls)
        print('Malformed call: $result');
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }
    else if (result is ResultAuthenticationFailed) {
      if (serverpod.runtimeSettings.logMalformedCalls)
        print('Access denied: $result');
      request.response.statusCode = HttpStatus.forbidden;
      request.response.close();
      return;
    }
    else if (result is ResultInternalServerError) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.writeln('Internal server error. Call log id: ${result.sessionLogId}');
      request.response.close();
      return;
    }
    else if (result is ResultStatusCode) {
      request.response.statusCode = result.statusCode;
      request.response.close();
      return;
    }
    else {
      String? serializedEntity = serializationManager.serializeEntity(result);
      request.response.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.write(serializedEntity);
      request.response.close();
      return;
    }
  }

  Future<String?> _readBody(HttpRequest request) async {
    // TODO: Find more efficient solution?
    int len = 0;
    List<int> data = [];
    await for (var segment in request) {
      len += segment.length;
      if (len > serverpod.config.maxRequestSize!)
        return null;
      data += segment;
    }
    return Utf8Decoder().convert(data);
  }

  Future _handleUriCall(Uri uri, String body, HttpRequest request) async {
    String endpointName = uri.path.substring(1);
    return endpoints.handleUriCall(this, endpointName, uri, body, request);
  }

  void shutdown() {
    _httpServer.close();
    _futureCallManager.stop();
    _running = false;
  }
}