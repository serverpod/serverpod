import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  var firstInt = Types(anInt: 1);
  var secondInt = Types(anInt: 2);
  var thirdInt = Types(anInt: 3);
  var nullInt = Types(anInt: null);

  await client.columnIntLegacy.insert([firstInt, secondInt, thirdInt, nullInt]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnIntLegacy.deleteAll());

  group('Given int column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnIntLegacy.findAll();

      expect(result.length, 4);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnIntLegacy.equals(1);

      expect(result.first.anInt, 1);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnIntLegacy.equals(null);

      expect(result.first.anInt, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.notEquals(1);

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.notEquals(null);

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.inSet([
        1,
        2,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnIntLegacy.notInSet([1]);

      expect(result.length, 3);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.greaterThan(1);

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.greaterOrEqualThan(1);

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.lessThan(3);

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.lessOrEqualThan(3);

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await client.columnIntLegacy.between(1, 2);

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await client.columnIntLegacy.notBetween(1, 2);

      expect(result.first.anInt, 3);
    });
  });
}
