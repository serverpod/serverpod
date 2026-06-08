import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final _london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
final _paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

final _routeLP = GeographyLineString(points: [_london, _paris]);

final _westernEuropeBbox = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: -10.0, latitude: 35.0),
    GeographyPoint(longitude: 25.0, latitude: 35.0),
    GeographyPoint(longitude: 25.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 35.0),
  ],
);

Future<void> _deleteAll(Session session) async {
  await ObjectWithGeographyPoint.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
  await ObjectWithGeographyLineString.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
  await ObjectWithGeographyPolygon.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
  await ObjectWithGeographyGeometryCollection.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async => await _deleteAll(session));

  group('Given a GeographyPoint column in SQLite', () {
    test('when inserting and fetching then the value is round-tripped correctly.',
        () async {
      await ObjectWithGeographyPoint.db.insert(
        session,
        [ObjectWithGeographyPoint(location: _london, locationNullable: null)],
      );

      final result = await ObjectWithGeographyPoint.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 1);
      expect(result.first.location, equals(_london));
      expect(result.first.locationNullable, isNull);
    });

    test(
      'when inserting with nullable field then the nullable value is preserved.',
      () async {
        await ObjectWithGeographyPoint.db.insert(
          session,
          [
            ObjectWithGeographyPoint(
              location: _london,
              locationNullable: _paris,
            ),
          ],
        );

        final result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (_) => Constant.bool(true),
        );

        expect(result.first.locationNullable, equals(_paris));
      },
    );

    test(
      'when using intersects then an exception is thrown.',
      () async {
        await ObjectWithGeographyPoint.db.insert(
          session,
          [ObjectWithGeographyPoint(location: _london, locationNullable: null)],
        );

        await expectLater(
          ObjectWithGeographyPoint.db.find(
            session,
            where: (t) => t.location.intersects(_westernEuropeBbox),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when using distanceWithin then an exception is thrown.',
      () async {
        await ObjectWithGeographyPoint.db.insert(
          session,
          [ObjectWithGeographyPoint(location: _london, locationNullable: null)],
        );

        await expectLater(
          ObjectWithGeographyPoint.db.find(
            session,
            where: (t) => t.location.distanceWithin(_paris, 500000),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when ordering by distance then an exception is thrown.',
      () async {
        await ObjectWithGeographyPoint.db.insert(
          session,
          [ObjectWithGeographyPoint(location: _london, locationNullable: null)],
        );

        await expectLater(
          ObjectWithGeographyPoint.db.find(
            session,
            orderBy: (t) => t.location.distance(_paris),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('Given a GeographyLineString column in SQLite', () {
    test(
      'when inserting and fetching then the value is round-tripped correctly.',
      () async {
        await ObjectWithGeographyLineString.db.insert(
          session,
          [
            ObjectWithGeographyLineString(
              lineString: _routeLP,
              lineStringNullable: null,
            ),
          ],
        );

        final result = await ObjectWithGeographyLineString.db.find(
          session,
          where: (_) => Constant.bool(true),
        );

        expect(result.length, 1);
        expect(result.first.lineString, equals(_routeLP));
        expect(result.first.lineStringNullable, isNull);
      },
    );
  });

  group('Given a GeographyPolygon column in SQLite', () {
    test(
      'when inserting and fetching then the value is round-tripped correctly.',
      () async {
        await ObjectWithGeographyPolygon.db.insert(
          session,
          [
            ObjectWithGeographyPolygon(
              polygon: _westernEuropeBbox,
              polygonNullable: null,
            ),
          ],
        );

        final result = await ObjectWithGeographyPolygon.db.find(
          session,
          where: (_) => Constant.bool(true),
        );

        expect(result.length, 1);
        expect(result.first.polygon, equals(_westernEuropeBbox));
        expect(result.first.polygonNullable, isNull);
      },
    );
  });

  group('Given a GeographyGeometryCollection column in SQLite', () {
    test(
      'when inserting and fetching then the value is round-tripped correctly.',
      () async {
        final collection = GeographyGeometryCollection(
          geometries: [_london, _routeLP],
        );

        await ObjectWithGeographyGeometryCollection.db.insert(
          session,
          [
            ObjectWithGeographyGeometryCollection(
              collection: collection,
              collectionNullable: null,
            ),
          ],
        );

        final result = await ObjectWithGeographyGeometryCollection.db.find(
          session,
          where: (_) => Constant.bool(true),
        );

        expect(result.length, 1);
        expect(result.first.collection.geometries.length, 2);
        expect(result.first.collectionNullable, isNull);
      },
    );
  });
}
