import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final _firstBigInt = BigInt.parse('12345678901234567890');
final _secondBigInt = BigInt.one;
final _thirdBigInt = BigInt.zero;

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aBigInt: _firstBigInt),
    Types(aBigInt: _secondBigInt),
    Types(aBigInt: _thirdBigInt),
    Types(aBigInt: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given BigInt column in database', () {
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
        where: (t) => t.aBigInt.equals(_firstBigInt),
      );

      expect(result.first.aBigInt, _firstBigInt);
    });

    test('when filtering using equals with null then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBigInt.equals(null),
      );

      expect(result.first.aBigInt, isNull);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBigInt.notEquals(_firstBigInt),
      );

      expect(result.length, 3);
    });

    test(
        'when filtering using notEquals with null then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBigInt.notEquals(null),
      );

      expect(result.length, 3);
    });

    test('when filtering using inSet then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBigInt.inSet({_firstBigInt, _secondBigInt}),
      );

      expect(result.length, 2);
    });

    test('when filtering using empty inSet then no rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBigInt.inSet({}),
      );

      expect(result, isEmpty);
    });

    test('when filtering using notInSet then matching row is returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBigInt.notInSet({_firstBigInt}),
      );

      expect(result.length, 3);
    });

    test('when filtering using empty notInSet then all rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBigInt.notInSet({}),
      );

      expect(result.length, 4);
    });
  });
}
