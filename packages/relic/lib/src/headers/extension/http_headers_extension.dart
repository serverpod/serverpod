import 'dart:io';

/// Extension on `HttpHeaders` to provide a method for retrieving a single header value.
extension HttpHeadersExtension on HttpHeaders {
  /// Returns the first header value associated with [key] as a `String`.
  /// If no value is found or multiple values are present, it logs a warning and returns `null`.
  String? parseSingleValue(String key) {
    // Try to get a single value directly from value()
    var singleValue = value(key);
    if (singleValue != null) return singleValue;

    // If value() returns null, check for multiple values in the list
    var multiValues = this[key];

    // If the list has exactly one item, return that item
    if (multiValues != null && multiValues.length == 1) {
      return multiValues.first;
    }

    // Warning: Multiple values or no value found, returning null
    if (multiValues != null && multiValues.length > 1) {
      //print('Warning: Multiple values found for "$key".');
    } else {
      //print('Warning: No values found for "$key".');
    }

    return multiValues?.firstOrNull;
  }
}
