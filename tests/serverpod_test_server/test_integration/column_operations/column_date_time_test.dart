import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

final firstDate = DateTime.utc(1991, 5, 28);
final secondDate = DateTime.utc(2001, 5, 28);
final thirdDate = DateTime.utc(2011, 5, 28);

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aDateTime: firstDate),
    Types(aDateTime: secondDate),
    Types(aDateTime: thirdDate),
    Types(aDateTime: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given date time column in database', () {
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
        where: (t) => t.aDateTime.equals(firstDate),
      );

      expect(result.first.aDateTime, firstDate);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime.equals(null),
      );

      expect(result.first.aDateTime, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime.notEquals(firstDate),
      );

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime.notEquals(null),
      );

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime.inSet({firstDate, secondDate}),
      );

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime.notInSet({firstDate}),
      );

      expect(result.length, 3);
    });

    test('when filtering using greater than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime > firstDate,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime >= firstDate,
      );

      expect(result.length, 3);
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime < thirdDate,
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime <= thirdDate,
      );

      expect(result.length, 3);
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime.between(firstDate, secondDate),
      );

      expect(result.length, 2);
    });

    test('when filtering using not between then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aDateTime.notBetween(firstDate, secondDate),
      );

      expect(result.first.aDateTime, thirdDate);
    });
  });
}
