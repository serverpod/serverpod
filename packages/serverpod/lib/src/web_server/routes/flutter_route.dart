import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';

/// Route for serving Flutter web applications with WASM support.
///
/// Provides everything needed to serve a Flutter web app:
/// - Static file serving from a directory
/// - Automatic fallback to index.html for client-side routing
/// - WASM headers (COOP/COEP) for multi-threading support
///
/// ## Basic Usage
///
/// ```dart
/// pod.webServer.addRoute(
///   FlutterRoute(Directory('web/flutter_app')),
///   '/**',
/// );
/// ```
///
/// ## Custom Index File
///
/// ```dart
/// pod.webServer.addRoute(
///   FlutterRoute(
///     Directory('web/flutter_app'),
///     indexFile: File('web/flutter_app/main.html'),
///   ),
///   '/**',
/// );
/// ```
///
/// ## Cache Control
///
/// ```dart
/// pod.webServer.addRoute(
///   FlutterRoute(
///     Directory('web/flutter_app'),
///     cacheControlFactory: StaticRoute.public(maxAge: Duration(hours: 1)),
///   ),
///   '/**',
/// );
/// ```
///
/// ## How It Works
///
/// 1. Creates a sub-router for the route path
/// 2. Applies wasmHeadersMiddleware for Flutter WASM multi-threading
/// 3. Applies fallbackMiddleware to serve index.html on 404
/// 4. Injects static directory route
/// 5. Attaches the sub-router to the main router
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
  /// - [directory] is the root directory containing Flutter web files
  /// - [indexFile] is the fallback file (defaults to [directory]/index.html)
  /// - [cacheControlFactory] customizes cache headers for static assets
  /// - [cacheBustingConfig] enables cache busting for assets
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
