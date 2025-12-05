import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Route for serving Single Page Applications (SPAs) with fallback support.
///
/// Combines static file serving with automatic fallback to a specified file
/// (typically index.html) when requested files don't exist. This enables
/// client-side routing in SPAs.
///
/// ## Basic Usage
///
/// ```dart
/// pod.webServer.addRoute(
///   SpaRoute(
///     Directory('web/app'),
///     fallback: File('web/app/index.html'),
///   ),
///   '/**',
/// );
/// ```
///
/// ## How It Works
///
/// 1. Creates a sub-router for the route path
/// 2. Applies fallbackMiddleware to intercept 404 responses
/// 3. Injects the static route into the sub-router
/// 4. Attaches the sub-router to the main router
///
/// This ensures all 404s from the static route fall back to the specified file.
class SpaRoute extends Route {
  /// The directory containing static files
  final Directory directory;

  /// The fallback file (typically [directory]/index.html)
  final File fallback;

  /// Cache control factory for static files
  final CacheControlFactory? cacheControlFactory;

  /// Cache busting configuration for static files
  final CacheBustingConfig? cacheBustingConfig;

  /// Creates a new SpaRoute.
  ///
  /// - [directory] is the root directory containing static files
  /// - [fallback] is the file to serve when requested files don't exist
  /// - [cacheControlFactory] customizes cache headers for static assets
  /// - [cacheBustingConfig] enables cache busting for assets
  SpaRoute(
    this.directory, {
    required this.fallback,
    this.cacheControlFactory,
    this.cacheBustingConfig,
  }) : super(methods: {Method.get, Method.head});

  @override
  void injectIn(RelicRouter router) {
    final subRouter = Router<Handler>();

    subRouter.use(
      '/',
      fallbackMiddleware(
        fallback: StaticRoute.file(fallback),
        on: (response) => response.statusCode == 404,
      ),
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
    throw UnimplementedError(
      'SpaRoute handles routing via injectIn and should not be called directly',
    );
  }
}
