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
/// Unless `SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL` is set, all files are served
/// without a `Cache-Control` header, leaving caching behavior to client side
/// heuristics. Both the files in [directory] and the [fallback] file use the
/// same headers, so set the environment variable only when the app shell can
/// safely be cached, for example when the SPA build embeds content hashes in
/// its asset URLs and the `max-age` is short enough for deploys to roll out.
///
/// The `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL` environment variable used by
/// [StaticRoute] does not apply to this route.
class SpaRoute extends Route {
  /// The directory containing static files
  final Directory directory;

  /// The fallback file (typically [directory]/index.html)
  final File fallback;

  /// Cache control factory for the static files and the [fallback] file.
  ///
  /// Defaults to the value of `SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL`, or to
  /// leaving caching behavior to client side heuristics when the environment
  /// variable is not set.
  final CacheControlFactory cacheControlFactory;

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
          cacheControlFactory: cacheControlFactory,
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
