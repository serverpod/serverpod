import 'dart:io' as io;

import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/custom/custom_headers.dart';
import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/method/request_method.dart';

/// Parses a URI from the given [value] and returns it as a `Uri`.
///
/// - Throws a [FormatException] if the [value] is empty or contains an invalid URI.
Uri parseUri(String value) {
  if (value.isEmpty) {
    throw FormatException('Value cannot be empty');
  }

  try {
    return Uri.parse(value);
  } catch (e) {
    throw FormatException('Invalid URI format');
  }
}

/// Parses a date from the given [value] and returns it as a `DateTime`.
///
/// - Throws a [FormatException] if the [value] is empty or contains an invalid date.
DateTime parseDate(String value) {
  if (value.isEmpty) {
    throw FormatException('Value cannot be empty');
  }
  try {
    return parseHttpDate(value);
  } catch (e) {
    throw FormatException('Invalid date format');
  }
}

/// Parses an integer from the given [value] and returns it as an `int`.
///
/// - Throws a [FormatException] if the [value] is empty, contains an invalid number, or is not an integer.
int parseInt(String value) {
  if (value.isEmpty) {
    throw FormatException('Value cannot be empty');
  }

  num parsedValue;
  try {
    parsedValue = num.parse(value);
  } catch (e) {
    throw FormatException('Invalid number');
  }

  if (parsedValue is! int) {
    throw FormatException('Must be an integer');
  }

  return parsedValue;
}

/// Parses a positive integer from the given [value] and returns it as an `int`.
///
/// - Throws a [FormatException] if the [value] is empty, contains an invalid number, is negative, or is not an integer.
int parsePositiveInt(String value) {
  if (value.isEmpty) {
    throw FormatException('Value cannot be empty');
  }
  num parsedValue;
  try {
    parsedValue = num.parse(value);
  } catch (e) {
    throw FormatException('Invalid number');
  }

  if (parsedValue.isNegative) {
    throw FormatException('Must be non-negative');
  }

  if (parsedValue is! int) {
    throw FormatException('Must be an integer');
  }

  return parsedValue;
}

/// Parses a boolean from the given [value] and returns it as a `bool`.
///
/// - Throws a [FormatException] if the [value] is empty or contains an invalid boolean.
bool parseBool(String value) {
  if (value.isEmpty) {
    throw FormatException('Value cannot be empty');
  }
  try {
    return bool.parse(value);
  } catch (e) {
    throw FormatException('Invalid boolean');
  }
}

/// Parses a positive boolean from the given [value] and returns it as a `bool`.
///
/// - Throws a [FormatException] if the [value] is 'empty', 'false' or contains an invalid boolean.
bool parsePositiveBool(String value) {
  if (value.isEmpty) {
    throw FormatException('Value cannot be empty');
  }

  bool parsedValue;

  try {
    parsedValue = bool.parse(value);
  } catch (e) {
    throw FormatException('Invalid boolean');
  }

  if (!parsedValue) {
    throw FormatException('Must be true or null');
  }

  return parsedValue;
}

/// Parses a string from the given [value] and returns it as a `String`.
///
/// - Throws a [FormatException] if the [value] is empty.
String parseString(String value) {
  if (value.isEmpty) {
    throw FormatException('Value cannot be empty');
  }
  return value.trim();
}

/// Parses a list of strings from the given [values] and returns it as a `List<String>`.
///
/// - Throws a [FormatException] if the resulting list is empty.
List<String> parseStringList(List<String> values) {
  var tempValues = values.splitTrimAndFilterUnique();
  if (tempValues.isEmpty) {
    throw FormatException('Value cannot be empty');
  }
  return tempValues;
}

/// Parses a list of methods from the given [values] and returns it as a `List<Method>`.
///
/// - Throws a [FormatException] if the resulting list is empty.
List<RequestMethod> parseMethodList(List<String> values) {
  var tempValues = values.splitTrimAndFilterUnique(emptyCheck: false);
  if (tempValues.isEmpty) {
    throw FormatException('Value cannot be empty');
  }
  return tempValues.map(RequestMethod.parse).toList();
}

/// Parses custom headers from the [headers] and returns them as a [CustomHeaders] instance.
///
/// - Excludes headers specified in [excludedHeaders].
/// - Returns an empty [CustomHeaders] if no valid headers are found.
CustomHeaders parseCustomHeaders(
  io.HttpHeaders headers, {
  Set<String> excludedHeaders = const {},
}) {
  var custom = <MapEntry<String, List<String>>>[];

  headers.forEach((name, values) {
    if (excludedHeaders.contains(name.toLowerCase())) {
      return;
    }

    custom.add(MapEntry(
      name,
      values.fold(
        [],
        (a, b) => [
          ...a,
          ...b.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty)
        ],
      ),
    ));
  });

  if (custom.isEmpty) return CustomHeaders.empty();

  return CustomHeaders.fromEntries(custom);
}
