import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  test(
    'Given unnamed constructor matcher when describing matcher then description is correct',
    () {
      final matcher = containsClass('User').withUnnamedConstructor() as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" with an unnamed constructor',
        ),
      );
    },
  );

  test(
    'Given named constructor matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withNamedConstructor('_') as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        endsWith('with a "_" named constructor'),
      );
    },
  );

  test(
    'Given unnamed factory constructor matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withUnnamedConstructor(isFactory: true)
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with an unnamed factory constructor'),
      );
    },
  );

  test(
    'Given named factory constructor matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withNamedConstructor('_', isFactory: true)
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with a "_" named factory constructor'),
      );
    },
  );
}
