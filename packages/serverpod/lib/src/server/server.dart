import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:relic/io_adapter.dart';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/caches.dart';
import 'package:serverpod/src/database/database.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/health_check.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/websocket_request_handlers/endpoint_websocket_request_handler.dart';
import 'package:serverpod/src/server/websocket_request_handlers/method_websocket_request_handler.dart';

/// Handling incoming calls and routing them to the correct [Endpoint]
/// methods.
class Server {
  // Map of [WebSocket] connected to the server.
  // The key is a unique identifier for the connection.
  // The value is a tuple of a [Future] that completes when the connection is
  // closed and the [WebSocket] object.
  final Map<String, (Future<void>, RelicWebSocket)> _webSockets = {};

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
  final io.SecurityContext? _securityContext;

  /// Responsible for dispatching calls to the correct [Endpoint] methods.
  final EndpointDispatch endpoints;

  bool _running = false;

  /// True if the server is currently running.
  bool get running => _running;

  io.HttpServer? _ioServer;
  RelicServer? _relicServer;

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
    io.SecurityContext? securityContext,
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
    try {
      final ioServer = await bindHttpServer(
        io.InternetAddress.anyIPv6,
        port: port,
        context: _securityContext,
      );
      final server = RelicServer(IOAdapter(ioServer));
      await server.mountAndStart(_relicRequestHandler);
      _ioServer = ioServer;
      _relicServer = server;
    } catch (e, stackTrace) {
      await _reportFrameworkException(e, stackTrace,
          message: 'Failed to bind socket, port $port may already be in use.');
      return false;
    }

    _running = true;

    // Determine the scheme based on security context
    var scheme = _securityContext != null ? 'https' : 'http';

