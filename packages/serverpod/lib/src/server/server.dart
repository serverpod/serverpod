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
class Server implements RouterInjectable {
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

  final int _port;

  int? _actualPort;

  /// Port the server is listening on.
  /// Returns the actual port from the running server if available,
  /// otherwise returns the configured port.
  int get port => _actualPort ?? _port;

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

  late AuthenticationHandler _authenticationHandler;

  /// [AuthenticationHandler] responsible for authenticating users.
  AuthenticationHandler get authenticationHandler => _authenticationHandler;

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
    required int port,
    required this.serializationManager,
    required DatabasePoolManager? databasePoolManager,
    required this.passwords,
    required this.runMode,
    String? name,
    required this.caches,
    io.SecurityContext? securityContext,
    this.whitelistedExternalCalls,
    required this.endpoints,
    required this.httpResponseHeaders,
    required this.httpOptionsResponseHeaders,
  })  : name = name ?? 'Server $serverId',
        _databasePoolManager = databasePoolManager,
        _securityContext = securityContext,
        _port = port;

  late final _app = RelicApp()..inject(this);

  @override
  void injectIn(RelicRouter router) {
    if (serverpod.config.loggingMode == ServerpodLoggingMode.verbose) {
      router.use('/', _verboseLogging);
    }
    router
      ..use('/', _headers)
      ..use('/', _reportException)
      ..get('/', _health)
      ..get('/websocket',
          _dispatchWebSocket(EndpointWebsocketRequestHandler.handleWebsocket))
      ..get('/v1/websocket',
          _dispatchWebSocket(MethodWebsocketRequestHandler.handleWebsocket))
      ..anyOf({Method.get, Method.options, Method.post},
          '/serverpod_cloud_storage', _cloudStorage)
      ..any('/**', _endpoints);
  }

  /// Starts the server.
  /// Returns true if the server was started successfully.
  Future<bool> start(
      {required AuthenticationHandler authenticationHandler}) async {
    _authenticationHandler = authenticationHandler;
    try {
      final server = await _app.serve(
        address: io.InternetAddress.anyIPv6,
        port: _port,
        securityContext: _securityContext,
      );
      _actualPort = server.port;
      _relicServer = server;
    } catch (e, stackTrace) {
      await _reportFrameworkException(e, stackTrace,
          message: 'Failed to bind socket, port $_port may already be in use.');
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

  Handler _verboseLogging(Handler next) {
    return (req) async {
      final path = req.requestedUri.path;
      serverpod.logVerbose('handleRequest: ${req.method} $path');
      return await next(req);
    };
  }

  Handler _reportException(Handler next) {
    return (req) async {
      try {
        return await next(req);
      } on _RequestTooLargeException catch (e) {
        return Response(
          io.HttpStatus.requestEntityTooLarge,
          body: Body.fromString(e.errorDescription),
        );
      } catch (e, stackTrace) {
        await _reportFrameworkException(
          e,
          stackTrace,
          message:
              'Internal server error. Request handler failed with exception.',
          request: req,
        );
        return Response.internalServerError();
      }
    };
  }

  Future<Result> _health(Request req) async {
    final checks = await performHealthChecks(serverpod);
    final issues = <String>[];
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

    return Response(
      allOk ? io.HttpStatus.ok : io.HttpStatus.serviceUnavailable,
      body: Body.fromString(responseBuffer.toString()),
      //headers: headers,
    );
  }

  Handler _headers(Handler next) {
    return (req) async {
      final isOptions = req.method == Method.options;
      // TODO: Make httpResponseHeaders a Headers object from the get-go.
      // or better yet, use middleware
      final headers = Headers.build((mh) {
        for (var rh in httpResponseHeaders.entries) {
          mh[rh.key] = ['${rh.value}'];
        }
        if (isOptions) {
          for (var orh in httpOptionsResponseHeaders.entries) {
            mh[orh.key] = ['${orh.value}'];
          }
        }
      });

      // early exit on Method.options
      if (isOptions) return Response.ok(headers: headers);

      final result = await next(req);
      return switch (result) {
        Response() => result.copyWith(headers: headers),
        _ => result,
      };
    };
  }

  FutureOr<Result> _cloudStorage(Request req) async {
    final uri = req.requestedUri;
    assert(uri.path == '/serverpod_cloud_storage');
    var result = await _handleUriCall(uri, '', req);
    return _toResponse(result);
  }

  Future<Response> _endpoints(Request req) async {
    final body = await _readBody(req);
    var result = await _handleUriCall(req.requestedUri, body, req);
    return _toResponse(result);
  }

  Response _toResponse(EndpointResult result) {
    switch (result) {
      case ResultNoSuchEndpoint():
        return Response.notFound(
          body: Body.fromString(result.errorDescription),
        );
      case ResultInvalidParams():
        return Response.badRequest(
          body: Body.fromString(result.errorDescription),
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
        );
      case ResultInternalServerError():
        return Response.internalServerError(
          body: Body.fromString(
              'Internal server error. Call log id: ${result.sessionLogId}'),
        );
      case ResultStatusCode():
        return Response(
          result.statusCode,
          body: result.message != null
              ? Body.fromString(result.message!)
              : Body.empty(),
        );
      case ExceptionResult():
        var serializedModel =
            serializationManager.encodeWithTypeForProtocol(result.model);
        return Response.badRequest(
          body: Body.fromString(serializedModel, mimeType: MimeType.json),
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
              value = Response.ok(body: value);
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
        );
    }
  }

  Handler _dispatchWebSocket(
    Future<void> Function(
      Server,
      RelicWebSocket,
      Request,
      void Function(),
    ) requestHandler,
  ) {
    return (req) async {
      return WebSocketUpgrade((webSocket) async {
        try {
          // TODO(kasper): Should we keep doing this?
          webSocket.pingInterval = const Duration(seconds: 30);
          var websocketKey = const Uuid().v4();
          final handlerFuture = requestHandler(
            this,
            webSocket,
            req,
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
    };
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

  Future<EndpointResult> _handleUriCall(
    Uri uri,
    String body,
    Request request,
  ) async {
    var path = uri.pathSegments.join('/');
    var endpointComponents = path.split('.');
    if (endpointComponents.isEmpty || endpointComponents.length > 2) {
      return ResultInvalidParams('Endpoint name is not valid');
    }

    // Read query parameters
    var queryParameters = <String, dynamic>{};
    var isValidBody = body != 'null' && body.isNotEmpty;
    if (isValidBody) {
      try {
        queryParameters = jsonDecode(body);
      } catch (_) {
        return ResultInvalidParams('Invalid JSON in body');
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
          'No method name specified',
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
    } catch (e) {
      if (e is AuthHeaderEncodingException || e is InvalidHeaderException) {
        return ResultStatusCode(
          400,
          'Request has invalid "authorization" header',
        );
      } else {
        rethrow;
      }
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
    await _app.close();
    var webSockets = _webSockets.values.toList();
    List<Future<void>> webSocketCompletions = [];
    for (var (webSocketCompletion, webSocket) in webSockets) {
      webSocketCompletions.add(webSocketCompletion);
      await webSocket.tryClose();
    }

    // Wait for all WebSockets to close.
    await Future.wait(webSocketCompletions);
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

  /// Returns information about the current connections to the server.
  Future<ConnectionsInfo> connectionsInfo() async =>
      await _relicServer?.connectionsInfo() ?? (active: 0, closing: 0, idle: 0);
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
  String get errorDescription =>
      'Request size exceeds the maximum allowed size of $maxSize bytes.';

  /// Creates a new [ResultRequestTooLarge] object.
  ///
  /// - [maxSize]: The maximum allowed size for the request in bytes.
  const _RequestTooLargeException(this.maxSize);

  @override
  String toString() {
    return errorDescription;
  }
}
