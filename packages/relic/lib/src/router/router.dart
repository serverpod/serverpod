// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:collection' show UnmodifiableMapView;
import 'dart:convert';
import 'dart:typed_data';

import 'package:http_methods/http_methods.dart';
import 'package:meta/meta.dart' show sealed;
import 'package:relic/relic.dart';

import 'router_entry.dart' show RouterEntry;

/// Get a URL parameter captured by the [Router].
@Deprecated('Use Request.params instead')
String params(Request request, String name) {
  final value = request.params[name];
  if (value == null) {
    throw Exception('no such parameter $name');
  }
  return value;
}

final _emptyParams = UnmodifiableMapView(<String, String>{});

extension RouterParams on Request {
  /// Get URL parameters captured by the [Router].
  ///
  /// **Example**
  /// ```dart
  /// final app = Router();
  ///
  /// app.get('/hello/<name>', (Request request) {
  ///   final name = request.params['name'];
  ///   return Response.ok('Hello $name');
  /// });
  /// ```
  ///
  /// If no parameters are captured this returns an empty map.
  ///
  /// The returned map is unmodifiable.
  Map<String, String> get params {
    final p = context['shelf_router/params'];
    if (p is Map<String, String>) {
      return UnmodifiableMapView(p);
    }
    return _emptyParams;
  }
}

/// Middleware to remove body from request.
final _removeBody = createMiddleware(responseHandler: (r) {
  if (r.headers.contentLength != null) {
    r = r.copyWith(
      headers: r.headers.copyWith(
        contentLength: '0',
      ),
    );
  }
  return r.copyWith(
    body: Body.fromData(
      Uint8List.fromList(<int>[]),
    ),
  );
});

/// A shelf [Router] routes requests to handlers based on HTTP verb and route
/// pattern.
///
/// ```dart
/// import 'package:shelf_router/shelf_router.dart';
/// import 'package:shelf/shelf.dart';
/// import 'package:shelf/shelf_io.dart' as io;
///
/// var app = Router();
///
/// // Route pattern parameters can be specified <paramName>
/// app.get('/users/<userName>/whoami', (Request request) async {
///   // The matched values can be read with params(request, param)
///   var userName = request.params['userName'];
///   return Response.ok('You are ${userName}');
/// });
///
/// // The matched value can also be taken as parameter, if the handler given
/// // doesn't implement Handler, it's assumed to take all parameters in the
/// // order they appear in the route pattern.
/// app.get('/users/<userName>/say-hello', (Request request, String userName) async {
///   assert(userName == request.params['userName']);
///   return Response.ok('Hello ${userName}');
/// });
///
/// // It is possible to have multiple parameters, and if desired a custom
/// // regular expression can be specified with <paramName|REGEXP>, where
/// // REGEXP is a regular expression (leaving out ^ and $).
/// // If no regular expression is specified `[^/]+` will be used.
/// app.get('/users/<userName>/messages/<msgId|\d+>', (Request request) async {
///   var msgId = int.parse(request.params['msgId']!);
///   return Response.ok(message.getById(msgId));
/// });
///
/// var server = await io.serve(app, 'localhost', 8080);
/// ```
///
/// If multiple routes match the same request, the handler for the first
/// route is called.
/// If no route matches a request, a [Response.notFound] will be returned
/// instead. The default matcher can be overridden with the `notFoundHandler`
/// constructor parameter.
@sealed
class Router {
  final List<RouterEntry> _routes = [];
  final Handler _notFoundHandler;

  /// Creates a new [Router] routing requests to handlers.
  ///
  /// The [notFoundHandler] will be invoked for requests where no matching route
  /// was found. By default, a simple [Response.notFound] will be used instead.
  Router({Handler notFoundHandler = _defaultNotFound})
      : _notFoundHandler = notFoundHandler;

  /// Add [handler] for [verb] requests to [route].
  ///
  /// If [verb] is `GET` the [handler] will also be called for `HEAD` requests
  /// matching [route]. This is because handling `GET` requests without handling
  /// `HEAD` is always wrong. To explicitely implement a `HEAD` handler it must
  /// be registered before the `GET` handler.
  void add(String verb, String route, Function handler) {
    if (!isHttpMethod(verb)) {
      throw ArgumentError.value(verb, 'verb', 'expected a valid HTTP method');
    }
    verb = verb.toUpperCase();

    if (verb == 'GET') {
      // Handling in a 'GET' request without handling a 'HEAD' request is always
      // wrong, thus, we add a default implementation that discards the body.
      _routes.add(RouterEntry('HEAD', route, handler, middleware: _removeBody));
    }
    _routes.add(RouterEntry(verb, route, handler));
  }

  /// Handle all request to [route] using [handler].
  void all(String route, Function handler) {
    _routes.add(RouterEntry('ALL', route, handler));
  }

