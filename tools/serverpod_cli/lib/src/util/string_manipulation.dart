import 'package:super_string/super_string.dart';

/// Splits a string on the separator token unless the token is inside
/// brackets or angle brackets, ( ) and < >.
List<String> splitIgnoringBrackets(
  String input, {
  String separator = ',',
}) {
  List<String> result = [];
  StringBuffer current = StringBuffer();
  int depth = 0;

  for (var char in input.iterable) {
    if (char == separator && depth == 0) {
      result.add(current.toString().trim());
      current.clear();
    } else {
      current.write(char);
      if (char == '<' || char == '(') {
        depth++;
      } else if (char == '>' || char == ')') {
        depth--;
      }
    }
  }

  if (current.isNotEmpty) {
    result.add(current.toString().trim());
  }

  return result;
}
