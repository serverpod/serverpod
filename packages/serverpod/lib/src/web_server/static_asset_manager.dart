import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;

/// Manages static assets with automatic cache busting.
///
/// This class provides functionality to:
/// - Compute content hashes for static files
/// - Generate versioned URLs for cache busting
/// - Cache hash results for performance
/// - Invalidate cache when files change
/// - Support CDN URLs
class StaticAssetManager {
  static final StaticAssetManager _instance = StaticAssetManager._internal();

  /// Creates a new instance of [StaticAssetManager].
  /// Returns the singleton instance.
  factory StaticAssetManager() => _instance;

  StaticAssetManager._internal();

  /// Cache of file hashes: file path -> (hash, last modified)
  final Map<String, _HashCacheEntry> _hashCache = {};

  /// Static directories configured for serving
  final List<String> _staticDirectories = [];

  /// CDN URL prefix for serving static assets
  String? _cdnUrlPrefix;

  /// Maximum number of cache entries to keep.
  static const int _maxCacheEntries = 1000;

  /// Configure static directories that the server will serve.
  /// Similar to Django's STATICFILES_DIRS.
  void configureStaticDirectories(List<String> directories) {
    _staticDirectories.clear();
    _staticDirectories.addAll(directories.map((dir) => p.normalize(dir)));
  }

  /// Configure CDN URL prefix for serving static assets.
  /// If set, assetUrl() will return CDN URLs instead of local paths.
  void configureCdnUrl(String? cdnUrlPrefix) {
    _cdnUrlPrefix = cdnUrlPrefix;
  }

  /// Generate a versioned URL for a static asset.
  ///
  /// This function:
  /// 1. Computes a hash of the file content if not already cached
  /// 2. Caches the result for performance
  /// 3. Invalidates cache when the file changes
  /// 4. Appends the hash to the filename
  /// 5. Returns the versioned URL
  ///
  /// Example: assetUrl('images/logo.png') -> 'images/logo.abc123def.png'
  ///
  /// If CDN is configured: assetUrl('images/logo.png') -> 'https://mycdn.com/static/images/logo.abc123def.png'
  Future<String?> assetUrl(String assetPath) async {
    if (assetPath.isEmpty) return null;

    // Normalize the path
    var normalizedPath = p.normalize(assetPath);

    // Find the file in configured static directories
    var file = await _findStaticFile(normalizedPath);
    if (file == null) {
      return null;
    }

    // Compute or get cached hash
    var hash = await _getFileHash(file);
    if (hash == null) {
      return null;
    }

    // Generate versioned filename
    var versionedPath = _addHashToPath(normalizedPath, hash);

    // Return CDN URL if configured, otherwise local path
    if (_cdnUrlPrefix != null) {
      return '$_cdnUrlPrefix/$versionedPath';
    } else {
      return '/$versionedPath';
    }
  }

  /// Find a static file in the configured directories.
  Future<File?> _findStaticFile(String assetPath) async {
    for (var staticDir in _staticDirectories) {
      var fullPath = p.join(staticDir, assetPath);
      var file = File(fullPath);
      if (await file.exists()) {
        return file;
      }
    }
    return null;
  }

  /// Get the content hash for a file, using cache when possible.
  Future<String?> _getFileHash(File file) async {
    try {
      var stat = await file.stat();
      var filePath = file.absolute.path;
      var lastModified = stat.modified;

      // Check if we have a cached hash that's still valid
      var cached = _hashCache[filePath];
      if (cached != null && cached.lastModified == lastModified) {
        return cached.hash;
      }

      // Compute new hash
      var hash = await _computeFileHash(file);
      if (hash == null) {
        return null;
      }

      // Cache the result
      _hashCache[filePath] = _HashCacheEntry(hash, lastModified);

      // Clean up cache if it gets too large
      _cleanupCache();

      return hash;
    } catch (e) {
      return null;
    }
  }

  /// Compute the content hash of a file.
  Future<String?> _computeFileHash(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var hash = _sha256(bytes);
      return hash.substring(0, 8); // Use first 8 characters
    } catch (e) {
      return null;
    }
  }

  /// Add hash to a file path.
  String _addHashToPath(String path, String hash) {
    var dir = p.dirname(path);
    var filename = p.basename(path);
    var name = p.basenameWithoutExtension(filename);
    var extension = p.extension(filename);

    var versionedFilename = '$name.$hash$extension';

    if (dir == '.') {
      return versionedFilename;
    } else {
      return p.join(dir, versionedFilename);
    }
  }

  /// Clean up the hash cache to prevent memory leaks.
  void _cleanupCache() {
    if (_hashCache.length <= _maxCacheEntries) return;

    // Remove oldest entries (simple LRU-like behavior)
    var entries = _hashCache.entries.toList();
    entries
        .sort((a, b) => a.value.lastModified.compareTo(b.value.lastModified));

    var toRemove = entries.take(_hashCache.length - _maxCacheEntries + 100);
    for (var entry in toRemove) {
      _hashCache.remove(entry.key);
    }
  }

  /// Clear the hash cache (useful for testing or manual cache invalidation).
  void clearCache() {
    _hashCache.clear();
  }

  /// Get cache statistics for monitoring.
  Map<String, dynamic> getCacheStats() {
    return {
      'cacheSize': _hashCache.length,
      'maxCacheSize': _maxCacheEntries,
      'staticDirectories': List.from(_staticDirectories),
      'cdnUrlPrefix': _cdnUrlPrefix,
    };
  }

  /// Simple SHA-256-like hash implementation.
  String _sha256(List<int> bytes) {
    var hash = 0;
    for (var byte in bytes) {
      hash = ((hash << 5) - hash + byte) & 0xffffffff;
    }
    return hash.abs().toRadixString(16).padLeft(8, '0');
  }
}

/// Cache entry for file hashes.
class _HashCacheEntry {
  final String hash;
  final DateTime lastModified;

  _HashCacheEntry(this.hash, this.lastModified);
}
