import 'dart:io';

/// Extension on `HttpHeaders` to provide utility methods for parsing header values.
extension HttpHeadersExtension on HttpHeaders {
  /// Returns the first header value associated with [key] as a `String`.
  ///
  /// - If a single value is found, it is returned.
  /// - If multiple values are present, the first value is returned.
  /// - If the header is one that shouldn't be split by commas (e.g., `If-Range`), it won't split the value.
  /// - Returns `null` if no value is found.
  String? parseSingleValue(String key) {
    // Try to retrieve a single value using the value() method
    var singleValue = value(key);
    if (singleValue != null) return singleValue;

    // Check for multiple values in the header
    var multiValues = this[key];

    // For headers that shouldn't be split (e.g., 'If-Range'), return the first value
    if (_shouldNotSplitHeader(key)) {
      return multiValues?.firstOrNull;
    }

    // If the header can be split and contains only one value, return it
    if (multiValues != null && multiValues.length == 1) {
      return multiValues.first;
    }

    // If multiple values are present, return the first value (log warning if necessary)
    return multiValues?.firstOrNull;
  }

  /// Parses and returns multiple header values associated with [key] as a `List<String>`.
  ///
  /// - For headers that should not be split by commas (e.g., `If-Range`), returns the values without splitting.
  /// - For headers that can be split, splits the values by commas and trims any whitespace.
  /// - Returns `null` if no values are found.
  List<String>? parseMultipleValue(String key) {
    List<String>? multiValues = this[key];

    if (multiValues == null) return null;

    var values = switch (_shouldNotSplitHeader(key)) {
      true => multiValues,
      false => multiValues.fold<List<String>>(
          [],
          (a, b) => [
            ...a,
            ...b.split(',').map((value) => value.trim()),
          ],
        ),
    }
        .where((e) => e.isNotEmpty)
        .map((e) => e.trim())
        .toList();

    return values.isEmpty ? null : values;
  }

  /// Parses a URI from the header value associated with [key].
  ///
  /// - Returns a valid `Uri` if the header value contains a valid absolute URI.
  /// - Returns `null` if the value is invalid or empty.
  Uri? parseUri(String key) {
    var value = parseSingleValue(key);
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    return (uri != null && uri.isAbsolute) ? uri : null;
  }

  /// Determines whether the header specified by [key] should not be split by commas.
  ///
  /// This is useful for headers like `If-Range` and `Date`, where commas may be part of the value.
  bool _shouldNotSplitHeader(String key) {
    const nonSplittingHeaders = {
      'if-range',
      'date',
      'last-modified',
      'etag',
    };

    return nonSplittingHeaders.contains(key.toLowerCase());
  }
}
