import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  var oneString = Types(aString: 'one');
  var twoString = Types(aString: 'two');
  var nullString = Types(aString: null);

  await client.columnStringLegacy.insert([oneString, twoString, nullString]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnStringLegacy.deleteAll());

  group('Given string column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnStringLegacy.findAll();

      expect(result.length, 3);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnStringLegacy.equals('one');

      expect(result.first.aString, 'one');
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnStringLegacy.equals(null);

      expect(result.first.aString, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnStringLegacy.notEquals('one');

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnStringLegacy.notEquals(null);

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnStringLegacy.inSet(['one', 'two']);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnStringLegacy.notInSet(['one']);

      expect(result.length, 2);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await client.columnStringLegacy.like('on%');

      expect(result.length, 1);
      expect(result.first.aString, 'one');
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await client.columnStringLegacy.ilike('On%');

      expect(result.length, 1);
      expect(result.first.aString, 'one');
    });
  });
}
