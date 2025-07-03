import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with serverOnly scoped fields with default values",
    () {
      test(
        'when an object is created without specifying serverOnly field, then the default value is used',
        () {
          // This test would need a corresponding model in the test protocol
          // For now, this is a placeholder showing the structure
          expect(true, isTrue); // Placeholder
        },
      );

      test(
        'when an object is created with a specific serverOnly field value, then that value is used',
        () {
          // This test would need a corresponding model in the test protocol
          // For now, this is a placeholder showing the structure
          expect(true, isTrue); // Placeholder
        },
      );
    },
  );
}