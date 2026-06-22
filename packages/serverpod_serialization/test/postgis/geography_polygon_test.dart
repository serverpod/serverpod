import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

// A simple closed square: (0,0) -> (1,0) -> (1,1) -> (0,1) -> (0,0)
const squareRing = [
  GeographyPoint(longitude: 0.0, latitude: 0.0),
  GeographyPoint(longitude: 1.0, latitude: 0.0),
  GeographyPoint(longitude: 1.0, latitude: 1.0),
  GeographyPoint(longitude: 0.0, latitude: 1.0),
  GeographyPoint(longitude: 0.0, latitude: 0.0),
];

// A hole inside the square.
const holeRing = [
  GeographyPoint(longitude: 0.2, latitude: 0.2),
  GeographyPoint(longitude: 0.8, latitude: 0.2),
  GeographyPoint(longitude: 0.8, latitude: 0.8),
  GeographyPoint(longitude: 0.2, latitude: 0.8),
  GeographyPoint(longitude: 0.2, latitude: 0.2),
];

void main() {
  group('Given a GeographyPolygon created with an exterior ring', () {
    const polygon = GeographyPolygon(exteriorRing: squareRing);

    test('when getting the exterior ring then it matches the input.', () {
      expect(polygon.exteriorRing, squareRing);
    });

    test('when getting the holes then they are empty.', () {
      expect(polygon.holes, isEmpty);
    });

    test('when getting the SRID then it defaults to 4326.', () {
      expect(polygon.srid, Geography.defaultSrid);
    });

    test(
      'when converted to EWKT then it matches the SRID and POLYGON string.',
      () {
        expect(
          polygon.toEwkt(),
          'SRID=4326;POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))',
        );
      },
    );

    test('when converted to a string then it matches the EWKT.', () {
      expect(polygon.toString(), polygon.toEwkt());
    });
  });

  group('Given a GeographyPolygon created with a hole', () {
    const polygon = GeographyPolygon(
      exteriorRing: squareRing,
      holes: [holeRing],
    );

    test('when getting the holes then the interior ring is stored.', () {
      expect(polygon.holes.length, 1);
      expect(polygon.holes[0], holeRing);
    });

    test(
      'when converted to EWKT then it contains the exterior and interior rings.',
      () {
        expect(
          polygon.toEwkt(),
          'SRID=4326;POLYGON('
          '(0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0), '
          '(0.2 0.2, 0.8 0.2, 0.8 0.8, 0.2 0.8, 0.2 0.2)'
          ')',
        );
      },
    );
  });

  group('Given a GeographyPolygon created with a custom SRID', () {
    const polygon = GeographyPolygon(exteriorRing: squareRing, srid: 3857);

    test('when getting the SRID then it matches the custom value.', () {
      expect(polygon.srid, 3857);
    });

    test('when converted to EWKT then it starts with the custom SRID.', () {
      expect(
        polygon.toEwkt(),
        'SRID=3857;POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))',
      );
    });
  });

  group('Given two GeographyPolygons with the same rings and SRID', () {
    const a = GeographyPolygon(exteriorRing: squareRing);
    const b = GeographyPolygon(exteriorRing: squareRing);

    test('when compared then they are equal.', () {
      expect(a, equals(b));
    });

    test('when getting their hashCodes then they match.', () {
      expect(a.hashCode, b.hashCode);
    });
  });

  group('Given two GeographyPolygons that differ', () {
    test(
      'when one has a hole and the other does not then they are not equal.',
      () {
        const a = GeographyPolygon(exteriorRing: squareRing);
        const b = GeographyPolygon(exteriorRing: squareRing, holes: [holeRing]);
        expect(a, isNot(equals(b)));
      },
    );

    test('when the SRID differs then they are not equal.', () {
      const a = GeographyPolygon(exteriorRing: squareRing, srid: 4326);
      const b = GeographyPolygon(exteriorRing: squareRing, srid: 3857);
      expect(a, isNot(equals(b)));
    });
  });
}
