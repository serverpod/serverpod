import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group(
    'Given compilation unit with class with constructor without field initializer',
    () {
      late final compilationUnit = parseCode(
        '''
      class User {
        User();
      }
    ''',
      );

      test('when negate matching field initializer then test passes', () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withUnnamedConstructor().withFieldInitializer('name'),
          ),
        );
      });
    },
  );

  group(
    'Given compilation unit with class with constructor with field initializer',
    () {
      late final compilationUnit = parseCode(
        '''
      class User {
        final String name;
        User() : name = "John";
      }
    ''',
      );

      test('when matching field initializer then test passes', () {
        expect(
          compilationUnit,
          containsClass(
            'User',
          ).withUnnamedConstructor().withFieldInitializer('name'),
        );
      });

      test('when negate matching wrong initializer then test passes', () {
        expect(
          compilationUnit,
          isNot(
            containsClass('User').withUnnamedConstructor().withFieldInitializer(
              'invalidInitializer',
            ),
          ),
        );
      });

      test(
        'when matching field initializer then mismatch description is correct',
        () {
          final matcher =
              containsClass(
                    'User',
                  ).withUnnamedConstructor().withFieldInitializer('wrongName')
                  as Matcher;
          final description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals(
              'does not have a field initializer for "wrongName". Found initializers: [name]',
            ),
          );
        },
      );
    },
  );

  test(
    'Given field initializer matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass(
                'User',
              ).withUnnamedConstructor().withFieldInitializer('name')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" with an unnamed constructor with field initializer for "name"',
        ),
      );
    },
  );
}
