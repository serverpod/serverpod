import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/caches.dart';
import 'package:serverpod/src/database/database.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:serverpod/src/server/health_check.dart';
import 'package:serverpod/src/server/websocket_request_handlers/endpoint_websocket_request_handler.dart';
import 'package:serverpod/src/server/websocket_request_handlers/method_websocket_request_handler.dart';

/// Handling incoming calls and routing them to the correct [Endpoint]
/// methods.
class Server {
  // Map of [WebSocket] connected to the server.
  // The key is a unique identifier for the connection.
  // The value is a tuple of a [Future] that completes when the connection is
  // closed and the [WebSocket] object.
  final Map<String, (Future<void>, WebSocket)> _webSockets = {};

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
  final DatabasePoolManager? _databasePoolManager;

  /// Creates a new [Database] object with a connection to the configured
  /// database.
  Database createDatabase(Session session) {
    var databasePoolManager = _databasePoolManager;
    if (databasePoolManager == null) {
      throw ArgumentError('Database config not set');
    }

    return DatabaseConstructor.create(
      session: session,
      poolManager: databasePoolManager,
    );
  }

  /// The [SerializationManager] used by the server.
  final SerializationManager serializationManager;

  /// [AuthenticationHandler] responsible for authenticating users.
  final AuthenticationHandler authenticationHandler;

  /// Caches used by the server.
  final Caches caches;

  /// The name of the server.
  final String name;

  /// Security context if the server is running over https.
  final SecurityContext? _securityContext;

  /// Responsible for dispatching calls to the correct [Endpoint] methods.
  final EndpointDispatch endpoints;

  bool _running = false;

  /// True if the server is currently running.
  bool get running => _running;

  late HttpServer _httpServer;

  /// The [HttpServer] responsible for handling calls.
  HttpServer get httpServer => _httpServer;

  /// Currently not in use.
  List<String>? whitelistedExternalCalls;

  /// Map of passwords loaded from config/passwords.yaml
  Map<String, String> passwords;

  /// Central message dispatch for real time messages.
  MessageCentral messageCentral = MessageCentral();

  /// HTTP headers used by all API responses. Defaults to allowing any
  /// cross origin resource sharing (CORS).
  final Map<String, dynamic> httpResponseHeaders;

  /// HTTP headers used for OPTIONS responses. These headers are sent in
  /// addition to the [httpResponseHeaders] when the request method is OPTIONS.
  final Map<String, dynamic> httpOptionsResponseHeaders;

  /// Creates a new [Server] object.
  Server({
    required this.serverpod,
    required this.serverId,
    required this.port,
    required this.serializationManager,
    required DatabasePoolManager? databasePoolManager,
    required this.passwords,
    required this.runMode,
    required this.authenticationHandler,
    String? name,
    required this.caches,
    SecurityContext? securityContext,
    this.whitelistedExternalCalls,
    required this.endpoints,
    required this.httpResponseHeaders,
    required this.httpOptionsResponseHeaders,
  })  : name = name ?? 'Server $serverId',
        _databasePoolManager = databasePoolManager,
        _securityContext = securityContext;

