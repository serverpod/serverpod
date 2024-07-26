import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a string with single quotes containing double quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "controlToken, 'This \"is\" a default value', controlToken",
    );
    expect(result, [
      'controlToken',
      '\'This "is" a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string with double quotes containing single quotes when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'controlToken, "This \'is\' a default value", controlToken',
    );
    expect(result, [
      'controlToken',
      '"This \'is\' a default value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string with single quotes containing double quotes and angle brackets when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "controlToken, 'This <\"is\"> a default value', controlToken",
    );
    expect(result, [
      'controlToken',
      '\'This <"is"> a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string with double quotes containing single quotes and parenthesis when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'controlToken, "This (\'is\') a default value", controlToken',
    );
    expect(result, [
      'controlToken',
      '"This (\'is\') a default value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string with single quotes containing double quotes and nested brackets when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "controlToken, 'This \"is\" a (default <value>)', controlToken",
    );
    expect(result, [
      'controlToken',
      '\'This "is" a (default <value>)\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string with double quotes containing single quotes and nested brackets when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'controlToken, "This \'is\' a (default <value>)", controlToken',
    );
    expect(result, [
      'controlToken',
      '"This \'is\' a (default <value>)"',
      'controlToken',
    ]);
  });

  test(
      'Given a string with single quotes containing double quotes and a comma when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "controlToken, 'This \",is\" a default value', controlToken",
    );
    expect(result, [
      'controlToken',
      '\'This ",is" a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string with single quotes containing double quotes and a single quote when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      "controlToken, 'This \"is a default value', controlToken",
    );
    expect(result, [
      'controlToken',
      '\'This "is a default value\'',
      'controlToken',
    ]);
  });

  test(
      'Given a string with double quotes containing single quotes and a comma when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'controlToken, "This \',is\' a default value", controlToken',
    );
    expect(result, [
      'controlToken',
      '"This \',is\' a default value"',
      'controlToken',
    ]);
  });

  test(
      'Given a string with double quotes containing single quotes and a single quote when splitting then it is split correctly.',
      () {
    var result = splitIgnoringBracketsAndQuotes(
      'controlToken, "This \'is a default value", controlToken',
    );
    expect(result, [
      'controlToken',
      '"This \'is a default value"',
      'controlToken',
    ]);
  });
}
