import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'config.dart';
import 'templates.dart';
import 'web_widget.dart';

/// The Serverpod webserver.
class WebServer {
  /// Reference to the [Serverpod] this webserver is associated with.
  final Serverpod serverpod;

  /// The server id of this server.
  final String serverId;

  /// The port the webserver is running on.
  late final int port;

  /// The hostname of the webserver.
  late final String hostname;

  /// A list of [Route] which defines how to handle path passed to the server.
  final List<Route> routes = <Route>[];

  /// Creates a new webserver.
  WebServer({
    required this.serverpod,
  }) : serverId = serverpod.serverId {
    var config = WebserverConfig(
      serverId: serverId,
      runMode: serverpod.runMode,
    );

    port = config.port!;
    hostname = config.hostname!;
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
  Future<void> start() async {
    await templates.loadAll();

    await runZonedGuarded(
      _start,
      (e, stackTrace) {
        // Last resort error handling
        stdout.writeln('${DateTime.now()} Relic zoned error: $e');
        stdout.writeln('$stackTrace');
      },
    );
  }

  Future<void> _start() async {
    await HttpServer.bind(InternetAddress.anyIPv6, port)
        .then((HttpServer httpServer) {
      _httpServer = httpServer;
      httpServer.autoCompress = true;
      httpServer.listen((HttpRequest request) {
        try {
          _handleRequest(request);
        } catch (e, stackTrace) {
          logError(e, stackTrace: stackTrace);
        }
      }, onError: (e, StackTrace stackTrace) {
        logError(e, stackTrace: stackTrace);
      }).onDone(() {
        stdout.writeln('Server stopped.');
      });
    });

    stdout.writeln('Webserver listening on port $port');
  }

  void _handleRequest(HttpRequest request) async {
    if (serverpod.runMode == 'production') {
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

    if (uri.host != hostname) {
      var redirect = uri.replace(host: hostname);
      request.response.headers.add('Location', redirect.toString());
      request.response.statusCode = HttpStatus.movedPermanently;
      await request.response.close();
      return;
    }

    String? authenticationKey;
    for (var cookie in request.cookies) {
      if (cookie.name == 'auth') {
        authenticationKey = cookie.value;
      }
    }

    // TODO: Fix body
    var session = MethodCallSession(
      server: serverpod.server,
      uri: uri,
      endpointName: 'webserver',
      body: '',
      authenticationKey: authenticationKey,
      httpRequest: request,
    );

//    print('Getting path: ${uri.path}');

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
      logError(e, stackTrace: stackTrace);

      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('$e');
      await request.response.close();
    }
    return true;
  }

  /// Logs an error to stderr.
  void logError(var e, {StackTrace? stackTrace}) {
    stderr.writeln('ERROR: $e');
    stderr.writeln('$stackTrace');
  }

  /// Logs a message to stdout.
  void logDebug(String msg) {
    stdout.writeln(msg);
  }

  /// Stops the webserver.
  void stop() {
    if (_httpServer != null) {
      _httpServer!.close();
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

abstract class Route {
  final RouteMethod method;
  String? _matchPath;

  Route({this.method = RouteMethod.get});

  void setHeaders(HttpHeaders headers) {
    headers.contentType = ContentType('text', 'html', charset: 'utf-8');
  }

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

  Future<Map<String, String>> getBody(HttpRequest request) async {
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

  Future<String?> _readBody(HttpRequest request) async {
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

abstract class WidgetRoute extends Route {
  Future<AbstractWidget> build(Session session, HttpRequest request);

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    var widget = await build(session, request);
    // if (widget == null)
    //   return false;

    if (widget is WidgetJson) {
      request.response.headers.contentType = ContentType('application', 'json');
    } else if (widget is WidgetRedirect) {
      var uri = Uri.parse(widget.url);
      await request.response.redirect(uri);
      return true;
    }

    request.response.write(widget.toString());
    return true;
  }
}
