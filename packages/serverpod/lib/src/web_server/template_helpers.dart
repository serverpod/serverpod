import 'static_asset_manager.dart';

/// Template helper functions for Serverpod web templates.
class TemplateHelpers {
  /// Generate a versioned URL for a static asset.
  ///
  /// This function can be used in templates to generate cache-busted URLs
  /// for static assets like images, CSS, and JavaScript files.
  ///
  /// Example usage in templates:
  /// ```html
  /// <img src="{{ assetUrl('images/logo.png') }}" alt="Logo">
  /// <link rel="stylesheet" href="{{ assetUrl('css/style.css') }}">
  /// <script src="{{ assetUrl('js/app.js') }}"></script>
  /// ```
  ///
  /// The function will:
  /// 1. Compute a hash of the file content
  /// 2. Append the hash to the filename
  /// 3. Return the versioned URL
  ///
  /// If the file doesn't exist, returns null.
  static Future<String?> assetUrl(String assetPath) async {
    return await StaticAssetManager().assetUrl(assetPath);
  }

  /// Synchronous version of assetUrl for use in templates.
  /// Note: This will return the asset path without hash if the file
  /// hasn't been processed yet. Use the async version when possible.
  static String assetUrlSync(String assetPath) {
    // For synchronous templates, we can't compute hashes on-demand
    // Return the original path - the static directory route will handle
    // hash removal if needed
    return '/$assetPath';
  }
}
