import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(anEnum: TestEnum.one),
    Types(anEnum: TestEnum.two),
    Types(anEnum: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given enum column in database', () {
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
        where: (t) => t.anEnum.equals(TestEnum.one),
      );

      expect(result.first.anEnum, TestEnum.one);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anEnum.equals(null),
      );

      expect(result.first.anEnum, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anEnum.notEquals(TestEnum.one),
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anEnum.notEquals(null),
      );

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anEnum.inSet({
          TestEnum.one,
          TestEnum.two,
        }),
      );

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.anEnum.notInSet({
          TestEnum.one,
        }),
      );

      expect(result.length, 2);
    });
  });
}
