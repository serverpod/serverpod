import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
final paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

final routeLondonParis = GeographyLineString(points: [london, paris]);

final westernEuropeBbox = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: -10.0, latitude: 35.0),
    GeographyPoint(longitude: 25.0, latitude: 35.0),
    GeographyPoint(longitude: 25.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 35.0),
  ],
);

final collection = GeographyGeometryCollection(geometries: [london, paris]);

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(
      aGeographyPoint: london,
      aGeographyLineString: routeLondonParis,
      aGeographyPolygon: westernEuropeBbox,
      aGeographyGeometryCollection: collection,
    ),
    Types(aGeographyPoint: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given geography columns stored as text in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 2);
    });

    test(
      'when reading geography columns then the stored values round-trip.',
      () async {
        var result = await Types.db.find(
          session,
          where: (_) => Constant.bool(true),
        );

        var row = result.firstWhere((r) => r.aGeographyPoint != null);
        expect(row.aGeographyPoint, equals(london));
        expect(row.aGeographyLineString, equals(routeLondonParis));
        expect(row.aGeographyPolygon, equals(westernEuropeBbox));
        expect(row.aGeographyGeometryCollection!.geometries.length, 2);
      },
    );

    test('when using intersects then an exception is thrown.', () async {
      await expectLater(
        Types.db.find(
          session,
          where: (t) => t.aGeographyPoint.intersects(westernEuropeBbox),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('when using distanceWithin then an exception is thrown.', () async {
      await expectLater(
        Types.db.find(
          session,
          where: (t) => t.aGeographyPoint.distanceWithin(paris, 500000),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('when ordering by distance then an exception is thrown.', () async {
      await expectLater(
        Types.db.find(
          session,
          orderBy: (t) => t.aGeographyPoint.distance(paris),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
