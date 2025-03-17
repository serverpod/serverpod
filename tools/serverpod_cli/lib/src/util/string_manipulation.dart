import 'package:super_string/super_string.dart';

/// Splits a string on the separator token unless the token is inside
/// brackets, angle brackets, ( ) and < >, curly braces, { }, single quotes '', or double quotes "".
List<String> splitIgnoringBracketsAndBracesAndQuotes(
  String input, {
  String separator = ',',
  bool includeEmpty = false,
}) {
  List<String> result = [];
  StringBuffer current = StringBuffer();
  int depth = 0;

  bool insideSingleQuote = false;
  bool insideDoubleQuote = false;

  for (var (index, char) in input.iterable.indexed) {
    if (char == separator && depth == 0) {
      result.add(current.toString().trim());
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

  if (current.toString().trim().isNotEmpty || includeEmpty) {
    result.add(current.toString().trim());
  }

  return result;
}
