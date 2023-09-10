import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

final firstDate = DateTime.utc(1991, 5, 28);
final secondDate = DateTime.utc(2001, 5, 28);
final thirdDate = DateTime.utc(2011, 5, 28);

Future<void> _createTestDatabase(Client client) async {
  var first = Types(aDateTime: firstDate);
  var second = Types(aDateTime: secondDate);
  var third = Types(aDateTime: thirdDate);
  var nullDateTime = Types(aDateTime: null);

  await client.columnDateTime.insert([first, second, third, nullDateTime]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnDateTime.deleteAll());

  group('Given date time column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnDateTime.findAll();

      expect(result.length, 4);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnDateTime.equals(firstDate);

      expect(result.first.aDateTime, firstDate);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnDateTime.equals(null);

      expect(result.first.aDateTime, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.notEquals(firstDate);

      // NULL is considered an "unknown" value in Postgres and therefore
      // is not not "firstDate"
      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.notEquals(null);

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.inSet([
        firstDate,
        secondDate,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnDateTime.notInSet([firstDate]);

      // NULL is considered an "unknown" value in Postgres and therefore
      // is not not "firstDate"
      expect(result.length, 2);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.isDistinctFrom(firstDate);

      expect(result.length, 3);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await client.columnDateTime.isNotDistinctFrom(firstDate);

      expect(result.first.aDateTime, firstDate);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.greaterThan(firstDate);

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.greaterOrEqualThan(firstDate);

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.lessThan(thirdDate);

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.lessOrEqualThan(thirdDate);

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await client.columnDateTime.between(firstDate, secondDate);

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result =
          await client.columnDateTime.notBetween(firstDate, secondDate);

      expect(result.first.aDateTime, thirdDate);
    });
  });
}
