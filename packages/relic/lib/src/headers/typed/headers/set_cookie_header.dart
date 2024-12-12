import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/parser/common_types_parser.dart';
import 'package:relic/src/headers/typed/headers/util/cookie_util.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Set-Cookie header.
///
/// This class manages the parsing and representation of set cookie.
class SetCookieHeader implements TypedHeader {
  /// The keys used for the Set-Cookie header.
  static const String _expires = 'Expires=';
  static const String _maxAge = 'Max-Age=';
  static const String _domain = 'Domain=';
  static const String _path = 'Path=';
  static const String _secure = 'Secure';
  static const String _httpOnly = 'HttpOnly';
  static const String _sameSite = 'SameSite=';

  /// The name of the cookie.
  final String name;

  /// The value of the cookie.
  final String value;

  /// The time at which the cookie expires.
  final DateTime? expires;

  /// The number of seconds until the cookie expires. A zero or negative value
  /// means the cookie has expired.
  final int? maxAge;

  /// The domain that the cookie applies to.
  final Uri? domain;

  /// The path within the [domain] that the cookie applies to.
  final Uri? path;

  /// Whether to only send this cookie on secure connections.
  final bool secure;

  /// Whether the cookie is only sent in the HTTP request and is not made
  /// available to client side scripts.
  final bool httpOnly;

  /// Whether the cookie is available from other sites.
  ///
  /// This value is `null` if the SameSite attribute is not present.
  ///
  /// See [SameSite] for more information.
  SameSite? sameSite;

  /// Constructs a [Cookie] instance with the specified name and value.
  SetCookieHeader({
    required String name,
    required String value,
    this.expires,
    this.maxAge,
    this.domain,
    this.path,
    this.secure = false,
    this.httpOnly = false,
    this.sameSite,
  })  : name = validateCookieName(name),
        value = validateCookieValue(value);

  factory SetCookieHeader.parse(String value) {
    var splitValue = value.splitTrimAndFilterUnique(separator: ';');
    if (splitValue.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    bool secure = false;
    bool httpOnly = false;
    String cookieName = '';
    String cookieValue = '';
    SameSite? sameSite;
    DateTime? expires;
    int? maxAge;
    Uri? domain;
    Uri? path;

    for (var cookie in splitValue) {
      // Handle SameSite attribute
      if (cookie.toLowerCase().contains(_sameSite.toLowerCase())) {
        if (sameSite != null) {
          throw FormatException('Supplied multiple SameSite attributes');
        }
        var samesiteValue = cookie.split('=')[1].trim();
        sameSite = SameSite.values.firstWhere(
          (sameSite) =>
              sameSite.name.toLowerCase() == samesiteValue.toLowerCase(),
          orElse: () => throw FormatException('Invalid SameSite attribute'),
        );
        continue;
      }

      // Handle Path attribute;
      if (cookie.toLowerCase().contains(_path.toLowerCase())) {
        if (path != null) {
          throw FormatException('Supplied multiple Path attributes');
        }
        var pathValue = cookie.split('=')[1].trim();
        path = parseUri(pathValue);
        continue;
      }

      // Handle Domain attribute
      if (cookie.toLowerCase().contains(_domain.toLowerCase())) {
        if (domain != null) {
          throw FormatException('Supplied multiple Domain attributes');
        }
        var domainValue = cookie.split('=')[1].trim();
        domain = parseUri(domainValue);
        continue;
      }

      // Handle Max-Age attribute
      if (cookie.toLowerCase().contains(_maxAge.toLowerCase())) {
        if (maxAge != null) {
          throw FormatException('Supplied multiple Max-Age attributes');
        }
        var maxAgeValue = cookie.split('=')[1].trim();
        maxAge = parseInt(maxAgeValue);
        continue;
      }

      // Handle Expires attribute
      if (cookie.toLowerCase().contains(_expires.toLowerCase())) {
        if (expires != null) {
          throw FormatException('Supplied multiple Expires attributes');
        }
        var expiresValue = cookie.split('=')[1].trim();
        expires = parseDate(expiresValue);
        continue;
      }

      // Handle Secure attribute
      if (cookie.toLowerCase().contains(_secure.toLowerCase())) {
        secure = true;
        continue;
      }

      // Handle HttpOnly attribute
      if (cookie.toLowerCase().contains(_httpOnly.toLowerCase())) {
        httpOnly = true;
        continue;
      }

      // Handle Name and Value
      // If non of the other attributes are present, then the cookie is a name and value pair
      if (cookie.contains('=')) {
        if (cookieName.isNotEmpty || cookieValue.isNotEmpty) {
          throw FormatException('Supplied multiple Name and Value attributes');
        }
        final parts = cookie.split('=');
        cookieName = parts.first.trim();
        cookieValue = parts.last.trim();
        continue;
      }

      throw FormatException('Invalid cookie format');
    }

    return SetCookieHeader(
      name: cookieName,
      value: cookieValue,
      secure: secure,
      httpOnly: httpOnly,
      sameSite: sameSite,
      path: path,
      domain: domain,
      maxAge: maxAge,
      expires: expires,
    );
  }

  /// Converts the [Cookie] instance into a string representation suitable for HTTP headers.
  @override
  String toHeaderString() {
    // Use a set to ensure unique attributes
    final attributes = <String>{};
    if (name.isNotEmpty) attributes.add('$name=$value');

    if (secure) attributes.add(_secure);
    if (httpOnly) attributes.add(_httpOnly);
    if (sameSite != null) attributes.add('$_sameSite${sameSite!.name}');
    if (expires != null) {
      attributes.add('$_expires${formatHttpDate(expires!)}');
    }
    if (maxAge != null) attributes.add('$_maxAge$maxAge');
    if (domain != null) attributes.add('$_domain${domain.toString()}');
    if (path != null) attributes.add('$_path${path.toString()}');

    return attributes.join('; ');
  }

  @override
  String toString() {
    return 'SetCookieHeader(name: $name, '
        'value: $value, '
        'expires: $expires, '
        'maxAge: $maxAge, '
        'domain: $domain, '
        'path: $path, '
        'secure: $secure, '
        'httpOnly: $httpOnly, '
        'sameSite: $sameSite)';
  }
}

/// Cookie cross-site availability configuration.
///
/// The value of [Cookie.sameSite], which defines whether an
/// HTTP cookie is available from other sites or not.
///
/// Has three possible values: [lax], [strict] and [none].
final class SameSite {
  /// Default value, cookie with this value will generally not be sent on
  /// cross-site requests, unless the user is navigated to the original site.
  static const lax = SameSite._("Lax");

  /// Cookie with this value will never be sent on cross-site requests.
  static const strict = SameSite._("Strict");

  /// Cookie with this value will be sent in all requests.
  ///
  /// [Cookie.secure] must also be set to true, otherwise the `none` value
  /// will have no effect.
  static const none = SameSite._("None");

  static const List<SameSite> values = [lax, strict, none];

  final String name;

  const SameSite._(this.name);

  @override
  String toString() => "SameSite($name)";
}
