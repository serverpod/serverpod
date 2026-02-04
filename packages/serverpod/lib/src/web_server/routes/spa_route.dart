import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Route for serving Single Page Applications (SPAs) with fallback support.
///
/// Combines static file serving with automatic fallback to a specified file
/// when requested files don't exist, enabling client-side routing.
///
/// ```dart
/// pod.webServer.addRoute(
///   SpaRoute(
///     Directory('web/app'),
///     fallback: File('web/app/index.html'),
///   ),
/// );
/// ```
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
  /// The [directory] parameter specifies the root directory containing static
  /// files. The [fallback] parameter is the file served when requested files
  /// don't exist, enabling client-side routing.
  ///
  /// Cache behavior can be customized using [cacheControlFactory] for static
  /// asset headers and [cacheBustingConfig] for cache busting support.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  SpaRoute(
    this.directory, {
    required this.fallback,
    this.cacheControlFactory,
    this.cacheBustingConfig,
    super.host,
  }) : super(methods: {Method.get, Method.head});

  @override
  void injectIn(RelicRouter router) {
    final subRouter = Router<Handler>();

    subRouter.use(
      '/',
      FallbackMiddleware(
        fallback: StaticRoute.file(fallback),
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
    throw UnimplementedError(
      'SpaRoute handles routing via injectIn and should not be called directly',
    );
  }
}
