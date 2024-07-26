import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a string field with default value using single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefault: String, default='This \"is\" a default value', controlToken",
    );
    expect(result, [
      'stringDefault: String',
      'default=\'This "is" a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefault: String, default="This \'is\' a default value", controlToken',
    );
    expect(result, [
      'stringDefault: String',
      'default="This \'is\' a default value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default null value using single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefaultNull: String?, default='This \"is\" a default null value', controlToken",
    );
    expect(result, [
      'stringDefaultNull: String?',
      'default=\'This "is" a default null value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default null value using double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefaultNull: String?, default="This \'is\' a default null value", controlToken',
    );
    expect(result, [
      'stringDefaultNull: String?',
      'default="This \'is\' a default null value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default model value using single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefaultModel: String, defaultModel='This \"is\" a default model value', controlToken",
    );
    expect(result, [
      'stringDefaultModel: String',
      'defaultModel=\'This "is" a default model value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default model value using double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefaultModel: String, defaultModel="This \'is\' a default model value", controlToken',
    );
    expect(result, [
      'stringDefaultModel: String',
      'defaultModel="This \'is\' a default model value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default persist value using single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefaultPersist: String?, defaultPersist='This \"is\" a default persist value', controlToken",
    );
    expect(result, [
      'stringDefaultPersist: String?',
      'defaultPersist=\'This "is" a default persist value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default persist value using double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefaultPersist: String?, defaultPersist="This \'is\' a default persist value", controlToken',
    );
    expect(result, [
      'stringDefaultPersist: String?',
      'defaultPersist="This \'is\' a default persist value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default and default model values using single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefaultAndDefaultModel: String, default='This \"is\" a default value', defaultModel='This \"is\" a default model value', controlToken",
    );
    expect(result, [
      'stringDefaultAndDefaultModel: String',
      'default=\'This "is" a default value\'',
      'defaultModel=\'This "is" a default model value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default and default model values using double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefaultAndDefaultModel: String, default="This \'is\' a default value", defaultModel="This \'is\' a default model value", controlToken',
    );
    expect(result, [
      'stringDefaultAndDefaultModel: String',
      'default="This \'is\' a default value"',
      'defaultModel="This \'is\' a default model value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default and default persist values using single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefaultAndDefaultPersist: String, default='This \"is\" a default value', defaultPersist='This \"is\" a default persist value', controlToken",
    );
    expect(result, [
      'stringDefaultAndDefaultPersist: String',
      'default=\'This "is" a default value\'',
      'defaultPersist=\'This "is" a default persist value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default and default persist values using double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefaultAndDefaultPersist: String, default="This \'is\' a default value", defaultPersist="This \'is\' a default persist value", controlToken',
    );
    expect(result, [
      'stringDefaultAndDefaultPersist: String',
      'default="This \'is\' a default value"',
      'defaultPersist="This \'is\' a default persist value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default model and default persist values using single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefaultModelAndDefaultPersist: String, defaultModel='This \"is\" a default model value', defaultPersist='This \"is\" a default persist value', controlToken",
    );
    expect(result, [
      'stringDefaultModelAndDefaultPersist: String',
      'defaultModel=\'This "is" a default model value\'',
      'defaultPersist=\'This "is" a default persist value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default model and default persist values using double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefaultModelAndDefaultPersist: String, defaultModel="This \'is\' a default model value", defaultPersist="This \'is\' a default persist value", controlToken',
    );
    expect(result, [
      'stringDefaultModelAndDefaultPersist: String',
      'defaultModel="This \'is\' a default model value"',
      'defaultPersist="This \'is\' a default persist value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using single quotes containing double quotes and angle brackets when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefault: String, default='This <\"is\"> a default value', controlToken",
    );
    expect(result, [
      'stringDefault: String',
      'default=\'This <"is"> a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using double quotes containing single quotes and parenthesis when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefault: String, default="This (\'is\') a default value", controlToken',
    );
    expect(result, [
      'stringDefault: String',
      'default="This (\'is\') a default value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using single quotes containing double quotes and nested brackets when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefault: String, default='This \"is\" a (default <value>)', controlToken",
    );
    expect(result, [
      'stringDefault: String',
      'default=\'This "is" a (default <value>)\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using double quotes containing single quotes and nested brackets when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefault: String, default="This \'is\' a (default <value>)", controlToken',
    );
    expect(result, [
      'stringDefault: String',
      'default="This \'is\' a (default <value>)"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using single quotes containing double quotes and a comma when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefault: String, default='This \",is\" a default value', controlToken",
    );
    expect(result, [
      'stringDefault: String',
      'default=\'This ",is" a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using single quotes containing double quotes and a single quote when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "stringDefault: String, default='This \"is a default value', controlToken",
    );
    expect(result, [
      'stringDefault: String',
      'default=\'This "is a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using double quotes containing single quotes and a comma when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefault: String, default="This \',is\' a default value", controlToken',
    );
    expect(result, [
      'stringDefault: String',
      'default="This \',is\' a default value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string field with default value using double quotes containing single quotes and a single quote when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'stringDefault: String, default="This \'is a default value", controlToken',
    );
    expect(result, [
      'stringDefault: String',
      'default="This \'is a default value"',
      'controlToken',
    ]);
  });
}
