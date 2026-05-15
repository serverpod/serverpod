import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

// Simple bounding-box polygons (closed rings: first == last point).
final _londonBbox = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: -0.5, latitude: 51.3),
    GeographyPoint(longitude: 0.3, latitude: 51.3),
    GeographyPoint(longitude: 0.3, latitude: 51.7),
    GeographyPoint(longitude: -0.5, latitude: 51.7),
    GeographyPoint(longitude: -0.5, latitude: 51.3), // close
  ],
);

final _parisBbox = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: 2.1, latitude: 48.7),
    GeographyPoint(longitude: 2.6, latitude: 48.7),
    GeographyPoint(longitude: 2.6, latitude: 49.0),
    GeographyPoint(longitude: 2.1, latitude: 49.0),
    GeographyPoint(longitude: 2.1, latitude: 48.7), // close
  ],
);

// Polygon with one interior hole (donut).
final _donut = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: -1.0, latitude: 51.0),
    GeographyPoint(longitude: 1.0, latitude: 51.0),
    GeographyPoint(longitude: 1.0, latitude: 52.0),
    GeographyPoint(longitude: -1.0, latitude: 52.0),
    GeographyPoint(longitude: -1.0, latitude: 51.0),
  ],
  holes: [
    [
      GeographyPoint(longitude: -0.3, latitude: 51.3),
      GeographyPoint(longitude: 0.3, latitude: 51.3),
      GeographyPoint(longitude: 0.3, latitude: 51.7),
      GeographyPoint(longitude: -0.3, latitude: 51.7),
      GeographyPoint(longitude: -0.3, latitude: 51.3),
    ],
  ],
);

Future<void> _deleteAll(Session session) async {
  await ObjectWithGeographyPolygon.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async => await _deleteAll(session));

  group('Given geography polygon column in database', () {
    test('when inserting a row then the row is returned with correct values.',
        () async {
      var inserted = await ObjectWithGeographyPolygon.db.insertRow(
        session,
        ObjectWithGeographyPolygon(polygon: _londonBbox),
      );

      expect(inserted.id, isNotNull);
      expect(inserted.polygon, equals(_londonBbox));
      expect(inserted.polygonNullable, isNull);
    });

    test(
        'when inserting a row with a nullable field then it round-trips correctly.',
        () async {
      var inserted = await ObjectWithGeographyPolygon.db.insertRow(
        session,
        ObjectWithGeographyPolygon(
          polygon: _londonBbox,
          polygonNullable: _parisBbox,
        ),
      );

      expect(inserted.polygon, equals(_londonBbox));
      expect(inserted.polygonNullable, equals(_parisBbox));
    });

    test('when fetching by id then the correct row is returned.', () async {
      var inserted = await ObjectWithGeographyPolygon.db.insertRow(
        session,
        ObjectWithGeographyPolygon(polygon: _donut),
      );

      var fetched = await ObjectWithGeographyPolygon.db.findById(
        session,
        inserted.id!,
      );

      expect(fetched, isNotNull);
      // Verify hole count survived the round-trip.
      expect(fetched!.polygon.holes.length, 1);
    });

    test('when updating a row then the new value is persisted.', () async {
      var inserted = await ObjectWithGeographyPolygon.db.insertRow(
        session,
        ObjectWithGeographyPolygon(polygon: _londonBbox),
      );

      var updated = await ObjectWithGeographyPolygon.db.updateRow(
        session,
        inserted.copyWith(polygon: _parisBbox),
      );

      expect(updated.polygon, equals(_parisBbox));

      var fetched = await ObjectWithGeographyPolygon.db.findById(
        session,
        inserted.id!,
      );
      expect(fetched!.polygon, equals(_parisBbox));
    });

    test('when inserting multiple rows then all rows are returned.', () async {
      await ObjectWithGeographyPolygon.db.insert(session, [
        ObjectWithGeographyPolygon(polygon: _londonBbox),
        ObjectWithGeographyPolygon(polygon: _parisBbox),
        ObjectWithGeographyPolygon(polygon: _donut),
      ]);

      var result = await ObjectWithGeographyPolygon.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test('when deleting a row then it is no longer in the database.', () async {
      var inserted = await ObjectWithGeographyPolygon.db.insertRow(
        session,
        ObjectWithGeographyPolygon(polygon: _londonBbox),
      );

      await ObjectWithGeographyPolygon.db.deleteRow(session, inserted);

      var fetched = await ObjectWithGeographyPolygon.db.findById(
        session,
        inserted.id!,
      );
      expect(fetched, isNull);
    });

    test(
        'when filtering by equality then only matching rows are returned.',
        () async {
      await ObjectWithGeographyPolygon.db.insert(session, [
        ObjectWithGeographyPolygon(polygon: _londonBbox),
        ObjectWithGeographyPolygon(polygon: _parisBbox),
      ]);

      var result = await ObjectWithGeographyPolygon.db.find(
        session,
        where: (t) => t.polygon.equals(_londonBbox),
      );

      expect(result.length, 1);
      expect(result.first.polygon, equals(_londonBbox));
    });

    test(
        'when updating nullable field to null then null is persisted.',
        () async {
      var inserted = await ObjectWithGeographyPolygon.db.insertRow(
        session,
        ObjectWithGeographyPolygon(
          polygon: _londonBbox,
          polygonNullable: _parisBbox,
        ),
      );

      var updated = await ObjectWithGeographyPolygon.db.updateRow(
        session,
        inserted.copyWith(polygonNullable: null),
      );

      expect(updated.polygonNullable, isNull);
    });
  });
}
