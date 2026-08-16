import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given empty string', () {
    const actual = '';
    test('when negate matching with class then test passes', () {
      expect(actual, isNot(containsClass('User')));
    });

    test('when matching with class then mismatch description is correct', () {
      final matcher = containsClass('User') as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(actual, description, {}, false);

      expect(
        description.toString(),
        equals('"String" is not a CompilationUnit'),
      );
    });
  });

  test(
    'Given empty compilation unit when negate matching with class name then test passes',
    () {
      late final compilationUnit = parseCode('');

      expect(
        compilationUnit,
        isNot(containsClass('User')),
      );
    },
  );

  group('Given compilation unit with class', () {
    late final compilationUnit = parseCode(
      '''
      class User {}
      ''',
    );

    test('when matching with class name then test passes', () {
      expect(
        compilationUnit,
        containsClass('User'),
      );
    });

    test(
      'when negate matching with non-existent class name then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('NonExistentClass')),
        );
      },
    );

    test(
      'when matching with non-existent class name then mismatch description is correct',
      () {
        final matcher = containsClass('NonExistentClass') as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not contain class "NonExistentClass". Found classes: [User]',
          ),
        );
      },
    );
  });

  test(
    'Given class matcher matching "User" when fetching description then description reflects matcher requirements',
    () {
      final matcher = containsClass('User') as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals('a CompilationUnit containing class "User"'),
      );
    },
  );

  test(
    'Given class and named constructor matcher when matching on empty name then exception is thrown',
    () {
      expect(
        () => containsClass('User').withNamedConstructor(''),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            equals('constructorName cannot be empty'),
          ),
        ),
      );
    },
  );
}
