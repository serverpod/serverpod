import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Constant expression', () {
    test('when initialized with null value then output is NULL.', () {
      var expression = Constant(null);

      expect(expression.toString(), 'NULL');
    });

    test(
        'when initialized with bool value then output is uppercase bool value.',
        () {
      var expression = Constant(true);

      expect(expression.toString(), 'TRUE');
    });

    test('when initialized with String value then output is escaped string.',
        () {
      var expression = Constant('test');

      expect(expression.toString(), '\'test\'');
    });

    test('when initialized with unknown type then FormatException is thrown.',
        () {
      expect(() => Constant(DateTime.now()), throwsFormatException);
    });
  });
}
