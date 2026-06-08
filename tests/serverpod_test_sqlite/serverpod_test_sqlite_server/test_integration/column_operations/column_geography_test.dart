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

Future<void> _createPointRows(Session session) async {
  await ObjectWithGeographyPoint.db.insert(session, [
    ObjectWithGeographyPoint(location: _london, locationNullable: _paris),
    ObjectWithGeographyPoint(location: _paris, locationNullable: null),
  ]);
}

Future<void> _deletePointRows(Session session) async {
  await ObjectWithGeographyPoint.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

Future<void> _createLineStringRows(Session session) async {
  await ObjectWithGeographyLineString.db.insert(session, [
    ObjectWithGeographyLineString(
      lineString: _routeLP,
      lineStringNullable: null,
    ),
  ]);
}

Future<void> _deleteLineStringRows(Session session) async {
  await ObjectWithGeographyLineString.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

Future<void> _createPolygonRows(Session session) async {
  await ObjectWithGeographyPolygon.db.insert(session, [
    ObjectWithGeographyPolygon(
      polygon: _westernEuropeBbox,
      polygonNullable: null,
    ),
  ]);
}

Future<void> _deletePolygonRows(Session session) async {
  await ObjectWithGeographyPolygon.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

Future<void> _createCollectionRows(Session session) async {
  await ObjectWithGeographyGeometryCollection.db.insert(session, [
    ObjectWithGeographyGeometryCollection(
      collection: GeographyGeometryCollection(geometries: [_london, _routeLP]),
      collectionNullable: null,
    ),
  ]);
}

Future<void> _deleteCollectionRows(Session session) async {
  await ObjectWithGeographyGeometryCollection.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a GeographyPoint column in SQLite', () {
    setUpAll(() async => await _createPointRows(session));
    tearDownAll(() async => await _deletePointRows(session));

    test('when fetching all then all rows are returned.', () async {
      final result = await ObjectWithGeographyPoint.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 2);
      expect(result.first.location, equals(_london));
    });

    test(
      'when fetching with nullable field then the nullable value is preserved.',
      () async {
        final result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (_) => Constant.bool(true),
          orderBy: (t) => t.id,
        );

        expect(result.first.locationNullable, equals(_paris));
        expect(result.last.locationNullable, isNull);
      },
    );

    test(
      'when using intersects then an exception is thrown.',
      () async {
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
        await expectLater(
          ObjectWithGeographyPoint.db.find(
            session,
            orderBy: (t) => t.location.distance(_paris),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when using within then an exception is thrown.',
      () async {
        await expectLater(
          ObjectWithGeographyPoint.db.find(
            session,
            where: (t) => t.location.within(_westernEuropeBbox),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('Given a GeographyLineString column in SQLite', () {
    setUpAll(() async => await _createLineStringRows(session));
    tearDownAll(() async => await _deleteLineStringRows(session));

    test('when fetching all then all rows are returned.', () async {
      final result = await ObjectWithGeographyLineString.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 1);
      expect(result.first.lineString, equals(_routeLP));
    });

    test(
      'when using intersects then an exception is thrown.',
      () async {
        await expectLater(
          ObjectWithGeographyLineString.db.find(
            session,
            where: (t) => t.lineString.intersects(_westernEuropeBbox),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('Given a GeographyPolygon column in SQLite', () {
    setUpAll(() async => await _createPolygonRows(session));
    tearDownAll(() async => await _deletePolygonRows(session));

    test('when fetching all then all rows are returned.', () async {
      final result = await ObjectWithGeographyPolygon.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 1);
      expect(result.first.polygon, equals(_westernEuropeBbox));
    });

    test(
      'when using contains then an exception is thrown.',
      () async {
        await expectLater(
          ObjectWithGeographyPolygon.db.find(
            session,
            where: (t) => t.polygon.contains(_london),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('Given a GeographyGeometryCollection column in SQLite', () {
    setUpAll(() async => await _createCollectionRows(session));
    tearDownAll(() async => await _deleteCollectionRows(session));

    test('when fetching all then all rows are returned.', () async {
      final result = await ObjectWithGeographyGeometryCollection.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 1);
      expect(result.first.collection.geometries.length, 2);
    });

    test(
      'when using intersects then an exception is thrown.',
      () async {
        await expectLater(
          ObjectWithGeographyGeometryCollection.db.find(
            session,
            where: (t) => t.collection.intersects(_westernEuropeBbox),
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
