import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  var firstEnum = Types(anEnum: TestEnum.one);
  var secondEnum = Types(anEnum: TestEnum.two);
  var nullEnum = Types(anEnum: null);

  await client.columnEnum.insert([firstEnum, secondEnum, nullEnum]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnEnum.deleteAll());

  group('Given enum column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnEnum.findAll();

      expect(result.length, 3);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnEnum.equals(TestEnum.one);

      expect(result.first.anEnum, TestEnum.one);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnEnum.equals(null);

      expect(result.first.anEnum, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnEnum.notEquals(TestEnum.one);

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnEnum.notEquals(null);

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnEnum.inSet([
        TestEnum.one,
        TestEnum.two,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnEnum.notInSet([TestEnum.one]);

      expect(result.length, 2);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await client.columnEnum.isDistinctFrom(TestEnum.one);

      expect(result.length, 2);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await client.columnEnum.isNotDistinctFrom(TestEnum.one);

      expect(result.first.anEnum, TestEnum.one);
    });
  });
}
