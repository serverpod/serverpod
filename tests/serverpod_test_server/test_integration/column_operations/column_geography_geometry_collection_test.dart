import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final _london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
final _paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

final _routeLP = GeographyLineString(points: [_london, _paris]);

final _europeBbox = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: -10.0, latitude: 35.0),
    GeographyPoint(longitude: 30.0, latitude: 35.0),
    GeographyPoint(longitude: 30.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 35.0),
  ],
);

final _mixedCollection = GeographyGeometryCollection(
  geometries: [_london, _routeLP, _europeBbox],
);

final _pointsOnly = GeographyGeometryCollection(
  geometries: [_london, _paris],
);

Future<void> _deleteAll(Session session) async {
  await ObjectWithGeographyGeometryCollection.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async => await _deleteAll(session));

  group('Given geography geometry collection column in database', () {
    test('when inserting a row then the row is returned with correct values.',
        () async {
      var inserted = await ObjectWithGeographyGeometryCollection.db.insertRow(
        session,
        ObjectWithGeographyGeometryCollection(collection: _pointsOnly),
      );

      expect(inserted.id, isNotNull);
      expect(inserted.collection.geometries.length, 2);
      expect(inserted.collectionNullable, isNull);
    });

    test(
        'when inserting a mixed collection then all geometry types round-trip.',
        () async {
      var inserted = await ObjectWithGeographyGeometryCollection.db.insertRow(
        session,
        ObjectWithGeographyGeometryCollection(collection: _mixedCollection),
      );

      expect(inserted.collection.geometries.length, 3);
      expect(inserted.collection.geometries[0], isA<GeographyPoint>());
      expect(inserted.collection.geometries[1], isA<GeographyLineString>());
      expect(inserted.collection.geometries[2], isA<GeographyPolygon>());
    });

    test(
        'when inserting a row with a nullable field then it round-trips correctly.',
        () async {
      var inserted = await ObjectWithGeographyGeometryCollection.db.insertRow(
        session,
        ObjectWithGeographyGeometryCollection(
          collection: _pointsOnly,
          collectionNullable: _mixedCollection,
        ),
      );

      expect(inserted.collection.geometries.length, 2);
      expect(inserted.collectionNullable?.geometries.length, 3);
    });

    test('when fetching by id then the correct row is returned.', () async {
      var inserted = await ObjectWithGeographyGeometryCollection.db.insertRow(
        session,
        ObjectWithGeographyGeometryCollection(collection: _mixedCollection),
      );

      var fetched = await ObjectWithGeographyGeometryCollection.db.findById(
        session,
        inserted.id!,
      );

      expect(fetched, isNotNull);
      expect(fetched!.collection.geometries.length, 3);
    });

    test('when updating a row then the new value is persisted.', () async {
      var inserted = await ObjectWithGeographyGeometryCollection.db.insertRow(
        session,
        ObjectWithGeographyGeometryCollection(collection: _pointsOnly),
      );

      var updated = await ObjectWithGeographyGeometryCollection.db.updateRow(
        session,
        inserted.copyWith(collection: _mixedCollection),
      );

      expect(updated.collection.geometries.length, 3);
    });

    test('when inserting multiple rows then all rows are returned.', () async {
      await ObjectWithGeographyGeometryCollection.db.insert(session, [
        ObjectWithGeographyGeometryCollection(collection: _pointsOnly),
        ObjectWithGeographyGeometryCollection(collection: _mixedCollection),
      ]);

      var result = await ObjectWithGeographyGeometryCollection.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 2);
    });

    test('when deleting a row then it is no longer in the database.', () async {
      var inserted = await ObjectWithGeographyGeometryCollection.db.insertRow(
        session,
        ObjectWithGeographyGeometryCollection(collection: _pointsOnly),
      );

      await ObjectWithGeographyGeometryCollection.db.deleteRow(
          session, inserted);

      var fetched = await ObjectWithGeographyGeometryCollection.db.findById(
        session,
        inserted.id!,
      );
      expect(fetched, isNull);
    });

    test(
        'when updating nullable field to null then null is persisted.',
        () async {
      var inserted = await ObjectWithGeographyGeometryCollection.db.insertRow(
        session,
        ObjectWithGeographyGeometryCollection(
          collection: _pointsOnly,
          collectionNullable: _mixedCollection,
        ),
      );

      var updated = await ObjectWithGeographyGeometryCollection.db.updateRow(
        session,
        inserted.copyWith(collectionNullable: null),
      );

      expect(updated.collectionNullable, isNull);
    });
  });
}
