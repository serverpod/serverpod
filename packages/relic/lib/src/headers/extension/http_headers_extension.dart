import 'dart:io';

/// Extension on HttpHeaders to retrieve header values.
extension HttpHeadersExtension on HttpHeaders {
  /// Gets the value of a header by key.
  ///
  /// Tries to get a single value using `value(key)`.
  /// If it's null, retrieves the full list using `this[key]`.
  dynamic getValue(String key) => value(key) ?? this[key];
}
