import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Cache-Control header.
///
/// This class manages cache directives like `no-cache`, `no-store`, `max-age`,
/// `must-revalidate`, etc. It supports parsing header values and generating
/// the appropriate header string.
class CacheControlHeader implements TypedHeader {
  // Cache-Control directive constants
  static const String _noCacheDirective = 'no-cache';
  static const String _noStoreDirective = 'no-store';
  static const String _mustRevalidateDirective = 'must-revalidate';
  static const String _proxyRevalidateDirective = 'proxy-revalidate';
  static const String _noTransformDirective = 'no-transform';
  static const String _onlyIfCachedDirective = 'only-if-cached';
  static const String _immutableDirective = 'immutable';
  static const String _mustUnderstandDirective = 'must-understand';
  static const String _publicDirective = 'public';
  static const String _privateDirective = 'private';
  static const String _maxAgeDirective = 'max-age';
  static const String _staleWhileRevalidateDirective = 'stale-while-revalidate';
  static const String _sMaxAgeDirective = 's-maxage';
  static const String _staleIfErrorDirective = 'stale-if-error';
  static const String _maxStaleDirective = 'max-stale';
  static const String _minFreshDirective = 'min-fresh';

  static const List<String> _validDirectives = [
    _noCacheDirective,
    _noStoreDirective,
    _mustRevalidateDirective,
    _proxyRevalidateDirective,
    _noTransformDirective,
    _onlyIfCachedDirective,
    _immutableDirective,
    _mustUnderstandDirective,
    _publicDirective,
    _privateDirective,
    _maxAgeDirective,
    _staleWhileRevalidateDirective,
    _sMaxAgeDirective,
    _staleIfErrorDirective,
    _maxStaleDirective,
    _minFreshDirective,
  ];

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

  /// Specifies that the response must be revalidated with the origin server before use.
  final bool mustRevalidate;

  /// Specifies that the shared cache must revalidate with the origin server before use.
  final bool proxyRevalidate;

  /// Specifies the maximum amount of time (in seconds) a resource is considered fresh for shared caches.
  final int? sMaxAge;

  /// Indicates that the response is allowed to be transformed by intermediaries.
  final bool noTransform;

  /// Indicates that the response should only be returned from cache and not fetch from origin.
  final bool onlyIfCached;

  /// Specifies the maximum amount of time (in seconds) a stale resource can be used while the cache is being refreshed.
  final int? staleIfError;

  /// Specifies the maximum amount of time (in seconds) a stale resource can be used.
  final int? maxStale;

  /// Specifies the minimum amount of time (in seconds) a resource is considered fresh.
  final int? minFresh;

  /// Indicates that the response is immutable.
  final bool immutable;

  /// Indicates that the response must be understood by the cache.
  final bool mustUnderstand;

  /// Constructs a [CacheControlHeader] instance with the specified directives.
  CacheControlHeader({
    this.noCache = false,
    this.noStore = false,
    this.maxAge,
    this.staleWhileRevalidate,
    this.publicCache,
    this.privateCache,
    this.mustRevalidate = false,
    this.proxyRevalidate = false,
    this.sMaxAge,
    this.noTransform = false,
    this.onlyIfCached = false,
    this.staleIfError,
    this.maxStale,
    this.minFresh,
    this.immutable = false,
    this.mustUnderstand = false,
  }) {
    if (publicCache == true && privateCache == true) {
      throw FormatException('Must be either public or private');
    }
    if (maxAge != null && staleWhileRevalidate != null) {
      throw FormatException(
        'Cannot have both max-age and stale-while-revalidate directives',
      );
    }
  }

