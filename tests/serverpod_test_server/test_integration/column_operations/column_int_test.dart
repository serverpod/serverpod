import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(anInt: 1),
    Types(anInt: 2),
    Types(anInt: 3),
    Types(anInt: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given int column in database', () {
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
        where: (t) => t.anInt.equals(1),
      );

      expect(result.first.anInt, 1);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.equals(null),
      );

      expect(result.first.anInt, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.notEquals(1),
      );

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.notEquals(null),
      );

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.inSet({1, 2}),
      );

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.notInSet({1}),
      );

      expect(result.length, 3);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.isDistinctFrom(1),
      );

      expect(result.length, 3);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.isNotDistinctFrom(1),
      );

      expect(result.first.anInt, 1);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt > 1,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt >= 1,
      );

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt < 3,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt <= 3,
      );

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.between(1, 2),
      );

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anInt.notBetween(1, 2),
      );

      expect(result.first.anInt, 3);
    });
  });
}
