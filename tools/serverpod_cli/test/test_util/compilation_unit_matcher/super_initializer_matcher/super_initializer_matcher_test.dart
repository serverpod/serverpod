import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group(
    'Given compilation unit with class with constructor without initializer',
    () {
      late final compilationUnit = parseCode(
        '''
      class User {
        User();
      }
    ''',
      );

      test('when negate matching class and initializer then test passes', () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withUnnamedConstructor().withSuperInitializer(),
          ),
        );
      });
    },
  );

  group(
    'Given compilation unit with class with constructor with super initializer',
    () {
      late final compilationUnit = parseCode(
        '''
      class Super {
        Super();
      }

      class User extends Super {
        User() : super();
      }
    ''',
      );

      test(
        'when matching class, constructor and super initializer then test passes',
        () {
          expect(
            compilationUnit,
            containsClass(
              'User',
            ).withUnnamedConstructor().withSuperInitializer(),
          );
        },
      );
    },
  );

  group(
    'Given compilation unit with class with constructor with local initializer',
    () {
      late final compilationUnit = parseCode(
        '''
      class User {
        final String _name;
        User(String name) : _name = name;
      }
    ''',
      );

      test(
        'when negate matching class, constructor and super initializer then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass(
                'User',
              ).withUnnamedConstructor().withSuperInitializer(),
            ),
          );
        },
      );

      test(
        'when matching class, constructor and super initializer then mismatch description is correct',
        () {
          final matcher =
              containsClass(
                    'User',
                  ).withUnnamedConstructor().withSuperInitializer()
                  as Matcher;
          final description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals('does not have a super initializer'),
          );
        },
      );
    },
  );

  test(
    'Given super initializer matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withUnnamedConstructor().withSuperInitializer()
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" with an unnamed constructor with a super initializer',
        ),
      );
    },
  );
}
