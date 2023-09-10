import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  var firstInt = Types(anInt: 1);
  var secondInt = Types(anInt: 2);
  var thirdInt = Types(anInt: 3);
  var nullInt = Types(anInt: null);

  await client.columnInt.insert([firstInt, secondInt, thirdInt, nullInt]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnInt.deleteAll());

  group('Given int column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnInt.findAll();

      expect(result.length, 4);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnInt.equals(1);

      expect(result.first.anInt, 1);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnInt.equals(null);

      expect(result.first.anInt, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnInt.notEquals(1);

      // NULL is considered an "unknown" value in Postgres and therefore
      // is not not 1
      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnInt.notEquals(null);

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnInt.inSet([
        1,
        2,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnInt.notInSet([1]);

      // NULL is considered an "unknown" value in Postgres and therefore
      // is not not 1
      expect(result.length, 2);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await client.columnInt.isDistinctFrom(1);

      expect(result.length, 3);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await client.columnInt.isNotDistinctFrom(1);

      expect(result.first.anInt, 1);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await client.columnInt.greaterThan(1);

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await client.columnInt.greaterOrEqualThan(1);

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await client.columnInt.lessThan(3);

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await client.columnInt.lessOrEqualThan(3);

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await client.columnInt.between(1, 2);

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await client.columnInt.notBetween(1, 2);

      expect(result.first.anInt, 3);
    });
  });
}
