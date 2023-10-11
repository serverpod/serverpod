import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  var firstInt = Types(aDouble: 1.0);
  var secondInt = Types(aDouble: 2.0);
  var thirdInt = Types(aDouble: 3.0);
  var nullInt = Types(aDouble: null);

  await client.columnDoubleLegacy
      .insert([firstInt, secondInt, thirdInt, nullInt]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnDoubleLegacy.deleteAll());

  group('Given double column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnDoubleLegacy.findAll();

      expect(result.length, 4);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnDoubleLegacy.equals(1.0);

      expect(result.first.aDouble, 1.0);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnDoubleLegacy.equals(null);

      expect(result.first.aDouble, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.notEquals(1.0);

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.notEquals(null);

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.inSet([
        1.0,
        2.0,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnDoubleLegacy.notInSet([1.0]);

      expect(result.length, 3);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.isDistinctFrom(1.0);

      expect(result.length, 3);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await client.columnDoubleLegacy.isNotDistinctFrom(1.0);

      expect(result.first.aDouble, 1.0);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.greaterThan(1.0);

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.greaterOrEqualThan(1.0);

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.lessThan(3.0);

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.lessOrEqualThan(3.0);

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await client.columnDoubleLegacy.between(1.0, 2.0);

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await client.columnDoubleLegacy.notBetween(1.0, 2.0);

      expect(result.first.aDouble, 3.0);
    });
  });
}
