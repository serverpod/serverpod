import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given compilation unit with class', () {
    late final compilationUnit = parseCode(
      '''
      class User {}
      ''',
    );

    test(
      'when negate matching class and unnamed constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withUnnamedConstructor()),
        );
      },
    );

    test(
      'when negate matching class and named constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withNamedConstructor('_')),
        );
      },
    );
  });

  group('Given compilation unit with class and unnamed constructor', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        User();
      }
    ''',
    );

    test('when matching class and unnamed constructor then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withUnnamedConstructor(),
      );
    });

    test(
      'when matching class and unnamed non-factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          containsClass('User').withUnnamedConstructor(isFactory: false),
        );
      },
    );

    test(
      'when negate matching with non-existent class and constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('NonExistentClass').withUnnamedConstructor()),
        );
      },
    );

    test(
      'when negate matching class and named constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withNamedConstructor('_')),
        );
      },
    );

    test(
      'when negate matching class and unnamed factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withUnnamedConstructor(isFactory: true)),
        );
      },
    );
  });

  group('Given compilation unit with class and private named constructor', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        User._();
      }
    ''',
    );

    test(
      'when matching class and private named constructor then test passes',
      () {
        expect(
          compilationUnit,
          containsClass('User').withNamedConstructor('_'),
        );
      },
    );

    test(
      'when negate matching class and unnamed constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withUnnamedConstructor()),
        );
      },
    );
  });

  group('Given compilation unit with class and unnamed factory constructor', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        factory User() => User();
      }
    ''',
    );

    test(
      'when matching class and unnamed factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          containsClass('User').withUnnamedConstructor(isFactory: true),
        );
      },
    );

    test(
      'when negate matching class and unnamed non-factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withUnnamedConstructor(isFactory: false)),
        );
      },
    );

    test(
      'when negate matching class and named factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass('User').withNamedConstructor('_', isFactory: true),
          ),
        );
      },
    );
  });

  group('Given compilation unit with class and named factory constructor', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        factory User.namedFactory() => User();
      }
    ''',
    );

    test('when matching class and named constructor then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withNamedConstructor(
          'namedFactory',
        ),
      );
    });

    test(
      'when matching class and named factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          containsClass('User').withNamedConstructor(
            'namedFactory',
            isFactory: true,
          ),
        );
      },
    );

    test(
      'when negate matching class and unnamed factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass('User').withUnnamedConstructor(
              isFactory: true,
            ),
          ),
        );
      },
    );

    test(
      'when negate matching class and named non-factory constructor then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass('User').withNamedConstructor(
              'namedFactory',
              isFactory: false,
            ),
          ),
        );
      },
    );
  });
}
