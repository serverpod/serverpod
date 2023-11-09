import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

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

  await client.columnUuidLegacy.insert([first, second, nullUuid]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnUuidLegacy.deleteAll());

  group('Given uuid column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnUuidLegacy.findAll();

      expect(result.length, 3);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnUuidLegacy.equals(firstUuid);

      expect(result.first.aUuid, firstUuid);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnUuidLegacy.equals(null);

      expect(result.first.aUuid, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnUuidLegacy.notEquals(firstUuid);

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnUuidLegacy.notEquals(null);

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnUuidLegacy.inSet([
        firstUuid,
        secondUuid,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnUuidLegacy.notInSet([firstUuid]);

      expect(result.length, 2);
    });
  });
}
