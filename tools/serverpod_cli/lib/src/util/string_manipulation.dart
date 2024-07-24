/// Splits a string on the separator token unless the token is inside
/// brackets, angle brackets, ( ) and < >, single quotes, or double quotes.
/// Handles nested brackets and skips separators within single (' ')
/// or double (" ") quotes.
List<String> splitIgnoringBrackets(
  String input, {
  String separator = ',',
}) {
  List<String> result = [];
  StringBuffer current = StringBuffer();
  int depth = 0;
  bool insideSingleQuotes = false;
  bool insideDoubleQuotes = false;

  for (int i = 0; i < input.length; i++) {
    var char = input[i];

    if (char == separator &&
        depth == 0 &&
        !insideSingleQuotes &&
        !insideDoubleQuotes) {
      result.add(current.toString().trim());
      current.clear();
    } else {
      current.write(char);
      if (char == '<' || char == '(') {
        depth++;
      } else if (char == '>' || char == ')') {
        depth--;
      } else if (char == "'" && !insideDoubleQuotes) {
        if (insideSingleQuotes) {
          // Check if it's an escaped single quote
          if (i > 0 && input[i - 1] == '\\') {
            continue;
          }
          insideSingleQuotes = false;
        } else {
          insideSingleQuotes = true;
        }
      } else if (char == '"' && !insideSingleQuotes) {
        if (insideDoubleQuotes) {
          // Check if it's an escaped double quote
          if (i > 0 && input[i - 1] == '\\') {
            continue;
          }
          insideDoubleQuotes = false;
        } else {
          insideDoubleQuotes = true;
        }
      }
    }
  }

  if (current.isNotEmpty) {
    result.add(current.toString().trim());
  }

  return result;
}
