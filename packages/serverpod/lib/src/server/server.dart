import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/health_check.dart';

import '../cache/caches.dart';

/// Handling incoming calls and routing them to the correct [Endpoint]
/// methods.
class Server {
  /// The [Serverpod] managing the server.
  final Serverpod serverpod;

  /// The id of the server. If running in a cluster, all servers need unique
  /// ids.
  final String serverId;

  /// Port the server is listening on.
  final int port;

  /// The [ServerpodRunMode] the server is running in.
  final String runMode;

  /// Current database configuration.
  DatabasePoolManager databaseConfig;

  /// The [SerializationManager] used by the server.
  final SerializationManager serializationManager;

  /// [AuthenticationHandler] responsible for authenticating users.
  final AuthenticationHandler? authenticationHandler;

  /// Caches used by the server.
  final Caches caches;

  /// The name of the server.
  final String name;

  /// Security context if the server is running over https.
  final SecurityContext? securityContext;

  /// Responsible for dispatching calls to the correct [Endpoint] methods.
  final EndpointDispatch endpoints;

  bool _running = false;

  /// True if the server is currently running.
  bool get running => _running;

  late final HttpServer _httpServer;

  /// The [HttpServer] responsible for handling calls.
  HttpServer get httpServer => _httpServer;

  /// Currently not in use.
  List<String>? whitelistedExternalCalls;

  /// Map of passwords loaded from config/passwords.yaml
  Map<String, String> passwords;

  /// Central message dispatch for real time messages.
  MessageCentral messageCentral = MessageCentral();

  /// Creates a new [Server] object.
  Server({
    required this.serverpod,
    required this.serverId,
    required this.port,
    required this.serializationManager,
    required this.databaseConfig,
    required this.passwords,
    required this.runMode,
    this.authenticationHandler,
    String? name,
    required this.caches,
    this.securityContext,
    this.whitelistedExternalCalls,
    required this.endpoints,
  }) : name = name ?? 'Server id $serverId';

