/// Regular expression pattern that matches a string entirely enclosed
/// in double quotes, allowing for escaped characters inside.
///
/// Example Matches:
/// - `"Hello, world!"`
/// - `"This is a \"quoted\" string"`
/// - `"Another example with \\backslashes\\"`
const fullDoubleQuotedStringPattern = r'^"(\\.|[^"\\])*"$';

/// Regular expression pattern that matches a string entirely enclosed
/// in single quotes, allowing for escaped characters inside.
///
/// Example Matches:
/// - `'Hello, world!'`
/// - `'This is a \'quoted\' string'`
/// - `'Another example with \\backslashes\\'`
const fullSingleQuotedStringPattern = r"^'(\\.|[^'\\])*'$";

/// Regular expression pattern that captures the content of a double-quoted
/// string, accounting for escaped characters, for replacement purposes.
///
/// Example Captures:
/// - `"Hello, world!"` -> `Hello, world!`
/// - `"This is a \"quoted\" string"` -> `This is a \"quoted\" string`
/// - `"Another example with \\backslashes\\"` -> `Another example with \\backslashes\\`
const doubleQuotedStringCapturePattern = r'"([^"\\]*(?:\\.[^"\\]*)*)"';

/// Checks if the given value is a string that is entirely enclosed
/// in double quotes, using the fullDoubleQuotedStringPattern.
///
/// Example:
/// - Input: `"Hello, world!"`
/// - Returns: `true`
///
/// - Input: `Hello, world!`
/// - Returns: `false`
bool isValidDoubleQuote(dynamic value) {
  if (value is! String) return false;
  return RegExp(fullDoubleQuotedStringPattern).hasMatch(value);
}

/// Checks if the given value is a string that is entirely enclosed
/// in single quotes, using the fullSingleQuotedStringPattern.
///
/// Example:
/// - Input: `'Hello, world!'`
/// - Returns: `true`
///
/// - Input: `Hello, world!`
/// - Returns: `false`
bool isValidSingleQuote(dynamic value) {
  if (value is! String) return false;
  return RegExp(fullSingleQuotedStringPattern).hasMatch(value);
}

/// Converts a double-quoted string to a single-quoted string, ensuring that
/// any existing single quotes inside the string are properly escaped.
///
/// Example:
/// - Input: `"Hello, world!"`
/// - Output: `'Hello, world!'`
///
/// - Input: `"It's a \"beautiful\" day"`
/// - Output: `'It\'s a "beautiful" day'`
String convertToSingleQuotedString(String value) {
  return value.replaceAllMapped(
    RegExp(doubleQuotedStringCapturePattern),
    (match) {
      /// Extracts the content inside the double quotes.
      String content = match.group(1)!;

      /// Escapes any single quotes within the content.
      content = content.replaceAll("'", r"\'");

      /// Returns the content enclosed in single quotes.
      return "'$content'";
    },
  );
}

/// Converts a Dart string into a SQL-safe string by escaping necessary characters.
///
/// This method handles:
/// - Escaping single quotes (`'`) to prevent SQL injection and syntax errors.
/// - Handling escaped double quotes (`"`), ensuring they are correctly represented in SQL by doubling them.
///
/// The method performs validation to ensure the string contains valid quoting.
///
/// ### Examples:
/// ```dart
/// _escapeSqlString("This is a \'default persist value")  // Returns "This is a ''default persist value"
/// _escapeSqlString("This is a \"default\" persist value") // Returns "This is a ""default"" persist value"
/// ```
///
/// Throws:
/// - `FormatException` if the string contains invalid quoting.
String escapeSqlString(String value) {
  if (isValidSingleQuote(value)) {
    return value.replaceAll("\\'", "''").replaceAll('\\"', '"');
  }

  if (isValidDoubleQuote(value)) {
    return value.replaceAll("\\'", "'").replaceAll('\\"', '""');
  }

  /// This exception is unlikely to be thrown due to prior validation checks,
  /// but it's included as a safeguard to handle any unexpected input.
  throw FormatException(
    'The string contains invalid quoting or escape sequences: $value',
  );
}
