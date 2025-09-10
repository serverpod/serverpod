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

  /// Creates a new [StaticAssetsConfig].
  const StaticAssetsConfig({
    this.staticDirectories = const ['web/static'],
    this.cdnUrlPrefix,
    this.enableCacheBusting = true,
  });

  /// Configure the static asset manager with this configuration.
  void configure() {
    var manager = StaticAssetManager();
    manager.configureStaticDirectories(staticDirectories);
    manager.configureCdnUrl(cdnUrlPrefix);
  }
}

/// Extension on Serverpod to easily configure static assets.
extension StaticAssetsConfigExtension on Serverpod {
  /// Configure static assets for this server.
  void configureStaticAssets(StaticAssetsConfig config) {
    config.configure();
  }
}
