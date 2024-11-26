import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/exception/invalid_header_exception.dart';
import 'package:relic/src/headers/extension/string_list_extensions.dart';

/// A class responsible for parsing HTTP headers.
///
/// This class provides methods to parse various types of header values,
/// including single values, multiple values, URIs, dates, integers, and
/// booleans.
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
    required T Function(String) onParse,
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
    required T Function(List<String>) onParse,
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

  /// Parses a URI from the header value associated with [key], or returns
  /// `null` if no valid URI is found.
  ///
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but contains an invalid URI.
  Uri? parseUri(String key) {
    return parseSingleValue(
      key,
      onParse: (value) {
        if (value.isEmpty) {
          throw FormatException('Value cannot be empty');
        }

        try {
          return Uri.parse(value);
        } catch (e) {
          throw FormatException('Invalid URI format');
        }
      },
    );
  }

  /// Parses a date from the header value associated with [key] and returns it
  /// as a `DateTime`, or `null` if no valid date is found.
  ///
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but contains an invalid date.
  DateTime? parseDate(String key) {
    return parseSingleValue(
      key,
      onParse: (value) {
        if (value.isEmpty) {
          throw FormatException('Value cannot be empty');
        }
        try {
          return parseHttpDate(value);
        } catch (e) {
          throw FormatException('Invalid date format');
        }
      },
    );
  }

  /// Parses an integer from the header value associated with [key] and returns
  /// it as an `int`, or `null` if no valid integer is found.
  ///
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but contains an invalid integer.
  int? parseInt(
    String key, {
    bool allowNegative = true,
  }) {
    return parseSingleValue(
      key,
      onParse: (value) {
        if (value.isEmpty) {
          throw FormatException('Value cannot be empty');
        }

        num parsedValue;
        try {
          parsedValue = num.parse(value);
        } catch (e) {
          throw FormatException('Invalid number');
        }

        if (!allowNegative && parsedValue < 0) {
          throw FormatException('Must be non-negative');
        }

        if (parsedValue is! int) {
          throw FormatException('Must be an integer');
        }

        return parsedValue;
      },
    );
  }

  /// Parses a boolean from the header value associated with [key] and returns
  /// it as a `bool`, or `null` if no valid boolean is found.
  ///
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but contains an invalid boolean.
  bool? parseBool(
    String key, {
    bool allowFalse = true,
  }) {
    return parseSingleValue(
      key,
      onParse: (value) {
        if (value.isEmpty) {
          throw FormatException('Value cannot be empty');
        }
        bool parsedValue = bool.parse(value);
        if (!allowFalse && !parsedValue) {
          throw FormatException('Must be true or null');
        }
        return parsedValue;
      },
    );
  }

  /// Parses a string from the header value associated with [key] and returns
  /// it as a `String`, or `null` if no valid string is found.
  ///
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but contains an empty string.
  String? parseString(String key) {
    return parseSingleValue(
      key,
      onParse: (value) {
        if (value.isEmpty) {
          throw FormatException('Value cannot be empty');
        }
        return value.trim();
      },
    );
  }

  /// Parses a list of strings from the header value associated with [key] and
  /// returns it as a `List<String>`, or `null` if no valid list is found.
  ///
  /// - Throws an [InvalidHeaderException] if `strict` is `true` and the header
  /// `key` is present but contains only empty values.
  List<String>? parseStringList(String key) {
    return parseMultipleValue(
      key,
      onParse: (values) {
        var tempValues = values.splitTrimAndFilterUnique();
        if (tempValues.isEmpty) {
          throw FormatException('Value cannot be empty');
        }
        return tempValues;
      },
    );
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
