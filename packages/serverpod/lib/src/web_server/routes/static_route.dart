import 'dart:async';
import 'dart:io';
import 'package:serverpod/serverpod.dart';

/// Route for serving static assets.
class StaticRoute extends Route {
  static CacheControlHeader? _defaultFactory(
    Request ctx,
    FileInfo fileInfo,
  ) => null;

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
  /// return for a given asset. Default is to leave caching behavior to client
  /// side heuristics.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  factory StaticRoute.directory(
    Directory root, {
    CacheBustingConfig? cacheBustingConfig,
    CacheControlFactory cacheControlFactory = _defaultFactory,
    String? host,
  }) {
    return StaticRoute._(
      StaticHandler.directory(
        root,
        cacheBustingConfig: cacheBustingConfig,
        cacheControl: cacheControlFactory,
      ).asHandler,
      tailMatch: true,
      host: host,
    );
  }

  /// Use [StaticRoute.file] to serve a single [file].
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Default is to leave caching behavior to client
  /// side heuristics.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  factory StaticRoute.file(
    File file, {
    CacheControlFactory cacheControlFactory = _defaultFactory,
    String? host,
  }) {
    return StaticRoute._(
      StaticHandler.file(
        file,
        cacheControl: cacheControlFactory,
      ).asHandler,
      tailMatch: false,
      host: host,
    );
  }

  @override
  FutureOr<Result> handleCall(Session session, Request request) =>
      _handler(request);
}
