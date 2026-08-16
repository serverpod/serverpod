import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  test(
    'Given parameter matcher chained on constructor matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withUnnamedConstructor().withParameter('name')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" with an unnamed constructor with a "name" parameter',
        ),
      );
    },
  );

  test(
    'Given parameter matcher chained on method matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withMethod('method').withParameter('name')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" with method "method" with a "name" parameter',
        ),
      );
    },
  );

  test(
    'Given required parameter matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass(
                'User',
              ).withUnnamedConstructor().withParameter('name', isRequired: true)
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with a required "name" parameter'),
      );
    },
  );

  test(
    'Given initializer parameter matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User')
                  .withUnnamedConstructor()
                  .withInitializerParameter('name', Initializer.this_)
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with a "name" parameter initialized with "this"'),
      );
    },
  );

  test(
    'Given required initializer parameter when describing matcher then description is correct',
    () {
      final matcher =
          containsClass(
                'User',
              ).withUnnamedConstructor().withInitializerParameter(
                'name',
                Initializer.super_,
                isRequired: true,
              )
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with a required "name" parameter initialized with "super"'),
      );
    },
  );

  test(
    'Given typed parameter matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass(
                'User',
              ).withUnnamedConstructor().withTypedParameter('name', 'String')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with a "name" parameter with type "String"'),
      );
    },
  );

  test(
    'Given required typed parameter matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withUnnamedConstructor().withTypedParameter(
                'name',
                'String',
                isRequired: true,
              )
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with a required "name" parameter with type "String"'),
      );
    },
  );
}
