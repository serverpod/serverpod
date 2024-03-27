import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

final firstUuid = UuidValue.fromString('6948DF80-14BD-4E04-8842-7668D9C001F5');
final secondUuid = UuidValue.fromString('4B8302DA-21AD-401F-AF45-1DFD956B80B5');

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aUuid: firstUuid),
    Types(aUuid: secondUuid),
    Types(aUuid: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given uuid column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test('when filtering using equals then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.equals(firstUuid),
      );

      expect(result.first.aUuid, firstUuid);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.equals(null),
      );

      expect(result.first.aUuid, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.notEquals(firstUuid),
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.notEquals(null),
      );

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.inSet({firstUuid, secondUuid}),
      );

      expect(result.length, 2);
    });

    test('when filtering using empty inSet then no rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.inSet({}),
      );

      expect(result, isEmpty);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.notInSet({firstUuid}),
      );

      expect(result.length, 2);
    });

    test('when filtering using empty notInSet then no rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.notInSet({}),
      );

      expect(result.length, 3);
    });
  });
}
