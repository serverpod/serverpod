import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

final firstBit = Bit.fromString('100');
final secondBit = Bit.fromString('010');
final thirdBit = Bit.fromString('001');
final queryBit = Bit.fromString('111');

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aBit: firstBit),
    Types(aBit: secondBit),
    Types(aBit: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given bit column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test(
        'when ordering by Hamming distance then closest rows are returned first.',
        () async {
      var result = await Types.db.find(
        session,
        orderBy: (t) => t.aBit.distanceHamming(queryBit),
      );

      expect(result.length, 3);
      // The null value should be last when ordering by distance
      expect(result.last.aBit, isNull);
    });

    test(
        'when filtering using closer than with Hamming distance then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBit.distanceHamming(queryBit) < 3.0,
      );

      expect(result.isNotEmpty, true);
    });

    test(
        'when ordering by Jaccard distance then closest rows are returned first.',
        () async {
      var result = await Types.db.find(
        session,
        orderBy: (t) => t.aBit.distanceJaccard(queryBit),
      );

      expect(result.length, 3);
      // The null value should be last when ordering by distance
      expect(result.last.aBit, isNull);
    });

    test(
        'when filtering using closer than with Jaccard distance then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aBit.distanceJaccard(queryBit) < 1.0,
      );

      expect(result.isNotEmpty, true);
    });

    test(
        'when inserting and retrieving a bit vector then the same values are returned.',
        () async {
      await Types.db.insert(session, [Types(aBit: thirdBit)]);

      var result = await Types.db.find(
        session,
        where: (t) => t.aBit.distanceHamming(thirdBit) < 1.0,
      );

      expect(result.length, 1);
      expect(result.first.aBit!.toList(), equals(thirdBit.toList()));
    });
  });
}