  /// Parses the Cache-Control header value and returns a [CacheControlHeader] instance.
  ///
  /// This method splits the header value by commas, trims each directive, and processes
  /// common cache directives like `no-cache`, `no-store`, `max-age`, etc.
  factory CacheControlHeader.parse(List<String> values) {
    var directives = values.splitTrimAndFilterUnique();

    if (directives.isEmpty) {
      throw FormatException('Directives cannot be empty');
    }

    // Check if at least one directive is valid
    var foundOneDirective = directives.any(
      (directive) => _validDirectives.any(
        (validDirective) => directive.startsWith(validDirective),
      ),
    );

    // Check for invalid directives
    var invalidDirectives = directives.where(
      (directive) => !_validDirectives.any(
        (validDirective) => directive.startsWith(validDirective),
      ),
    );

    if (!foundOneDirective || invalidDirectives.isNotEmpty) {
      throw FormatException('Invalid directive');
    }

    bool noCache = directives.contains(_noCacheDirective);
    bool noStore = directives.contains(_noStoreDirective);
    bool mustRevalidate = directives.contains(_mustRevalidateDirective);
    bool proxyRevalidate = directives.contains(_proxyRevalidateDirective);
    bool noTransform = directives.contains(_noTransformDirective);
    bool onlyIfCached = directives.contains(_onlyIfCachedDirective);
    bool immutable = directives.contains(_immutableDirective);
    bool mustUnderstand = directives.contains(_mustUnderstandDirective);
    int? maxAge;
    int? staleWhileRevalidate;
    int? sMaxAge;
    int? staleIfError;
    int? maxStale;
    int? minFresh;
    bool? publicCache = directives.contains(_publicDirective);
    bool? privateCache = directives.contains(_privateDirective);

    for (var directive in directives) {
      if (directive.startsWith('$_maxAgeDirective=')) {
        maxAge = int.tryParse(directive.substring(_maxAgeDirective.length + 1));
      } else if (directive.startsWith('$_staleWhileRevalidateDirective=')) {
        staleWhileRevalidate = int.tryParse(
            directive.substring(_staleWhileRevalidateDirective.length + 1));
      } else if (directive.startsWith('$_sMaxAgeDirective=')) {
        sMaxAge =
            int.tryParse(directive.substring(_sMaxAgeDirective.length + 1));
      } else if (directive.startsWith('$_staleIfErrorDirective=')) {
        staleIfError = int.tryParse(
            directive.substring(_staleIfErrorDirective.length + 1));
      } else if (directive.startsWith('$_maxStaleDirective=')) {
        maxStale =
            int.tryParse(directive.substring(_maxStaleDirective.length + 1));
      } else if (directive.startsWith('$_minFreshDirective=')) {
        minFresh =
            int.tryParse(directive.substring(_minFreshDirective.length + 1));
      }
    }

    if (publicCache == true && privateCache == true) {
      throw FormatException('Cannot be both public and private');
    }

    if (maxAge != null && staleWhileRevalidate != null) {
      throw FormatException(
        'Cannot have both max-age and stale-while-revalidate directives',
      );
    }

    return CacheControlHeader(
      noCache: noCache,
      noStore: noStore,
      mustRevalidate: mustRevalidate,
      proxyRevalidate: proxyRevalidate,
      noTransform: noTransform,
      onlyIfCached: onlyIfCached,
      maxAge: maxAge,
      staleWhileRevalidate: staleWhileRevalidate,
      sMaxAge: sMaxAge,
      publicCache: publicCache,
      privateCache: privateCache,
      staleIfError: staleIfError,
      maxStale: maxStale,
      minFresh: minFresh,
      immutable: immutable,
      mustUnderstand: mustUnderstand,
    );
  }

  /// Converts the [CacheControlHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the set directives.
  @override
  String toHeaderString() {
    List<String> directives = [];
    if (noCache) directives.add(_noCacheDirective);
    if (noStore) directives.add(_noStoreDirective);
    if (mustRevalidate) directives.add(_mustRevalidateDirective);
    if (proxyRevalidate) directives.add(_proxyRevalidateDirective);
    if (noTransform) directives.add(_noTransformDirective);
    if (onlyIfCached) directives.add(_onlyIfCachedDirective);
    if (immutable) directives.add(_immutableDirective);
    if (mustUnderstand) directives.add(_mustUnderstandDirective);
    if (publicCache == true) directives.add(_publicDirective);
    if (privateCache == true) directives.add(_privateDirective);
    if (maxAge != null) directives.add('$_maxAgeDirective=$maxAge');
    if (staleWhileRevalidate != null) {
      directives.add('$_staleWhileRevalidateDirective=$staleWhileRevalidate');
    }
    if (sMaxAge != null) directives.add('$_sMaxAgeDirective=$sMaxAge');
    if (staleIfError != null) {
      directives.add('$_staleIfErrorDirective=$staleIfError');
    }
    if (maxStale != null) directives.add('$_maxStaleDirective=$maxStale');
    if (minFresh != null) directives.add('$_minFreshDirective=$minFresh');

    return directives.join(', ');
  }

  @override
  String toString() {
    return 'CacheControlHeader('
        'noCache: $noCache, '
        'noStore: $noStore, '
        'maxAge: $maxAge, '
        'staleWhileRevalidate: $staleWhileRevalidate, '
        'publicCache: $publicCache, '
        'privateCache: $privateCache, '
        'mustRevalidate: $mustRevalidate, '
        'proxyRevalidate: $proxyRevalidate, '
        'sMaxAge: $sMaxAge, '
        'noTransform: $noTransform, '
        'onlyIfCached: $onlyIfCached, '
        'staleIfError: $staleIfError, '
        'maxStale: $maxStale, '
        'minFresh: $minFresh, '
        'immutable: $immutable, '
        'mustUnderstand: $mustUnderstand'
        ')';
  }
}