  /// Starts the server.
  /// Returns true if the server was started successfully.
  Future<bool> start() async {
    HttpServer httpServer;
    try {
      var context = _securityContext;
      httpServer = await switch (context) {
        SecurityContext() => HttpServer.bindSecure(
            InternetAddress.anyIPv6,
            port,
            context,
          ),
        _ => HttpServer.bind(InternetAddress.anyIPv6, port),
      };
    } catch (e) {
      stderr.writeln(
        '${DateTime.now().toUtc()} ERROR: Failed to bind socket, port $port '
        'may already be in use.',
      );
      stderr.writeln('${DateTime.now().toUtc()} ERROR: $e');
      return false;
    }

    try {
      _runServer(httpServer);
    } catch (e, stackTrace) {
      stderr.writeln(
          '${DateTime.now().toUtc()} Internal server error. Failed to run server.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      return false;
    }

    _running = true;
    stdout.writeln('$name listening on port $port');
    return _running;
  }

  void _runServer(HttpServer httpServer) async {
    serverpod.logVerbose(
      'runServer address: ${httpServer.address}, port: ${httpServer.port}',
    );

    _httpServer = httpServer;
    httpServer.autoCompress = true;

    try {
      await for (var request in httpServer) {
        serverpod.logVerbose(
          'received request: ${request.method} ${request.uri.path}',
        );

        _handleRequestWithErrorBoundary(request);
      }
    } catch (e, stackTrace) {
      stderr.writeln(
          '${DateTime.now().toUtc()} Internal server error. httpSever.listen failed.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
    }

    stdout.writeln('$name stopped');
  }

  void _handleRequestWithErrorBoundary(HttpRequest request) async {
    // [Future.sync] ensures no synchronous error is accidentally thrown from the handler
    // https://dart.dev/libraries/async/futures-error-handling#solution-using-future-sync-to-wrap-your-code
    await Future.sync(() {
      return _handleRequest(request);
    }).catchError((e, stackTrace) async {
      stderr.writeln(
        '${DateTime.now().toUtc()} Internal server error. _handleRequest failed with exception.',
      );
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      request.response.statusCode = HttpStatus.internalServerError;
      return request.response.close();
    });
  }

  //TODO: encode analyze
  Future<void> _handleRequest(HttpRequest request) async {
    serverpod
        .logVerbose('handleRequest: ${request.method} ${request.uri.path}');

    for (var header in httpResponseHeaders.entries) {
      request.response.headers.add(header.key, header.value);
    }

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
      await _dispatchWebSocketUpgradeRequest(
        request,
        EndpointWebsocketRequestHandler.handleWebsocket,
      );
      return;
    } else if (uri.path == '/v1/websocket') {
      await _dispatchWebSocketUpgradeRequest(
        request,
        MethodWebsocketRequestHandler.handleWebsocket,
      );
      return;
    } else if (uri.path == '/serverpod_cloud_storage') {
      readBody = false;
    }

    // This OPTIONS check is necessary when making requests from
    // eg `editor.swagger.io`. It ensures proper handling of preflight requests
    // with the OPTIONS method.
    if (request.method == 'OPTIONS') {
      for (var header in httpOptionsResponseHeaders.entries) {
        request.response.headers.add(header.key, header.value);
      }

      // Safari and potentially other browsers require Content-Length=0.
      request.response.headers.add('Content-Length', 0);
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      return;
    }

    String body;
    if (readBody) {
      try {
        body = await _readBody(request);
      } on _RequestTooLargeException catch (e) {
        if (serverpod.runtimeSettings.logMalformedCalls) {
          // TODO: Log to database?
          stderr.writeln('${DateTime.now().toUtc()} ${e.errorDescription}');
        }
        request.response.statusCode = HttpStatus.requestEntityTooLarge;
        request.response.write(e.errorDescription);
        await request.response.close();
        return;
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

    var result = await _handleUriCall(uri, body, request);

    if (result is ResultNoSuchEndpoint) {
      if (serverpod.runtimeSettings.logMalformedCalls) {
        // TODO: Log to database?
        stderr.writeln('Malformed call: $result');
      }

      request.response.statusCode = HttpStatus.notFound;
      request.response.writeln(result.errorDescription);
      await request.response.close();
      return;
    } else if (result is ResultInvalidParams) {
      if (serverpod.runtimeSettings.logMalformedCalls) {
        // TODO: Log to database?
        stderr.writeln('Malformed call: $result');
      }

      request.response.statusCode = HttpStatus.badRequest;
      request.response.writeln(result.errorDescription);
      await request.response.close();
      return;
    } else if (result is ResultAuthenticationFailed) {
      if (serverpod.runtimeSettings.logMalformedCalls) {
        // TODO: Log to database?
        stderr.writeln('Access denied: $result');
      }

      request.response.statusCode = switch (result.reason) {
        AuthenticationFailureReason.unauthenticated => HttpStatus.unauthorized,
        AuthenticationFailureReason.insufficientAccess => HttpStatus.forbidden,
      };
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
      if (result.message != null) {
        request.response.writeln(result.message);
      }
      await request.response.close();
      return;
    } else if (result is ExceptionResult) {
      request.response.headers.contentType = ContentType.json;
      request.response.statusCode = HttpStatus.badRequest;

      var serializedModel =
          serializationManager.encodeWithTypeForProtocol(result.model);
      request.response.write(serializedModel);
      await request.response.close();
    } else if (result is ResultSuccess) {
      // Set content type.
      if (!result.sendByteDataAsRaw) {
        request.response.headers.contentType =
            ContentType('application', 'json', charset: 'utf-8');
      }

      // Send the response
      if (result.sendByteDataAsRaw && result.returnValue is ByteData?) {
        var byteData = result.returnValue as ByteData?;
        if (byteData != null) {
          request.response.add(byteData.buffer.asUint8List());
        }
      } else {
        var serializedModel = SerializationManager.encodeForProtocol(
          result.returnValue,
        );
        request.response.write(serializedModel);
      }
      await request.response.close();
      return;
    }
  }

  Future<void> _dispatchWebSocketUpgradeRequest(
    HttpRequest request,
    Future<void> Function(
      Server,
      WebSocket,
      HttpRequest,
      void Function(),
    ) requestHandler,
  ) async {
    WebSocket webSocket;
    try {
      webSocket = await WebSocketTransformer.upgrade(request);
    } on WebSocketException {
      serverpod.logVerbose('Failed to upgrade connection to websocket');
      return;
    }
    webSocket.pingInterval = const Duration(seconds: 30);
    var websocketKey = const Uuid().v4();
    _webSockets[websocketKey] = (
      requestHandler(
        this,
        webSocket,
        request,
        () => _webSockets.remove(websocketKey),
      ),
      webSocket
    );
  }

  Future<String> _readBody(HttpRequest request) async {
    var builder = BytesBuilder();
    var len = 0;
    await for (var segment in request) {
      len += segment.length;
      if (len > serverpod.config.maxRequestSize) {
        throw _RequestTooLargeException(serverpod.config.maxRequestSize);
      }
      builder.add(segment);
    }
    return const Utf8Decoder().convert(builder.toBytes());
  }

  Future<Result> _handleUriCall(
    Uri uri,
    String body,
    HttpRequest request,
  ) async {
    var path = uri.pathSegments.join('/');
    var endpointComponents = path.split('.');
    if (endpointComponents.isEmpty || endpointComponents.length > 2) {
      return ResultInvalidParams('Endpoint $path is not a valid endpoint name');
    }

    // Read query parameters
    var queryParameters = <String, dynamic>{};
    var isValidBody = body != 'null' && body.isNotEmpty;
    if (isValidBody) {
      try {
        queryParameters = jsonDecode(body);
      } catch (_) {
        return ResultInvalidParams('Invalid JSON in body: $body');
      }
    }

    // Add query parameters from uri
    queryParameters.addAll(uri.queryParameters);

    String endpointName;
    String methodName;

    if (path.contains('/')) {
      // Using the new path format (for OpenAPI)
      var pathComponents = path.split('/');
      endpointName = pathComponents[0];
      methodName = pathComponents[1];
    } else {
      // Using the standard format with query parameters
      endpointName = path;
      var method = queryParameters['method'];
      if (method is String) {
        methodName = method;
      } else {
        return ResultInvalidParams(
          'No method name specified in call to $endpointName',
        );
      }
    }

    // Get the the authentication key, if any
    // If it is provided in the HTTP authorization header we use that,
    // otherwise we look for it in the query parameters (the old method).
    var authHeaderValue =
        request.headers.value(HttpHeaders.authorizationHeader);
    String? authenticationKey;
    try {
      authenticationKey = unwrapAuthHeaderValue(authHeaderValue);
    } on AuthHeaderEncodingException catch (_) {
      return ResultStatusCode(
        400,
        'Request has invalid "authorization" header: $authHeaderValue',
      );
    }
    authenticationKey ??= queryParameters['auth'];

    MethodCallSession? maybeSession;
    try {
      var methodCallContext = await endpoints.getMethodCallContext(
        createSessionCallback: (connector) {
          maybeSession = MethodCallSession(
            server: this,
            uri: uri,
            body: body,
            path: path,
            httpRequest: request,
            method: methodName,
            endpoint: endpointName,
            queryParameters: queryParameters,
            authenticationKey: authenticationKey,
            enableLogging: connector.endpoint.logSessions,
          );
          return maybeSession!;
        },
        endpointPath: endpointName,
        methodName: methodName,
        parameters: queryParameters,
        serializationManager: serializationManager,
      );

      MethodCallSession? session = maybeSession;
      if (session == null) {
        return ResultInternalServerError(
            'Session was not created', StackTrace.current, 0);
      }

      var result = await methodCallContext.method.call(
        session,
        methodCallContext.arguments,
      );

      return ResultSuccess(
        result,
        sendByteDataAsRaw: methodCallContext.endpoint.sendByteDataAsRaw,
      );
    } on MethodNotFoundException catch (e) {
      return ResultInvalidParams(e.message);
    } on InvalidEndpointMethodTypeException catch (e) {
      return ResultInvalidParams(e.message);
    } on EndpointNotFoundException catch (e) {
      return ResultNoSuchEndpoint(e.message);
    } on NotAuthorizedException catch (e) {
      return e.authenticationFailedResult;
    } on InvalidParametersException catch (e) {
      return ResultInvalidParams(e.message);
    } on SerializableException catch (exception) {
      return ExceptionResult(model: exception);
    } on Exception catch (e, stackTrace) {
      var sessionLogId =
          await maybeSession?.close(error: e, stackTrace: stackTrace);
      return ResultInternalServerError(
          e.toString(), stackTrace, sessionLogId ?? 0);
    } catch (e, stackTrace) {
      // Something did not work out
      var sessionLogId =
          await maybeSession?.close(error: e, stackTrace: stackTrace);
      return ResultInternalServerError(
          e.toString(), stackTrace, sessionLogId ?? 0);
    } finally {
      await maybeSession?.close();
    }
  }

  /// Shuts the server down.
  /// Returns a [Future] that completes when the server is shut down.
  Future<void> shutdown() async {
    await _httpServer.close();
    var webSockets = _webSockets.values.toList();
    List<Future<void>> webSocketCompletions = [];
    for (var (webSocketCompletion, webSocket) in webSockets) {
      webSocketCompletions.add(webSocketCompletion);
      await webSocket.close();
    }

    // Wait for all WebSockets to close.
    await Future.wait(webSocketCompletions);

    _running = false;
  }
}

/// The result of a failed request to the server where the request size
/// exceeds the maximum allowed limit.
///
/// This error provides details about the maximum allowed size, allowing the
/// client to adjust their request accordingly.
class _RequestTooLargeException implements Exception {
  /// Maximum allowed request size in bytes.
  final int maxSize;

  /// Description of the error.
  ///
  /// Contains a human-readable explanation of the error, including the maximum
  /// allowed size and the actual size of the request.
  final String errorDescription;

  /// Creates a new [ResultRequestTooLarge] object.
  ///
  /// - [maxSize]: The maximum allowed size for the request in bytes.
  _RequestTooLargeException(this.maxSize)
      : errorDescription =
            'Request size exceeds the maximum allowed size of $maxSize bytes.';

  @override
  String toString() {
    return errorDescription;
  }
}
