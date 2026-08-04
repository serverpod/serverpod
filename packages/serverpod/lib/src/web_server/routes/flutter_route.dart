import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';

const _flutterCacheControlEnvironmentVariable =
    'SERVERPOD_WEB_SERVER_FLUTTER_CACHE_CONTROL';

/// Route for serving Flutter web applications with WASM support.
///
/// Combines static file serving with automatic fallback to index.html for
/// client-side routing, plus WASM headers (COOP/COEP) for multi-threading.
///
/// Unless `SERVERPOD_WEB_SERVER_FLUTTER_CACHE_CONTROL` is set, critical Flutter
/// files (index.html, flutter_service_worker.js, flutter_bootstrap.js,
/// manifest.json, version.json) are served with no-cache headers by default
/// to prevent stale app manifests and service workers. All other files can be
/// cached according to browser heuristics or custom cache control.
///
/// To invalidate the cache, change the version in your pubspec.yaml file and
/// build your Flutter project.
///
/// ```dart
/// pod.webServer.addRoute(
///   FlutterRoute(Directory('web/flutter_app')),
/// );
/// ```
class FlutterRoute extends Route {
  /// Files that should never be cached to prevent issues with stale
  /// app manifests, service workers, or version mismatches.
  static const noCacheFiles = {
    'index.html',
    'flutter_service_worker.js',
    'flutter_bootstrap.js',
    'manifest.json',
    'version.json',
  };

  /// The directory containing Flutter web files
  final Directory directory;

  /// The index file to use as fallback (defaults to index.html in [directory])
  final File indexFile;

  /// Cache control factory for static files
  final CacheControlFactory cacheControlFactory;

  /// Cache busting configuration for static files
  final CacheBustingConfig? cacheBustingConfig;

  /// Creates a new FlutterRoute.
  ///
  /// The [directory] parameter specifies the root directory containing Flutter
  /// web files. The [indexFile] parameter sets the fallback file for SPA
  /// routing and defaults to `index.html` within the specified directory.
  ///
  /// Cache behavior can be customized using [cacheControlFactory] for static
  /// asset headers and [cacheBustingConfig] for cache busting support. If no
  /// [cacheControlFactory] is provided, a default factory is used that prevents
  /// caching of critical Flutter files (index.html, flutter_service_worker.js,
  /// flutter_bootstrap.js, manifest.json, version.json) while allowing other
  /// files to be cached according to browser heuristics.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  ///
  /// An explicit [cacheControlFactory] takes precedence over the value of the
  /// `SERVERPOD_WEB_SERVER_FLUTTER_CACHE_CONTROL` environment variable.
  ///
  /// If that environment variable is set and no [cacheControlFactory] is
  /// provided, it is parsed at construction time. An invalid value throws a
  /// [FormatException].
  FlutterRoute(
    this.directory, {
    File? indexFile,
    CacheControlFactory? cacheControlFactory,
    this.cacheBustingConfig,
    super.host,
  }) : cacheControlFactory =
           cacheControlFactory ?? _cacheControlFromEnvironment(),
       indexFile = indexFile ?? File(path.join(directory.path, 'index.html')),
       super(methods: {Method.get, Method.head});

  /// Resolves cache control from the environment, or the Flutter defaults.
  ///
  /// Parses `SERVERPOD_WEB_SERVER_FLUTTER_CACHE_CONTROL` immediately so invalid
  /// values fail at construction rather than on the first request.
  static CacheControlFactory _cacheControlFromEnvironment() {
    final cacheControl =
        Platform.environment[_flutterCacheControlEnvironmentVariable];
    if (cacheControl == null) {
      return _defaultFlutterCacheControl;
    }

    final header = CacheControlHeader.parse([cacheControl]);
    return (_, _) => header;
  }

  /// Default cache control factory for Flutter web files.
  ///
  /// Returns no-cache headers for critical Flutter files to prevent issues
  /// with stale app manifests, service workers, or version mismatches.
  /// All other files are cached publicly for one day.
  static CacheControlHeader? _defaultFlutterCacheControl(
    Request request,
    FileInfo fileInfo,
  ) {
    final filename = path.basename(fileInfo.file.path);
    if (noCacheFiles.contains(filename)) {
      return StaticRoute.privateNoCache()(request, fileInfo);
    }

    return StaticRoute.public(maxAge: const Duration(days: 1))(
      request,
      fileInfo,
    );
  }

  @override
  void injectIn(RelicRouter router) {
    final subRouter = Router<Handler>();

    subRouter.use('/', const WasmHeadersMiddleware().call);

    subRouter.use(
      '/',
      FallbackMiddleware(
        fallback: StaticRoute.file(
          indexFile,
          cacheControlFactory: StaticRoute.privateNoCache(),
        ),
        on: (response) => response.statusCode == 404,
      ).call,
    );

    StaticRoute.directory(
      directory,
      cacheBustingConfig: cacheBustingConfig,
      cacheControlFactory: cacheControlFactory,
    ).injectIn(subRouter);

    router.attach('/', subRouter);
  }

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    // This should never be called since routing is handled via injectIn
    throw UnimplementedError(
      'FlutterRoute handles routing via injectIn and should not be called directly',
    );
  }
}
