import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a mixed-case string, '
    'when it is capitalized, '
    'then only its first character is uppercase.',
    () {
      expect('hELLO'.capitalize(), 'Hello');
    },
  );

  test(
    'Given a string containing a multi-byte character, '
    'when its characters are iterated, '
    'then the character remains a single entry.',
    () {
      expect('AçB'.iterable, ['A', 'ç', 'B']);
    },
  );

  test(
    'Given a string containing repeated tokens, '
    'when occurrences within a substring are counted, '
    'then only occurrences within that substring are returned.',
    () {
      expect('banana'.count('a', 2, 6), 2);
    },
  );

  test(
    'Given words separated by spaces and underscores, '
    'when they are converted to upper camel case, '
    'then separators are removed and each word is capitalized.',
    () {
      expect('hello world_dart'.toCamelCase(), 'HelloWorldDart');
    },
  );

  test(
    'Given words separated by spaces and underscores, '
    'when they are converted to lower camel case, '
    'then the first word is lowercase and later words are capitalized.',
    () {
      expect(
        'Hello world_dart'.toCamelCase(isLowerCamelCase: true),
        'helloWorldDart',
      );
    },
  );

  test(
    'Given a string and candidate values, '
    'when at least one candidate is contained in the string, '
    'then containment succeeds.',
    () {
      expect('This is Serverpod'.containsAny(['Flutter', 'Serverpod']), isTrue);
    },
  );

  test(
    'Given a mixed-case database type with several words, '
    'when it is converted to lower camel case, '
    'then the first word is lowercase and later words are capitalized.',
    () {
      expect(
        databaseTypeToLowerCamelCase('TIMESTAMP WITHOUT TIME ZONE'),
        'timestampWithoutTimeZone',
      );
    },
  );
}
