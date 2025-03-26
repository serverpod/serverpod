import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given compilation unit with class that does not extend another class',
      () {
    late final compilationUnit = parseCode(
      '''
      class User {}
      ''',
    );

    test('when negate matching class and extention then test passes', () {
      expect(
        compilationUnit,
        isNot(containsClass('User').thatExtends('Parent')),
      );
    });

    test(
        'when matching with class name and non-existent extends then test fails',
        () {
      final matcher =
          containsClass('User').thatExtends('NonExistentParent') as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        equals(
          'does not extend any class',
        ),
      );
    });
  });

  group('Given compilation unit with class that extends another class', () {
    late final compilationUnit = parseCode(
      '''
      class User extends Parent {}
      ''',
    );

    test('when matching class and extention then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').thatExtends('Parent'),
      );
    });

    test('when negate matching class and invalid extention then test passes',
        () {
      expect(
        compilationUnit,
        isNot(containsClass('User').thatExtends('InvalidParent')),
      );
    });

    test(
        'when matching with class name and incorrect extends clause then test fails',
        () {
      final matcher =
          containsClass('User').thatExtends('InvalidParent') as Matcher;
      final description = StringDescription();
      matcher.describeMismatch(compilationUnit, description, {}, false);

      expect(
        description.toString(),
        equals(
          'extends the class "Parent"',
        ),
      );
    });
  });

  test(
      'Given matcher for class extending another class when fetching description then description is correct',
      () {
    final matcher = containsClass('User').thatExtends('Parent') as Matcher;
    final description = StringDescription();
    matcher.describe(description);

    expect(
      description.toString(),
      equals('a CompilationUnit containing class "User" that extends "Parent"'),
    );
  });
}
