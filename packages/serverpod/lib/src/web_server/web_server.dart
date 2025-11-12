import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:relic/io_adapter.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/session.dart';

/// The Serverpod webserver.
class WebServer {
  /// Reference to the [Serverpod] this webserver is associated with.
  final Serverpod serverpod;

  /// The server id of this server.
  final String serverId;

  /// The configuration for this web server.
  late final ServerConfig _config;

  /// The port the webserver is listening on, or null if not started.
  int? get port => _actualPort;

  int? _actualPort;

  late final _app = RelicApp()
    ..inject(_ReportExceptionMiddleware(this))
    ..inject(_SessionMiddleware(serverpod.server));

  RelicServer? _server;

  /// Security context if the web server is running over https.
  final SecurityContext? _securityContext;

  /// Creates a new webserver.
  WebServer({
    required this.serverpod,
    SecurityContext? securityContext,
  }) : serverId = serverpod.serverId,
       _securityContext = securityContext {
    var config = serverpod.config.webServer;

    if (config == null) {
      throw StateError(
        'No web server configuration found in Serverpod unable to create the WebServer.',
      );
    }

    _config = config;
  }

  bool _running = false;

  /// Returns true if the webserver is currently running.
  bool get running => _running;

  /// Adds [route] to the server, together with a [path] that defines how
  /// calls are routed.
  void addRoute(Route route, [String path = '/']) =>
      _app.group(path).inject(route);

  /// Adds a [Middleware] to the server for all routes below [path].
  void addMiddleware(Middleware middleware, String path) =>
      _app.use(path, middleware);

  /// Sets a fallback [route] to use if no other registered [Route] matches
  /// a request.
  ///
  /// If not set, default behavior is to return "404 Not Found".
  set fallbackRoute(Route route) => _app.fallback = route.asHandler;

  /// Returns true if the webserver has any routes registered.
  bool get hasRoutes => !_app.isEmpty;

  /// Starts the webserver.
  /// Returns true if the webserver was started successfully.
  Future<bool> start() async {
    var templatesDirectory = Directory(path.joinAll(['web', 'templates']));
    await templates.loadAll(templatesDirectory);
    if (templates.isEmpty) {
      logDebug(
        'No webserver relic templates found, template directory path: "${templatesDirectory.path}".',
      );
    }

    try {
      final server = await _app.serve(
        address: InternetAddress.anyIPv6,
        port: _config.port,
        securityContext: _securityContext,
      );
      _server = server;
      _actualPort = server.port;
      _running = true;

      var scheme = _securityContext != null ? 'https' : 'http';
      var host = _config.publicHost;
      logInfo('Webserver listening on $scheme://$host:$_actualPort');
    } catch (e, stackTrace) {
      await _reportException(
        e,
        stackTrace,
        message:
            'Failed to bind socket, port ${_config.port} may already be in use.',
      );
    }
    return _running;
  }

  Future<void> _reportException(
    Object e,
    StackTrace stackTrace, {
    OriginSpace space = OriginSpace.framework,
    String? message,
    Session? session,
    Request? request,
  }) async {
    logError(
      message != null ? '$message $e' : e,
      stackTrace: stackTrace,
    );

    var context = session != null
        ? contextFromSession(session, request: request)
        : request != null
        ? contextFromRequest(serverpod.server, request, OperationType.web)
        : contextFromServer(serverpod.server);

    serverpod.internalSubmitEvent(
      ExceptionEvent(e, stackTrace, message: message),
      space: space,
      context: context,
    );
  }

  /// Logs an error to stderr.
  void logError(Object e, {StackTrace? stackTrace}) {
    var now = DateTime.now().toUtc();
    stderr.writeln('$now WebServer ERROR: $e');
    if (stackTrace != null) {
      stderr.writeln('$stackTrace');
    }
  }

  /// Logs an info message to stdout.
  void logInfo(String msg) {
    var now = DateTime.now().toUtc();
    stdout.writeln('$now WebServer  INFO: $msg');
  }

