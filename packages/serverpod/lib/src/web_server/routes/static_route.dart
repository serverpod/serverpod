import 'dart:async';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/web_server/routes/cache_control_environment.dart';

const _staticCacheControlEnvironmentVariable =
    'SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL';

/// Route for serving static assets.
class StaticRoute extends Route {
  /// Returns a [CacheControlHeader] with private and no-cache.
  static CacheControlFactory privateNoCache() =>
      (_, _) => CacheControlHeader(privateCache: true, noCache: true);

  /// Returns a [CacheControlHeader] with no-store.
  static CacheControlFactory noStore() =>
      (_, _) => CacheControlHeader(noStore: true);

  /// Returns a [CacheControlHeader] with public, and possibly max-age set to [maxAge].
  static CacheControlFactory public({Duration? maxAge}) =>
      (_, _) =>
          CacheControlHeader(publicCache: true, maxAge: maxAge?.inSeconds);

  /// Returns a [CacheControlHeader] with public, immutable, and possibly max-age set to [maxAge].
  static CacheControlFactory publicImmutable({Duration? maxAge}) =>
      (_, _) => CacheControlHeader(
        publicCache: true,
        immutable: true,
        maxAge: maxAge?.inSeconds,
      );

  final Handler _handler;

  StaticRoute._(this._handler, {required bool tailMatch, super.host})
    : super(methods: {Method.get, Method.head}, path: tailMatch ? '/**' : '/');

  /// Use [StaticRoute.directory] to serve everything below a given [root].
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Defaults to the value of
  /// `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL`, or leaving caching behavior
  /// to client side heuristics when the environment variable is not set.
  ///
  /// An explicit [cacheControlFactory] takes precedence over the value of the
  /// `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL` environment variable.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  factory StaticRoute.directory(
    Directory root, {
    CacheBustingConfig? cacheBustingConfig,
    CacheControlFactory? cacheControlFactory,
    String? host,
  }) {
    return StaticRoute._(
      StaticHandler.directory(
        root,
        cacheBustingConfig: cacheBustingConfig,
        cacheControl:
            cacheControlFactory ??
            cacheControlFactoryFromEnvironment(
              _staticCacheControlEnvironmentVariable,
              fallback: noCacheControl,
            ),
      ).asHandler,
      tailMatch: true,
      host: host,
    );
  }

  /// Use [StaticRoute.withCacheBusting] to serve everything below
  /// a given root with cache-busting support. The root is configured by
  /// [CacheBustingConfig.fileSystemRoot]
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Defaults to the value of
  /// `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL`, or a factory that produces a
  /// [CacheControlHeader] with public cache enabled and 1 year max age when
  /// the environment variable is not set.
  ///
  /// An explicit [cacheControlFactory] takes precedence over the value of the
  /// `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL` environment variable.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  factory StaticRoute.withCacheBusting(
    CacheBustingConfig config, {
    CacheControlFactory? cacheControlFactory,
    String? host,
  }) {
    return StaticRoute._(
      StaticHandler.directory(
        config.fileSystemRoot,
        cacheBustingConfig: config,
        cacheControl:
            cacheControlFactory ??
            cacheControlFactoryFromEnvironment(
              _staticCacheControlEnvironmentVariable,
              fallback: StaticRoute.publicImmutable(
                maxAge: const Duration(days: 365),
              ),
            ),
      ).asHandler,
      tailMatch: true,
      host: host,
    );
  }

  /// Use [StaticRoute.file] to serve a single [file].
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Defaults to the value of
  /// `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL`, or leaving caching behavior
  /// to client side heuristics when the environment variable is not set.
  ///
  /// An explicit [cacheControlFactory] takes precedence over the value of the
  /// `SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL` environment variable.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  factory StaticRoute.file(
    File file, {
    CacheControlFactory? cacheControlFactory,
    String? host,
  }) {
    return StaticRoute._(
      StaticHandler.file(
        file,
        cacheControl:
            cacheControlFactory ??
            cacheControlFactoryFromEnvironment(
              _staticCacheControlEnvironmentVariable,
              fallback: noCacheControl,
            ),
      ).asHandler,
      tailMatch: false,
      host: host,
    );
  }

  @override
  FutureOr<Result> handleCall(Session session, Request request) =>
      _handler(request);
}
