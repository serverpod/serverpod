import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';

final firstHalfVector = HalfVector([1.0, 0.0, 0.0]);
final secondHalfVector = HalfVector([0.0, 1.0, 0.0]);
final thirdHalfVector = HalfVector([0.0, 0.0, 1.0]);
final queryHalfVector = HalfVector([0.5, 0.5, 0.5]);

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aHalfVector: firstHalfVector),
    Types(aHalfVector: secondHalfVector),
    Types(aHalfVector: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given half vector column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test(
      'when ordering by L2 distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            orderBy: (t) => t.aHalfVector.distanceL2(queryHalfVector),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when filtering using closer than with L2 distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            where: (t) => t.aHalfVector.distanceL2(queryHalfVector) < 1.0,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when ordering by cosine distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            orderBy: (t) => t.aHalfVector.distanceCosine(queryHalfVector),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when filtering using closer than with cosine distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            where: (t) => t.aHalfVector.distanceCosine(queryHalfVector) < 0.5,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when ordering by inner product distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            orderBy: (t) => t.aHalfVector.distanceInnerProduct(queryHalfVector),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when filtering using closer than with inner product distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            where: (t) =>
                t.aHalfVector.distanceInnerProduct(queryHalfVector) < 0.5,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when ordering by L1 distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            orderBy: (t) => t.aHalfVector.distanceL1(queryHalfVector),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when filtering using closer than with L1 distance then an exception is thrown.',
      () async {
        await expectLater(
          Types.db.find(
            session,
            where: (t) => t.aHalfVector.distanceL1(queryHalfVector) < 2.0,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
