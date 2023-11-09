import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Client client) async {
  var firstEnum = Types(anEnum: TestEnum.one);
  var secondEnum = Types(anEnum: TestEnum.two);
  var nullEnum = Types(anEnum: null);

  await client.columnEnumLegacy.insert([firstEnum, secondEnum, nullEnum]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnEnumLegacy.deleteAll());

  group('Given enum column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnEnumLegacy.findAll();

      expect(result.length, 3);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnEnumLegacy.equals(TestEnum.one);

      expect(result.first.anEnum, TestEnum.one);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnEnumLegacy.equals(null);

      expect(result.first.anEnum, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnEnumLegacy.notEquals(TestEnum.one);

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnEnumLegacy.notEquals(null);

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnEnumLegacy.inSet([
        TestEnum.one,
        TestEnum.two,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnEnumLegacy.notInSet([TestEnum.one]);

      expect(result.length, 2);
    });
  });
}
