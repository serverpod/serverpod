import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given compilation unit with class and no fields ', () {
    late final compilationUnit = parseCode(
      '''
      class User {}
      ''',
    );
    test(
      'when negate matching with non-existent field of the class then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withField('nonExistentField')),
        );
      },
    );
  });

  group(
    'Given compilation unit with class and non-nullable non-late non-override final String field',
    () {
      late final compilationUnit = parseCode(
        '''
      class User {
        final String name;
      }
    ''',
      );

      test('when matching class and field then test passes', () {
        expect(
          compilationUnit,
          containsClass('User').withField('name'),
        );
      });

      test('when matching class and non-nullable field then test passes', () {
        expect(
          compilationUnit,
          containsClass('User').withField('name', isNullable: false),
        );
      });

      test('when matching class and final field then test passes', () {
        expect(
          compilationUnit,
          containsClass('User').withField('name', isFinal: true),
        );
      });

      test('when matching class and non-late field then test passes', () {
        expect(
          compilationUnit,
          containsClass('User').withField('name', isLate: false),
        );
      });

      test(
        'when matching class and non-nullable non-late non-override final String field then test passes',
        () {
          expect(
            compilationUnit,
            containsClass('User').withField(
              'name',
              isNullable: false,
              isFinal: true,
              isLate: false,
              isOverride: false,
              type: 'String',
            ),
          );
        },
      );

      test('when matching class and non-override field then test passes', () {
        expect(
          compilationUnit,
          containsClass('User').withField('name', isOverride: false),
        );
      });

      test('when matching class and String field then test passes', () {
        expect(
          compilationUnit,
          containsClass('User').withField('name', type: 'String'),
        );
      });

      test(
        'when negate matching class and nullable field then test passes',
        () {
          expect(
            compilationUnit,
            isNot(containsClass('User').withField('name', isNullable: true)),
          );
        },
      );

      test(
        'when negate matching class and non-final field then test passes',
        () {
          expect(
            compilationUnit,
            isNot(containsClass('User').withField('name', isFinal: false)),
          );
        },
      );

      test('when negate matching class and late field then test passes', () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withField('name', isLate: true)),
        );
      });

      test(
        'when negate matching class and override field then test passes',
        () {
          expect(
            compilationUnit,
            isNot(containsClass('User').withField('name', isOverride: true)),
          );
        },
      );

      test('when matching class and int field then test passes', () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withField('name', type: 'int')),
        );
      });

      test(
        'when negate matching with non-existent class and field then test passes',
        () {
          expect(
            compilationUnit,
            isNot(containsClass('NonExistentClass').withField('name')),
          );
        },
      );
    },
  );

  group('Given compilation unit with class and nullable field', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        final String? name;
      }
    ''',
    );

    test('when matching class and field then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withField('name'),
      );
    });

    test('when matching class and nullable field then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withField('name', isNullable: true),
      );
    });

    test(
      'when negate matching class and non-nullable field then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withField('name', isNullable: false)),
        );
      },
    );
  });

  group('Given compilation unit with class and non-final field', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        String name;
      }
    ''',
    );

    test('when matching class and non-final field then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withField('name', isFinal: false),
      );
    });

    test('when negate matching class and final field then test passes', () {
      expect(
        compilationUnit,
        isNot(containsClass('User').withField('name', isFinal: true)),
      );
    });
  });

  group('Given compilation unit with class and late final field', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        late final String name;
      }
    ''',
    );

    test('when matching class and late final field then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withField('name', isLate: true),
      );
    });

    test(
      'when negate matching class and non-late final field then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withField('name', isLate: false)),
        );
      },
    );
  });
}
