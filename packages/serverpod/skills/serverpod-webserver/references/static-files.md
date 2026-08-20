# Static files

Reference for the [Serverpod Web Server](../SKILL.md) skill.

```dart
pod.webServer.addRoute(
  StaticRoute.directory(Directory('web/static')),
  '/static/',
);
```

Serves all files under the prefix. Automatic content-type detection, ETag, and Last-Modified.

## Cache control

```dart
pod.webServer.addRoute(
  StaticRoute.directory(Directory('web/static'),
    cacheControlFactory: StaticRoute.publicImmutable(maxAge: const Duration(minutes: 5))),
  '/static/',
);
```

Built-in factories: `StaticRoute.public(maxAge:)`, `StaticRoute.publicImmutable(maxAge:)`, `StaticRoute.privateNoCache()`, `StaticRoute.noStore()`.

## Cache-busting

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