    serverpod.logVerbose(
      'Server started on $scheme://localhost:$port',
    );
    return _running;
  }

  FutureOr<HandledContext> _relicRequestHandler(NewContext context) async {
    try {
      return await _handleRequest(context);
    } catch (e, stackTrace) {
      await _reportFrameworkException(
        e,
        stackTrace,
        message:
            'Internal server error. Request handler failed with exception.',
        request: context.request,
      );
      return context.withResponse(Response.internalServerError(
        body: Body.fromString('Internal Server Error'),
      ));
    }
  }

  FutureOr<HandledContext> _handleRequest(NewContext context) async {
    final request = context.request;
    final uri = request.requestedUri;
    serverpod.logVerbose('handleRequest: ${request.method} ${uri.path}');

    // TODO: Make httpResponseHeaders a Headers object from the get-go.
    // or better yet, use middleware
    final headers = Headers.build((mh) {
      for (var rh in httpResponseHeaders.entries) {
        mh[rh.key] = ['${rh.value}'];
      }
    });

    var readBody = true;

    // TODO: Use Router instead of manual dispatch on path and verb
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

      var responseBuffer = StringBuffer();
      if (allOk) {
        responseBuffer.writeln('OK ${DateTime.now().toUtc()}');
      } else {
        responseBuffer.writeln('SADNESS ${DateTime.now().toUtc()}');
      }
      for (var issue in issues) {
        responseBuffer.writeln(issue);
      }

      var response = Response(
        allOk ? io.HttpStatus.ok : io.HttpStatus.serviceUnavailable,
        body: Body.fromString(responseBuffer.toString()),
        headers: headers,
      );
      return context.withResponse(response);
    } else if (uri.path == '/websocket') {
      return await _dispatchWebSocketUpgradeRequest(
        context,
        EndpointWebsocketRequestHandler.handleWebsocket,
      );
    } else if (uri.path == '/v1/websocket') {
      return await _dispatchWebSocketUpgradeRequest(
        context,
        MethodWebsocketRequestHandler.handleWebsocket,
      );
    } else if (uri.path == '/serverpod_cloud_storage') {
      readBody = false;
    }

    // This OPTIONS check is necessary when making requests from
    // eg `editor.swagger.io`. It ensures proper handling of preflight requests
    // with the OPTIONS method.
    if (request.method == RequestMethod.options) {
      final combinedHeaders = headers.transform((mh) {
        for (var orh in httpOptionsResponseHeaders.entries) {
          mh[orh.key] = ['${orh.value}'];
        }
        mh.contentLength = 0; // TODO: Why set this explicitly?
      });

      return context.withResponse(Response.ok(headers: combinedHeaders));
    }

    late final String body;
    if (readBody) {
      try {
        body = await _readBody(request);
      } on _RequestTooLargeException catch (e) {
        if (serverpod.runtimeSettings.logMalformedCalls) {
          // TODO: Log to database?
          io.stderr.writeln('${DateTime.now().toUtc()} ${e.errorDescription}');
        }
        return context.withResponse(Response(
          io.HttpStatus.requestEntityTooLarge,
          body: Body.fromString(e.errorDescription),
          headers: headers,
        ));
      } catch (e, stackTrace) {
        await _reportFrameworkException(e, stackTrace,
            message: 'Internal server error. Failed to read body of request.',
            request: context.request);
        return context.withResponse(Response.badRequest(
          body: Body.fromString('Failed to read request body.'),
          headers: headers,
        ));
      }
    } else {
      body = '';
    }

    var result = await _handleUriCall(uri, body, request);
    if (serverpod.runtimeSettings.logMalformedCalls) {
      _logMalformedCalls(result);
    }
    return context.withResponse(_toResponse(result, headers));
  }

  void _logMalformedCalls(Result result) {
    final error = switch (result) {
      ResultInvalidParams() => 'Malformed call',
      ResultNoSuchEndpoint() => 'Malformed call',
      ResultAuthenticationFailed() => 'Access denied',
      // ResultInternalServerError // TODO: historically not included
      _ => null
    };
    if (error != null) {
      // TODO: Log to database?
      io.stderr.writeln('$error: $result');
    }
  }

  Response _toResponse(Result result, Headers headers) {
    switch (result) {
      case ResultNoSuchEndpoint():
        return Response.notFound(
          body: Body.fromString(result.errorDescription),
          headers: headers,
        );
      case ResultInvalidParams():
        return Response.badRequest(
          body: Body.fromString(result.errorDescription),
          headers: headers,
        );
      case ResultAuthenticationFailed():
        var authFailedStatusCode = switch (result.reason) {
          AuthenticationFailureReason.unauthenticated =>
            io.HttpStatus.unauthorized,
          AuthenticationFailureReason.insufficientAccess =>
            io.HttpStatus.forbidden,
        };
        return Response(
          authFailedStatusCode,
          headers: headers,
        );
      case ResultInternalServerError():
        return Response.internalServerError(
          body: Body.fromString(
              'Internal server error. Call log id: ${result.sessionLogId}'),
          headers: headers,
        );
      case ResultStatusCode():
        return Response(
          result.statusCode,
          body: result.message != null
              ? Body.fromString(result.message!)
              : Body.empty(),
          headers: headers,
        );
      case ExceptionResult():
        var serializedModel =
            serializationManager.encodeWithTypeForProtocol(result.model);
        return Response.badRequest(
          body: Body.fromString(serializedModel, mimeType: MimeType.json),
          headers: headers,
        );
      case ResultSuccess():
        var value = result.returnValue;
        if (result.sendAsRaw) {
          switch (value) {
            case String():
              value = Body.fromString(value);
              continue body;
            case Stream<Uint8List>():
              value = Body.fromDataStream(value);
              continue body;
            case ByteData():
              value = Uint8List.sublistView(value);
              continue bytes;
            bytes:
            case Uint8List():
              value = Body.fromData(value);
              continue body;
            body:
            case Body():
              value = Response.ok(body: value, headers: headers);
              continue response;
            response:
            case Response():
              return value;
          }
        }
        return Response.ok(
          body: Body.fromString(
            SerializationManager.encodeForProtocol(value),
            mimeType: MimeType.json,
          ),
          headers: headers,
        );
    }
  }

  FutureOr<HandledContext> _dispatchWebSocketUpgradeRequest(
    NewContext newContext,
    Future<void> Function(
      Server,
      RelicWebSocket,
      Request,
      void Function(),
    ) requestHandler,
  ) async {
    return newContext.connect((webSocket) async {
      try {
        // TODO(kasper): Should we keep doing this?
        webSocket.pingInterval = const Duration(seconds: 30);

        var websocketKey = const Uuid().v4();
        final handlerFuture = requestHandler(
          this,
          webSocket,
          newContext.request,
          () => _webSockets.remove(websocketKey),
        );

        _webSockets[websocketKey] = (handlerFuture, webSocket);

        await handlerFuture;
      } catch (e, stackTrace) {
        await _reportFrameworkException(
          e,
          stackTrace,
          message: 'Failed to upgrade connection to websocket.',
          operationType: OperationType.stream,
        );
      }
    });
  }

  Future<String> _readBody(Request request) async {
    var builder = BytesBuilder(copy: false);
    var len = 0;
    var maxRequestSize = serverpod.config.maxRequestSize;
    var tooLargeForSure = (request.body.contentLength ?? -1) > maxRequestSize;
    if (!tooLargeForSure) {
      await for (var segment in request.read()) {
        if (tooLargeForSure) continue; // always drain request, if reading begun
        len += segment.length;
        tooLargeForSure = len > maxRequestSize;
        builder.add(segment);
      }
    }
    if (tooLargeForSure) {
      // We defer raising the exception until we have drained the request stream
      // This is a workaround for https://github.com/dart-lang/sdk/issues/60271
      // and fixes: https://github.com/serverpod/serverpod/issues/3213 for us.
      throw _RequestTooLargeException(maxRequestSize);
    }
    return const Utf8Decoder().convert(builder.takeBytes());
  }

  Future<Result> _handleUriCall(
    Uri uri,
    String body,
    Request request,
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

    // Get the authentication key, if any
    // If it is provided in the HTTP authorization header we use that,
    // otherwise we look for it in the query parameters (the old method).
    String? authenticationKey;
    String? authenticationHeaderValue;

    try {
      authenticationHeaderValue = request.headers.authorization?.headerValue;
      authenticationKey = unwrapAuthHeaderValue(authenticationHeaderValue);
    } on InvalidHeaderException catch (_) {
      // Use authHeaderValueFromHeader in the error message as it's the (potentially problematic) value we read
      return ResultStatusCode(
        400,
        'Request has invalid "authorization" header: $authenticationHeaderValue',
      );
    }
    authenticationKey ??= queryParameters['auth'] as String?;

    MethodCallSession? maybeSession;
    try {
      var methodCallContext = await endpoints.getMethodCallContext(
        createSessionCallback: (connector) {
          maybeSession = MethodCallSession(
            server: this,
            uri: uri,
            body: body,
            path: path,
            request: request,
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
        serverpod.internalSubmitEvent(
          ExceptionEvent(
            Exception('Session was not created'),
            StackTrace.current,
          ),
          space: OriginSpace.framework,
          context: contextFromRequest(this, request, OperationType.method),
        );

        return ResultInternalServerError(
            'Session was not created', StackTrace.current, 0);
      }

      try {
        var result = await methodCallContext.method.call(
          session,
          methodCallContext.arguments,
        );

        return ResultSuccess(
          result,
          sendAsRaw: methodCallContext.endpoint.sendAsRaw,
        );
      } catch (e, stackTrace) {
        // Note: In case of malformed argument, the method connector may throw,
        // which may be argued is not an "application space" exception.
        serverpod.internalSubmitEvent(
          ExceptionEvent(e, stackTrace),
          space: OriginSpace.application,
          context: contextFromSession(session, request: request),
        );

        rethrow;
      }
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
    await _relicServer?.close();
    var webSockets = _webSockets.values.toList();
    List<Future<void>> webSocketCompletions = [];
    for (var (webSocketCompletion, webSocket) in webSockets) {
      webSocketCompletions.add(webSocketCompletion);
      await webSocket.tryClose();
    }

    // Wait for all WebSockets to close.
    await Future.wait(webSocketCompletions);
    await _ioServer?.close(force: true);
    _running = false;
  }

  Future<void> _reportFrameworkException(
    Object e,
    StackTrace stackTrace, {
    String? message,
    Request? request,
    OperationType? operationType,
  }) async {
    var now = DateTime.now().toUtc();
    if (message != null) {
      io.stderr.writeln('$now ERROR: $message');
    }
    io.stderr.writeln('$now ERROR: $e');
    io.stderr.writeln('$stackTrace');

    var context = request != null
        ? contextFromRequest(this, request, operationType)
        : contextFromServer(this);

    serverpod.internalSubmitEvent(
      ExceptionEvent(e, stackTrace, message: message),
      space: OriginSpace.framework,
      context: context,
    );
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

// ignore: public_member_api_docs
extension ServerInternalMethods on Server {
  /// Returns the underlying [io.HttpServer] instance.
  ///
  /// This method is not intended for public use.
  io.HttpServer? get ioServer => _ioServer;
}
