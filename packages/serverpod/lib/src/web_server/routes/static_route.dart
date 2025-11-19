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
  static CacheControlFactory public({int? maxAge}) =>
      (_, _) => CacheControlHeader(publicCache: true, maxAge: maxAge);

  /// Returns a [CacheControlHeader] with public, immutable, and possibly max-age set to [maxAge].
  static CacheControlFactory publicImmutable({int? maxAge}) =>
      (_, _) => CacheControlHeader(
        publicCache: true,
        immutable: true,
        maxAge: maxAge,
      );

  final Handler _handler;

  StaticRoute._(this._handler) : super(methods: {Method.get, Method.head});

  /// Use [StaticRoute.directory] to serve everything below a given [root].
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Default is to leave caching behavior to client
  /// side heuristics.
  factory StaticRoute.directory(
    Directory root, {
    CacheBustingConfig? cacheBustingConfig,
    CacheControlFactory cacheControlFactory = _defaultFactory,
  }) {
    return StaticRoute._(
      StaticHandler.directory(
        root,
        cacheBustingConfig: cacheBustingConfig,
        cacheControl: cacheControlFactory,
      ).asHandler,
    );
  }

  /// Use [StaticRoute.file] to serve a single [file].
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Default is to leave caching behavior to client
  /// side heuristics.
  factory StaticRoute.file(
    File file, {
    CacheControlFactory cacheControlFactory = _defaultFactory,
  }) {
    return StaticRoute._(
      StaticHandler.file(
        file,
        cacheControl: cacheControlFactory,
      ).asHandler,
    );
  }

  @override
  FutureOr<Result> handleCall(Session session, Request context) =>
      _handler(context);
}
