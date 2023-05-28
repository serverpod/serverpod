import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../../protocol.dart';
import '../../serverpod.dart';
import '../cache/caches.dart';
import 'health_check.dart';

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
    required this.caches,
    required this.endpoints,
    this.authenticationHandler,
    String? name,
    this.securityContext,
    this.whitelistedExternalCalls,
  }) : name = name ?? 'Server $serverId';

  /// Starts the server.
  Future<void> start() async {
    if (securityContext != null) {
      try {
        final httpServer = await HttpServer.bindSecure(
          InternetAddress.anyIPv6,
          port,
          securityContext!,
        );
        await _runServer(httpServer);
      } catch (e, stackTrace) {
        stderr
          ..writeln(
            '${DateTime.now().toUtc()} Internal server error. '
            'Failed to bind socket.',
          )
          ..writeln('$e')
          ..writeln('$stackTrace');
      }
    } else {
      try {
        final httpServer = await HttpServer.bind(InternetAddress.anyIPv6, port);
        await _runServer(httpServer);
      } catch (e, stackTrace) {
        stderr
          ..writeln(
            '${DateTime.now().toUtc()} Internal server error. '
            'Failed to bind socket.',
          )
          ..writeln('$e')
          ..writeln('$stackTrace');
      }
    }

    _running = true;
    stdout.writeln('$name listening on port $port');
  }

  Future<void> _runServer(HttpServer httpServer) async {
    serverpod.logVerbose(
      'runServer address: ${httpServer.address}, port: ${httpServer.port}',
    );

    _httpServer = httpServer;
    httpServer.autoCompress = true;

    try {
      await for (final request in httpServer) {
        serverpod.logVerbose(
          'received request: ${request.method} ${request.uri.path}',
        );

        try {
          await _handleRequest(request);
        } catch (e, stackTrace) {
          stderr
            ..writeln(
              '${DateTime.now().toUtc()} Internal server error. '
              '_handleRequest failed.',
            )
            ..writeln('$e')
            ..writeln('$stackTrace');
        }
      }
    } catch (e, stackTrace) {
      stderr
        ..writeln(
          '${DateTime.now().toUtc()} Internal server error. '
          'httpSever.listen failed.',
        )
        ..writeln('$e')
        ..writeln('$stackTrace');
    }

    stdout.writeln('$name stopped');
  }

  Future<void> _handleRequest(HttpRequest request) async {
    serverpod
        .logVerbose('handleRequest: ${request.method} ${request.uri.path}');

    // Set Access-Control-Allow-Origin, required for Flutter web.
    request.response.headers.add('Access-Control-Allow-Origin', '*');

    Uri uri;

    try {
      uri = request.requestedUri;
    } catch (e) {
      if (serverpod.runtimeSettings.logMalformedCalls) {
        // TODO: Specific log for this?
        stderr.writeln(
          'Malformed call, invalid uri from '
          '${request.connectionInfo!.remoteAddress.address}',
        );
      }

      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }

    var readBody = true;

    if (uri.path == '/') {
      // Perform health checks
      final checks = await performHealthChecks(serverpod);
      final issues = <String>[];
      var allOk = true;
      for (final metric in checks.metrics) {
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

      issues.forEach(request.response.writeln);

      await request.response.close();
      return;
    } else if (uri.path == '/websocket') {
      final webSocket = await WebSocketTransformer.upgrade(request);
      webSocket.pingInterval = const Duration(seconds: 30);
      unawaited(_handleWebsocket(webSocket, request));
      return;
    } else if (uri.path == '/serverpod_cloud_storage') {
      readBody = false;
    }

    String? body;
    if (readBody) {
      try {
        body = await _readBody(request);
      } catch (e, stackTrace) {
        stderr
          ..writeln(
            '${DateTime.now().toUtc()} Internal server error. '
            'Failed to read body of request.',
          )
          ..writeln('$e')
          ..writeln('$stackTrace');
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
        return;
      }
    } else {
      body = '';
    }

    final result = await _handleUriCall(uri, body!, request);

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
        'Internal server error. Call log id: ${result.sessionLogId}',
      );
      await request.response.close();
      return;
    } else if (result is ResultStatusCode) {
      request.response.statusCode = result.statusCode;
      await request.response.close();
      return;
    } else if (result is ExceptionResult) {
      request.response.headers.contentType = ContentType.json;
      request.response.statusCode = HttpStatus.internalServerError;

      final serializedEntity =
          serializationManager.encodeWithType(result.entity);
      request.response.write(serializedEntity);
      await request.response.close();
    } else if (result is ResultSuccess) {
      // Set content type.
      if (!result.sendByteDataAsRaw) {
        request.response.headers.contentType =
            ContentType('application', 'json', charset: 'utf-8');
      }

      // Send the response
      if (result.sendByteDataAsRaw && result.returnValue is ByteData?) {
        final byteData = result.returnValue as ByteData?;
        if (byteData != null) {
          request.response.add(byteData.buffer.asUint8List());
        }
      } else {
        final serializedEntity =
            SerializationManager.encode(result.returnValue);
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
    await for (final segment in request) {
      len += segment.length;
      if (len > serverpod.config.maxRequestSize) return null;
      data += segment;
    }
    return const Utf8Decoder().convert(data);
  }

  Future<Result> _handleUriCall(
    Uri uri,
    String body,
    HttpRequest request,
  ) async {
    final endpointName = uri.path.substring(1);
    return endpoints.handleUriCall(this, endpointName, uri, body, request);
  }

  Future<void> _handleWebsocket(
    WebSocket webSocket,
    HttpRequest request,
  ) async {
    try {
      final session = StreamingSession(
        server: this,
        uri: request.uri,
        httpRequest: request,
        webSocket: webSocket,
      );

      for (final endpointConnector in endpoints.connectors.values) {
        session.sessionLogs.currentEndpoint = endpointConnector.endpoint.name;
        await _callStreamOpened(session, endpointConnector.endpoint);
      }
      for (final module in endpoints.modules.values) {
        for (final endpointConnector in module.connectors.values) {
          session.sessionLogs.currentEndpoint = endpointConnector.endpoint.name;
          await _callStreamOpened(session, endpointConnector.endpoint);
        }
      }

      dynamic error;
      StackTrace? stackTrace;

      try {
        await for (final jsonData in webSocket) {
          jsonData as String;

          final data = jsonDecode(jsonData) as Map<String, dynamic>;

          // Handle control commands.
          final command = data['command'] as String?;
          if (command != null) {
            final args = data['args'] as Map;

            if (command == 'ping') {
              webSocket.add(SerializationManager.encode({'command': 'pong'}));
            } else if (command == 'auth') {
              final authKey = args['key'] as String?;
              session.updateAuthenticationKey(authKey);
            }
            continue;
          }

          // Handle messages passed to endpoints.
          final endpointName = data['endpoint'] as String;
          final serialization = data['object'] as Map<String, dynamic>;

          final endpointConnector = endpoints.getConnectorByName(endpointName);
          if (endpointConnector == null) {
            throw Exception('Endpoint not found: $endpointName');
          }

          final authFailed = await endpoints.canUserAccessEndpoint(
            session,
            endpointConnector.endpoint,
          );

          if (authFailed == null) {
            // Process the message.
            final startTime = DateTime.now();
            dynamic messageError;
            StackTrace? messageStackTrace;

            SerializableEntity? message;
            try {
              session.sessionLogs.currentEndpoint = endpointName;

              message = serializationManager
                  .deserializeByClassName(serialization) as SerializableEntity?;

              if (message == null) throw Exception('Streamed message was null');

              await endpointConnector.endpoint
                  .handleStreamMessage(session, message);
            } catch (e, s) {
              messageError = e;
              messageStackTrace = s;
            }

            final duration =
                DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
            final logManager = session.serverpod.logManager;

            final slow = duration >=
                logManager
                    .getLogSettingsForStreamingSession(
                      endpoint: endpointName,
                    )
                    .slowSessionDuration;

            final shouldLog = logManager.shouldLogMessage(
              session: session,
              endpoint: endpointName,
              slow: slow,
              failed: messageError != null,
            );

            if (shouldLog) {
              final messageName = serialization['className'] as String;
              final logEntry = MessageLogEntry(
                sessionLogId: session.sessionLogs.temporarySessionId,
                serverId: serverId,
                messageId: session.currentMessageId,
                endpoint: endpointName,
                messageName: messageName,
                duration: duration,
                order: session.sessionLogs.currentLogOrderId,
                error: messageError?.toString(),
                stackTrace: messageStackTrace?.toString(),
                slow: slow,
              );
              unawaited(logManager.logMessage(session, logEntry));

              session.sessionLogs.currentLogOrderId += 1;
            }

            session.currentMessageId += 1;
          }
        }
      } catch (e, s) {
        error = e;
        stackTrace = s;
      }

      // TODO: Possibly keep a list of open streams instead
      for (final endpointConnector in endpoints.connectors.values) {
        await _callStreamClosed(session, endpointConnector.endpoint);
      }
      for (final module in endpoints.modules.values) {
        for (final endpointConnector in module.connectors.values) {
          await _callStreamClosed(session, endpointConnector.endpoint);
        }
      }
      await session.close(error: error, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      stderr
        ..writeln('$e')
        ..writeln('$stackTrace');
      return;
    }
  }

  Future<void> _callStreamOpened(
    StreamingSession session,
    Endpoint endpoint,
  ) async {
    try {
      // TODO: We need to mark stream as accessbile (in endpoint?) and check
      // future messages that are passed to this endpoint.
      final authFailed =
          await endpoints.canUserAccessEndpoint(session, endpoint);
      if (authFailed == null) await endpoint.streamOpened(session);
    } catch (e) {
      return;
    }
  }

  Future<void> _callStreamClosed(
    StreamingSession session,
    Endpoint endpoint,
  ) async {
    try {
      final authFailed =
          await endpoints.canUserAccessEndpoint(session, endpoint);
      if (authFailed == null) await endpoint.streamClosed(session);
    } catch (e) {
      return;
    }
  }

  /// Shuts the server down.
  Future<void> shutdown() async {
    await _httpServer.close();
    _running = false;
  }
}
