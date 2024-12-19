import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ResultRequestTooLarge', () {
    test('should create error with correct description', () {
      final error = ResultRequestTooLarge(1024, 2048);

      expect(error.maxSize, 1024);
      expect(error.actualSize, 2048);
      expect(error.toString(),
          'Request size exceeds the maximum allowed size of 1024 bytes. Actual size: 2048 bytes.');
    });
  });
}
