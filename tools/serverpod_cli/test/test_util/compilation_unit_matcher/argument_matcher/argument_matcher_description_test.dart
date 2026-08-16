import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  test(
    'Given argument matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withArgument('name')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" with an unnamed constructor with a super initializer passed "name" argument',
        ),
      );
    },
  );

  test(
    'Given positional argument matcher when describing matcher then description is adapted for positional arguments',
    () {
      final matcher =
          containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withPositionalArgument('name')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('passed "name" positional argument'),
      );
    },
  );

  test(
    'Given named argument matcher when describing matcher then description is adapted for positional arguments',
    () {
      final matcher =
          containsClass('User')
                  .withUnnamedConstructor()
                  .withSuperInitializer()
                  .withNamedArgument('name', 'parameterName')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('passed "name" argument for "parameterName" parameter'),
      );
    },
  );
}
