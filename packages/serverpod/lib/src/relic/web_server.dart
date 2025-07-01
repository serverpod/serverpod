import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';

/// The Serverpod webserver.
class WebServer {
  /// Reference to the [Serverpod] this webserver is associated with.
  final Serverpod serverpod;

  /// The server id of this server.
  final String serverId;

  /// The port the webserver is running on.
  late final int _port;

  /// A list of [Route] which defines how to handle path passed to the server.
  final List<Route> routes = <Route>[];

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

    _port = config.port;
  }

  bool _running = false;

  /// Returns true if the webserver is currently running.
  bool get running => _running;

  HttpServer? _httpServer;

  /// Returns the [HttpServer] this webserver is using to handle connections.
  HttpServer get httpServer => _httpServer!;

  /// Adds a [Route] to the server, together with a path that defines how
  /// calls are routed.
  void addRoute(Route route, String matchPath) {
    route._matchPath = matchPath;
    routes.add(route);
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
      var context = _securityContext;
      _httpServer = await switch (context) {
        SecurityContext() => HttpServer.bindSecure(
            InternetAddress.anyIPv6,
            _port,
            context,
          ),
        _ => HttpServer.bind(
            InternetAddress.anyIPv6,
            _port,
          ),
      };
    } catch (e, stackTrace) {
      await _reportException(e, stackTrace,
          message: 'Failed to bind socket, '
              'port $_port may already be in use.');

      return false;
    }
    httpServer.autoCompress = true;

    runZonedGuarded(
      _start,
      (e, stackTrace) async {
        // Last resort error handling

        await _reportException(e, stackTrace, message: 'Relic zoned error');
      },
    );

    return true;
  }

  void _start() async {
    logInfo('Webserver listening on port $_port');

    try {
      await for (var request in httpServer) {
        try {
          _handleRequest(request);
        } catch (e, stackTrace) {
          await _reportException(e, stackTrace, httpRequest: request);
        }
      }
    } catch (e, stackTrace) {
      await _reportException(e, stackTrace);
    }
  }

  void _handleRequest(HttpRequest request) async {
    if (serverpod.runMode == ServerpodRunMode.production) {
      request.response.headers.add('Strict-Transport-Security',
          'max-age=63072000; includeSubDomains; preload');
    }

    Uri uri;
    try {
      uri = request.requestedUri;
    } catch (e) {
      logDebug(
          'Malformed call, invalid uri from ${request.connectionInfo?.remoteAddress.address}');

      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }

    String? authenticationKey;
    for (var cookie in request.cookies) {
      if (cookie.name == 'auth') {
        authenticationKey = cookie.value;
      }
    }

    var queryParameters = request.uri.queryParameters;
    authenticationKey ??= queryParameters['auth'];

    WebCallSession session = WebCallSession(
      server: serverpod.server,
      endpoint: uri.path,
      authenticationKey: authenticationKey,
    );

    // Check routes
    for (var route in routes) {
      if (route._isMatch(uri.path)) {
        var found = await _handleRouteCall(route, session, request);
        if (found) {
          await request.response.close();
          await session.close();
          return;
        }
      }
    }

    // No matching patch found
    request.response.statusCode = HttpStatus.notFound;
    await request.response.close();
    await session.close();
  }

  Future<bool> _handleRouteCall(
      Route route, Session session, HttpRequest request) async {
    route.setHeaders(request.response.headers);
    try {
      var found = await route.handleCall(session, request);
      return found;
    } catch (e, stackTrace) {
      await _reportException(
        e,
        stackTrace,
        space: OriginSpace.application,
        session: session,
        httpRequest: request,
      );

      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('Internal Server Error');

      await request.response.close();
    }
    return true;
  }

  Future<void> _reportException(
    Object e,
    StackTrace stackTrace, {
    OriginSpace space = OriginSpace.framework,
    String? message,
    Session? session,
    HttpRequest? httpRequest,
  }) async {
    logError(
      message != null ? '$message $e' : e,
      stackTrace: stackTrace,
    );

    var context = session != null
        ? contextFromSession(session, httpRequest: httpRequest)
        : httpRequest != null
            ? contextFromHttpRequest(
                serverpod.server, httpRequest, OperationType.web)
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
    var localHttpServer = _httpServer;
    if (localHttpServer != null) {
      await localHttpServer.close();
    }
    _running = false;
  }
}

/// Defines HTTP call methods for routes.
enum RouteMethod {
  /// HTTP get.
  get,

  /// HTTP post.
  post,
}

/// A [Route] defines a destination in Serverpod's web server. It will handle
/// a call and generate an appropriate response by manipulating the
/// [HttpRequest] object. You override [Route], or more likely it's subclass
/// [ComponentRoute] to create your own custom routes in your server.
abstract class Route {
  /// The method this route will respond to, i.e. HTTP get or post.
  final RouteMethod method;
  String? _matchPath;

  /// Creates a new [Route].
  Route({this.method = RouteMethod.get});

  /// Sets the headers of the response. Default is text/html with UTF-8
  /// encoding.
  void setHeaders(HttpHeaders headers) {
    headers.contentType = ContentType('text', 'html', charset: 'utf-8');
  }

  /// Handles a call to this route. This method is responsible for setting
  /// a correct response headers, status code, and write the response body to
  /// `request.response`.
  Future<bool> handleCall(Session session, HttpRequest request);

  bool _isMatch(String path) {
    if (_matchPath == null) {
      return false;
    }
    if (_matchPath!.endsWith('*')) {
      var start = _matchPath!.substring(0, _matchPath!.length - 1);
      return path.startsWith(start);
    } else {
      return _matchPath == path;
    }
  }

  // TODO: May want to create another abstraction layer here, to handle other
  // types of responses too. Or at least clarify the naming of the method.

  /// Returns the body of the request, assuming it is standard URL encoded form
  /// post request.
  static Future<Map<String, String>> getBody(HttpRequest request) async {
    var body = await _readBody(request);

    var params = <String, String>{};

    if (body != null) {
      var encodedParams = body.split('&');
      for (var encodedParam in encodedParams) {
        var comps = encodedParam.split('=');
        if (comps.length != 2) {
          continue;
        }

        var name = Uri.decodeQueryComponent(comps[0]);
        var value = Uri.decodeQueryComponent(comps[1]);

        params[name] = value;
      }
    }

    return params;
  }

  static Future<String?> _readBody(HttpRequest request) async {
    var builder = BytesBuilder();
    var len = 0;
    await for (var segment in request) {
      len += segment.length;
      if (len > 10240) {
        return null;
      }
      builder.add(segment);
    }
    return const Utf8Decoder().convert(builder.toBytes());
  }
}

/// A [ComponentRoute] is the most convenient way to create routes in your server.
/// Override the [build] method and return an appropriate [Component].
abstract class ComponentRoute extends Route {
  /// Override this method to build your web [Component] from the current [session]
  /// and [request].
  Future<AbstractComponent> build(Session session, HttpRequest request);

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    var widget = await build(session, request);

    if (widget is JsonComponent) {
      request.response.headers.contentType = ContentType('application', 'json');
    } else if (widget is RedirectComponent) {
      var uri = Uri.parse(widget.url);
      await request.response.redirect(uri);
      return true;
    }

    request.response.write(widget.toString());
    return true;
  }
}
