import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
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
    Types(aGeographyPolygon: westernEuropeBbox),
    Types(aGeographyPolygon: null),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given geography polygon column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await Types.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 2);
    });

    test(
      'when filtering with contains for a point inside then the polygon row is returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aGeographyPolygon.contains(london),
        );

        expect(result.length, 1);
        expect(result.first.aGeographyPolygon, equals(westernEuropeBbox));
      },
    );

    test(
      'when filtering with contains for a point outside then no rows are returned.',
      () async {
        var result = await Types.db.find(
          session,
          where: (t) => t.aGeographyPolygon.contains(tokyo),
        );

        expect(result, isEmpty);
      },
    );
  });
}
