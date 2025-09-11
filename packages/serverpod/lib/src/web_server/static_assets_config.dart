import 'package:serverpod/serverpod.dart';
import 'static_asset_manager.dart';

/// Configuration for static assets in Serverpod.
///
/// This class provides a way to configure static asset directories
/// and CDN settings at server startup.
class StaticAssetsConfig {
  /// Static directories that the server will serve.
  /// Similar to Django's STATICFILES_DIRS.
  final List<String> staticDirectories;

  /// CDN URL prefix for serving static assets.
  /// If set, assetUrl() will return CDN URLs instead of local paths.
  final String? cdnUrlPrefix;

  /// Whether to enable automatic cache busting for static files.
  final bool enableCacheBusting;

  /// The configured static asset manager instance.
  late final StaticAssetManager _manager;

  /// Creates a new [StaticAssetsConfig].
  StaticAssetsConfig({
    this.staticDirectories = const ['web/static'],
    this.cdnUrlPrefix,
    this.enableCacheBusting = true,
  });

  /// Configure the static asset manager with this configuration.
  void configure() {
    _manager = StaticAssetManager();
    _manager.configureStaticDirectories(staticDirectories);
    _manager.configureCdnUrl(cdnUrlPrefix);
  }

  /// Get the configured static asset manager.
  StaticAssetManager get manager => _manager;
}

/// Extension on Serverpod to easily configure static assets.
extension StaticAssetsConfigExtension on Serverpod {
  /// Configure static assets for this server.
  void configureStaticAssets(StaticAssetsConfig config) {
    config.configure();
  }
}
