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
///
/// ## About Caching ..
///
/// By default, all files are served with `private, no-cache` headers so the
/// browser always revalidates with the server via ETag. This is the only safe
/// default because:
///
/// - Flutter's service worker is deprecated and will be removed
///   (see [flutter#156910](https://github.com/flutter/flutter/issues/156910)).
///   Since Flutter 3.32, the generated service worker is a self-destructing
///   stub that provides no caching for either WASM or JS builds.
/// - Flutter's build output uses fixed filenames (`main.dart.wasm`,
///   `main.dart.js`, `main.dart.mjs`) with no content hashing, so aggressive
///   `max-age` caching risks serving stale applications after a rebuild.
/// - With `no-cache`, the browser still caches files locally but sends a
///   conditional request (`If-None-Match`) on each load. Unchanged files
///   receive a `304 Not Modified` response with no body, so the cost is a
///   round-trip per asset, not a full re-download.
///
/// To avoid the round-trip cost if needed, supply a [cacheBustingConfig]
/// from relic and post-process the Flutter build output to embed content
/// hashes in asset URLs. Files served through cache busting can then use
/// `immutable, max-age=31536000` caching via a custom [cacheControlFactory].
/// For inspiration see [Content-Hashed Caching for Flutter Web (Without a Service Worker)](https://chipsoffury.com/blog/flutter-web-cache-busting-strategy/)
/// Hopefully this situation will improve in the future.
class FlutterRoute extends Route {
  /// The directory containing Flutter web files.
  final Directory directory;

  /// The index file to use as fallback (defaults to index.html in [directory]).
  final File indexFile;

  /// Cache control factory for static files.
  ///
  /// Defaults to `private, no-cache` for all files (ETag revalidation on
  /// every request). Override this when using [cacheBustingConfig] to serve
  /// cache-busted assets with aggressive caching headers.
  final CacheControlFactory cacheControlFactory;

  /// Optional cache busting configuration for static files.
  ///
  /// When provided, the static file handler strips content hashes from
  /// incoming URLs before looking up files on disk. Use this together with
  /// a custom [cacheControlFactory] that returns aggressive caching headers
  /// for cache-busted assets.
  final CacheBustingConfig? cacheBustingConfig;

  /// Creates a new FlutterRoute.
  ///
  /// The [directory] parameter specifies the root directory containing Flutter
  /// web files. The [indexFile] parameter sets the fallback file for SPA
  /// routing and defaults to `index.html` within the specified directory.
  ///
  /// The [host] parameter restricts this route to a specific virtual host
  /// (defaults to `null`, matching any host).
  FlutterRoute(
    this.directory, {
    File? indexFile,
    CacheControlFactory? cacheControlFactory,
    this.cacheBustingConfig,
    super.host,
  }) : indexFile = indexFile ?? File(path.join(directory.path, 'index.html')),
       cacheControlFactory =
           cacheControlFactory ?? StaticRoute.privateNoCache(),
       super(methods: {Method.get, Method.head});

  @override
  void injectIn(RelicRouter router) {
    final subRouter = Router<Handler>();

    subRouter.use('/', const WasmHeadersMiddleware().call);

    subRouter.use(
      '/',
      FallbackMiddleware(
        fallback: StaticRoute.file(
          indexFile,
          cacheControlFactory: StaticRoute.privateNoCache(),
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
    // This should never be called since routing is handled via injectIn
    throw UnimplementedError(
      'FlutterRoute handles routing via injectIn and should not be called directly',
    );
  }
}
