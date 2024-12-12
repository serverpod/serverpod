import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/headers/util/cookie_util.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';
import 'package:collection/collection.dart';

/// A class representing the HTTP Cookie header.
///
/// This class manages the parsing and representation of cookies.
class CookieHeader implements TypedHeader {
  /// The list of cookies.
  final List<Cookie> cookies;

  /// Constructs a [CookieHeader] instance with the specified cookies.
  const CookieHeader({required this.cookies});

  /// Parses the Cookie header value and returns a [CookieHeader] instance.
  ///
  /// This method processes the header value, extracting the cookies into a list.
  factory CookieHeader.parse(String value) {
    if (value.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    final splitValues = value.splitTrimAndFilterUnique(separator: ';');

    final cookies = splitValues.map(Cookie.parse).toList();
    var names = cookies.map((cookie) => cookie.name.toLowerCase()).toList();
    var uniqueNames = names.toSet();

    if (names.length != uniqueNames.length) {
      throw FormatException('Supplied multiple Name and Value attributes');
    }

    return CookieHeader(cookies: cookies);
  }

  Cookie? getCookie(String name) {
    return cookies.firstWhereOrNull((cookie) => cookie.name == name);
  }

  /// Converts the [CookieHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() {
    return cookies.map((cookie) => cookie.toHeaderString()).join('; ');
  }

  @override
  String toString() {
    return 'CookieHeader(cookies: $cookies)';
  }
}

/// A class representing a single cookie.
class Cookie {
  /// The name of the cookie.
  final String name;

  /// The value of the cookie.
  final String value;

  Cookie({
    required String name,
    required String value,
  })  : name = validateCookieName(name),
        value = validateCookieValue(value);

  factory Cookie.parse(String value) {
    var splitValue = value.split('=');
    if (splitValue.length != 2) {
      throw FormatException('Invalid cookie format');
    }

    return Cookie(
      name: splitValue.first.trim(),
      value: splitValue.last.trim(),
    );
  }

  /// Converts the [Cookie] instance into a string representation suitable for HTTP headers.
  String toHeaderString() => '$name=$value';

  @override
  String toString() {
    return 'Cookie(name: $name, value: $value)';
  }
}
