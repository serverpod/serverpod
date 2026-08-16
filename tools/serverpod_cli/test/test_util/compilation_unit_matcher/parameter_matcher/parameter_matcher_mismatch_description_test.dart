import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given compilation unit with class and constructor', () {
    group(
      'Given compilation unit with class and constructor with "this" initializer parameter',
      () {
        late final compilationUnit = parseCode(
          '''
      class User {
        User(this.name);
      }
    ''',
        );

        test(
          'when matching with non-existent parameter then mismatch description is correct',
          () {
            final matcher =
                containsClass(
                      'User',
                    ).withUnnamedConstructor().withParameter('nonExistent')
                    as Matcher;
            final description = StringDescription();
            matcher.describeMismatch(compilationUnit, description, {}, false);

            expect(
              description.toString(),
              equals(
                'does not contain parameter "nonExistent". Found parameters: [name]',
              ),
            );
          },
        );

        test(
          'when matching matching class and constructor with "super" initializer parameter then mismatch description is correct',
          () {
            final matcher =
                containsClass('User')
                        .withUnnamedConstructor()
                        .withInitializerParameter('name', Initializer.super_)
                    as Matcher;
            final description = StringDescription();
            matcher.describeMismatch(compilationUnit, description, {}, false);

            expect(
              description.toString(),
              equals(
                'contains parameter "name" but it is initialized with "this"',
              ),
            );
          },
        );
      },
    );

    group(
      'Given compilation unit with class and constructor with "super" initializer parameter',
      () {
        late final compilationUnit = parseCode(
          '''
      class User{
        User(super.name);
      }
    ''',
        );

        test(
          'when matching class and constructor with "this" initializer parameter then mismatch description is correct',
          () {
            final matcher =
                containsClass('User')
                        .withUnnamedConstructor()
                        .withInitializerParameter('name', Initializer.this_)
                    as Matcher;
            final description = StringDescription();
            matcher.describeMismatch(compilationUnit, description, {}, false);

            expect(
              description.toString(),
              equals(
                'contains parameter "name" but it is initialized with "super"',
              ),
            );
          },
        );
      },
    );

    group(
      'Given compilation unit with class and constructor with typed parameter',
      () {
        late final compilationUnit = parseCode(
          '''
      class User {
        User(String name);
      }
    ''',
        );

        test(
          'when matching with incorrect parameter type then mismatch description is correct',
          () {
            final matcher =
                containsClass(
                      'User',
                    ).withUnnamedConstructor().withTypedParameter('name', 'int')
                    as Matcher;
            final description = StringDescription();
            matcher.describeMismatch(compilationUnit, description, {}, false);

            expect(
              description.toString(),
              equals('contains parameter "name" but it is of type "String"'),
            );
          },
        );
      },
    );

    group(
      'Given compilation unit with class and constructor with required parameter initialized with "this"',
      () {
        late final compilationUnit = parseCode(
          '''
      class User {
        User({required this.name});
      }
    ''',
        );

        test(
          'when matching class and constructor with required parameter then test passes',
          () {
            expect(
              compilationUnit,
              containsClass('User').withUnnamedConstructor().withParameter(
                'name',
                isRequired: true,
              ),
            );
          },
        );

        test(
          'when matching with optional parameter then mismatch description is correct',
          () {
            final matcher =
                containsClass('User').withUnnamedConstructor().withParameter(
                      'name',
                      isRequired: false,
                    )
                    as Matcher;
            final description = StringDescription();
            matcher.describeMismatch(compilationUnit, description, {}, false);

            expect(
              description.toString(),
              equals('contains parameter "name" but it is required'),
            );
          },
        );

        test(
          'when matching with optional "super" initializer parameter then mismatch description is correct',
          () {
            final matcher =
                containsClass(
                      'User',
                    ).withUnnamedConstructor().withInitializerParameter(
                      'name',
                      Initializer.super_,
                      isRequired: false,
                    )
                    as Matcher;
            final description = StringDescription();
            matcher.describeMismatch(compilationUnit, description, {}, false);

            expect(
              description.toString(),
              equals(
                'contains parameter "name" but it is required and it is initialized with "this"',
              ),
            );
          },
        );
      },
    );
  });
}
