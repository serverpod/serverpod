---
name: serverpod-webserver
description: Serverpod web server (Relic) — REST APIs, webhooks, middleware, static files, server-rendered HTML, SPAs, Flutter web. Use when adding HTTP routes, serving web pages or web apps, intercepting requests, or working with the Relic web server.
---

# Serverpod Web Server (Relic)

Built on Relic, shares `Session` (DB, logging, auth) with the main server. This skill is for the optional `webServer` listener (default port 8082), not the main API server (default port 8080).

## Routes

Extend `Route`, implement `handleCall(Session, Request)`. Register before `pod.start()`:

```dart
class HelloRoute extends Route {
  @override
  Future<Result> handleCall(Session session, Request request) async {
    return Response.ok(
      body: Body.fromString(
        jsonEncode({'message': 'Hello'}),
        mimeType: MimeType.json,
      ),
    );
  }
}

pod.webServer.addRoute(HelloRoute(), '/api/hello');
```

Routes matched in registration order. `Session` provides DB, logging, and auth access just like in endpoints.

## HTTP methods

Restrict which methods a route accepts (defaults to GET only) and branch on `request.method`:

```dart
class UserRoute extends Route {
  UserRoute() : super(methods: {Method.get, Method.post, Method.delete});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    if (request.method == Method.post) {
      final data = jsonDecode(await request.readAsString());
      // ...
      return Response(201);
    }
    // ...
  }
}
```

## Path parameters

```dart
pod.webServer.addRoute(UserRoute(), '/api/users/:id');
pod.webServer.addRoute(route, '/:userId/posts/:postId');
```

Access typed params:

```dart
class UserRoute extends Route {
  static const _idParam = IntPathParam(#id);

  @override
  Future<Result> handleCall(Session session, Request request) async {
    int userId = request.pathParameters.get(_idParam);
    // ...
  }
}
```

Raw access: `request.pathParameters.raw[#id]`. Typed query params work the same way with `IntQueryParam('page')` and `request.queryParameters.get(...)`, with raw access through `request.queryParameters.raw['query']`.

## Wildcards

```dart
pod.webServer.addRoute(route, '/item/*');   // One segment: /item/foo
pod.webServer.addRoute(route, '/item/**');  // Tail-match: /item/foo/bar/baz
```

`**` only at end of path. Access matched path via `request.remainingPath`.

## Headers and body

```dart
final userAgent = request.headers.userAgent;
final contentLength = request.headers.contentLength;
final auth = request.headers.authorization;
final apiKey = request.headers['X-API-Key']?.first;

final body = await request.readAsString();  // JSON, form data
final stream = request.read();              // Stream for large uploads
```

Body can only be read once.

## Response types

`Response` has named constructors for the common statuses: `ok`, `noContent`, `notModified`, `movedPermanently`, `found`, `seeOther`, `badRequest`, `unauthorized`, `forbidden`, `notFound`, `notImplemented`, `internalServerError`. Any other status uses the unnamed constructor, e.g. `Response(201)`. Bodies are built with `Body.fromString(content, mimeType: MimeType.json)`, `Body.fromData(...)` or `Body.fromDataStream(...)`.

## Fallback route

```dart
pod.webServer.fallbackRoute = NotFoundRoute();
```

Handles requests when no other route matches.

## Route modules (injectIn)

Group related endpoints by overriding `injectIn()`:

```dart
class UserCrudModule extends Route {
  @override
  void injectIn(RelicRouter router) {
    router
      ..get('/', _list)
      ..get('/:id', _get);
  }

  static const _idParam = IntPathParam(#id);

  Future<Result> _list(Request request) async {
    final session = await request.session;
    final users = await User.db.find(session);
    return Response.ok(
      body: Body.fromString(jsonEncode(users.map((u) => u.toJson()).toList()),
        mimeType: MimeType.json),
    );
  }

  Future<Result> _get(Request request) async {
    final session = await request.session;
    final user = await User.db.findById(session, request.pathParameters.get(_idParam));
    if (user == null) return Response.notFound();
    return Response.ok(
      body: Body.fromString(jsonEncode(user.toJson()), mimeType: MimeType.json),
    );
  }
}

pod.webServer.addRoute(UserCrudModule(), '/api/users');
// Creates GET /api/users and GET /api/users/:id
```

Note: `injectIn` handlers receive only `Request`; access `Session` with `await request.session`.

## Middleware

Middleware wraps handlers. Register with path prefix:

```dart
Handler apiKeyMiddleware(Handler next) {
  return (Request request) async {
    final apiKey = request.headers['X-API-Key']?.firstOrNull;
    if (apiKey == null || !await isValidApiKey(apiKey)) {
      return Response.unauthorized(body: Body.fromString('API key required'));
    }
    return await next(request);
  };
}

pod.webServer.addMiddleware(apiKeyMiddleware, '/api');
```

### Execution order

More specific paths run as inner middleware. Within the same path, order of registration:

```dart
pod.webServer.addMiddleware(rateLimitMiddleware, '/api/users'); // Inner (last before handler)
pod.webServer.addMiddleware(apiKeyMiddleware, '/api');           // Outer (first)
```

For `/api/users/list`: apiKeyMiddleware → rateLimitMiddleware → handler → rateLimitMiddleware → apiKeyMiddleware.

### Request-scoped data (ContextProperty)

Pass data from middleware to routes without modifying the request:

```dart
final _tenantProperty = ContextProperty<String>('tenant');

extension TenantEx on Request {
  String get tenant => _tenantProperty.get(this);
}

Handler tenantMiddleware(Handler next) {
  return (Request request) async {
    final session = await request.session;
    final tenant = await extractTenant(session, request.headers.host);
    if (tenant == null) return Response.notFound();
    _tenantProperty[request] = tenant;
    return await next(request);
  };
}

// In route:
final tenant = request.tenant;
```

Data cleaned up automatically when request completes. Host-specific middleware: `pod.webServer.addMiddleware(mw, '/api', host: 'api.example.com')`.

## Virtual host routing

Restrict routes/middleware to a specific `Host` header:

```dart
pod.webServer.addRoute(ApiRoute(), '/v1');  // ApiRoute has host: 'api.example.com'
pod.webServer.addRoute(SpaRoute(webDir, fallback: index, host: 'www.example.com'), '/');
pod.webServer.addRoute(HealthRoute(), '/health');  // All hosts (default)
```

All route types support `host`: `Route`, `StaticRoute`, `SpaRoute`, `FlutterRoute`.

## Serving files and web apps

These are covered in reference files in this skill directory. Read the one that matches the task:

- [`references/static-files.md`](references/static-files.md) — `StaticRoute`, cache control, cache-busted asset URLs.
- [`references/spa-and-flutter-web.md`](references/spa-and-flutter-web.md) — `SpaRoute`, `FlutterRoute`, SPA fallbacks, WASM headers.
- [`references/server-rendered-html.md`](references/server-rendered-html.md) — `WidgetRoute`, Mustache templates, the widget types.