  /// Logs a debug message to stdout.
  void logDebug(String msg) {
    var now = DateTime.now().toUtc();
    stdout.writeln('$now WebServer DEBUG: $msg');
  }

  /// Stops the webserver.
  Future<void> stop() async {
    final server = _server;
    if (server != null) {
      _server = null;
      await server.close();
    }
    _running = false;
  }
}

class _SessionMiddleware extends MiddlewareObject {
  final Server _server;

  const _SessionMiddleware(this._server);

  @override
  Handler call(Handler next) {
    return (req) async {
      final authenticationKey = unwrapAuthHeaderValue(
        req.headers.authorization?.headerValue,
      );
      final session = await SessionInternalMethods.createWebCallSession(
        server: _server,
        endpoint: req.requestedUri.path,
        authenticationKey: authenticationKey,
        remoteInfo: req.remoteInfo,
      );
      _sessionProperty[req] = session;
      try {
        return await next(req);
      } finally {
        await session.close();
      }
    };
  }
}

class _ReportExceptionMiddleware extends MiddlewareObject {
  final WebServer _webServer;

  const _ReportExceptionMiddleware(this._webServer);

  @override
  Handler call(Handler next) {
    return (req) async {
      try {
        return await next(req);
      } catch (e, stackTrace) {
        await _webServer._reportException(
          e,
          stackTrace,
          space: OriginSpace.application,
          session: req.sessionOrNull,
          request: req,
        );
        return Response.internalServerError();
      }
    };
  }
}

final _sessionProperty = ContextProperty<Session>();

/// [Session] related extension methods for [Context].
extension SessionEx on Request {
  /// The session associated with this request context.
  ///
  /// Throws, if no session has been initiated.
  Session get session => _sessionProperty[this];

  /// The session associated with this request context, if any.
  ///
  /// Safe to use, even before session is initiated.
  Session? get sessionOrNull => _sessionProperty.getOrNull(this);
}

/// A [Route] defines a destination in Serverpod's web server. It will handle
/// a call and generate an appropriate response by manipulating the
/// [Request] object. You override [Route], or more likely it's subclass
/// [WidgetRoute] to create your own custom routes in your server.
abstract class Route extends HandlerObject {
  /// The methods this route will respond to, i.e. HTTP get or post.
  final Set<Method> methods;

  /// The suffix path this route will respond to.
  ///
  /// The complete path is determined by where the route is added, ie.
  /// the path given to [WebServer.addRoute].
  final String path;

  /// Creates a new [Route].
  Route({this.methods = const {Method.get}, this.path = '/'});

  @override
  void injectIn(RelicRouter router) => router.anyOf(methods, path, asHandler);

  /// Handles a call to this route, by extracting [Session] from context and
  /// forwarding to [handleCall].
  @override
  FutureOr<Result> call(Request context) {
    return handleCall(context.session, context);
  }

  /// Handles a call to this route.
  FutureOr<Result> handleCall(Session session, Request context);
}

/// A [WidgetRoute] is the most convenient way to create routes in your server.
/// Override the [build] method and return an appropriate [WebWidget].
abstract class WidgetRoute extends Route {
  /// Override this method to build your web widget from the current [session]
  /// and [request].
  Future<WebWidget> build(Session session, Request request);

  @override
  FutureOr<Result> handleCall(
    Session session,
    Request req,
  ) async {
    var widget = await build(session, req);

    if (widget is RedirectWidget) {
      var uri = Uri.parse(widget.url);
      return Response.seeOther(uri);
    }

    final mimeType = widget is JsonWidget ? MimeType.json : MimeType.html;

    final headers = Headers.build(
      (mh) => mh.cacheControl = CacheControlHeader(
        noCache: true,
        privateCache: true,
      ),
    );

    return Response.ok(
      body: Body.fromString(widget.toString(), mimeType: mimeType),
      headers: headers,
    );
  }
}
