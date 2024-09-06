import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:mustache_template/mustache.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/relic/util/log_utils.dart';

part './routes/routes.dart';

/// The Serverpod webserver.
class WebServer {
  static WebServer? _currentInstance;

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

  /// Global access to all templates loaded when starting the webserver.
  final Templates _templates = Templates();

  /// Creates a new webserver. If a security context is provided an HTTPS server
  /// will be started.
  WebServer({
    required this.serverpod,
    this.securityContext,
    this.address,
  }) : serverId = serverpod.serverId {
    _currentInstance = this;

    var config = serverpod.config.webServer;

    if (config == null) {
      throw StateError(
        'No web server configuration found in Serverpod unable to create the '
        'WebServer.',
      );
    }

    _port = config.port;
  }

  /// Gets the current instance of the [WebServer]. Returns `null` if no instance
  /// is running.
  static WebServer? get currentInstance => _currentInstance;

  bool _running = false;

  /// Returns true if the webserver is currently running.
  bool get running => _running;

  HttpServer? _httpServer;

  /// Returns the [HttpServer] this webserver is using to handle connections.
  HttpServer get httpServer => _httpServer!;

  /// Retrieves a loaded template by its [name]. Returns `null` if the template
  /// is not found.
  Template? getTemplate(String name) => _templates[name];

  /// Starts the webserver.
  /// Returns true if the webserver was started successfully.
  Future<bool> start() async {
    await _templates.loadAll();

    try {
      _httpServer = await switch (securityContext != null) {
        true => HttpServer.bindSecure(
            address ?? InternetAddress.anyIPv6,
            _port,
            securityContext!,
          ),
        false => HttpServer.bind(
            address ?? InternetAddress.anyIPv6,
            _port,
          ),
      };
    } catch (e) {
      var now = DateTime.now().toUtc();
      stderr.writeln(
        '$now ERROR: Failed to bind socket, Webserver '
        'port $_port may already be in use.',
      );
      stderr.writeln('$now ERROR: $e');
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

  /// Stops the webserver.
  Future<void> stop() async {
    await _httpServer?.close();
    _httpServer = null;
    _running = false;
  }

  /// Adds a [Route] to the server, together with a path that defines how
  /// calls are routed.
  void addRoute(Route route, String matchPath) {
    route._matchPath = matchPath;
    routes.add(route);
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

    // Check routes
    var route = routes.firstWhereOrNull(
      (route) => route._isMatch(uri.path),
    );

    if (route == null) {
      // No matching route found
      await _handleNotFound(request, uri);
      return;
    }

    logDebug('Handle: $uri');

    WebCallSession session = WebCallSession(
      server: serverpod.server,
      endpoint: uri.path,
      authenticationKey: _findAuthenticationKey(request),
    );

    var response = await _handleRouteCall(
      route,
      session,
      Request.fromHttpRequest(request),
    );

    // If the route returned a "not found" response
    if (response.statusCode == HttpStatus.notFound) {
      await _handleNotFound(request, uri);
      await session.close();
      return;
    }

    logDebug('Writing $uri');
    await response.writeHttpResponse(
      request.response,
      poweredByHeader: 'serverpod-relic',
    );
    logDebug('Finished $uri');
    await session.close();
  }

  Future<Response> _handleRouteCall(
    Route route,
    Session session,
    Request request,
  ) async {
    try {
      return await route.handleCall(session, request);
    } catch (e) {
      return Response.internalServerError();
    }
  }

  /// Handles "not found" responses by logging and closing the request
  Future<void> _handleNotFound(HttpRequest request, Uri uri) async {
    logError('Route not found: $uri');
    request.response.statusCode = HttpStatus.notFound;
    await request.response.close();
  }

  /// Extracts the authentication key from either cookies or query parameters
  String? _findAuthenticationKey(HttpRequest request) {
    // Check for the authentication key in cookies
    for (var cookie in request.cookies) {
      if (cookie.name == 'auth') {
        return cookie.value;
      }
    }

    return request.uri.queryParameters['auth'];
  }
}
