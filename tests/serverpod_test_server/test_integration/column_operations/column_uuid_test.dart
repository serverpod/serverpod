import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnUuidEndpoint extends Endpoint {
  Future<void> insert(Session session, List<Types> types) async {
    for (var type in types) {
      await Types.db.insertRow(session, type);
    }
  }

  Future<int> deleteAll(Session session) async {
    var result =
        await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
    return result.length;
  }

  Future<List<Types>> findAll(Session session) async {
    return await Types.db.find(
      session,
      where: (_) => Constant.bool(true),
    );
  }

  Future<List<Types>> equals(Session session, UuidValue? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aUuid.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, UuidValue? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aUuid.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<UuidValue> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aUuid.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<UuidValue> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aUuid.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, UuidValue value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aUuid.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(
      Session session, UuidValue value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aUuid.isNotDistinctFrom(value),
    );
  }
}

final firstUuid = UuidValue('6948DF80-14BD-4E04-8842-7668D9C001F5');
final secondUuid = UuidValue('4B8302DA-21AD-401F-AF45-1DFD956B80B5');

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

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.notInSet({firstUuid}),
      );

      expect(result.length, 2);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.isDistinctFrom(firstUuid),
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aUuid.isNotDistinctFrom(firstUuid),
      );

      expect(result.first.aUuid, firstUuid);
    });
  });
}
