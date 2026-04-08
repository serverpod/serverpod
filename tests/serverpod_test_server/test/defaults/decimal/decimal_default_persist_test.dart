import 'package:serverpod_test_server/src/generated/protocol.dart';
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
  });
}
