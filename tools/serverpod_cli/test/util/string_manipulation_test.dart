import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a string without the separator token then the result is a list with only the string as the first entry.',
      () {
    var result = splitIgnoringBrackets('example');
    expect(result, ['example']);
  });

  test(
      'Given a string with one separator token then the result contains both the strings.',
      () {
    var result = splitIgnoringBrackets('example,string');
    expect(result, ['example', 'string']);
  });

  test(
      'Given a string that ends with the separator token then the result contains one entry.',
      () {
    var result = splitIgnoringBrackets('example,');
    expect(result, ['example']);
  });

  test(
      'Given a string with the separator token within angle brackets then the string is not split.',
      () {
    var result = splitIgnoringBrackets('Map<String, String>');
    expect(result, ['Map<String, String>']);
  });

  test(
      'Given a string with the separator token within parenthesis brackets the string is not split.',
      () {
    var result = splitIgnoringBrackets('method(String, String)');
    expect(result, ['method(String, String)']);
  });

  test(
      'Given string with the separator token within nested brackets then the string is not split.',
      () {
    var result = splitIgnoringBrackets(
      'method(Map<String, Map<String, List<int>>>, String)',
    );
    expect(result, ['method(Map<String, Map<String, List<int>>>, String)']);
  });

  test(
      'Given a string with the separator token both in nested brackets and outside then the string is only split on the tokens outside the brackets.',
      () {
    var result = splitIgnoringBrackets(
      'method(Map<String, Map<String, List<int>>>, String), String',
    );

    expect(result, [
      'method(Map<String, Map<String, List<int>>>, String)',
      'String',
    ]);
  });

  test(
      'Given a string with a custom separator token when splitting with that separator token then the string is split.',
      () {
    var result = splitIgnoringBrackets(
      'String; String',
      separator: ';',
    );

    expect(result, [
      'String',
      'String',
    ]);
  });
}
