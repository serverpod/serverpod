import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';

/// Route for serving Flutter web applications with WASM support.
///
/// Combines static file serving with automatic fallback to index.html for
/// client-side routing, plus WASM headers (COOP/COEP) for multi-threading.
///
/// ```dart
/// pod.webServer.addRoute(
///   FlutterRoute(Directory('web/flutter_app')),
/// );
/// ```
class FlutterRoute extends Route {
  /// The directory containing Flutter web files
  final Directory directory;

  /// The index file to use as fallback (defaults to index.html in [directory])
  final File? indexFile;

  /// Cache control factory for static files
  final CacheControlFactory? cacheControlFactory;

  /// Cache busting configuration for static files
  final CacheBustingConfig? cacheBustingConfig;

  /// Creates a new FlutterRoute.
  ///
  /// The [directory] parameter specifies the root directory containing Flutter
  /// web files. The [indexFile] parameter sets the fallback file for SPA
  /// routing and defaults to `index.html` within the specified directory.
  ///
  /// Cache behavior can be customized using [cacheControlFactory] for static
  /// asset headers and [cacheBustingConfig] for cache busting support.
  FlutterRoute(
    this.directory, {
    this.indexFile,
    this.cacheControlFactory,
    this.cacheBustingConfig,
  }) : super(methods: {Method.get, Method.head});

  @override
  void injectIn(RelicRouter router) {
    final subRouter = Router<Handler>();

    subRouter.use('/', const WasmHeadersMiddleware().call);

    final index = indexFile ?? File(path.join(directory.path, 'index.html'));

    subRouter.use(
      '/',
      FallbackMiddleware(
        fallback: StaticRoute.file(index),
        on: (response) => response.statusCode == 404,
      ).call,
    );

    StaticRoute.directory(
      directory,
      cacheBustingConfig: cacheBustingConfig,
      cacheControlFactory: cacheControlFactory ?? (_, _) => null,
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