  /// Starts the server.
  Future<void> start() async {
    if (securityContext != null) {
      await HttpServer.bindSecure(
              InternetAddress.anyIPv6, port, securityContext!)
          .then(_runServer, onError: (e, StackTrace stackTrace) {
        stderr.writeln(
            '${DateTime.now().toUtc()} Internal server error. Failed to bind secure socket.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      });
    } else {
      await HttpServer.bind(InternetAddress.anyIPv6, port).then(_runServer,
          onError: (e, StackTrace stackTrace) {
        stderr.writeln(
            '${DateTime.now().toUtc()} Internal server error. Failed to bind socket.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      });
    }

    _running = true;
    stdout.writeln('$name listening on port $port');
  }

  void _runServer(HttpServer httpServer) {
    _httpServer = httpServer;
    httpServer.autoCompress = true;
    httpServer.listen(
      (HttpRequest request) {
        try {
          _handleRequest(request);
        } catch (e, stackTrace) {
          stderr.writeln(
              '${DateTime.now().toUtc()} Internal server error. _handleRequest failed.');
          stderr.writeln('$e');
          stderr.writeln('$stackTrace');
        }
      },
      onError: (e, StackTrace stackTrace) {
        stderr.writeln(
            '${DateTime.now().toUtc()} Internal server error. httpSever.listen failed.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      },
    ).onDone(() {
      stdout.writeln('$name stopped');
    });
  }

  Future<void> _handleRequest(HttpRequest request) async {
    Uri uri;

    try {
      uri = request.requestedUri;
    } catch (e) {
      if (serverpod.runtimeSettings.logMalformedCalls) {
        // TODO: Specific log for this?
        stderr.writeln(
            'Malformed call, invalid uri from ${request.connectionInfo!.remoteAddress.address}');
      }

      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }

    var readBody = true;

    if (uri.path == '/') {
      // Perform health checks
      var checks = await performHealthChecks(serverpod);
      var issues = <String>[];
      var allOk = true;
      for (var metric in checks.metrics) {
        if (!metric.isHealthy) {
          allOk = false;
          issues.add('${metric.name}: ${metric.value}');
        }
      }

      if (allOk) {
        request.response.writeln('OK ${DateTime.now().toUtc()}');
      } else {
        request.response.writeln('SADNESS ${DateTime.now().toUtc()}');
      }
      for (var issue in issues) {
        request.response.writeln(issue);
      }

      await request.response.close();
      return;
    } else if (uri.path == '/websocket') {
      var webSocket = await WebSocketTransformer.upgrade(request);
      webSocket.pingInterval = const Duration(minutes: 1);
      unawaited(_handleWebsocket(webSocket, request));
      return;
    } else if (uri.path == '/serverpod_cloud_storage') {
      readBody = false;
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
    if (readBody) {
      try {
        body = await _readBody(request);
      } catch (e, stackTrace) {
        stderr.writeln(
            '${DateTime.now().toUtc()} Internal server error. Failed to read body of request.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
        return;
      }
    } else {
      body = '';
    }

    var result = await _handleUriCall(uri, body!, request);

    if (result is ResultInvalidParams) {
      if (serverpod.runtimeSettings.logMalformedCalls) {
        // TODO: Log to database?
        stderr.writeln('Malformed call: $result');
      }
      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    } else if (result is ResultAuthenticationFailed) {
      if (serverpod.runtimeSettings.logMalformedCalls) {
        // TODO: Log to database?
        stderr.writeln('Access denied: $result');
      }
      request.response.statusCode = HttpStatus.forbidden;
      await request.response.close();
      return;
    } else if (result is ResultInternalServerError) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.writeln(
          'Internal server error. Call log id: ${result.sessionLogId}');
      await request.response.close();
      return;
    } else if (result is ResultStatusCode) {
      request.response.statusCode = result.statusCode;
      await request.response.close();
      return;
    } else if (result is ResultSuccess) {
      // Set content type.
      if (!result.sendByteDataAsRaw) {
        request.response.headers.contentType =
            ContentType('application', 'json', charset: 'utf-8');
      }

      // Set Access-Control-Allow-Origin, required for Flutter web.
      request.response.headers.add('Access-Control-Allow-Origin', '*');

      // Send the response
      if (result.sendByteDataAsRaw && result.returnValue is ByteData?) {
        var byteData = result.returnValue as ByteData?;
        if (byteData != null) {
          request.response.add(byteData.buffer.asUint8List());
        }
      } else {
        var serializedEntity =
            serializationManager.serializeEntity(result.returnValue);
        request.response.write(serializedEntity);
      }
      await request.response.close();
      return;
    }
  }

  Future<String?> _readBody(HttpRequest request) async {
    // TODO: Find more efficient solution?
    var len = 0;
    var data = <int>[];
    await for (var segment in request) {
      len += segment.length;
      if (len > serverpod.config.maxRequestSize) return null;
      data += segment;
    }
    return const Utf8Decoder().convert(data);
  }

  Future<Result> _handleUriCall(
      Uri uri, String body, HttpRequest request) async {
    var endpointName = uri.path.substring(1);
    return endpoints.handleUriCall(this, endpointName, uri, body, request);
  }

  Future<void> _handleWebsocket(
      WebSocket webSocket, HttpRequest request) async {
    try {
      var session = StreamingSession(
        server: this,
        uri: request.uri,
        httpRequest: request,
        webSocket: webSocket,
      );

      for (var endpointConnector in endpoints.connectors.values) {
        await _callStreamOpened(session, endpointConnector.endpoint);
      }
      for (var module in endpoints.modules.values) {
        for (var endpointConnector in module.connectors.values) {
          await _callStreamOpened(session, endpointConnector.endpoint);
        }
      }

      dynamic error;
      StackTrace? stackTrace;

      try {
        await for (String jsonData in webSocket) {
          var data = jsonDecode(jsonData) as Map;
          var endpointName = data['endpoint'] as String;
          var serialization = data['object'] as Map;
          var message = serializationManager.createEntityFromSerialization(
              serialization.cast<String, dynamic>());

          if (message == null) throw Exception('Streamed message was null');

          var endpointConnector = endpoints.getConnectorByName(endpointName);
          if (endpointConnector == null) {
            throw Exception('Endpoint not found: $endpointName');
          }

          var authFailed = await endpoints.canUserAccessEndpoint(
              session, endpointConnector.endpoint);
          if (authFailed == null) {
            await endpointConnector.endpoint
                .handleStreamMessage(session, message);
          }
        }
      } catch (e, s) {
        error = e;
        stackTrace = s;
      }

      // TODO: Possibly keep a list of open streams instead
      for (var endpointConnector in endpoints.connectors.values) {
        await _callStreamClosed(session, endpointConnector.endpoint);
      }
      for (var module in endpoints.modules.values) {
        for (var endpointConnector in module.connectors.values) {
          await _callStreamClosed(session, endpointConnector.endpoint);
        }
      }
      await session.close(error: error, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      return;
    }
  }

  Future<void> _callStreamOpened(
      StreamingSession session, Endpoint endpoint) async {
    try {
      // TODO: We need to mark stream as accessbile (in endpoint?) and check
      // future messages that are passed to this endpoint.
      var authFailed = await endpoints.canUserAccessEndpoint(session, endpoint);
      if (authFailed == null) await endpoint.streamOpened(session);
    } catch (e) {
      return;
    }
  }

  Future<void> _callStreamClosed(
      StreamingSession session, Endpoint endpoint) async {
    try {
      var authFailed = await endpoints.canUserAccessEndpoint(session, endpoint);
      if (authFailed == null) await endpoint.streamClosed(session);
    } catch (e) {
      return;
    }
  }

  /// Shuts the server down.
  void shutdown() {
    _httpServer.close();
    _running = false;
  }
}
