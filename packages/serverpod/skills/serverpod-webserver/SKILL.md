---
name: serverpod-webserver
description: Serverpod web server (Relic) — REST APIs, webhooks, static files, middleware, server-rendered HTML, SPAs, Flutter web. Use when adding HTTP routes, serving web pages, or working with the Relic web server.
---

# Serverpod Web Server (Relic)

Built on Relic, shares `Session` (DB, logging, auth) with the main server. Runs on `webServer` port (default 8082). Use for REST, webhooks, static files, SPAs, or server-rendered pages.

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

Restrict which methods a route accepts:

```dart
class UserRoute extends Route {
  UserRoute() : super(methods: {Method.get, Method.post, Method.delete});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    if (request.method == Method.post) {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      return Response.created(
        body: Body.fromString(jsonEncode({'status': 'created', 'data': data}),
          mimeType: MimeType.json),
      );
    }
    final users = await User.db.find(session);
    return Response.ok(
      body: Body.fromString(jsonEncode(users.map((u) => u.toJson()).toList()),
        mimeType: MimeType.json),
    );
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
    final user = await User.db.findById(session, userId);
    if (user == null) return Response.notFound();
    return Response.ok(
      body: Body.fromString(jsonEncode(user.toJson()), mimeType: MimeType.json),
    );
  }
}
```

Raw access: `request.pathParameters.raw[#id]`.

## Wildcards

```dart
pod.webServer.addRoute(route, '/item/*');   // One segment: /item/foo
pod.webServer.addRoute(route, '/item/**');  // Tail-match: /item/foo/bar/baz
```

`**` only at end of path. Access matched path via `request.remainingPath`.

## Query parameters

```dart
class SearchRoute extends Route {
  static const _pageParam = IntQueryParam('page');

  @override
  Future<Result> handleCall(Session session, Request request) async {
    int page = request.queryParameters.get(_pageParam);
    String? query = request.queryParameters.raw['query'];
    // ...
  }
}
```

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

```dart
Response.ok(body: Body.fromString('Success'));
Response.created(body: Body.fromString('Created'));
Response.noContent();
Response.badRequest(body: Body.fromString('Invalid'));
Response.unauthorized(body: Body.fromString('Not authenticated'));
Response.notFound(body: Body.fromString('Not found'));
Response.internalServerError(body: Body.fromString('Error'));
```

Use `Body.fromString(content, mimeType: MimeType.json)` for JSON responses.

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

  Future<Result> _list(Request request) async {
    final session = request.session;
    final users = await User.db.find(session);
    return Response.ok(
      body: Body.fromString(jsonEncode(users.map((u) => u.toJson()).toList()),
        mimeType: MimeType.json),
    );
  }

  static const _idParam = IntPathParam(#id);
  Future<Result> _get(Request request) async {
    int userId = request.pathParameters.get(_idParam);
    final user = await User.db.findById(request.session, userId);
    if (user == null) return Response.notFound();
    return Response.ok(
      body: Body.fromString(jsonEncode(user.toJson()), mimeType: MimeType.json),
    );
  }
}

