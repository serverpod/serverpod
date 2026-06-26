import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
final paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
final berlin = GeographyPoint(longitude: 13.405, latitude: 52.52);
final tokyo = GeographyPoint(longitude: 139.69, latitude: 35.68);

// Bounding box polygon around Western Europe (excludes Tokyo).
final westernEuropeBbox = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: -10.0, latitude: 35.0),
    GeographyPoint(longitude: 25.0, latitude: 35.0),
    GeographyPoint(longitude: 25.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 60.0),
    GeographyPoint(longitude: -10.0, latitude: 35.0),
  ],
);

Future<void> _createTestDatabase(Session session) async {
  await Types.db.insert(session, [
    Types(aGeographyPoint: london),
    Types(aGeographyPoint: paris),
    Types(aGeographyPoint: tokyo),
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

  group('Given geography point column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 4);
    });

    test(
      'when filtering with intersects then points inside the polygon are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aGeographyPoint.intersects(westernEuropeBbox),
        );

        expect(result.length, 2);
        expect(
          result.map((r) => r.aGeographyPoint),
          containsAll([london, paris]),
        );
      },
    );

    test(
      'when filtering with distanceWithin then points within the distance are returned.',
      () async {
        // London–Paris ~344 km; Tokyo is ~9700 km from Paris.
        var result = await Types.db.find(
          session,
          where: (t) => t.aGeographyPoint.distanceWithin(paris, 500000),
        );

        expect(result.length, 2);
        expect(
          result.map((r) => r.aGeographyPoint),
          containsAll([london, paris]),
        );
      },
    );

    test(
      'when ordering by distance then closest rows are returned first.',
      () async {
        // Distance from Berlin: Paris ~878 km, London ~931 km, Tokyo ~8900 km.
        var result = await Types.db.find(
          session,
          orderBy: (t) => t.aGeographyPoint.distance(berlin),
        );

        expect(result.length, 4);
        expect(result.first.aGeographyPoint, equals(paris));
        // The null value should be last when ordering by distance.
        expect(result.last.aGeographyPoint, isNull);
      },
    );

    test(
      'when filtering with within then points inside the polygon are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aGeographyPoint.within(westernEuropeBbox),
        );

        expect(result.length, 2);
        expect(
          result.map((r) => r.aGeographyPoint),
          containsAll([london, paris]),
        );
      },
    );
  });
}
