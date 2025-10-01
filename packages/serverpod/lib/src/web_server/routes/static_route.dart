import 'dart:async';
import 'dart:io';
import 'package:serverpod/serverpod.dart';

/// Route for serving static assets.
class StaticRoute extends Route {
  static CacheControlHeader? _defaultFactory(
    NewContext ctx,
    FileInfo fileInfo,
  ) =>
      null;

  /// Returns a [CacheControlHeader] with private and no-cache.
  CacheControlFactory privateNoCache() =>
      (_, __) => CacheControlHeader(privateCache: true, noCache: true);

  /// Returns a [CacheControlHeader] with no-store.
  CacheControlFactory noStore() => (_, __) => CacheControlHeader(noStore: true);

  /// Returns a [CacheControlHeader] with public, and possibly max-age set to [maxAge].
  CacheControlFactory public({int? maxAge}) =>
      (_, __) => CacheControlHeader(publicCache: true, maxAge: maxAge);

  /// Returns a [CacheControlHeader] with public, immutable, and possibly max-age set to [maxAge].
  CacheControlFactory publicImmutable({int? maxAge}) => (_, __) =>
      CacheControlHeader(publicCache: true, immutable: true, maxAge: maxAge);

  final Handler _handler;

  StaticRoute._(this._handler) : super(methods: {Method.get, Method.head});

  /// Use [StaticRoute.directory] to serve everything below a given [root].
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Default is to leave caching behavior to client
  /// side heuristics.
  factory StaticRoute.directory(Directory root,
      [CacheControlFactory cacheControlFactory = _defaultFactory]) {
    return StaticRoute._(
        createStaticHandler(root.path, cacheControl: cacheControlFactory));
  }

  /// Use [StaticRoute.file] to serve a single [file].
  ///
  /// Use [cacheControlFactory] to customize what [CacheControlHeader] to
  /// return for a given asset. Default is to leave caching behavior to client
  /// side heuristics.
  factory StaticRoute.file(File file,
      [CacheControlFactory cacheControlFactory = _defaultFactory]) {
    return StaticRoute._(
        createFileHandler(file.path, cacheControl: cacheControlFactory));
  }

  @override
  FutureOr<HandledContext> handleCall(Session session, NewContext context) =>
      _handler(context);
}
