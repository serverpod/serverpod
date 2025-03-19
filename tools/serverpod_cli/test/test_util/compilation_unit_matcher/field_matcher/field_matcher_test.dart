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

    test(
        'when matching with non-existent class then mismatch description is correct',
        () {
      final matcher =
          containsClass('NonExistentClass').withField('name') as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        equals(
          'does not contain class "NonExistentClass". Found classes: [User]',
        ),
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

    test(
        'when matching with non-existent field then mismatch description is correct',
        () {
      final matcher =
          containsClass('User').withField('nonExistentField') as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains(
            'does not contain field "nonExistentField". Found fields: [name]'),
      );
    });

    test(
        'when matching with nullable field then mismatch description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isNullable: true) as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains('contains field "name" but the field is non-nullable'),
      );
    });

    test('when describing matcher then description is correct', () {
      final matcher = containsClass('User').withField('name') as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains(
            'a CompilationUnit containing class "User" with a field "name"'),
      );
    });

    test(
        'when describing matcher with nullable field then description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isNullable: true) as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains(
            'a CompilationUnit containing class "User" with a nullable field "name"'),
      );
    });

    test(
        'when describing matcher with non-nullable field then description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isNullable: false) as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains(
            'a CompilationUnit containing class "User" with a non-nullable field "name"'),
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

    test(
        'when matching with non-nullable field then mismatch description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isNullable: false) as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains('contains field "name" but the field is nullable'),
      );
    });

    test('when describing matcher then description is correct', () {
      final matcher = containsClass('User').withField('name') as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains(
            'a CompilationUnit containing class "User" with a field "name"'),
      );
    });

    test(
        'when describing matcher with nullable field then description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isNullable: true) as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains(
            'a CompilationUnit containing class "User" with a nullable field "name"'),
      );
    });

    test(
        'when describing matcher with non-nullable field then description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isNullable: false) as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains(
            'a CompilationUnit containing class "User" with a non-nullable field "name"'),
      );
    });
  });
}
