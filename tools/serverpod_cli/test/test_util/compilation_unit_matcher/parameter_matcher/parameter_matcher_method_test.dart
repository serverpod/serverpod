import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  group('Given compilation unit with class and method with no parameters', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        void greet() {}
      }
    ''',
    );

    test(
      'when negate matching with non-existent method parameter then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withMethod('greet').withParameter('nonExistentParameter'),
          ),
        );
      },
    );
  });

  group('Given compilation unit with class and method with typed parameter', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        void greet(String name) {}
      }
    ''',
    );

    test('when matching class and method with parameter then test passes', () {
      expect(
        compilationUnit,
        containsClass('User').withMethod('greet').withParameter('name'),
      );
    });

    test(
      'when matching class and method with typed parameter then test passes',
      () {
        expect(
          compilationUnit,
          containsClass(
            'User',
          ).withMethod('greet').withParameter('name', type: 'String'),
        );
      },
    );

    test(
      'when negate matching class method with invalid "extra properties" and parameter then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withMethod('greet', isOverride: true).withParameter('name'),
          ),
        );
      },
    );

    test(
      'when negate matching class with parameter with invalid type then test passes',
      () {
        expect(
          compilationUnit,
          isNot(
            containsClass(
              'User',
            ).withMethod('greet').withParameter('name', type: 'String?'),
          ),
        );
      },
    );
  });
}
