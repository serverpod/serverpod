import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  var trueBool = Types(aBool: true);
  var falseBool = Types(aBool: false);
  var nullBool = Types(aBool: null);

  await client.columnBoolLegacy.insert([trueBool, falseBool, nullBool]);
}

void main() async {
  var client = Client(serverUrl);

  setUpAll(() async => await _createTestDatabase(client));
  tearDownAll(() async => await client.columnBoolLegacy.deleteAll());

  group('Given bool column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await client.columnBoolLegacy.findAll();

      expect(result.length, 3);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await client.columnBoolLegacy.equals(true);

      expect(result.first.aBool, isTrue);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await client.columnBoolLegacy.equals(null);

      expect(result.first.aBool, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await client.columnBoolLegacy.notEquals(true);

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await client.columnBoolLegacy.notEquals(null);

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await client.columnBoolLegacy.inSet([true, false]);

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await client.columnBoolLegacy.notInSet([true]);

      expect(result.length, 2);
    });
  });
}
