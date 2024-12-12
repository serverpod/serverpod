import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// Represents the HTTP Strict-Transport-Security (HSTS) header for managing
/// HSTS settings.
class StrictTransportSecurityHeader implements TypedHeader {
  /// The max-age directive specifies the time, in seconds, that the browser
  /// should remember that a site is only to be accessed using HTTPS.
  final int maxAge;

  /// The includeSubDomains directive applies this rule to all of the site's subdomains as well.
  final bool includeSubDomains;

  /// The preload directive indicates that the site is requesting inclusion
  /// in the HSTS preload list maintained by browsers.
  final bool preload;

  /// Creates a [StrictTransportSecurityHeader] with the specified [maxAge], [includeSubDomains], and [preload].
  StrictTransportSecurityHeader({
    required this.maxAge,
    this.includeSubDomains = false,
    this.preload = false,
  });

  /// Predefined directive values.
  static const _maxAgePrefix = 'max-age=';
  static const _includeSubDomains = 'includeSubDomains';
  static const _preload = 'preload';

  /// Parses the Strict-Transport-Security header value into a [StrictTransportSecurityHeader] instance.
  ///
  /// Throws a [FormatException] if the max-age directive is missing or invalid.
  factory StrictTransportSecurityHeader.parse(String value) {
    final splitValues = value.splitTrimAndFilterUnique(separator: ';');
    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    int? maxAge;
    bool includeSubDomains = false;
    bool preload = false;

    for (var directive in splitValues) {
      if (directive.startsWith(_maxAgePrefix)) {
        maxAge = int.tryParse(directive.substring(_maxAgePrefix.length));
      } else if (directive == _includeSubDomains) {
        includeSubDomains = true;
      } else if (directive == _preload) {
        preload = true;
      }
    }

    if (maxAge == null) {
      throw FormatException('Max-age directive is missing or invalid');
    }

    return StrictTransportSecurityHeader(
      maxAge: maxAge,
      includeSubDomains: includeSubDomains,
      preload: preload,
    );
  }

  /// Converts the [StrictTransportSecurityHeader] into a string representation
  /// for HTTP headers.
  @override
  String toHeaderString() {
    final directives = ['$_maxAgePrefix$maxAge'];
    if (includeSubDomains) directives.add(_includeSubDomains);
    if (preload) directives.add(_preload);
    return directives.join('; ');
  }

  @override
  String toString() {
    return 'StrictTransportSecurityHeader(maxAge: $maxAge, includeSubDomains: $includeSubDomains, preload: $preload)';
  }
}
