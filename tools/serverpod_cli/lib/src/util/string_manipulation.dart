import 'package:super_string/super_string.dart';

/// Splits a string on the separator token unless the token is inside
/// brackets, angle brackets, ( ) and < >, curly braces, { }, single quotes '', or double quotes "".
List<String> splitIgnoringBracketsAndBracesAndQuotes(
  String input, {
  String separator = ',',
  bool returnEmptyParts = false,
}) {
  List<String> result = [];
  StringBuffer current = StringBuffer();
  int depth = 0;

  bool insideSingleQuote = false;
  bool insideDoubleQuote = false;

  for (var (index, char) in input.iterable.indexed) {
    if (char == separator && depth == 0) {
      var trimmed = current.toString().trim();
      if (trimmed.isNotEmpty || returnEmptyParts) {
        result.add(trimmed);
      }
      current.clear();
    } else {
      current.write(char);

      /// When inside quotes we ignore all depth modification until matching end quote is found.
      if (insideDoubleQuote || insideSingleQuote) {
        var isEscaped = index > 0 && input[index - 1] == '\\';

        if (insideDoubleQuote && char == '"' && !isEscaped) {
          /// If inside "" and non escaped " is found, only descrease depth and switch bool value
          depth--;
          insideDoubleQuote = false;
        } else if (insideSingleQuote && char == '\'' && !isEscaped) {
          /// If inside ' and non escaped ' is found, only descrease depth and switch bool value
          depth--;
          insideSingleQuote = false;
        }
      } else {
        if (char == '<' || char == '(' || char == '{') {
          depth++;
        } else if (char == '>' || char == ')' || char == '}') {
          depth--;
        } else if (char == '"') {
          depth++;
          insideDoubleQuote = true;
        } else if (char == '\'') {
          depth++;
          insideSingleQuote = true;
        }
      }
    }
  }

  var trimmed = current.toString().trim();
  if (trimmed.isNotEmpty || returnEmptyParts) {
    result.add(trimmed);
  }

  return result;
}

/// Removes {@template ...} and {@endtemplate} markers from documentation
/// comments, as they are only needed in source files for documentation
/// generation and should not appear in generated files.
///
/// Example:
/// ```dart
/// /// {@template example.method}
/// /// This is a method
/// /// {@endtemplate}
/// ```
/// becomes:
/// ```dart
/// /// This is a method
/// ```
String? stripDocumentationTemplateMarkers(String? documentation) {
  if (documentation == null || documentation.isEmpty) {
    return documentation;
  }

  // Regular expression to match {@template ...} lines and {@endtemplate} lines
  // Match the entire line including the comment markers (///)
  final templateMarkerPattern = RegExp(
    r'^\s*///\s*\{@template\s+[^}]+\}\s*$',
    multiLine: true,
  );
  final endTemplateMarkerPattern = RegExp(
    r'^\s*///\s*\{@endtemplate\}\s*$',
    multiLine: true,
  );

  var result = documentation;
  
  // Remove {@template ...} lines
  result = result.replaceAll(templateMarkerPattern, '');
  
  // Remove {@endtemplate} lines
  result = result.replaceAll(endTemplateMarkerPattern, '');
  
  // Clean up any resulting extra blank lines (more than one consecutive blank line)
  result = result.replaceAll(RegExp(r'(\n\s*\n)\s*\n+'), '\$1');
  
  // Trim leading/trailing whitespace
  result = result.trim();
  
  return result.isEmpty ? null : result;
}
