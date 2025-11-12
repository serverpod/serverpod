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
      'when matching with non-existent unnamed constructor then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withUnnamedConstructor() as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals('does not contain an unnamed constructor'),
        );
      },
    );

    test(
      'when matching with non-existent named constructor then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withNamedConstructor('_') as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not contain "_" named constructor. Found named constructors: []',
          ),
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

    test(
      'when matching with unnamed factory constructor then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withUnnamedConstructor(isFactory: false)
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals('contains constructor but it is not a factory constructor'),
        );
      },
    );

    test(
      'when matching with named factory constructor then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withNamedConstructor('_') as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not contain "_" named constructor. Found named constructors: []',
          ),
        );
      },
    );
  });

  group('Given compilation unit with class with multiple named constructors', () {
    late final compilationUnit = parseCode(
      '''
      class User {
        User();
        User.named();
        User._();
      }
    ''',
    );

    test(
      'when matching with non-existent named constructor then mismatch description is correct',
      () {
        final matcher =
            containsClass('User').withNamedConstructor('nonExistent')
                as Matcher;
        final description = StringDescription();
        matcher.describeMismatch(compilationUnit, description, {}, false);

        expect(
          description.toString(),
          equals(
            'does not contain "nonExistent" named constructor. Found named constructors: [named, _]',
          ),
        );
      },
    );
  });
}
