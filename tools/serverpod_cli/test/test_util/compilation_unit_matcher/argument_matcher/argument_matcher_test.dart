import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group(
    'Given compilation unit with class with super initializer without arguments',
    () {
      late final compilationUnit = parseCode(
        '''
      class User extends Super {
        User(String name) : super();
      }
    ''',
      );

      test(
        'when negate matching class, constructor, super initializer and non-existent argument then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withArgument('nonExistentArgument'),
            ),
          );
        },
      );
    },
  );

  group(
    'Given compilation unit with class with super initializer with positional argument',
    () {
      late final compilationUnit = parseCode(
        '''
      class User extends Super {
        User(String name) : super(name);
      }
    ''',
      );

      test(
        'when matching class, constructor, super initializer and argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withArgument('name'),
          );
        },
      );

      test(
        'when matching class, constructor, super initializer and positional argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withPositionalArgument('name'),
          );
        },
      );

      test(
        'when negate matching class, constructor, super initializer and named argument then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withNamedArgument('name', 'name'),
            ),
          );
        },
      );
    },
  );

  group(
    'Given compilation unit with class with super initializer with argument for named parameter',
    () {
      late final compilationUnit = parseCode(
        '''
      class User extends Super {
        User(String name) : super(name: name);
      }
    ''',
      );

      test(
        'when matching class, constructor, super initializer and argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withArgument('name'),
          );
        },
      );

      test(
        'when matching class, constructor, super initializer and named argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withNamedArgument('name', 'name'),
          );
        },
      );

      test(
        'when negate matching class, constructor, super initializer and named argument with incorrect parameter name then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withNamedArgument('name', 'incorrect'),
            ),
          );
        },
      );

      test(
        'when negate matching class, constructor, super initializer and positional argument then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withPositionalArgument('name'),
            ),
          );
        },
      );
    },
  );

  group(
    'Given compilation unit with class with super initializer with same argument for multiple positional parameters',
    () {
      late final compilationUnit = parseCode(
        '''
      class User extends Super {
        User(String name) : super(name, name);
      }
    ''',
      );

      test(
        'when matching class, constructor, super initializer and argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withArgument('name'),
          );
        },
      );

      test(
        'when matching class, constructor, super initializer and positional argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withPositionalArgument('name'),
          );
        },
      );

      test(
        'when negate matching class, constructor, super initializer and named argument then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withNamedArgument('name', 'name'),
            ),
          );
        },
      );
    },
  );

  group(
    'Given compilation unit with class with super initializer with literal argument',
    () {
      late final compilationUnit = parseCode(
        '''
      class User extends Super {
        User() : super('name');
      }
    ''',
      );

      test(
        'when matching class, constructor, super initializer and argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withArgument("'name'"),
          );
        },
      );
    },
  );

  group(
    'Given compilation unit with class with super initializer with identifier argument',
    () {
      late final compilationUnit = parseCode(
        '''
      class User extends Super {
        User() : super(name);
      }
    ''',
      );
      test(
        'when matching class, constructor, super initializer and argument then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withSuperInitializer()
                .withArgument('name'),
          );
        },
      );
    },
  );

  group('Given compilation unit with class with field initializer with argument', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        final String name;
        User(String name) : name = name;
      }
    ''',
    );

    test(
      'when matching class, constructor, field initializer and argument then test passes',
      () {
        expect(
          compilationUnit,
          containsClass('User')
              .withUnnamedConstructor()
              .withFieldInitializer('name')
              .withArgument('name'),
        );
      },
    );

    test(
      'when matching class, constructor, field initializer and positional argument then test passes',
      () {
        expect(
          compilationUnit,
          containsClass('User')
              .withUnnamedConstructor()
              .withFieldInitializer('name')
              .withPositionalArgument('name'),
        );
      },
    );

    test(
      'when negate matching class, constructor, field initializer and named argument then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass('User')
                .withUnnamedConstructor()
                .withFieldInitializer('name')
                .withNamedArgument('name', 'name'),
          ),
        );
      },
    );

    test(
      'when negate matching class, constructor, field initializer and invalid argument then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass('User')
                .withUnnamedConstructor()
                .withFieldInitializer('name')
                .withArgument('invalidArgument'),
          ),
        );
      },
    );
  });
}
