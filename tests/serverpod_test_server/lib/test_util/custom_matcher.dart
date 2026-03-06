import 'package:test/test.dart';

Matcher containsCount(String substring, int expectedCount) {
  return predicate((String mainString) {
    int count = 0;
    int index = mainString.indexOf(substring);
    while (index != -1) {
      count++;
      index = mainString.indexOf(substring, index + substring.length);
    }
    return count == expectedCount;
  }, 'contains $expectedCount occurrences of "$substring"');
}

/// Returns a matcher that checks if a value
/// does not match the regular expression given by [regexp].
Matcher notMatches(Pattern regexp) {
  return predicate((value) {
    return regexp.allMatches(value.toString()).isEmpty;
  });
}
