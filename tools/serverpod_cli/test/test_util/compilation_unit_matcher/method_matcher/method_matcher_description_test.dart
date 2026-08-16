import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  test(
    'Given method matcher when describing matcher then description is correct',
    () {
      final matcher = containsClass('User').withMethod('methodName') as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        equals(
          'a CompilationUnit containing class "User" with method "methodName"',
        ),
      );
    },
  );

  test(
    'Given override method matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withMethod('methodName', isOverride: true)
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with override method "methodName"'),
      );
    },
  );

  test(
    'Given non-override method matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withMethod('methodName', isOverride: false)
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with non-override method "methodName"'),
      );
    },
  );

  test(
    'Given String return method matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass('User').withMethod('methodName', returnType: 'String')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with method "methodName" returning "String"'),
      );
    },
  );

  test(
    'Given String return override method matcher when describing matcher then description is correct',
    () {
      final matcher =
          containsClass(
                'User',
              ).withMethod('methodName', isOverride: true, returnType: 'String')
              as Matcher;
      final description = StringDescription();
      matcher.describe(description);

      expect(
        description.toString(),
        contains('with override method "methodName" returning "String"'),
      );
    },
  );
}
