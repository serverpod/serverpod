import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:relic/io_adapter.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';

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

  /// Router for handling incoming requests.
  final router = ServerpodRouter();

  RelicServer? _server;

  /// Security context if the web server is running over https.
  final SecurityContext? _securityContext;

  /// Creates a new webserver.
  WebServer({
    required this.serverpod,
    SecurityContext? securityContext,
  })  : serverId = serverpod.serverId,
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

  /// Adds a [Route] to the server, together with a path that defines how
  /// calls are routed.
  void addRoute(Route route, String matchPath) {
    route._matchPath = matchPath;
    router.add(route);
  }

  /// Starts the webserver.
  /// Returns true if the webserver was started successfully.
  Future<bool> start() async {
    var templatesDirectory = Directory(path.joinAll(['web', 'templates']));
    await templates.loadAll(templatesDirectory);
    if (templates.isEmpty) {
      logDebug(
          'No webserver relic templates found, template directory path: "${templatesDirectory.path}".');
    }

    try {
      final server = await serve(
        const Pipeline()
            .addMiddleware(
              routeWith(router as Router<Route>, toHandler: _routeToHandler),
            )
            .addHandler(
              respondWith((_) => Response.notFound()),
            ),
        InternetAddress.anyIPv6,
        _config.port,
        securityContext: _securityContext,
      );
      _server = server;
      _actualPort = (server.adapter as IOAdapter).port;
      _running = true;

      var scheme = _securityContext != null ? 'https' : 'http';
      var host = _config.publicHost;
      var port = _actualPort;
      logInfo('Webserver listening on $scheme://$host:$port');
    } catch (e, stackTrace) {
      await _reportException(e, stackTrace,
          message: 'Failed to bind socket, '
              'port $port may already be in use.');
    }
    return _running;
  }

  Handler _routeToHandler(Route route) {
    return (ctx) {
      final request = ctx.request;

      final session = WebCallSession(
        server: serverpod.server,
        endpoint: request.requestedUri.path,
        authenticationKey: request.headers.authorization?.headerValue,
        remoteInfo: request.remoteInfo,
      );

      return _handleRouteCall(route, session, ctx);
    };
  }

  Future<HandledContext> _handleRouteCall(
    Route route,
    Session session,
    NewContext context,
  ) async {
    try {
      return await route.handleCall(session, context);
    } catch (e, stackTrace) {
      final request = context.request;
      await _reportException(
        e,
        stackTrace,
        space: OriginSpace.application,
        session: session,
        request: request,
      );

      return context.respond(Response.internalServerError());
    }
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

/// A [Route] defines a destination in Serverpod's web server. It will handle
/// a call and generate an appropriate response by manipulating the
/// [Request] object. You override [Route], or more likely it's subclass
/// [WidgetRoute] to create your own custom routes in your server.
abstract class Route {
  /// The methods this route will respond to, i.e. HTTP get or post.
  final Set<Method> methods;
  String? _matchPath;

  /// Creates a new [Route].
  Route({this.methods = const {Method.get}});

  /// Handles a call to this route.
  FutureOr<HandledContext> handleCall(Session session, NewContext context);
}

/// A [WidgetRoute] is the most convenient way to create routes in your server.
/// Override the [build] method and return an appropriate [WebWidget].
abstract class WidgetRoute extends Route {
  /// Override this method to build your web widget from the current [session]
  /// and [request].
  Future<WebWidget> build(Session session, Request request);

  @override
  FutureOr<HandledContext> handleCall(
    Session session,
    NewContext context,
  ) async {
    var widget = await build(session, context.request);

    if (widget is RedirectWidget) {
      var uri = Uri.parse(widget.url);
      return context.respond(Response.seeOther(uri));
    }

    final mimeType = widget is JsonWidget ? MimeType.json : MimeType.html;

    final headers = Headers.build(
      (mh) => mh.cacheControl = CacheControlHeader(
        noCache: true,
        privateCache: true,
      ),
    );

    return context.respond(Response.ok(
      body: Body.fromString(widget.toString(), mimeType: mimeType),
      headers: headers,
    ));
  }
}

/// A [ServerpodRouter] is a collection of [Route]s that can be used to
/// handle incoming requests. It uses the [relic] package to match routes.
extension type ServerpodRouter._(Router<Route> _router) {
  /// Creates a new [ServerpodRouter].
  ServerpodRouter() : _router = Router<Route>();

  /// Adds a [Route] to the router.
  void add(Route route) =>
      _router.anyOf(route.methods, route._matchPath!, route);

  /// Looks up a [Route] in the router based on the HTTP method and path.
  LookupResult<Route>? lookup(Method method, String path) =>
      _router.lookup(method, path);

  /// Checks if the router is empty.
  bool get isEmpty => _router.isEmpty;
}
