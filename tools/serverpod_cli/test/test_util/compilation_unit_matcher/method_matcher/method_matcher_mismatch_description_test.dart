import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given compilation unit with class with no methods', () {
    late final compilationUnit = parseCode(
      '''
      class User {}
      ''',
    );

    test(
      'when matching class and non-existing method then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withMethod('nonExistentMethod') as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not contain method "nonExistentMethod". Found methods: []',
          ),
        );
      },
    );
  });

  group('Given compilation unit with class with String return method', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        String getName() {}
      }
    ''',
    );

    test(
      'when matching with non-existent method then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withMethod('nonExistentMethod') as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not contain method "nonExistentMethod". Found methods: [getName]',
          ),
        );
      },
    );

    test(
      'when matching class and override method then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withMethod('getName', isOverride: true)
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals('contains method "getName" but it is not overridden'),
        );
      },
    );

    test(
      'when matching class and int return method then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withMethod('getName', returnType: 'int')
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals('contains method "getName" but it returns "String"'),
        );
      },
    );

    test(
      'when matching class and override int return method then mismatch description is correct',
      () {
        final matcher =
            containsClass(
                  'User',
                ).withMethod('getName', isOverride: true, returnType: 'int')
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'contains method "getName" but it is not overridden and returns "String"',
          ),
        );
      },
    );
  });

  group('Given compilation unit with class with multiple methods', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        String getName() {}
        String getHobby() {}
      }
    ''',
    );

    test(
      'when matching with non-existent method then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withMethod('nonExistentMethod') as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not contain method "nonExistentMethod". Found methods: [getName, getHobby]',
          ),
        );
      },
    );
  });
  group('Given compilation unit with class with overridden method', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        @override
        String getName() {}
      }
    ''',
    );

    test(
      'when matching class and non-overridden method then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withMethod('getName', isOverride: false)
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals('contains method "getName" but it is overridden'),
        );
      },
    );
  });
}
