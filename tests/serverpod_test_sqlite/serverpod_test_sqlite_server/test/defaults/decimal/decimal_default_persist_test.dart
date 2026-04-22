import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with "defaultPersist" Decimal fields,', () {
    test(
      'when an object is created, then the "decimalDefaultPersist" field should be null.',
      () {
        var object = DecimalDefaultPersist();
        expect(object.decimalDefaultPersist, isNull);
      },
    );

    test(
      'when an object of the class is created with a specific value for "decimalDefaultPersist", then the field value should match the provided value.',
      () {
        var object = DecimalDefaultPersist(
          decimalDefaultPersist: Decimal.parse('15.5'),
        );
        expect(object.decimalDefaultPersist, equals(Decimal.parse('15.5')));
      },
    );
  });
}
