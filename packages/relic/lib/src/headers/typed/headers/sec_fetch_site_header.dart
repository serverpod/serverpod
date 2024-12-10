import 'package:relic/src/headers/typed/typed_headers.dart';

/// A class representing the HTTP Sec-Fetch-Site header.
///
/// This header indicates the relationship between the origin of the request
/// initiator and the origin of the requested resource.
class SecFetchSiteHeader extends TypedHeader {
  /// The site value of the request.
  final String site;

  /// Private constructor for [SecFetchSiteHeader].
  const SecFetchSiteHeader(this.site);

  /// Predefined site values.
  static const _sameOrigin = 'same-origin';
  static const _sameSite = 'same-site';
  static const _crossSite = 'cross-site';
  static const _none = 'none';

  static const sameOrigin = SecFetchSiteHeader(_sameOrigin);
  static const sameSite = SecFetchSiteHeader(_sameSite);
  static const crossSite = SecFetchSiteHeader(_crossSite);
  static const none = SecFetchSiteHeader(_none);

  /// Parses a [value] and returns the corresponding [SecFetchSiteHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory SecFetchSiteHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    switch (trimmed) {
      case _sameOrigin:
        return sameOrigin;
      case _sameSite:
        return sameSite;
      case _crossSite:
        return crossSite;
      case _none:
        return none;
      default:
        return SecFetchSiteHeader(trimmed);
    }
  }

  /// Converts the [SecFetchSiteHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() => site;

  @override
  String toString() {
    return 'SecFetchSiteHeader(value: $site)';
  }
}
