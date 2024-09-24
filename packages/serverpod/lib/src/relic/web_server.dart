import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';

/// The Serverpod webserver.
class WebServer {
  /// Reference to the [Serverpod] this webserver is associated with.
  final Serverpod serverpod;

  /// If a security context is provided an HTTPS server will be started.
  final SecurityContext? securityContext;

  /// The [address] can either be a [String] or an [InternetAddress]. If
  /// [address] is a [String], the server will perform a
  /// [InternetAddress.lookup] and use the first value in the list. Defaults to
  /// [InternetAddress.anyIPv6].
  final Object? address;

  /// The server id of this server.
  final String serverId;

  /// The port the webserver is running on.
  late final int _port;

  /// A list of [Route] which defines how to handle path passed to the server.
  final List<Route> routes = <Route>[];

  /// Creates a new webserver. If a security context is provided an HTTPS server
  /// will be started.
  WebServer({
    required this.serverpod,
    this.securityContext,
    this.address,
  }) : serverId = serverpod.serverId {
    var config = serverpod.config.webServer;

    if (config == null) {
      throw StateError(
        'No web server configuration found in Serverpod unable to create the '
        'WebServer.',
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
      _httpServer = await (securityContext == null
          ? HttpServer.bind(
              address ?? InternetAddress.anyIPv6,
              _port,
            )
          : HttpServer.bindSecure(
              address ?? InternetAddress.anyIPv6,
              _port,
              securityContext!,
            ));
    } catch (e) {
      stderr.writeln(
        '${DateTime.now().toUtc()} ERROR: Failed to bind socket, Webserver '
        'port $_port may already be in use.',
      );
      stderr.writeln('${DateTime.now().toUtc()} ERROR: $e');
      return false;
    }
    httpServer.autoCompress = true;

    runZonedGuarded(
      _start,
      (e, stackTrace) {
        // Last resort error handling
        stdout.writeln('${DateTime.now()} Relic zoned error: $e');
        stdout.writeln('$stackTrace');
      },
    );

    return true;
  }

  void _start() async {
    stdout.writeln('Webserver listening on port $_port');

    try {
      await for (var request in httpServer) {
        try {
          _handleRequest(request);
        } catch (e, stackTrace) {
          logError(e, stackTrace: stackTrace);
        }
      }
    } catch (e, stackTrace) {
      logError(e, stackTrace: stackTrace);
    }
  }

  void _handleRequest(HttpRequest request) async {
    Uri uri;
    try {
      uri = request.requestedUri;
    } catch (e) {
      logDebug(
        'Malformed call, invalid uri from '
        '${request.connectionInfo?.remoteAddress.address}',
      );

      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }

    print('Handle: $uri');

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
        var response = await _handleRouteCall(
          route,
          session,
          Request.fromHttpRequest(request),
        );
        if (response.statusCode == HttpStatus.notFound) {
          continue;
        }
        print('Writing $uri');
        await response.writeHttpResponse(request.response, 'serverpod-relic');
        print('Finished $uri');
        await session.close();
        return;
      }
    }

    print('Not found. $uri');
    // No matching patch found
    request.response.statusCode = HttpStatus.notFound;
    await request.response.close();
    await session.close();
  }

  Future<Response> _handleRouteCall(
      Route route, Session session, Request request) async {
    try {
      return route.handleCall(session, request);
    } catch (e) {
      return Response.internalServerError();
    }
  }

  /// Logs an error to stderr.
  void logError(var e, {StackTrace? stackTrace}) {
    stderr.writeln('ERROR: $e');
    if (stackTrace != null) {
      stderr.writeln('$stackTrace');
    }
  }

  /// Logs a message to stdout.
  void logDebug(String msg) {
    stdout.writeln(msg);
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
/// [WidgetRoute] to create your own custom routes in your server.
abstract class Route {
  /// The method this route will respond to, i.e. HTTP get or post.
  final RouteMethod method;
  String? _matchPath;

  /// Creates a new [Route].
  Route({this.method = RouteMethod.get});

  /// Handles a call to this route. This method is responsible for setting
  /// a correct response headers, status code, and write the response body to
  /// `request.response`.
  Future<Response> handleCall(Session session, Request request);

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
    // TODO: Find more efficient solution?
    var len = 0;
    var data = <int>[];
    await for (var segment in request) {
      len += segment.length;
      if (len > 10240) {
        return null;
      }
      data += segment;
    }
    return const Utf8Decoder().convert(data);
  }
}

/// A [WidgetRoute] is the most convenient way to create routes in your server.
/// Override the [build] method and return an appropriate [Widget].
abstract class WidgetRoute extends Route {
  /// Override this method to build your web [Widget] from the current [session]
  /// and [request].
  Future<AbstractWidget> build(Session session, Request request);

  @override
  Future<Response> handleCall(Session session, Request request) async {
    var widget = await build(session, request);

    if (widget is WidgetJson) {
      return Response.ok(
        body: Body.fromString(
          widget.toString(),
          contentType: BodyType.json,
        ),
      );
    } else if (widget is WidgetRedirectPermanently) {
      return Response.movedPermanently(widget.url);
    } else if (widget is WidgetRedirectTemporarily) {
      return Response.seeOther(widget.url);
    } else {
      return Response.ok(
        body: Body.fromString(
          widget.toString(),
          contentType: BodyType.html,
        ),
      );
    }
  }
}
