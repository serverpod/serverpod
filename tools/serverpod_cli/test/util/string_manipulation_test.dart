import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a string without the separator token then the result is a list with only the string as the first entry.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes('example');
    expect(result, ['example']);
  });

  test(
      'Given a string with one separator token then the result contains both the strings.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes('example,string');
    expect(result, ['example', 'string']);
  });

  test(
      'Given a string that ends with the separator token then the result contains one entry.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes('example,');
    expect(result, ['example']);
  });

  test(
      'Given a string with the separator token within angle brackets then the string is not split.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes('Map<String, String>');
    expect(result, ['Map<String, String>']);
  });

  test(
      'Given a string with the separator token within parenthesis brackets the string is not split.',
      () {
    var result =
        splitIgnoringBracketsAndBracesAndQuotes('method(String, String)');
    expect(result, ['method(String, String)']);
  });

  test(
      'Given string with the separator token within nested brackets then the string is not split.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes(
      'method(Map<String, Map<String, List<int>>>, String)',
    );
    expect(result, ['method(Map<String, Map<String, List<int>>>, String)']);
  });

  test(
      'Given a string with the separator token both in nested brackets and outside then the string is only split on the tokens outside the brackets.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes(
      'method(Map<String, Map<String, List<int>>>, String), String',
    );

    expect(result, [
      'method(Map<String, Map<String, List<int>>>, String)',
      'String',
    ]);
  });

  test(
      'Given a string with the separator token both in nested braces and outside then the string is only split on the tokens outside the braces.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes(
      'int a, {bool x, bool y}',
    );

    expect(result, [
      'int a',
      '{bool x, bool y}',
    ]);
  });

  test(
      'Given a string with a custom separator token when splitting with that separator token then the string is split.',
      () {
    var result = splitIgnoringBracketsAndBracesAndQuotes(
      'String; String',
      separator: ';',
    );

    expect(result, [
      'String',
      'String',
    ]);
  });

  group('Given a string with single quotes', () {
    test('when splitting then it is recognized as a single token.', () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This is a default value\'',
        'controlToken',
      ]);
    });

    test(
        'with single double quote when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This \"is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This "is a default value\'',
        'controlToken',
      ]);
    });

    test(
        'with single escaped double quote when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This \\\"is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This \\"is a default value\'',
        'controlToken',
      ]);
    });

    test(
        'with single escaped single quote when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This \\'is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This \\\'is a default value\'',
        'controlToken',
      ]);
    });

    test('with a comma when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This ,is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This ,is a default value\'',
        'controlToken',
      ]);
    });

    test(
        'with angle brackets "<" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This <is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This <is a default value\'',
        'controlToken',
      ]);
    });

    test(
        'with angle brackets ">" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This >is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This >is a default value\'',
        'controlToken',
      ]);
    });

    test(
        'with parentheses "(" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This (is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This (is a default value\'',
        'controlToken',
      ]);
    });

    test(
        'with parentheses ")" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        "controlToken, 'This )is a default value', controlToken",
      );
      expect(result, [
        'controlToken',
        '\'This )is a default value\'',
        'controlToken',
      ]);
    });
  });

  group('Given a string with double quotes', () {
    test('when splitting then it is recognized as a single token.', () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This is a default value"',
        'controlToken',
      ]);
    });

    test(
        'with a single single quote when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This \'is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This \'is a default value"',
        'controlToken',
      ]);
    });

    test(
        'with a single escaped single quote when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This \\\'is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This \\\'is a default value"',
        'controlToken',
      ]);
    });

    test(
        'with a single escaped double quote when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This \\"is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This \\"is a default value"',
        'controlToken',
      ]);
    });

    test('with a comma when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This ,is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This ,is a default value"',
        'controlToken',
      ]);
    });

    test(
        'with angle brackets "<" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This <is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This <is a default value"',
        'controlToken',
      ]);
    });

    test(
        'with angle brackets ">" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This >is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This >is a default value"',
        'controlToken',
      ]);
    });

    test(
        'with parentheses "(" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This (is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This (is a default value"',
        'controlToken',
      ]);
    });

    test(
        'with parentheses ")" when splitting then it is recognized as a single token.',
        () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'controlToken, "This )is a default value", controlToken',
      );
      expect(result, [
        'controlToken',
        '"This )is a default value"',
        'controlToken',
      ]);
    });
  });
}
