import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// The Serverpod webserver.
class WebServer {
  /// Reference to the [Serverpod] this webserver is associated with.
  final Serverpod serverpod;

  /// The server id of this server.
  final String serverId;

  /// The port the webserver is running on.
  late final int _port;

  /// The hostname of the webserver.
  late final String _hostname;

  /// A list of [Route] which defines how to handle path passed to the server.
  final List<Route> routes = <Route>[];

  /// Creates a new webserver.
  WebServer({
    required this.serverpod,
  }) : serverId = serverpod.serverId {
    _port = serverpod.config.webServer.port;
    _hostname = serverpod.config.webServer.publicHost;
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
    await HttpServer.bind(InternetAddress.anyIPv6, _port)
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

    stdout.writeln('Webserver listening on port $_port');
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

    if (uri.host != _hostname) {
      var redirect = uri.replace(host: _hostname);
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

    var session = MethodCallSession(
      server: serverpod.server,
      uri: uri,
      endpointName: 'webserver',
      body: await Route.getBody(request),
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

  /// Sets the headers of the response. Default is text/html with UTF-8
  /// encoding.
  void setHeaders(HttpHeaders headers) {
    headers.contentType = ContentType('text', 'html', charset: 'utf-8');
  }

  /// Handles a call to this route. This method is repsonsible for setting
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

  /// Returns the body of the request, handle JSON as first class citizen
  static Future<String> getBody(HttpRequest request) async {
    var rawBody = await _readBody(request) ?? '';
    if (rawBody.isEmpty) return rawBody;

    try {
      json.decode(rawBody);
    } on FormatException catch (_) {
      // no json
      if (request.headers.contentType?.subType.contains('form-urlencoded') ==
          true) {
        return _convertToJsonBody(rawBody);
      }
    }
    return rawBody;
  }

  /// Returns the body of the request, assuming it is standard URL encoded form
  /// post request.
  static Future<String> _convertToJsonBody(String body) async {
    var params = <String, String>{};

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

    return json.encode(params);
  }

  /// For custom body retrieval use this method explicitly
  static Future<String?> _readBody(HttpRequest request) async {
    var listUint8List = await request.asBroadcastStream().toList();
    if (listUint8List.isEmpty) return null;

    var length = 0;
    var sb = StringBuffer('');
    for (var uInt8List in listUint8List) {
      length += uInt8List.length;
      if (length > 10240) return null;

      sb.write(const Utf8Decoder().convert(uInt8List));
    }

    return sb.toString();
  }
}

/// A [WidgetRoute] is the most convienient way to create routes in your server.
/// Override the [build] method and return an appropriate [Widget].
abstract class WidgetRoute extends Route {
  /// Override this method to build your web [Widget] from the current [session]
  /// and [request].
  Future<AbstractWidget> build(Session session, HttpRequest request);

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    var widget = await build(session, request);

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
