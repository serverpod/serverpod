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
      'when negate matching with non-existent method of the class then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withMethod('nonExistentMethod')),
        );
      },
    );
  });

  group('Given compilation unit with class with void method', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        void methodName() {}
      }
    ''',
    );

    test('when matching class and method then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withMethod('methodName'),
      );
    });

    test('when matching class and void return method then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withMethod('methodName', returnType: 'void'),
      );
    });

    test('when matching class and non-override method then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withMethod('methodName', isOverride: false),
      );
    });

    test(
      'when negate matching with non-existent class and method then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('NonExistentClass').withMethod('methodName')),
        );
      },
    );

    test('when negate matching class and override method then test passes', () {
      expect(
        compilationUnit,
        isNot(containsClass('User').withMethod('methodName', isOverride: true)),
      );
    });

    test(
      'when negate matching class and non-existent method then test passes',
      () {
        expect(
          compilationUnit,
          isNot(containsClass('User').withMethod('nonExistentMethod')),
        );
      },
    );

    test(
      'when negate matching class and String return method then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withMethod('methodName', returnType: 'String'),
          ),
        );
      },
    );
  });

  group('Given compilation unit with class with override method', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        @override
        void methodName() {}
      }
    ''',
    );

    test('when matching class and method then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withMethod('methodName'),
      );
    });

    test('when matching class and override method then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withMethod('methodName', isOverride: true),
      );
    });

    test(
      'when negate matching class and non-override method then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass('User').withMethod('methodName', isOverride: false),
          ),
        );
      },
    );
  });
}