pod.webServer.addRoute(UserCrudModule(), '/api/users');
// Creates GET /api/users and GET /api/users/:id
```

Note: `injectIn` handlers receive only `Request`; access `Session` via `request.session`.

## Middleware

Middleware wraps handlers. Register with path prefix:

```dart
Handler apiKeyMiddleware(Handler next) {
  return (Request request) async {
    final apiKey = request.headers['X-API-Key']?.firstOrNull;
    if (apiKey == null) {
      return Response.unauthorized(body: Body.fromString('API key required'));
    }
    if (!await isValidApiKey(apiKey)) {
      return Response.forbidden(body: Body.fromString('Invalid API key'));
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
    final tenant = await extractTenant(request.session, request.headers.host);
    if (tenant == null) return Response.notFound();
    _tenantProperty[request] = tenant;
    return await next(request);
  };
}

// In route:
final tenant = request.tenant;
```

Data cleaned up automatically when request completes. Host-specific middleware: `pod.webServer.addMiddleware(mw, '/api', host: 'api.example.com')`.

## Static files

```dart
pod.webServer.addRoute(
  StaticRoute.directory(Directory('web/static')),
  '/static/',
);
```

Serves all files under the prefix. Automatic content-type detection, ETag, and Last-Modified.

### Cache control

```dart
pod.webServer.addRoute(
  StaticRoute.directory(Directory('web/static'),
    cacheControlFactory: StaticRoute.publicImmutable(maxAge: const Duration(minutes: 5))),
  '/static/',
);
```

Built-in factories: `StaticRoute.public(maxAge:)`, `StaticRoute.publicImmutable(maxAge:)`, `StaticRoute.privateNoCache()`, `StaticRoute.noStore()`.

### Cache-busting

```dart
final cacheBustingConfig = CacheBustingConfig(
  mountPrefix: '/static',
  fileSystemRoot: Directory('web/static'),
  separator: '@',
);

pod.webServer.addRoute(
  StaticRoute.directory(Directory('web/static'),
    cacheBustingConfig: cacheBustingConfig,
    cacheControlFactory: StaticRoute.publicImmutable(maxAge: const Duration(minutes: 5))),
  '/static/',
);

// Generate versioned URL:
final url = await cacheBustingConfig.assetPath('/static/logo.png');
// → /static/logo@<hash>.png
```

## Virtual host routing

Restrict routes/middleware to a specific `Host` header:

```dart
pod.webServer.addRoute(ApiRoute(), '/v1');  // ApiRoute has host: 'api.example.com'
pod.webServer.addRoute(SpaRoute(webDir, fallback: index, host: 'www.example.com'), '/');
pod.webServer.addRoute(HealthRoute(), '/health');  // All hosts (default)
```

All route types support `host`: `Route`, `StaticRoute`, `SpaRoute`, `FlutterRoute`.

## Server-side HTML

Extend `WidgetRoute`, return a `TemplateWidget` from `build()`:

```dart
class MyRoute extends WidgetRoute {
  @override
  Future<TemplateWidget> build(Session session, Request request) async {
    final users = await User.db.find(session);
    return UserListWidget(users: users);
  }
}

class UserListWidget extends TemplateWidget {
  UserListWidget({required List<User> users}) : super(name: 'user_list') {
    values = {'users': users.map((u) => u.userName).join(', ')};
  }
}

pod.webServer.addRoute(MyRoute(), '/users');
```

Place Mustache templates in `web/templates/` (e.g. `web/templates/user_list.html`):

```html
<html><body><h1>Users</h1><p>{{users}}</p></body></html>
```

Other widgets: `ListWidget(children: [...])` concatenates widgets; `JsonWidget({'key': 'value'})` renders JSON; `RedirectWidget('/new/location')` redirects.

## Single-page apps (SPA)

`SpaRoute` serves a directory with fallback to `index.html` for client-side routing:

```dart
pod.webServer.addRoute(
  SpaRoute(
    Directory('web/app'),
    fallback: File('web/app/index.html'),
    cacheControlFactory: StaticRoute.publicImmutable(maxAge: const Duration(minutes: 5)),
  ),
  '/app',  // Or omit for root
);
```

Serves static files when they exist; falls back to index.html for unmatched paths so client-side routing (React Router, Vue Router, etc.) works.

For custom fallback logic, use `FallbackMiddleware` directly:

```dart
pod.webServer.addMiddleware(
  FallbackMiddleware(
    fallback: StaticRoute.file(File('web/app/index.html')),
    on: (response) => response.statusCode == 404,
  ),
);
pod.webServer.addRoute(StaticRoute.directory(Directory('web/app')), '/');
```

## Flutter web apps

`FlutterRoute` serves Flutter web builds with WASM multi-threading headers and smart caching:

```dart
final appDir = Directory('web/app');
if (appDir.existsSync()) {
  pod.webServer.addRoute(FlutterRoute(appDir));
}
```

Build: `cd my_project_flutter && flutter build web --wasm`. Copy output to server's `web/app/`.

### Default caching

- **Critical files** (`index.html`, `flutter_service_worker.js`, `flutter_bootstrap.js`, `manifest.json`, `version.json`): never cached (`private, no-cache, no-store`)
- **All other files**: cached 1 day (`public, max-age=86400`)

Override with `cacheControlFactory`. Invalidate cache by bumping version in Flutter `pubspec.yaml` and rebuilding.

### WASM headers

`FlutterRoute` automatically adds `Cross-Origin-Opener-Policy: same-origin` and `Cross-Origin-Embedder-Policy: require-corp` for `SharedArrayBuffer` support. If using `SpaRoute` instead, add `WasmHeadersMiddleware` manually:

```dart
pod.webServer.addMiddleware(const WasmHeadersMiddleware());
```

Both `SpaRoute` and `FlutterRoute` support `host`, cache-busting, and sub-path mounting.
