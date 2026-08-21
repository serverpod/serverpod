# Single-page apps and Flutter web

Reference for the [Serverpod Web Server](../SKILL.md) skill.

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

### Default caching

- **All files, including the fallback**: served without a `Cache-Control` header, leaving caching to the browser.

Set `SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL` to serve every file, including the app shell, with a given header, or pass `cacheControlFactory` to take precedence over it. `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL` does not apply to `SpaRoute`.

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

`FlutterRoute` serves Flutter web builds with SPA fallback and smart caching:

```dart
final appDir = Directory('web/app');
if (appDir.existsSync()) {
  pod.webServer.addRoute(
    FlutterRoute(
      appDir,
      enableWasmHeaders: false,
    ),
  );
}
```

Build: `cd my_project_flutter && flutter build web --base-href /app/ -o ../my_project_server/web/app`.

Generated projects set `enableWasmHeaders: false` on the `FlutterRoute` because
the default build is non-WASM. To opt into Flutter WASM, add `--wasm` to the
build command and remove the `enableWasmHeaders: false` line.

### Default caching

- **All files**: served with `private, no-cache` by default, so browsers revalidate with ETags and avoid stale Flutter assets after rebuilds.

Override with `cacheControlFactory` when using cache-busted assets.

### WASM headers

`FlutterRoute` automatically adds `Cross-Origin-Opener-Policy: same-origin` and `Cross-Origin-Embedder-Policy: require-corp` for `SharedArrayBuffer` support. If using `SpaRoute` instead, add `WasmHeadersMiddleware` manually:

```dart
pod.webServer.addMiddleware(const WasmHeadersMiddleware());
```

Both `SpaRoute` and `FlutterRoute` support `host`, cache-busting, and sub-path mounting.
