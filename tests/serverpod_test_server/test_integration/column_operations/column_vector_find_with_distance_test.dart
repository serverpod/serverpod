import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

final firstVector = Vector([1.0, 0.0, 0.0]);
final secondVector = Vector([0.0, 1.0, 0.0]);
final thirdVector = Vector([0.0, 0.0, 1.0]);
final queryVector = Vector([0.5, 0.5, 0.5]);

Future<void> _createTestDatabase(Session session) async {
  await ObjectWithVector.db.insert(session, [
    ObjectWithVector(
      vector: firstVector,
      vectorNullable: null,
      vectorIndexedHnsw: firstVector,
      vectorIndexedHnswWithParams: firstVector,
      vectorIndexedIvfflat: firstVector,
      vectorIndexedIvfflatWithParams: firstVector,
    ),
    ObjectWithVector(
      vector: secondVector,
      vectorNullable: secondVector,
      vectorIndexedHnsw: secondVector,
      vectorIndexedHnswWithParams: secondVector,
      vectorIndexedIvfflat: secondVector,
      vectorIndexedIvfflatWithParams: secondVector,
    ),
    ObjectWithVector(
      vector: thirdVector,
      vectorNullable: thirdVector,
      vectorIndexedHnsw: thirdVector,
      vectorIndexedHnswWithParams: thirdVector,
      vectorIndexedIvfflat: thirdVector,
      vectorIndexedIvfflatWithParams: thirdVector,
    ),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await ObjectWithVector.db.deleteWhere(
    session,
    where: (t) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given vector column in database when using findWithDistance', () {
    test('then rows with distances are returned.', () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL2(queryVector),
      );

      expect(result.length, 3);
      expect(result, everyElement(isA<RowWithDistance<ObjectWithVector>>()));

      // Each result should have both row and distance
      for (var item in result) {
        expect(item.row, isNotNull);
        expect(item.row.vector, isNotNull);
        expect(item.distance, isA<double>());
        expect(item.distance, greaterThanOrEqualTo(0));
      }
    });

    test('when ordering by distance then closest rows are returned first.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL2(queryVector),
        orderBy: (t) => t.vector.distanceL2(queryVector),
      );

      expect(result.length, 3);

      // Distances should be in ascending order
      for (int i = 0; i < result.length - 1; i++) {
        expect(
          result[i].distance,
          lessThanOrEqualTo(result[i + 1].distance),
        );
      }
    });

    test('when filtering by distance then only matching rows are returned.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL2(queryVector),
        where: (t) => t.vector.distanceL2(queryVector) < 1.0,
      );

      expect(result, isNotEmpty);

      // All returned items should have distance less than 1.0
      for (var item in result) {
        expect(item.distance, lessThan(1.0));
      }
    });

    test('when limiting results then only specified number of rows are returned.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL2(queryVector),
        limit: 2,
      );

      expect(result.length, 2);
    });

    test('when using offset then specified number of rows are skipped.',
        () async {
      var allResults = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL2(queryVector),
        orderBy: (t) => t.vector.distanceL2(queryVector),
      );

      var resultWithOffset = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL2(queryVector),
        orderBy: (t) => t.vector.distanceL2(queryVector),
        offset: 1,
      );

      expect(resultWithOffset.length, 2);
      expect(resultWithOffset.first.row.id, allResults[1].row.id);
    });

    test('when using cosine distance then distances are computed correctly.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceCosine(queryVector),
        orderBy: (t) => t.vector.distanceCosine(queryVector),
      );

      expect(result.length, 3);

      // Distances should be in ascending order
      for (int i = 0; i < result.length - 1; i++) {
        expect(
          result[i].distance,
          lessThanOrEqualTo(result[i + 1].distance),
        );
      }

      // Cosine distance should be between 0 and 2
      for (var item in result) {
        expect(item.distance, greaterThanOrEqualTo(0));
        expect(item.distance, lessThanOrEqualTo(2));
      }
    });

    test('when using inner product distance then distances are computed correctly.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceInnerProduct(queryVector),
        orderBy: (t) => t.vector.distanceInnerProduct(queryVector),
      );

      expect(result.length, 3);

      // All distances should be valid numbers
      for (var item in result) {
        expect(item.distance, isA<double>());
        expect(item.distance.isFinite, isTrue);
      }
    });

    test('when using L1 distance then distances are computed correctly.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL1(queryVector),
        orderBy: (t) => t.vector.distanceL1(queryVector),
      );

      expect(result.length, 3);

      // Distances should be in ascending order
      for (int i = 0; i < result.length - 1; i++) {
        expect(
          result[i].distance,
          lessThanOrEqualTo(result[i + 1].distance),
        );
      }

      // L1 distance should be non-negative
      for (var item in result) {
        expect(item.distance, greaterThanOrEqualTo(0));
      }
    });

    test('when ordering descending then farthest rows are returned first.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vector.distanceL2(queryVector),
        orderBy: (t) => t.vector.distanceL2(queryVector),
        orderDescending: true,
      );

      expect(result.length, 3);

      // Distances should be in descending order
      for (int i = 0; i < result.length - 1; i++) {
        expect(
          result[i].distance,
          greaterThanOrEqualTo(result[i + 1].distance),
        );
      }
    });

    test('when using nullable vector field then null values are handled.',
        () async {
      var result = await ObjectWithVector.db.findWithDistance(
        session,
        distance: (t) => t.vectorNullable.distanceL2(queryVector),
        orderBy: (t) => t.vectorNullable.distanceL2(queryVector),
      );

      expect(result.length, 3);

      // Result should include rows with null vectors at the end when sorted
      var lastRow = result.last;
      expect(lastRow.row.vectorNullable, isNull);
    });
  });
}
