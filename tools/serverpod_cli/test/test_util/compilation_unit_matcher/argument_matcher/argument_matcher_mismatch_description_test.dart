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
        'when matching class, constructor, super initializer and non-existent argument then mismatch description is correct',
        () {
          var matcher =
              containsClass('User')
                      .withUnnamedConstructor()
                      .withSuperInitializer()
                      .withArgument('5')
                  as Matcher;
          var description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals(
              'does not contain argument "5" in super initializer. Found arguments: []',
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
        'when matching class, constructor, super initializer and non-existent argument then mismatch description is correct',
        () {
          var matcher =
              containsClass('User')
                      .withUnnamedConstructor()
                      .withSuperInitializer()
                      .withArgument('5')
                  as Matcher;
          var description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals(
              'does not contain argument "5" in super initializer. Found arguments: [name]',
            ),
          );
        },
      );

      test(
        'when matching class, constructor, super initializer and named argument then mismatch description is correct',
        () {
          var matcher =
              containsClass('User')
                      .withUnnamedConstructor()
                      .withSuperInitializer()
                      .withNamedArgument('name', 'name')
                  as Matcher;
          var description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals(
              'contains argument "name" but it is not passed to a named parameter "name" in super initializer',
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
        'when matching class, constructor, super initializer and non-existent argument then mismatch description is correct',
        () {
          var matcher =
              containsClass('User')
                      .withUnnamedConstructor()
                      .withSuperInitializer()
                      .withArgument('5')
                  as Matcher;
          var description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals(
              'does not contain argument "5" in super initializer. Found arguments: [name: name]',
            ),
          );
        },
      );

      test(
        'when matching class, constructor, super initializer and incorrect named argument then mismatch description is correct',
        () {
          var matcher =
              containsClass('User')
                      .withUnnamedConstructor()
                      .withSuperInitializer()
                      .withNamedArgument('name', 'surname')
                  as Matcher;
          var description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals(
              'contains argument "name" but it is not passed to a named parameter "surname" in super initializer',
            ),
          );
        },
      );

      test(
        'when matching class, constructor, super initializer and positional argument then mismatch description is correct',
        () {
          var matcher =
              containsClass('User')
                      .withUnnamedConstructor()
                      .withSuperInitializer()
                      .withPositionalArgument('name')
                  as Matcher;
          var description = StringDescription();
          matcher.describeMismatch(compilationUnit, description, {}, false);

          expect(
            description.toString(),
            equals(
              'contains argument "name" but it is not a positional argument in super initializer',
            ),
          );
        },
      );
    },
  );
}
