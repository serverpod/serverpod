import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
final paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
final tokyo = GeographyPoint(longitude: 139.69, latitude: 35.68);
final osaka = GeographyPoint(longitude: 135.50, latitude: 34.69);

// A line from London to Paris (Western Europe).
final routeLondonParis = GeographyLineString(points: [london, paris]);

// A line from Tokyo to Osaka (Japan).
final routeTokyoOsaka = GeographyLineString(points: [tokyo, osaka]);

// Bounding box polygon around Western Europe (excludes Japan).
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
    Types(aGeographyLineString: routeLondonParis),
    Types(aGeographyLineString: routeTokyoOsaka),
    Types(aGeographyLineString: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given geography line string column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test(
      'when filtering with intersects then line strings overlapping the polygon are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aGeographyLineString.intersects(westernEuropeBbox),
        );

        expect(result.length, 1);
        expect(result.first.aGeographyLineString, equals(routeLondonParis));
      },
    );

    test(
      'when filtering with distanceWithin then line strings within the distance are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aGeographyLineString.distanceWithin(paris, 500000),
        );

        expect(result.length, 1);
        expect(result.first.aGeographyLineString, equals(routeLondonParis));
      },
    );

    test(
      'when ordering by distance then closest rows are returned first.',
      () async {
        var result = await Types.db.find(
          session,
          orderBy: (t) => t.aGeographyLineString.distance(london),
        );

        expect(result.length, 3);
        expect(result.first.aGeographyLineString, equals(routeLondonParis));
        // The null value should be last when ordering by distance.
        expect(result.last.aGeographyLineString, isNull);
      },
    );
  });
}
