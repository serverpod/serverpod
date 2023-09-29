import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

final firstDuration = const Duration(hours: 10);
final secondDuration = const Duration(hours: 20);
final thirdDuration = const Duration(hours: 30);

Future<void> _createTestDatabase(Client client) async {
  var first = Types(aDuration: firstDuration);
  var second = Types(aDuration: secondDuration);
  var third = Types(aDuration: thirdDuration);
  var nullDuration = Types(aDuration: null);

  await client.columnDurationLegacy
      .insert([first, second, third, nullDuration]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnDurationLegacy.deleteAll());

  group('Given duration column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnDurationLegacy.findAll();

      expect(result.length, 4);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnDurationLegacy.equals(firstDuration);

      expect(result.first.aDuration, firstDuration);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnDurationLegacy.equals(null);

      expect(result.first.aDuration, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnDurationLegacy.notEquals(firstDuration);

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnDurationLegacy.notEquals(null);

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnDurationLegacy.inSet([
        firstDuration,
        secondDuration,
      ]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnDurationLegacy.notInSet([firstDuration]);

      expect(result.length, 3);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result =
          await client.columnDurationLegacy.isDistinctFrom(firstDuration);

      expect(result.length, 3);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result =
          await client.columnDurationLegacy.isNotDistinctFrom(firstDuration);

      expect(result.first.aDuration, firstDuration);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await client.columnDurationLegacy.greaterThan(firstDuration);

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result =
          await client.columnDurationLegacy.greaterOrEqualThan(firstDuration);

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await client.columnDurationLegacy.lessThan(thirdDuration);

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result =
          await client.columnDurationLegacy.lessOrEqualThan(thirdDuration);

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await client.columnDurationLegacy
          .between(firstDuration, secondDuration);

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await client.columnDurationLegacy
          .notBetween(firstDuration, secondDuration);

      expect(result.first.aDuration, thirdDuration);
    });
  });
}
