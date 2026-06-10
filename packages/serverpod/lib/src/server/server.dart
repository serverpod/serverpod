import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod/src/cache/caches.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/health/health_routes.dart';
import 'package:serverpod/src/server/response_output.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:serverpod/src/server/websocket_request_handlers/endpoint_websocket_request_handler.dart';
import 'package:serverpod/src/server/websocket_request_handlers/method_websocket_request_handler.dart';
import 'package:serverpod_database/serverpod_database.dart';

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

    final inner = DatabaseConstructor.create(
      session: session,
      poolManager: databasePoolManager,
    );

    return serverpod.databaseInterceptor?.call(session, inner) ?? inner;
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
  final Headers httpResponseHeaders;

  /// HTTP headers used for OPTIONS responses. These headers are sent in
  /// addition to the [httpResponseHeaders] when the request method is OPTIONS.
  final Headers httpOptionsResponseHeaders;

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
  }) : name = name ?? 'Server $serverId',
       _databasePoolManager = databasePoolManager,
       _securityContext = securityContext,
       _port = port;

  late final _app = RelicApp()..inject(this);

  @override
  void injectIn(RelicRouter router) {
    // On hot reload, Relic replays all RouterInjectables. Re-initialize
    // endpoints so new/changed endpoint classes and methods are picked up.
    if (_running) {
      endpoints.connectors.clear();
      endpoints.modules.clear();
      endpoints.initializeEndpoints(this);
    }

    if (serverpod.config.loggingMode == ServerpodLoggingMode.verbose) {
      router.use('/', _verboseLogging);
    }

    final healthRoutes = HealthRoutes(serverpod);

    // Register core middleware first to ensure they wrap all user middleware
    router
      ..use('/', _headers)
      ..use('/', _reportException)
      // Legacy `GET /` health endpoint - API/insights only; would collide
      // with user homepage routes on the web server, so it's wired here
      // rather than from [HealthRoutes.injectIn].
      ..get('/', healthRoutes.legacyHealth);
    healthRoutes.injectIn(router);
    router
      ..get(
        '/websocket',
        _dispatchWebSocket(EndpointWebsocketRequestHandler.handleWebsocket),
      )
      ..get(
        '/v1/websocket',
        _dispatchWebSocket(MethodWebsocketRequestHandler.handleWebsocket),
      )
      ..anyOf(
        {Method.get, Method.options, Method.post},
        '/serverpod_cloud_storage',
        _cloudStorage,
      )
      ..any('/**', _endpoints);
  }

  /// Adds a [Middleware] to the server
  void addMiddleware(Middleware middleware) => _app.use('/', middleware);

  /// Starts the server.
  /// Returns true if the server was started successfully.
  Future<bool> start({
    required AuthenticationHandler authenticationHandler,
  }) async {
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
      await _reportFrameworkException(
        e,
        stackTrace,
        message: 'Failed to bind socket, port $_port may already be in use.',
      );
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
      final path = req.url.path;
      serverpod.logVerbose('handleRequest: ${req.method} $path');
      return await next(req);
    };
  }

  Handler _reportException(Handler next) {
    return (req) async {
      try {
        return await next(req);
      } catch (e, stackTrace) {
        return await _toErrorResponse(e, stackTrace, request: req);
      }
    };
  }

  /// Builds the HTTP [Response] for an [error] thrown while handling a request.
  ///
  /// Shared by [_reportException] and the method-call error path so a faulted
  /// call's queued response output (e.g. a sign-out cookie clear) can be
  /// applied to the same error response instead of being dropped. An
  /// unrecognized error is reported as a framework exception and becomes a 500.
  Future<Response> _toErrorResponse(
    Object error,
    StackTrace stackTrace, {
    Request? request,
  }) async {
    switch (error) {
      case MaxBodySizeExceeded():
        return Response.contentTooLarge(
          body: Body.fromString(
            'Request size exceeds the maximum allowed size of ${error.maxLength} bytes.',
          ),
        );
      case EndpointDispatchException():
        return switch (error) {
          EndpointNotFoundException() => Response.notFound(
            body: Body.fromString(error.message),
          ),
          NotAuthorizedException() => Response(switch (error.reason) {
            AuthenticationFailureReason.unauthenticated =>
              io.HttpStatus.unauthorized,
            AuthenticationFailureReason.insufficientAccess =>
              io.HttpStatus.forbidden,
          }),
          MethodNotFoundException() ||
          InvalidEndpointMethodTypeException() ||
          InvalidParametersException() => Response.badRequest(
            body: Body.fromString(error.message),
          ),
        };
      case SerializableException():
        return Response.badRequest(
          body: Body.fromString(
            serializationManager.encodeWithTypeForProtocol(error),
            mimeType: MimeType.json,
          ),
        );
      case HeaderException():
        return Response.badRequest(
          body: Body.fromString(error.httpResponseBody),
        );
      case AuthHeaderEncodingException():
        return Response.badRequest(
          body: Body.fromString('Request has invalid "authorization" header'),
        );
      default:
        await _reportFrameworkException(
          error,
          stackTrace,
          message:
              'Internal server error. Request handler failed with exception.',
          request: request,
        );
        return Response.internalServerError();
    }
  }

  Handler _headers(Handler next) {
    return (req) async {
      final isOptions = req.method == Method.options;
      final headers = isOptions
          ? httpResponseHeaders.transform((mh) {
              for (final h in httpOptionsResponseHeaders.entries) {
                mh[h.key] = h.value;
              }
            })
          : httpResponseHeaders;

      // early exit on Method.options
      if (isOptions) {
        return Response.ok(
          headers: _applyCredentialedCorsHeaders(headers, req),
        );
      }

      final result = await next(req);
      if (result is! Response) return result;

      // Merge default headers under any the response already set, then apply
      // credentialed CORS to the merged result so its Origin echo / Vary land
      // on the actual response (and append to a Vary the endpoint may have set).
      var merged = result.headers.isEmpty
          ? headers
          : result.headers.transform((mh) {
              for (final h in headers.entries) {
                mh[h.key] ??= h.value;
              }
            });
      return result.copyWith(
        headers: _applyCredentialedCorsHeaders(merged, req),
      );
    };
  }

  /// The `Origin` header of [req] normalized to lowercase, or null if absent.
  ///
  /// Origins (scheme + host) are case-insensitive, and browsers send a
  /// canonical lowercase origin; [ServerpodConfig.allowedOrigins] is likewise
  /// normalized to lowercase, so membership checks match regardless of the
  /// casing an operator happened to configure.
  String? _requestOrigin(Request req) =>
      req.headers[Headers.originHeader]?.firstOrNull?.trim().toLowerCase();

  /// Whether [req] carries an `Origin` that is present but not in
  /// [ServerpodConfig.allowedOrigins].
  ///
  /// A missing `Origin` (native / mobile / server-to-server, which don't send
  /// one) or an unset allow-list is not rejected. Shared by the WebSocket
  /// handshake and the HTTP cookie-auth origin gates so the two cannot drift.
  bool _isOriginDisallowed(Request req) {
    var allowedOrigins = serverpod.config.allowedOrigins;
    if (allowedOrigins == null) return false;
    var origin = _requestOrigin(req);
    return origin != null && !allowedOrigins.contains(origin);
  }

  /// When cookie-based web auth is enabled, credentialed CORS requires echoing
  /// the specific request `Origin` (the wildcard `*` is invalid with
  /// credentials) plus `Access-Control-Allow-Credentials: true`. Applied only
  /// for requests whose `Origin` is in [ServerpodConfig.allowedOrigins];
  /// otherwise [headers] is returned unchanged.
  Headers _applyCredentialedCorsHeaders(Headers headers, Request req) {
    if (serverpod.config.authCookie == null) return headers;

    var allowedOrigins = serverpod.config.allowedOrigins;
    var origin = _requestOrigin(req);

    // Echo the specific origin (the wildcard `*` is invalid with credentials)
    // only for an allow-listed origin. Guard the parse so a
    // malformed-but-allow-listed entry can't turn every response into a 500
    // from inside this response-building middleware.
    Origin? parsedOrigin;
    if (origin != null &&
        allowedOrigins != null &&
        allowedOrigins.contains(origin)) {
      try {
        parsedOrigin = Origin.parse(origin);
      } on FormatException {
        parsedOrigin = null;
      }
    }

    return headers.transform((mh) {
      if (parsedOrigin != null) {
        mh.accessControlAllowOrigin = AccessControlAllowOriginHeader.origin(
          origin: parsedOrigin,
        );
        mh.accessControlAllowCredentials = true;
      }
      // The credentialed-CORS response varies by Origin: an allow-listed origin
      // gets a specific Access-Control-Allow-Origin while every other request
      // keeps the default wildcard. A shared cache must therefore key on Origin
      // for *all* responses while authCookie is enabled - not only the ones
      // that echo a specific origin - otherwise it could serve a cached
      // wildcard (or another origin's) response to an allow-listed credentialed
      // request, which the browser then rejects. VaryHeader canonicalizes field
      // names to lowercase; a wildcard Vary already covers Origin.
      var vary = mh.vary;
      if (vary == null) {
        mh.vary = VaryHeader.headers(fields: const [Headers.originHeader]);
      } else if (!vary.isWildcard &&
          !vary.fields.contains(Headers.originHeader)) {
        mh.vary = VaryHeader.headers(
          fields: [...vary.fields, Headers.originHeader],
        );
      }
    });
  }

  FutureOr<Result> _cloudStorage(Request req) async {
    final uri = req.url;
    assert(uri.path == '/serverpod_cloud_storage');
    return await _handleEndpointCall(uri, '', req);
  }

  Future<Response> _endpoints(Request req) async {
    var maxRequestSize = serverpod.config.maxRequestSize;
    final body = await req.readAsString(maxLength: maxRequestSize);
    return await _handleEndpointCall(req.url, body, req);
  }

  Handler _dispatchWebSocket(
    Future<void> Function(
      Server,
      RelicWebSocket,
      Request,
      void Function(),
    )
    requestHandler,
  ) {
    return (req) async {
      // Reject cross-site WebSocket handshakes when an origin allow-list is
      // configured. Only browsers send an `Origin` header; native, mobile and
      // server-to-server clients don't, and are always allowed.
      if (_isOriginDisallowed(req)) {
        return Response.forbidden(
          body: Body.fromString('WebSocket origin not allowed.'),
        );
      }

      return WebSocketUpgrade((webSocket) async {
        try {
          webSocket.pingInterval = serverpod.config.websocketPingInterval;
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

  Future<Response> _handleEndpointCall(
    Uri uri,
    String body,
    Request request,
  ) async {
    var path = uri.pathSegments.join('/');
    var endpointComponents = path.split('.');
    if (endpointComponents.isEmpty || endpointComponents.length > 2) {
      throw InvalidParametersException('Endpoint name is not valid');
    }

    // Read query parameters
    var queryParameters = <String, dynamic>{};
    var isValidBody = body != 'null' && body.isNotEmpty;
    if (isValidBody) {
      try {
        queryParameters = jsonDecode(body);
      } catch (_) {
        throw InvalidParametersException('Invalid JSON in body');
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
        throw InvalidParametersException('No method name specified');
      }
    }

    // Get the authentication key, if any, from the HTTP authorization header.
    // Auth tokens are no longer accepted via the `?auth=` query parameter, so
    // they never appear in request URLs (and thus server/proxy access logs).
    String? authenticationKey;
    String? authenticationHeaderValue;

    authenticationHeaderValue = request.getAuthorizationHeaderValue(
      serverpod.config.validateHeaders,
    );
    authenticationKey = unwrapAuthHeaderValue(authenticationHeaderValue);

    // Fall back to the web auth cookie when configured and no header was sent
    // (the browser carries it for cookie-based web clients).
    authenticationKey ??= request.getAuthCookieValue(
      serverpod.config.authCookie,
    );

    MethodCallSession? maybeSession;
    try {
      var methodCallContext = await endpoints.getMethodCallContext(
        createSessionCallback: (connector) async {
          maybeSession = await SessionInternalMethods.createMethodCallSession(
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
        return Response.internalServerError();
      }

      try {
        var result = await methodCallContext.method.call(
          session,
          methodCallContext.arguments,
        );
        var response = methodCallContext.endpoint.sendAsRaw
            ? _toResponse(result)
            : Response.ok(
                body: Body.fromString(
                  SerializationManager.encodeForProtocol(result),
                  mimeType: MimeType.json,
                ),
              );
        return applyResponseOutput(
          response,
          headers: session.responseHeaders,
          cookies: session.responseCookies,
        );
      } catch (e, stackTrace) {
        // Note: In case of malformed argument, the method connector may throw,
        // which may be argued is not an "application space" exception.
        serverpod.internalSubmitEvent(
          ExceptionEvent(e, stackTrace),
          space: OriginSpace.application,
          context: contextFromSession(session, request: request),
        );
        await session.close(error: e, stackTrace: stackTrace);

        // Apply response output queued before the failure (e.g. a sign-out's
        // cookie clear) to the error response, so it still reaches the client
        // instead of being dropped when the call throws. With nothing queued,
        // defer to _reportException for identical handling.
        if (session.responseHeaders.isEmpty &&
            session.responseCookies.isEmpty) {
          rethrow;
        }
        return applyResponseOutput(
          await _toErrorResponse(e, stackTrace, request: request),
          headers: session.responseHeaders,
          cookies: session.responseCookies,
        );
      }
    } finally {
      await maybeSession?.close(); // safe to close twice
    }
  }

  static Response _toResponse(dynamic value) {
    if (value is Response) return value;
    final body = value is Body
        ? value
        : switch (value) {
            String() => Body.fromString(value),
            Stream<Uint8List>() => Body.fromDataStream(value),
            ByteData() => Body.fromData(Uint8List.sublistView(value)),
            Uint8List() => Body.fromData(value),
            _ => Body.fromString('$value'), // use toString as fallback
          };
    return Response.ok(body: body);
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
    log.error(
      message ?? 'Unhandled exception',
      error: e,
      stackTrace: stackTrace,
    );

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

/// Extension providing testing utilities for [Server] authentication.
extension ServerInternalMethods on Server {
  /// Sets the authentication handler for testing purposes.
  ///
  /// This method allows tests to override the default authentication handler
  /// by directly setting the internal [_authenticationHandler] field.
  void setAuthenticationHandlerForTesting(
    AuthenticationHandler authenticationHandler,
  ) {
    _authenticationHandler = authenticationHandler;
  }
}
