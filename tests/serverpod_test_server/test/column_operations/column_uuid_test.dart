import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

final firstUuid = UuidValue('6948DF80-14BD-4E04-8842-7668D9C001F5');
final secondUuid = UuidValue('4B8302DA-21AD-401F-AF45-1DFD956B80B5');

Future<void> _createTestDatabase(Client client) async {
  var first = Types(
    aUuid: firstUuid,
  );
  var second = Types(
    aUuid: secondUuid,
  );
  var nullUuid = Types(aUuid: null);

  await client.columnUuid.insert([first, second, nullUuid]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnUuid.deleteAll());

  group('Given uuid column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnUuid.findAll();

      expect(result.length, 3);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnUuid.equals(firstUuid);

      expect(result.first.aUuid, firstUuid);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnUuid.equals(null);

      expect(result.first.aUuid, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnUuid.notEquals(firstUuid);

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnUuid.notEquals(null);

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnUuid.inSet([
        firstUuid,
        secondUuid,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnUuid.notInSet([firstUuid]);

      // NULL is considered an "unknown" value in Postgres and therefore
      // is not not firstUuid
      expect(result.length, 1);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await client.columnUuid.isDistinctFrom(firstUuid);

      expect(result.length, 2);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await client.columnUuid.isNotDistinctFrom(firstUuid);

      expect(result.first.aUuid, firstUuid);
    });
  });
}
