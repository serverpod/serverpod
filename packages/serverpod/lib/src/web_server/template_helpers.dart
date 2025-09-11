import 'static_asset_manager.dart';

/// Template helper functions for Serverpod web templates.
class TemplateHelpers {
  final StaticAssetManager _assetManager;

  /// Creates a new [TemplateHelpers] with the given asset manager.
  TemplateHelpers(this._assetManager);


  /// Note: For templates, consider using [RouteStaticDirectory] with
  /// [enableAutomaticCacheBusting: true] instead, which handles cache busting
  /// at the routing level without requiring async operations in templates.
  Future<String?> assetUrl(String assetPath) async {
    return await _assetManager.assetUrl(assetPath);
  }
}
