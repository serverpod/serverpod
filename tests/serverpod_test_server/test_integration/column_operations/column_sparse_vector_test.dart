import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

final firstSparseVector = SparseVector.fromMap({1: 1.0}, 3);
final secondSparseVector = SparseVector.fromMap({2: 1.0}, 3);
final thirdSparseVector = SparseVector.fromMap({3: 1.0}, 3);
final querySparseVector = SparseVector.fromMap({1: 0.5, 2: 0.5, 3: 0.5}, 3);

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aSparseVector: firstSparseVector),
    Types(aSparseVector: secondSparseVector),
    Types(aSparseVector: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given sparse vector column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test('when ordering by L2 distance then closest rows are returned first.',
        () async {
      var result = await Types.db.find(
        session,
        orderBy: (t) => t.aSparseVector.distanceL2(querySparseVector),
      );

      expect(result.length, 3);
      // The null value should be last when ordering by distance
      expect(result.last.aSparseVector, isNull);
    });

    test(
        'when filtering using closer than with L2 distance then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aSparseVector.distanceL2(querySparseVector) < 1.0,
      );

      expect(result.isNotEmpty, true);
    });

    test(
        'when ordering by cosine distance then closest rows are returned first.',
        () async {
      var result = await Types.db.find(
        session,
        orderBy: (t) => t.aSparseVector.distanceCosine(querySparseVector),
      );

      expect(result.length, 3);
      // The null value should be last when ordering by distance
      expect(result.last.aSparseVector, isNull);
    });

    test(
        'when filtering using closer than with cosine distance then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aSparseVector.distanceCosine(querySparseVector) < 0.5,
      );

      expect(result.isNotEmpty, true);
    });

    test(
        'when ordering by inner product distance then closest rows are returned first.',
        () async {
      var result = await Types.db.find(
        session,
        orderBy: (t) => t.aSparseVector.distanceInnerProduct(querySparseVector),
      );

      expect(result.length, 3);
      // The null value should be last when ordering by distance
      expect(result.last.aSparseVector, isNull);
    });

    test(
        'when filtering using closer than with inner product distance then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) =>
            t.aSparseVector.distanceInnerProduct(querySparseVector) < 0.5,
      );

      expect(result.isNotEmpty, true);
    });

    test('when ordering by L1 distance then closest rows are returned first.',
        () async {
      var result = await Types.db.find(
        session,
        orderBy: (t) => t.aSparseVector.distanceL1(querySparseVector),
      );

      expect(result.length, 3);
      // The null value should be last when ordering by distance
      expect(result.last.aSparseVector, isNull);
    });

    test(
        'when filtering using closer than with L1 distance then matching rows are returned.',
        () async {
      var result = await Types.db.find(
        session,
        where: (t) => t.aSparseVector.distanceL1(querySparseVector) < 2.0,
      );

      expect(result.isNotEmpty, true);
    });

    test(
        'when inserting and retrieving a sparse vector then the same values are returned.',
        () async {
      await Types.db.insert(session, [Types(aSparseVector: thirdSparseVector)]);

      var result = await Types.db.find(
        session,
        where: (t) => t.aSparseVector.distanceCosine(thirdSparseVector) < 0.01,
      );

      expect(result.length, 1);
      expect(result.first.aSparseVector!.toList(),
          equals(thirdSparseVector.toList()));
    });
  });
}
