// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Deprecated Constant expression', () {
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
  group('Given a Constant expression', () {
    test('when null static is retrieved then output is NULL.', () {
      var expression = Constant.nullValue;

      expect(expression.toString(), 'NULL');
    });

    test(
        'when bool constructor is used value then output is uppercase bool value.',
        () {
      var expression = Constant.bool(true);

      expect(expression.toString(), 'TRUE');
    });

    test('when initialized with String value then output is escaped string.',
        () {
      var expression = Constant.string('test');

      expect(expression.toString(), '\'test\'');
    });
  });
}
