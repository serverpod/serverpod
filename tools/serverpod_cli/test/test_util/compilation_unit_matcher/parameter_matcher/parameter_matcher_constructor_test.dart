import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group(
    'Given compilation unit with class and constructor with no parameters',
    () {
      late final compilationUnit = parseCode(
        '''
      class User {
        User();
      }
    ''',
      );

      test(
        'when negate matching with non-existent constructor parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass(
                'User',
              ).withUnnamedConstructor().withParameter('nonExistentParameter'),
            ),
          );
        },
      );
    },
  );

  group('Given compilation unit with class and constructor with parameter', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        User(this.name);
      }
    ''',
    );

    test(
      'when matching class and constructor with parameter then test passes',
      () {
        expect(
          compilationUnit,
          containsClass('User').withUnnamedConstructor().withParameter('name'),
        );
      },
    );

    test(
      'when negate matching class constructor with invalid "extra properties" and parameter then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withUnnamedConstructor(isFactory: true).withParameter('name'),
          ),
        );
      },
    );

    test(
      'when negate matching non existing class with parameter then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'NonExistentClass',
            ).withUnnamedConstructor().withParameter('name'),
          ),
        );
      },
    );
  });

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
        'when matching class and constructor with "this" initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withInitializerParameter('name', Initializer.this_),
          );
        },
      );

      test(
        'when negate matching class and constructor with "super" initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User')
                  .withUnnamedConstructor()
                  .withInitializerParameter('name', Initializer.super_),
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
      class User {
        User(super.name);
      }
    ''',
      );

      test(
        'when matching class and constructor with "super" initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User')
                .withUnnamedConstructor()
                .withInitializerParameter('name', Initializer.super_),
          );
        },
      );

      test(
        'when negate matching class and constructor with "this" initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User')
                  .withUnnamedConstructor()
                  .withInitializerParameter('name', Initializer.this_),
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
        'when matching class and constructor with typed parameter then test passes',
        () {
          expect(
            compilationUnit,
            containsClass(
              'User',
            ).withUnnamedConstructor().withTypedParameter('name', 'String'),
          );
        },
      );

      test(
        'when negate matching class and constructor with incorrect type then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass(
                'User',
              ).withUnnamedConstructor().withTypedParameter('name', 'int'),
            ),
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
            containsClass(
              'User',
            ).withUnnamedConstructor().withParameter('name', isRequired: true),
          );
        },
      );

      test(
        'when negate matching class and constructor with optional parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User').withUnnamedConstructor().withParameter(
                'name',
                isRequired: false,
              ),
            ),
          );
        },
      );

      test(
        'when matching with required "this" initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            containsClass(
              'User',
            ).withUnnamedConstructor().withInitializerParameter(
              'name',
              Initializer.this_,
              isRequired: true,
            ),
          );
        },
      );

      test(
        'when negate matching with optional "this" initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass(
                'User',
              ).withUnnamedConstructor().withInitializerParameter(
                'name',
                Initializer.this_,
                isRequired: false,
              ),
            ),
          );
        },
      );

      test('when negate matching with typed parameter then test passes', () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withUnnamedConstructor().withTypedParameter('name', 'String'),
          ),
        );
      });
    },
  );

  group(
    'Given compilation unit with class and constructor with required typed parameter',
    () {
      late final compilationUnit = parseCode(
        '''
      class User {
        User({required String name});
      }
    ''',
      );

      test(
        'when matching class and constructor with required parameter then test passes',
        () {
          expect(
            compilationUnit,
            containsClass(
              'User',
            ).withUnnamedConstructor().withParameter('name', isRequired: true),
          );
        },
      );

      test(
        'when negate matching class and constructor with optional parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User').withUnnamedConstructor().withParameter(
                'name',
                isRequired: false,
              ),
            ),
          );
        },
      );

      test(
        'when matching with required matching typed parameter then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User').withUnnamedConstructor().withTypedParameter(
              'name',
              'String',
              isRequired: true,
            ),
          );
        },
      );

      test(
        'when negate matching with optional matching typed initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass('User').withUnnamedConstructor().withTypedParameter(
                'name',
                'String',
                isRequired: false,
              ),
            ),
          );
        },
      );

      test(
        'when negate matching with required "this" initializer parameter then test passes',
        () {
          expect(
            compilationUnit,
            isNot(
              containsClass(
                'User',
              ).withUnnamedConstructor().withInitializerParameter(
                'name',
                Initializer.this_,
                isRequired: true,
              ),
            ),
          );
        },
      );
    },
  );
}
