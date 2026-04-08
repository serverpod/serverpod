import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final _firstDecimal = Decimal.parse('123.45');
final _secondDecimal = Decimal.parse('1');
final _thirdDecimal = Decimal.parse('0');

Future<void> _createTestDatabase(Session session) async {
  await ObjectWithDecimal.db.insert(session, [
    ObjectWithDecimal(
      decimalValue: _firstDecimal,
      decimalValueNull: _firstDecimal,
    ),
    ObjectWithDecimal(
      decimalValue: _secondDecimal,
      decimalValueNull: _secondDecimal,
    ),
    ObjectWithDecimal(
      decimalValue: _thirdDecimal,
      decimalValueNull: _thirdDecimal,
    ),
    ObjectWithDecimal(decimalValue: Decimal.parse('0'), decimalValueNull: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await ObjectWithDecimal.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given Decimal column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await ObjectWithDecimal.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 4);
    });

    test(
      'when filtering using equals then matching row is returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull.equals(_firstDecimal),
        );

        expect(result.first.decimalValueNull, _firstDecimal);
      },
    );

    test(
      'when filtering using equals with null then matching row is returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull.equals(null),
        );

        expect(result.first.decimalValueNull, isNull);
      },
    );

    test(
      'when filtering using notEquals then matching rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull.notEquals(_firstDecimal),
        );

        expect(result.length, 3);
      },
    );

    test(
      'when filtering using notEquals with null then matching rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull.notEquals(null),
        );

        expect(result.length, 3);
      },
    );

    test(
      'when filtering using greater than then matching rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull > _secondDecimal,
        );

        expect(result.length, 1);
      },
    );

    test(
      'when filtering using less than then matching rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull < _firstDecimal,
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using between then matching rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) =>
              t.decimalValueNull.between(_thirdDecimal, _secondDecimal),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using inSet then matching rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) =>
              t.decimalValueNull.inSet({_firstDecimal, _secondDecimal}),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using empty inSet then no rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull.inSet({}),
        );

        expect(result, isEmpty);
      },
    );

    test(
      'when filtering using notInSet then matching rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull.notInSet({_firstDecimal}),
        );

        expect(result.length, 3);
      },
    );

    test(
      'when filtering using empty notInSet then all rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.decimalValueNull.notInSet({}),
        );

        expect(result.length, 4);
      },
    );
  });
}
