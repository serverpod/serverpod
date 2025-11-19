import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

var _firstUri = Uri.parse('http://serverpod.dev');
var _secondUri = Uri.parse('http://docs.serverpod.dev');

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aUri: _firstUri),
    Types(aUri: _secondUri),
    Types(aUri: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given Uri column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test(
      'when filtering using equals then matching row is returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.equals(_firstUri),
        );

        expect(result.first.aUri, _firstUri);
      },
    );

    test(
      'when filtering using equals with null then matching row is returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.equals(null),
        );

        expect(result.first.aUri, isNull);
      },
    );

    test(
      'when filtering using notEquals then matching rows are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.notEquals(_firstUri),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using notEquals with null then matching rows are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.notEquals(null),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using inSet then matching rows are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.inSet({_firstUri, _secondUri}),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using empty inSet then no rows are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.inSet({}),
        );

        expect(result, isEmpty);
      },
    );

    test(
      'when filtering using notInSet then matching row is returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.notInSet({_firstUri}),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using empty notInSet then no rows are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aUri.notInSet({}),
        );

        expect(result.length, 3);
      },
    );
  });
}
