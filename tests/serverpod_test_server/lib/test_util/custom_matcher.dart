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
