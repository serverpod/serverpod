import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

final firstDuration = const Duration(hours: 10);
final secondDuration = const Duration(hours: 20);
final thirdDuration = const Duration(hours: 30);

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aDuration: firstDuration),
    Types(aDuration: secondDuration),
    Types(aDuration: thirdDuration),
    Types(aDuration: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given duration column in database', () {
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
        where: (t) => t.aDuration.equals(firstDuration),
      );

      expect(result.first.aDuration, firstDuration);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration.equals(null),
      );

      expect(result.first.aDuration, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration.notEquals(firstDuration),
      );

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration.notEquals(null),
      );

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration.inSet({firstDuration, secondDuration}),
      );

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration.notInSet({firstDuration}),
      );

      expect(result.length, 3);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration > firstDuration,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration >= firstDuration,
      );

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration < thirdDuration,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration <= thirdDuration,
      );

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration.between(firstDuration, secondDuration),
      );

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDuration.notBetween(firstDuration, secondDuration),
      );

      expect(result.first.aDuration, thirdDuration);
    });
  });
}
