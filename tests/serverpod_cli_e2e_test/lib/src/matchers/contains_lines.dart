import 'package:test/test.dart';

/// Matches a string that contains all [substrings] on separate lines, in order.
Matcher containsLines(List<String> substrings) => _ContainsLines(substrings);

class _ContainsLines extends Matcher {
  final List<String> substrings;

  _ContainsLines(this.substrings);

  @override
  bool matches(Object? item, Map matchState) {
    if (item is! String) return false;
    final lines = item.split('\n');
    var lineIndex = 0;
    for (final substring in substrings) {
      while (lineIndex < lines.length) {
        if (lines[lineIndex].contains(substring)) {
          lineIndex++;
          break;
        }
        lineIndex++;
      }
      if (lineIndex > lines.length) return false;
    }
    return true;
  }

  @override
  Description describe(Description description) =>
      description.add('contains lines with ').addDescriptionOf(substrings);

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! String) {
      return mismatchDescription.add('is not a string');
    }
    return mismatchDescription.add('does not contain all substrings in order');
  }
}
