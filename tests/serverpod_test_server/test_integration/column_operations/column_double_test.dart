import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aDouble: 1.0),
    Types(aDouble: 2.0),
    Types(aDouble: 3.0),
    Types(aDouble: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given double column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 4);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.equals(1.0),
      );

      expect(result.first.aDouble, 1.0);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.equals(null),
      );

      expect(result.first.aDouble, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.notEquals(1.0),
      );

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.notEquals(null),
      );

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.inSet({1.0, 2.0}),
      );

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.notInSet({1.0}),
      );

      expect(result.length, 3);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble > 1.0,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble >= 1.0,
      );

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble < 3.0,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble <= 3.0,
      );

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.between(1.0, 2.0),
      );

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDouble.notBetween(1.0, 2.0),
      );

      expect(result.first.aDouble, 3.0);
    });
  });
}
