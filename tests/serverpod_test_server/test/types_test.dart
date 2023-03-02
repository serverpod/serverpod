import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Test UUID', () {
    test('Ensure ObjectWithUuid is generated correctly.', () {
      expect(ObjectWithUuid.t.uuid, isA<ColumnUuid>());
      expect(ObjectWithUuid.t.uuidNullable, isA<ColumnUuid>());
    });
  });
}
