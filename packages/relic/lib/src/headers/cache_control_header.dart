part of '../headers.dart';

/// A class representing the HTTP Cache-Control header.
///
/// This class manages cache directives like `no-cache`, `no-store`, and `max-age`.
/// It supports parsing header values and generating the appropriate header string.
class CacheControlHeader {
  /// Specifies that the response should not be cached.
  final bool noCache;

  /// Specifies that the cache should not store the response.
  final bool noStore;

  /// Specifies the maximum amount of time (in seconds) a resource is considered fresh.
  final int? maxAge;

  /// Specifies the maximum amount of time (in seconds) a stale resource can be used.
  final int? staleWhileRevalidate;

  /// Specifies whether the cache can be shared by different users (public caching).
  final bool? publicCache;

  /// Specifies that the resource is only for private use (specific to a single user).
  final bool? privateCache;

  /// Constructs a [CacheControlHeader] instance with the specified directives.
  const CacheControlHeader({
    this.noCache = false,
    this.noStore = false,
    this.maxAge,
    this.staleWhileRevalidate,
    this.publicCache,
    this.privateCache,
  });

  /// Parses the Cache-Control header value and returns a [CacheControlHeader] instance.
  ///
  /// This method splits the header value by commas, trims each directive, and processes
  /// common cache directives like `no-cache`, `no-store`, `max-age`, etc.
  factory CacheControlHeader.fromHeaderValue(String value) {
    final directives =
        value.split(',').map((directive) => directive.trim()).toList();

    bool noCache = directives.contains('no-cache');
    bool noStore = directives.contains('no-store');
    int? maxAge;
    int? staleWhileRevalidate;
    bool? publicCache = directives.contains('public');
    bool? privateCache = directives.contains('private');

    for (var directive in directives) {
      if (directive.startsWith('max-age=')) {
        maxAge = int.tryParse(directive.substring(8));
      } else if (directive.startsWith('stale-while-revalidate=')) {
        staleWhileRevalidate = int.tryParse(directive.substring(22));
      }
    }

    return CacheControlHeader(
      noCache: noCache,
      noStore: noStore,
      maxAge: maxAge,
      staleWhileRevalidate: staleWhileRevalidate,
      publicCache: publicCache,
      privateCache: privateCache,
    );
  }

  /// Static method that attempts to parse the Cache-Control header value and returns `null` if the value is `null`.
  ///
  /// This method safely parses the Cache-Control header value or returns `null` if the input is invalid or `null`.
  static CacheControlHeader? tryParse(String? value) {
    if (value == null) return null;
    return CacheControlHeader.fromHeaderValue(value);
  }

  /// Converts the [CacheControlHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the set directives.
  @override
  String toString() {
    List<String> directives = [];
    if (noCache) directives.add('no-cache');
    if (noStore) directives.add('no-store');
    if (publicCache == true) directives.add('public');
    if (privateCache == true) directives.add('private');
    if (maxAge != null) directives.add('max-age=$maxAge');
    if (staleWhileRevalidate != null) {
      directives.add('stale-while-revalidate=$staleWhileRevalidate');
    }

    return directives.join(', ');
  }
}
