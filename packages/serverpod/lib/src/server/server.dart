import 'dart:io';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'endpoint.dart';
import 'future_call.dart';
import 'future_call_manager.dart';
import 'runmode.dart';
import 'serverpod.dart';
import '../authentication/authentication_info.dart';
import '../cache/caches.dart';
import '../database/database.dart';
import '../generated/protocol.dart';

class Server {
  final endpoints = <String, Endpoint>{};

  final Serverpod serverpod;
  final int serverId;
  final int port;
  final String runMode;
  Database database;
  final SerializationManager serializationManager;
  final AuthenticationHandler authenticationHandler;
  final Caches caches;
  final String name;
  final SecurityContext securityContext;

  bool _running = false;
  bool get running => _running;
  
  HttpServer _httpServer;

  FutureCallManager _futureCallManager;

  Server({
    this.serverpod,
    @required this.serverId,
    @required this.port,
    @required this.serializationManager,
    this.database,
    Map<String, String> passwords,
    @required this.runMode,
    this.authenticationHandler,
    String name,
    this.caches,
    this.securityContext,
  }) :
    this.name = name ?? 'Server id $serverId'
  {
    if (runMode != ServerpodRunMode.generate) {
      // Setup future calls
      _futureCallManager = FutureCallManager(this, serializationManager);
    }
  }

  void addEndpoint(Endpoint endpoint, String name) {
    if (endpoints.containsKey(name))
      logWarning('Added endpoint with duplicate name ($name)');

    endpoint.initialize(this, name);
    endpoints[name] = endpoint;
  }

  void addFutureCall(FutureCall call, String name) {
    if (_futureCallManager != null)
      _futureCallManager.addFutureCall(call, name);
  }

  void callWithDelay(String callName, SerializableEntity object, Duration delay) {
    assert(_running, 'Server is not running, call start() before using future calls');
    _futureCallManager?.scheduleFutureCall(callName, object, DateTime.now().add(delay), serverId);
  }

  void start() async {
    if (securityContext != null) {
      HttpServer.bindSecure(InternetAddress.anyIPv6, port, securityContext).then((HttpServer httpServer) {
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
            logError(e.toString(), stackTrace: stackTrace);
          },
        ).onDone(() {
          logInfo('$name stopped');
        });
      },
      onError: (e, StackTrace stackTrace) {
        logError(e.toString(), stackTrace: stackTrace);
      });
    }
    else {
      HttpServer.bind(InternetAddress.anyIPv6, port).then((HttpServer httpServer) {
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
            logError(e.toString(), stackTrace: stackTrace);
          },
        ).onDone(() {
          logInfo('$name stopped');
        });
      },
      onError: (e, StackTrace stackTrace) {
        logError(e.toString(), stackTrace: stackTrace);
      });
    }

    // Start future calls
    _futureCallManager?.start();

    _running = true;
    logInfo('$name listening on port ${port}');
  }

  Future<Null> _handleRequest(HttpRequest request) async {
    Uri uri;

    try {
      uri = request.requestedUri;
    }
    catch(e) {
      if (serverpod.runtimeSettings.logMalformedCalls)
        logDebug('Malformed call, invalid uri from ${request.connectionInfo.remoteAddress.address}');

      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }

    if (uri.path == '/') {
      request.response.writeln('OK ${DateTime.now().toUtc()}');
      request.response.close();
      return;
    }

    // Check size of the request
    int contentLength = request.contentLength;
    if (contentLength == -1 || contentLength > serverpod.config.maxRequestSize) {
      if (serverpod.runtimeSettings.logMalformedCalls)
        logDebug('Malformed call, invalid content length ($contentLength): $uri');
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }

    String body;
    try {
      body = await request.transform(Utf8Decoder()).join();
    }
    catch (e, stackTrace) {
      logError(e, stackTrace: stackTrace);
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }

    var result = await _handleUriCall(uri, body);

    if (result is ResultInvalidParams) {
      if (serverpod.runtimeSettings.logMalformedCalls)
        logDebug('Malformed call: $result');
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }
    else if (result is ResultAuthenticationFailed) {
      if (serverpod.runtimeSettings.logMalformedCalls)
        logDebug('Access denied: $result');
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
    else {
      String serializedEntity = serializationManager.serializeEntity(result);
      request.response.write(serializedEntity);
      request.response.close();
      return;
    }
  }

  Future _handleUriCall(Uri uri, String body) async {
    String endpointName = uri.path.substring(1);
    Endpoint endpoint = endpoints[endpointName];

    if (endpoint == null)
      return ResultInvalidParams('Endpoint $endpointName does not exist in $uri');

    return endpoint.handleUriCall(uri, body);
  }

  void logDebug(String message) {
    serverpod.log(LogLevel.debug, message);
  }

  void logInfo(String message) {
    serverpod.log(LogLevel.info, message);
  }

  void logWarning(String warning, {StackTrace stackTrace}) {
    serverpod.log(LogLevel.warning, warning, stackTrace: stackTrace);
  }

  void logError(String error, {StackTrace stackTrace}) {
    serverpod.log(LogLevel.error, error, stackTrace: stackTrace);
  }

  void logFatal(String error, {StackTrace stackTrace}) {
    serverpod.log(LogLevel.fatal, error, stackTrace: stackTrace);
  }

  void shutdown() {
    _httpServer.close();
    _futureCallManager?.stop();
    _running = false;
  }
}