  /// Mount a handler below a prefix.
  ///
  /// In this case prefix may not contain any parameters, nor
  void mount(String prefix, Handler handler) {
    if (!prefix.startsWith('/')) {
      throw ArgumentError.value(prefix, 'prefix', 'must start with a slash');
    }

    // first slash is always in request.handlerPath
    final path = prefix.substring(1);
    if (prefix.endsWith('/')) {
      all('$prefix<path|[^]*>', (Request request) {
        return handler(request.copyWith(path: path));
      });
    } else {
      all(prefix, (Request request) {
        return handler(request.copyWith(path: path));
      });
      all('$prefix/<path|[^]*>', (Request request) {
        return handler(request.copyWith(path: '$path/'));
      });
    }
  }

  /// Route incoming requests to registered handlers.
  ///
  /// This method allows a Router instance to be a [Handler].
  Future<Response> call(Request request) async {
    // Note: this is a great place to optimize the implementation by building
    //       a trie for faster matching... left as an exercise for the reader :)
    for (var route in _routes) {
      if (route.verb != request.method.toUpperCase() && route.verb != 'ALL') {
        continue;
      }
      var params = route.match('/${request.url.path}');
      if (params != null) {
        final response = await route.invoke(request, params);
        if (response != routeNotFound) {
          return response;
        }
      }
    }
    return _notFoundHandler(request);
  }

  // Handlers for all methods

  /// Handle `GET` request to [route] using [handler].
  ///
  /// If no matching handler for `HEAD` requests is registered, such requests
  /// will also be routed to the [handler] registered here.
  void get(String route, Function handler) => add('GET', route, handler);

  /// Handle `HEAD` request to [route] using [handler].
  void head(String route, Function handler) => add('HEAD', route, handler);

  /// Handle `POST` request to [route] using [handler].
  void post(String route, Function handler) => add('POST', route, handler);

  /// Handle `PUT` request to [route] using [handler].
  void put(String route, Function handler) => add('PUT', route, handler);

  /// Handle `DELETE` request to [route] using [handler].
  void delete(String route, Function handler) => add('DELETE', route, handler);

  /// Handle `CONNECT` request to [route] using [handler].
  void connect(String route, Function handler) =>
      add('CONNECT', route, handler);

  /// Handle `OPTIONS` request to [route] using [handler].
  void options(String route, Function handler) =>
      add('OPTIONS', route, handler);

  /// Handle `TRACE` request to [route] using [handler].
  void trace(String route, Function handler) => add('TRACE', route, handler);

  /// Handle `PATCH` request to [route] using [handler].
  void patch(String route, Function handler) => add('PATCH', route, handler);

  static Response _defaultNotFound(Request request) => routeNotFound;

  /// Sentinel [Response] object indicating that no matching route was found.
  ///
  /// This is the default response value from a [Router] created without a
  /// `notFoundHandler`, when no routes matches the incoming request.
  ///
  /// If the [routeNotFound] object is returned from a [Handler] the [Router]
  /// will consider the route _not matched_, and attempt to match other routes.
  /// This is useful when mounting nested routers, or when matching a route
  /// is conditioned on properties beyond the path of the URL.
  ///
  /// **Example**
  /// ```dart
  /// final app = Router();
  ///
  /// // The pattern for this route will match '/search' and '/search?q=...',
  /// // but if request does not have `?q=...', then the handler will return
  /// // [Router.routeNotFound] causing the router to attempt further routes.
  /// app.get('/search', (Request request) async {
  ///   if (!request.uri.queryParameters.containsKey('q')) {
  ///     return Router.routeNotFound;
  ///   }
  ///   return Response.ok('TODO: make search results');
  /// });
  ///
  /// // Same pattern as above
  /// app.get('/search', (Request request) async {
  ///   return Response.ok('TODO: return search form');
  /// });
  ///
  /// // Create a single nested router we can mount for handling API requests.
  /// final api = Router();
  ///
  /// api.get('/version', (Request request) => Response.ok('1'));
  ///
  /// // Mounting router under '/api'
  /// app.mount('/api', api);
  ///
  /// // If a request matches `/api/...` then the routes in the [api] router
  /// // will be attempted. However, for a request like `/api/hello` there is
  /// // no matching route in the [api] router. Thus, the router will return
  /// // [Router.routeNotFound], which will cause matching to continue.
  /// // Hence, the catch-all route below will be matched, causing a custom 404
  /// // response with message 'nothing found'.
  ///
  /// // In the pattern below `<anything|.*>` is on the form `<name|regex>`,
  /// // thus, this simply creates a URL parameter called `anything` which
  /// // matches anything.
  /// app.all('/<anything|.*>', (Request request) {
  ///   return Response.notFound('nothing found');
  /// });
  /// ```
  static final Response routeNotFound = _RouteNotFoundResponse();
}

/// Extends [Response] to allow it to be used multiple times in the
/// actual content being served.
class _RouteNotFoundResponse extends Response {
  static const _message = 'Route not found';
  static final _messageBytes = utf8.encode(_message);

  _RouteNotFoundResponse() : super.notFound(body: Body.fromData(_messageBytes));

  @override
  Stream<List<int>> read() => Stream<List<int>>.value(_messageBytes);

  @override
  Response copyWith({
    Headers? headers,
    Map<String, Object?>? context,
    Body? body,
  }) {
    return super.copyWith(
      headers: headers,
      context: context,
      body: body ?? Body.fromData(_messageBytes),
    );
  }
}
