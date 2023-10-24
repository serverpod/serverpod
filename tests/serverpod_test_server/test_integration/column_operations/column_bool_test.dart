import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnBoolEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, bool? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aBool.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, bool? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aBool.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<bool> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aBool.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<bool> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aBool.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, bool value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aBool.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, bool value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aBool.isNotDistinctFrom(value),
    );
  }
}

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aBool: true),
    Types(aBool: false),
    Types(aBool: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given bool column in database', () {
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
        where: (t) => t.aBool.equals(true),
      );

      expect(result.first.aBool, isTrue);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBool.equals(null),
      );

      expect(result.first.aBool, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBool.notEquals(true),
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBool.notEquals(null),
      );

      expect(result.length, 2);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBool.inSet({true, false}),
      );

      expect(result.length, 2);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBool.notInSet({true}),
      );

      expect(result.length, 2);
    });

    test('when filtering using isDistinctFrom then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBool.isDistinctFrom(true),
      );

      expect(result.length, 2);
    });

    test(
        'when filtering using isNotDistinctFrom then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBool.isNotDistinctFrom(true),
      );

      expect(result.first.aBool, true);
    });
  });
}
