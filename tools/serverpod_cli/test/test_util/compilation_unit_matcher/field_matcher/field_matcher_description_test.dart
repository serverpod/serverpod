import 'package:test/test.dart';

import '../../compilation_unit_matcher.dart';

void main() {
  test(
      'Given field matcher when describing matcher then description is correct',
      () {
    final matcher = containsClass('User').withField('name') as Matcher;
    final description = StringDescription();
    matcher.describe(description);

    expect(
      description.toString(),
      contains('a CompilationUnit containing class "User" with a field "name"'),
    );
  });

  test(
      'Given field matcher for nullable field when describing matcher then description is correct',
      () {
    final matcher =
        containsClass('User').withField('name', isNullable: true) as Matcher;
    final description = StringDescription();
    matcher.describe(description);

    expect(
      description.toString(),
      contains(
          'a CompilationUnit containing class "User" with a nullable field "name"'),
    );
  });

  test(
      'Given field matcher for non-nullable field when describing matcher then description is correct',
      () {
    final matcher =
        containsClass('User').withField('name', isNullable: false) as Matcher;
    final description = StringDescription();
    matcher.describe(description);

    expect(
      description.toString(),
      contains(
          'a CompilationUnit containing class "User" with a non-nullable field "name"'),
    );
  });

  test(
      'Given field matcher for final field when describing matcher then description is correct',
      () {
    final matcher =
        containsClass('User').withField('name', isFinal: true) as Matcher;
    final description = StringDescription();
    matcher.describe(description);

    expect(
      description.toString(),
      contains(
          'a CompilationUnit containing class "User" with a final field "name"'),
    );
  });

  test(
      'Given field matcher for non-final field when describing matcher then description is correct',
      () {
    final matcher =
        containsClass('User').withField('name', isFinal: false) as Matcher;
    final description = StringDescription();
    matcher.describe(description);

    expect(
      description.toString(),
      contains(
          'a CompilationUnit containing class "User" with a non-final field "name"'),
    );
  });

  test(
      'Given field matcher for nullable non-final field when describing matcher then description is correct',
      () {
    final matcher = containsClass('User')
        .withField('name', isFinal: false, isNullable: true) as Matcher;
    final description = StringDescription();
    matcher.describe(description);

    expect(
      description.toString(),
      contains(
          'a CompilationUnit containing class "User" with a nullable non-final field "name"'),
    );
  });
}
