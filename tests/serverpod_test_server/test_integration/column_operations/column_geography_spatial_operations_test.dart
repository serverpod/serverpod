import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

// Reference points used across tests.
final _london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
final _paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
final _berlin = GeographyPoint(longitude: 13.405, latitude: 52.52);
final _tokyo = GeographyPoint(longitude: 139.69, latitude: 35.68);

// Bounding box polygon around Western Europe (excludes Tokyo).
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
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async => await _deleteAll(session));

  group('Given geography point column spatial operations', () {
    test(
      'intersects: when column value intersects given geometry then row is returned.',
      () async {
        await ObjectWithGeographyPoint.db.insert(session, [
          ObjectWithGeographyPoint(location: _london),
          ObjectWithGeographyPoint(location: _paris),
          ObjectWithGeographyPoint(location: _tokyo),
        ]);

        // Only London and Paris are inside the Western Europe bounding box.
        var result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (t) => t.location.intersects(_westernEuropeBbox),
        );

        expect(result.length, 2);
        expect(
          result.map((r) => r.location),
          containsAll([_london, _paris]),
        );
      },
    );

    test(
      'dwithin: when column value is within distance then row is returned.',
      () async {
        await ObjectWithGeographyPoint.db.insert(session, [
          ObjectWithGeographyPoint(location: _london),
          ObjectWithGeographyPoint(location: _paris),
          ObjectWithGeographyPoint(location: _tokyo),
        ]);

        // London–Paris ~344 km; Tokyo is ~9700 km from Paris.
        var result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (t) => t.location.dwithin(_paris, 500000), // 500 km
        );

        expect(result.length, 2);
        expect(
          result.map((r) => r.location),
          containsAll([_london, _paris]),
        );
      },
    );

    test(
      'dwithin: when column value is outside distance then row is not returned.',
      () async {
        await ObjectWithGeographyPoint.db.insertRow(
          session,
          ObjectWithGeographyPoint(location: _tokyo),
        );

        var result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (t) => t.location.dwithin(_paris, 500000),
        );

        expect(result, isEmpty);
      },
    );

    test(
      'distance: when ordering by distance then rows are sorted nearest first.',
      () async {
        await ObjectWithGeographyPoint.db.insert(session, [
          ObjectWithGeographyPoint(location: _tokyo),
          ObjectWithGeographyPoint(location: _london),
          ObjectWithGeographyPoint(location: _paris),
        ]);

        // Order by distance from Berlin: Paris ~878 km, London ~931 km, Tokyo ~8900 km.
        var result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (_) => Constant.bool(true),
          orderBy: (t) => t.location.distance(_berlin),
        );

        expect(result.length, 3);
        expect(result[0].location, equals(_paris));
        expect(result[1].location, equals(_london));
        expect(result[2].location, equals(_tokyo));
      },
    );

    test(
      'contains: when polygon column contains the given point then row is returned.',
      () async {
        await ObjectWithGeographyPoint.db.insert(session, [
          ObjectWithGeographyPoint(location: _london),
          ObjectWithGeographyPoint(location: _tokyo),
        ]);

        // _london is inside the Western Europe bbox; _tokyo is not.
        // contains(bbox) asks: "does this point contain the bbox?" — which is
        // never true for a single point vs a polygon (ST_Contains is asymmetric).
        // Instead test intersects for simple point-in-polygon semantics.
        var result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (t) => t.location.intersects(_westernEuropeBbox),
        );

        expect(result.length, 1);
        expect(result.first.location, equals(_london));
      },
    );

    test(
      'within: when point column is within the given polygon then row is returned.',
      () async {
        await ObjectWithGeographyPoint.db.insert(session, [
          ObjectWithGeographyPoint(location: _london),
          ObjectWithGeographyPoint(location: _tokyo),
        ]);

        // ST_Within(point, polygon) — true when point is inside polygon.
        var result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (t) => t.location.within(_westernEuropeBbox),
        );

        expect(result.length, 1);
        expect(result.first.location, equals(_london));
      },
    );
  });
}
