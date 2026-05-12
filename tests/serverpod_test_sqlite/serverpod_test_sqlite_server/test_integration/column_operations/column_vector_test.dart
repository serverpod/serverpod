import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';

final firstVector = Vector([1.0, 0.0, 0.0]);
final secondVector = Vector([0.0, 1.0, 0.0]);
final thirdVector = Vector([0.0, 0.0, 1.0]);
final queryVector = Vector([0.5, 0.5, 0.5]);

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aVector: firstVector),
    Types(aVector: secondVector),
    Types(aVector: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given vector column in database', () {
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
            orderBy: (t) => t.aVector.distanceL2(queryVector),
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
            orderBy: (t) => t.aVector.distanceCosine(queryVector),
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
            where: (t) => t.aVector.distanceCosine(queryVector) < 0.5,
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
            orderBy: (t) => t.aVector.distanceInnerProduct(queryVector),
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
            where: (t) => t.aVector.distanceInnerProduct(queryVector) < 0.5,
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
            orderBy: (t) => t.aVector.distanceL1(queryVector),
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
            where: (t) => t.aVector.distanceL1(queryVector) < 2.0,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
