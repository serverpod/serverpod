part of '../headers.dart';

/// A class representing the HTTP Cookie header.
///
/// This class manages the parsing and representation of cookies.
class CookieHeader {
  /// The list of cookies.
  final List<Cookie> cookies;

  /// Constructs a [CookieHeader] instance with the specified cookies.
  CookieHeader({required this.cookies});

  /// Parses the Cookie header value and returns a [CookieHeader] instance.
  ///
  /// This method processes the header value, extracting the cookies into a list.
  factory CookieHeader.parse(String value) {
    final splitValues = value.splitTrimAndFilterUnique(separator: ';');

    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    final cookies = splitValues.map((pair) {
      final parts = pair.split('=');
      if (parts.length != 2) {
        throw FormatException('Invalid cookie format');
      }

      return Cookie(name: parts[0].trim(), value: parts[1].trim());
    }).toList();

    return CookieHeader(cookies: cookies);
  }

  Cookie? getCookie(String name) {
    return cookies.firstWhere((cookie) => cookie.name == name);
  }

  /// Converts the [CookieHeader] instance into a string representation suitable for HTTP headers.
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
  Cookie({required this.name, required this.value});

  /// Converts the [Cookie] instance into a string representation suitable for HTTP headers.
  String toHeaderString() => '$name=$value';

  @override
  String toString() {
    return 'Cookie(name: $name, value: $value)';
  }
}
