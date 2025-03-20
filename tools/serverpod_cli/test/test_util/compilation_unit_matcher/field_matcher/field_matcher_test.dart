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
    });
  });

  group('Given compilation unit with class and non-nullable field', () {
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

    test('when negate matching class and nullable field then test passes', () {
      expect(
        compilationUnit,
        isNot(containsClass('User').withField('name', isNullable: true)),
      );
    });

    test(
        'when negate matching with non-existent class and field then test passes',
        () {
      expect(
        compilationUnit,
        isNot(containsClass('NonExistentClass').withField('name')),
      );
    });
  });

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

    test('when negate matching class and non-nullable field then test passes',
        () {
      expect(
        compilationUnit,
        isNot(containsClass('User').withField('name', isNullable: false)),
      );
    });
  });
}
