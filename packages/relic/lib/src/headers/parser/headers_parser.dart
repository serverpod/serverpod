import 'dart:io';
import 'package:relic/src/headers/exception/invalid_header_exception.dart';

/// A class responsible for parsing HTTP headers.
///
/// This class provides methods to parse various types of header values,
/// including single values and multiple values.
class HeadersParser {
  final HttpHeaders headers;
  final bool strict;
  final void Function(String, List<String>) onHeaderFailedToParse;

  HeadersParser({
    required this.headers,
    required this.strict,
    required this.onHeaderFailedToParse,
  });

  /// Parses a single header value associated with [key] and returns it as type
  /// [T], or `null` if no value is found.
  ///
  /// - If the header has multiple values, returns the first one.
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but has an unexpected or invalid value.
  T? parseSingleValue<T>(
    String key, {
    required T? Function(String) onParse,
  }) {
    var singleValue = headers.value(key);

    if (singleValue != null) {
      try {
        return onParse(singleValue);
      } catch (e) {
        if (!strict) {
          onHeaderFailedToParse(key, [singleValue]);
          return null;
        }

        _throwException(e, key: key);
      }
    }

    var multiValues = headers[key];
    if (multiValues == null) return null;

    singleValue = multiValues.firstOrNull;

    if (singleValue != null && multiValues.length == 1) {
      try {
        return onParse(multiValues.first);
      } catch (e) {
        if (!strict) {
          onHeaderFailedToParse(key, multiValues);
          return null;
        }

        _throwException(e, key: key);
      }
    }

    if (strict) {
      throw InvalidHeaderException(
        "Multiple values are not allowed",
        headerType: key,
      );
    }

    if (singleValue == null) return null;

    try {
      return onParse(singleValue);
    } catch (e) {
      onHeaderFailedToParse(key, multiValues);
      return null;
    }
  }

  /// Parses multiple header values associated with [key] and returns them as
  /// type [T], or `null` if no values are found.
  ///
  /// - Splits each value by commas and trims whitespace.
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but contains only empty or invalid values.
  T? parseMultipleValue<T>(
    String key, {
    required T? Function(List<String>) onParse,
  }) {
    List<String>? multiValues = headers[key];
    if (multiValues == null) return null;

    try {
      return onParse(multiValues);
    } catch (e) {
      if (!strict) {
        onHeaderFailedToParse(key, multiValues);
        return null;
      }

      _throwException(e, key: key);
    }
  }

  /// Throws an [InvalidHeaderException] with the appropriate message based on
  /// the type of the given [exception].
  ///
  /// This function extracts the message from the given [exception] and throws
  /// an [InvalidHeaderException] with the extracted message and the specified
  /// [key] as the header type.
  ///
  /// - [exception]: The exception object from which to extract the message.
  /// - [key]: The header type associated with the exception.
  ///
  /// Throws:
  /// - [InvalidHeaderException]: Always thrown with the extracted message and
  /// the specified header type.
  Never _throwException(
    Object exception, {
    required String key,
  }) {
    var message = "$exception";
    if (exception is InvalidHeaderException) {
      message = exception.message;
    } else if (exception is FormatException) {
      message = exception.message;
    } else if (exception is ArgumentError) {
      message = exception.message;
    }

    throw InvalidHeaderException(
      message,
      headerType: key,
    );
  }
}
