import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a string without the separator token then the result is a list with only the string as the first entry.',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes('example');
      expect(result, ['example']);
    },
  );

  test(
    'Given a string with one separator token then the result contains both the strings.',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes('example,string');
      expect(result, ['example', 'string']);
    },
  );

  test(
    'Given a string that ends with the separator token then the result contains one entry.',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes('example,');
      expect(result, ['example']);
    },
  );

  test(
    'Given a string with the separator token within angle brackets then the string is not split.',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'Map<String, String>',
      );
      expect(result, ['Map<String, String>']);
    },
  );

  test(
    'Given a string with the separator token within parenthesis brackets the string is not split.',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'method(String, String)',
      );
      expect(result, ['method(String, String)']);
    },
  );

  test(
    'Given string with the separator token within nested brackets then the string is not split.',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        'method(Map<String, Map<String, List<int>>>, String)',
      );
      expect(result, ['method(Map<String, Map<String, List<int>>>, String)']);
    },
  );

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
    },
  );

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
    },
  );

  test(
    'Given a string where some separators are right next to each other when it is split with returnEmptyParts=true then the empty parts are returned',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes(
        ',,',
        returnEmptyParts: true,
      );

      expect(result, [
        '',
        '',
        '',
      ]);
    },
  );

  test(
    'Given a string where some separators are right next to each other when it is split with returnEmptyParts=false then no empty parts are returned',
    () {
      var result = splitIgnoringBracketsAndBracesAndQuotes('a,,');

      expect(result, ['a']);
    },
  );

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
    },
  );

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
      },
    );

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
      },
    );

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
      },
    );

    test(
      'with a comma when splitting then it is recognized as a single token.',
      () {
        var result = splitIgnoringBracketsAndBracesAndQuotes(
          "controlToken, 'This ,is a default value', controlToken",
        );
        expect(result, [
          'controlToken',
          '\'This ,is a default value\'',
          'controlToken',
        ]);
      },
    );

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
      },
    );

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
      },
    );

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
      },
    );

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
      },
    );
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
      },
    );

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
      },
    );

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
      },
    );

    test(
      'with a comma when splitting then it is recognized as a single token.',
      () {
        var result = splitIgnoringBracketsAndBracesAndQuotes(
          'controlToken, "This ,is a default value", controlToken',
        );
        expect(result, [
          'controlToken',
          '"This ,is a default value"',
          'controlToken',
        ]);
      },
    );

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
      },
    );

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
      },
    );

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
      },
    );

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
      },
    );
  });

  group('stripDocumentationTemplateMarkers', () {
    test(
      'Given documentation with {@template} and {@endtemplate} markers then they are removed.',
      () {
        var input = '''/// {@template example.method}
/// This is a method
/// {@endtemplate}''';
        var result = stripDocumentationTemplateMarkers(input);
        expect(result, '''/// This is a method''');
      },
    );

    test(
      'Given documentation with only {@template} marker then it is removed.',
      () {
        var input = '''/// {@template example.method}
/// This is a method''';
        var result = stripDocumentationTemplateMarkers(input);
        expect(result, '''/// This is a method''');
      },
    );

    test(
      'Given documentation with only {@endtemplate} marker then it is removed.',
      () {
        var input = '''/// This is a method
/// {@endtemplate}''';
        var result = stripDocumentationTemplateMarkers(input);
        expect(result, '''/// This is a method''');
      },
    );

    test(
      'Given documentation with template markers and multiple paragraphs then markers are removed and content is preserved.',
      () {
        var input =
            '''/// {@template email_account_base_endpoint.start_registration}
/// Starts the registration for a new user account with an email-based login
/// associated to it.
///
/// Upon successful completion of this method, an email will have been
/// sent to [email] with a verification link, which the user must open to
/// complete the registration.
///
/// Always returns a account request ID, which can be used to complete the
/// registration. If the email is already registered, the returned ID will not
/// be valid.
/// {@endtemplate}''';
        var result = stripDocumentationTemplateMarkers(input);
        expect(
          result,
          '''/// Starts the registration for a new user account with an email-based login
/// associated to it.
///
/// Upon successful completion of this method, an email will have been
/// sent to [email] with a verification link, which the user must open to
/// complete the registration.
///
/// Always returns a account request ID, which can be used to complete the
/// registration. If the email is already registered, the returned ID will not
/// be valid.''',
        );
      },
    );

    test('Given null documentation then returns null.', () {
      var result = stripDocumentationTemplateMarkers(null);
      expect(result, null);
    });

    test('Given empty documentation then returns empty.', () {
      var result = stripDocumentationTemplateMarkers('');
      expect(result, '');
    });

    test(
      'Given documentation without template markers then it is returned unchanged.',
      () {
        var input = '''/// This is a method
/// with multiple lines''';
        var result = stripDocumentationTemplateMarkers(input);
        expect(result, input);
      },
    );

    test(
      'Given documentation that is only template markers then returns null.',
      () {
        var input = '''/// {@template example.method}
/// {@endtemplate}''';
        var result = stripDocumentationTemplateMarkers(input);
        expect(result, null);
      },
    );
  });
}
