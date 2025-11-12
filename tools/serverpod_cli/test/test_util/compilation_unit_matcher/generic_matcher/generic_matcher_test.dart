import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given a class with an extends clause that has no generics', () {
    late final compilationUnit = parseCode(
      '''
      class User extends Parent {}
      ''',
    );

    test(
      'when negate matching with non-existent generic on the extended class then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').thatExtends('Parent').withGeneric('T')),
        );
      },
    );

    test(
      'when matching with non-existent generic on the extended class then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').thatExtends('Parent').withGeneric('T')
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals('does not have any generics'),
        );
      },
    );
  });

  group('Given a class with an extends clause that has generics', () {
    late final compilationUnit = parseCode(
      '''
      class User extends Parent<T> {}
      ''',
    );

    test('when matching generic on the extended class then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').thatExtends('Parent').withGeneric('T'),
      );
    });

    test(
      'when negate matching non-existent generic on the extended class then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').thatExtends('Parent').withGeneric('X')),
        );
      },
    );

    test(
      'when matching incorrect generic on the extended class then test fails',
      () {
        final matcher =
            containsClass('User').thatExtends('Parent').withGeneric('X')
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not have the generic "X". Found generics: [T]',
          ),
        );
      },
    );
  });

  group('Given a class with an extends clause that with multiple generics', () {
    late final compilationUnit = parseCode(
      '''
      class User extends Parent<T, V> {}
      ''',
    );

    test('when matching generic on the extended class then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').thatExtends('Parent').withGeneric('V'),
      );
    });

    test(
      'when negate matching non-existent generic on the extended class then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').thatExtends('Parent').withGeneric('X')),
        );
      },
    );

    test(
      'when matching incorrect generic on the extended class then test fails',
      () {
        final matcher =
            containsClass('User').thatExtends('Parent').withGeneric('X')
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not have the generic "X". Found generics: [T, V]',
          ),
        );
      },
    );
  });

  test(
    'Given generics matcher with when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').thatExtends('Parent').withGeneric('T')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" that extends "Parent" with generic "T"',
        ),
      );
    },
  );
}
