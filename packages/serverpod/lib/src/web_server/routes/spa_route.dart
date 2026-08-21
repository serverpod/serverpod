import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/web_server/routes/cache_control_environment.dart';

const _spaCacheControlEnvironmentVariable =
    'SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL';

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
///
/// ## About caching
///
/// The [fallback] file is always served without a `Cache-Control` header when
/// it answers a client side route, leaving caching behavior to client side
/// heuristics. Caching the app shell would serve a stale application after a
/// deploy, so neither [cacheControlFactory] nor the environment variable below
/// applies to it.
///
/// The files in [directory] are served without a `Cache-Control` header as
/// well, unless `SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL` is set. Set it when
/// the SPA build embeds content hashes in its asset URLs, so that assets can
/// safely be cached for a long time.
///
/// The `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL` environment variable used by
/// [StaticRoute] does not apply to this route.
class SpaRoute extends Route {
  /// The directory containing static files
  final Directory directory;

  /// The fallback file (typically [directory]/index.html)
  final File fallback;

  /// Cache control factory for the files in [directory].
  ///
  /// Defaults to the value of `SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL`, or to
  /// leaving caching behavior to client side heuristics when the environment
  /// variable is not set. It never applies to the [fallback] file, which is
  /// always served without a `Cache-Control` header.
  final CacheControlFactory cacheControlFactory;

  /// Cache busting configuration for static files
  final CacheBustingConfig? cacheBustingConfig;

  /// Creates a new SpaRoute.
  ///
  /// The [directory] parameter specifies the root directory containing static
  /// files. The [fallback] parameter is the file served when requested files
  /// don't exist, enabling client-side routing.
  ///
  /// Cache behavior can be customized using [cacheControlFactory] for the
  /// headers of the files in [directory] and [cacheBustingConfig] for cache
  /// busting support. The [fallback] file is always served without a
  /// `Cache-Control` header.
  ///
  /// An explicit [cacheControlFactory] takes precedence over the value of the
  /// `SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL` environment variable.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  SpaRoute(
    this.directory, {
    required this.fallback,
    CacheControlFactory? cacheControlFactory,
    this.cacheBustingConfig,
    super.host,
  }) : cacheControlFactory =
           cacheControlFactory ??
           cacheControlFactoryFromEnvironment(
             _spaCacheControlEnvironmentVariable,
             fallback: noCacheControl,
           ),
       super(methods: {Method.get, Method.head});

  @override
  void injectIn(RelicRouter router) {
    final subRouter = Router<Handler>();

    subRouter.use(
      '/',
      FallbackMiddleware(
        fallback: StaticRoute.file(
          fallback,
          cacheControlFactory: noCacheControl,
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
    throw UnimplementedError(
      'SpaRoute handles routing via injectIn and should not be called directly',
    );
  }
}
