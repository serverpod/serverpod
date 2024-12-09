import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/base/typed_header.dart';
import 'package:collection/collection.dart';

/// A class representing the HTTP Cookie header.
///
/// This class manages the parsing and representation of cookies.
class CookieHeader extends TypedHeader {
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

  /// Constructs a [Cookie] instance with the specified name and value.
  Cookie({
    required this.name,
    required this.value,
  })  : assert(isNameValid(name), 'Invalid cookie name'),
        assert(isValueValid(value), 'Invalid cookie value');

  factory Cookie.parse(String value) {
    final parts = value.split('=');
    if (parts.length != 2) {
      throw FormatException('Invalid cookie format');
    }

    final name = parts[0].trim();
    final rawValue = parts[1].trim();

    if (!isNameValid(name)) {
      throw FormatException('Invalid cookie name');
    }

    final decodedValue = Uri.decodeComponent(rawValue);

    if (!isValueValid(decodedValue)) {
      throw FormatException('Invalid cookie value');
    }

    return Cookie(name: name, value: decodedValue);
  }

  /// Converts the [Cookie] instance into a string representation suitable for HTTP headers.
  String toHeaderString() => '$name=$value';

  @override
  String toString() {
    return 'Cookie(name: $name, value: $value)';
  }

  /// Validates the cookie name according to the rules.
  static bool isNameValid(String name) {
    if (name.isEmpty) return false;

    // Check for invalid characters
    var invalidCharacters = RegExp(r'[()<>@,;:"/[\]?={} \t]');
    if (name.contains(invalidCharacters)) return false;

    // Check for whitespace
    var whitespace = RegExp(r'\s');
    if (name.contains(whitespace)) return false;

    return true;
  }

  /// Validates the cookie value according to the rules.
  static bool isValueValid(String value) {
    if (value.isEmpty) return false;

    // Check for control characters and whitespace
    final invalidCharacters = RegExp(r'[\x00-\x1F\x7F]');
    if (value.contains(invalidCharacters)) return false;

    // Check for unencoded semicolon
    if (value.contains(';')) return false;

    return true;
  }
}
