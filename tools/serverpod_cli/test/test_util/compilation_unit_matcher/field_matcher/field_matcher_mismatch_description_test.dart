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

  group(
      'Given compilation unit with class and non-nullable non-late final field',
      () {
    late final compilationUnit = parseCode(
      '''
      class User {
        final String name;
      }
    ''',
    );

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

    test(
        'when matching with non-final field then mismatch description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isFinal: false) as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains('contains field "name" but the field is final'),
      );
    });

    test('when matching with late field then mismatch description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isLate: true) as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains('contains field "name" but the field is non-late'),
      );
    });

    test(
        'when matching with nullable late non-final field then mismatch description is correct',
        () {
      final matcher = containsClass('User').withField('name',
          isFinal: false, isNullable: true, isLate: true) as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains(
            'contains field "name" but the field is non-nullable and non-late and final'),
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
  });

  group('Given compilation unit with class and non-final field', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        String name;
      }
    ''',
    );

    test('when matching with final field then mismatch description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isFinal: true) as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains('contains field "name" but the field is non-final'),
      );
    });
  });

  group('Given compilation unit with class and late field', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        late String name;
      }
    ''',
    );

    test(
        'when matching with non-late field then mismatch description is correct',
        () {
      final matcher =
          containsClass('User').withField('name', isLate: false) as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        contains('contains field "name" but the field is late'),
      );
    });
  });
}
