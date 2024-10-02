import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/exception/invalid_header_value_exception.dart';

/// Extension on `HttpHeaders` to provide utility methods for parsing header values.
extension HttpHeadersExtension on HttpHeaders {
  /// Returns the first header value associated with [key] as a `String`.
  ///
  /// - If a single value is found, it is returned.
  /// - If multiple values are present, the first value is returned.
  /// - Returns `null` if no value is found.
  /// - Throws an [InvalidHeaderValueException] if `strict` is `true` and the header has an empty or unexpected value.
  ///
  /// [strict] determines whether an exception is thrown for invalid or unexpected header values.
  String? parseSingleValue(
    String key, {
    required bool strict,
  }) {
    var singleValue = value(key);
    if (singleValue != null) {
      if (singleValue.isEmpty) {
        if (strict) {
          throw InvalidHeaderValueException(
            "Header '$key' is present but has an empty value.",
          );
        }
        return null;
      }
      return singleValue;
    }

    var multiValues = this[key];

    if (multiValues != null && multiValues.length == 1) {
      return multiValues.first;
    }

    if (strict) {
      throw InvalidHeaderValueException(
        "Header '$key' is present but has multiple values; expected a single value.",
      );
    }

    return multiValues?.firstOrNull;
  }

  /// Parses and returns multiple header values associated with [key] as a `List<String>`.
  ///
  /// - For headers that can be split, splits the values by commas and trims any whitespace.
  /// - Returns `null` if no values are found.
  /// - Throws an [InvalidHeaderValueException] if `strict` is `true` and the header contains only empty values.
  ///
  /// [strict] determines whether an exception is thrown for invalid or unexpected header values.
  List<String>? parseMultipleValue(
    String key, {
    required bool strict,
  }) {
    List<String>? multiValues = this[key];

    if (multiValues == null) return null;

    var values = multiValues
        .fold<List<String>>(
          [],
          (a, b) => [
            ...a,
            ...b.split(',').map((value) => value.trim()),
          ],
        )
        .where((e) => e.isNotEmpty)
        .toList();

    if (values.isEmpty && strict) {
      throw InvalidHeaderValueException(
        "Header '$key' is present but contains only empty values.",
      );
    }

    return values.isEmpty ? null : values;
  }

  /// Parses a URI from the header value associated with [key].
  ///
  /// - Returns a valid `Uri` if the header value contains a valid absolute URI.
  /// - Returns `null` if the value is invalid or empty.
  /// - Throws an [InvalidHeaderValueException] if `strict` is `true` and the URI is invalid.
  ///
  /// [strict] determines whether an exception is thrown for invalid URIs.
  Uri? parseUri(
    String key, {
    required bool strict,
  }) {
    var value = parseSingleValue(key, strict: strict);
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);

    if (uri == null && strict) {
      throw InvalidHeaderValueException(
        "Header '$key' contains an invalid URI: $value.",
      );
    }

    return uri;
  }

  /// Parses a date from the header value associated with [key].
  ///
  /// - Returns a valid `DateTime` if the header value contains a valid date.
  /// - Throws an [InvalidHeaderValueException] if the date is invalid, regardless of the `strict` flag.
  DateTime? parseDate(
    String key, {
    required bool strict,
  }) {
    var singleValue = value(key);
    if (singleValue == null) return null;

    try {
      return parseHttpDate(singleValue);
    } catch (e) {
      throw InvalidHeaderValueException(
        "Header '$key' contains an invalid date: $singleValue.",
      );
    }
  }

  /// Parses an integer from the header value associated with [key].
  ///
  /// - Returns a valid `int` if the header value contains a valid integer.
  /// - Throws an [InvalidHeaderValueException] if `strict` is `true` and the integer is invalid.
  ///
  /// [strict] determines whether an exception is thrown for invalid integers.
  int? parseInt(
    String key, {
    required bool strict,
  }) {
    var singleValue = value(key);
    if (singleValue == null) return null;

    final parsedInt = int.tryParse(singleValue);

    if (parsedInt == null && strict) {
      throw InvalidHeaderValueException(
        "Header '$key' contains an invalid integer: $singleValue.",
      );
    }
    return parsedInt;
  }

  /// Parses a boolean from the header value associated with [key].
  ///
  /// - Returns a valid `bool` if the header value contains a valid boolean.
  /// - Throws an [InvalidHeaderValueException] if `strict` is `true` and the boolean is invalid.
  ///
  /// [strict] determines whether an exception is thrown for invalid booleans.
  bool? parseBool(
    String key, {
    required bool strict,
  }) {
    var singleValue = value(key);
    if (singleValue == null) return null;

    final parsedBool = bool.tryParse(singleValue);

    if (parsedBool == null && strict) {
      throw InvalidHeaderValueException(
        "Header '$key' contains an invalid boolean: $singleValue.",
      );
    }
    return parsedBool;
  }
}
