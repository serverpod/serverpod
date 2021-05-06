import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import 'web_widget.dart';
import 'templates.dart';
import 'config.dart';

class WebServer {
  final Serverpod serverpod;
  final int serverId;
  late final int port;
  late final String hostname;
  final List<Route> routes = <Route>[];

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
  bool get running => _running;

  HttpServer? _httpServer;
  HttpServer get httpServer => _httpServer!;

  void addRoute(Route route, String matchPath) {
    route._matchPath = matchPath;
    routes.add(route);
  }

  Future<void> start() async {
    await templates.loadAll();

    await runZonedGuarded(
      _start,
      (e, stackTrace) {
        // Last resort error handling
        print('${DateTime.now()} Relic zoned error: $e');
        print('$stackTrace');
      },
    );
  }

  Future<void> _start() async {
    await HttpServer.bind(InternetAddress.anyIPv6, port).then((HttpServer httpServer) {
      _httpServer = httpServer;
      httpServer.autoCompress = true;
      httpServer.listen(
              (HttpRequest request) {
            try {
              _handleRequest(request);
            }
            catch(e, stackTrace) {
              logError(e, stackTrace: stackTrace);
            }
          },
          onError: (e, StackTrace stackTrace) {
            logError(e, stackTrace: stackTrace);
          }
      ).onDone(() {
        print('Server stopped.');
      });
    });


    print('Webserver listening on port $port');
  }

  void _handleRequest(HttpRequest request) async {
    if (serverpod.runMode == 'production') {
      request.response.headers.add('Strict-Transport-Security', 'max-age=63072000; includeSubDomains; preload');
    }

    Uri uri;
    try {
      uri = request.requestedUri;
    }
    catch(e) {
      logDebug('Malformed call, invalid uri from ${request.connectionInfo?.remoteAddress.address}');

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
    var session = Session(
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

  Future<bool> _handleRouteCall(Route route, Session session, HttpRequest request) async {
    route.setHeaders(request.response.headers);
    try {
      var found = await route.handleCall(session, request);
      return found;
    }
    catch(e, stackTrace) {
      logError(e, stackTrace: stackTrace);

      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('$e');
      await request.response.close();
    }
    return true;
  }

  void logError(var e, {StackTrace? stackTrace}) {
    print('ERROR: $e');
    print('$stackTrace');
  }

  void logDebug(String msg) {
    print(msg);
  }

  void stop() {
    if (_httpServer != null) {
      _httpServer!.close();
    }
    _running = false;
  }
}

enum RouteMethod {
  get,
  post,
}

abstract class Route {
  final RouteMethod method;
  String? _matchPath;

  Route({this.method=RouteMethod.get});

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
    }
    else {
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
    return Utf8Decoder().convert(data);
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
    }
    else if (widget is WidgetRedirect) {
      var uri = Uri.parse(widget.url);
      await request.response.redirect(uri);
      return true;
    }

    request.response.write(widget.toString());
    return true;
  }
}