import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

const london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
const paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

const routeLP = GeographyLineString(points: [london, paris]);

const squarePolygon = GeographyPolygon(
  exteriorRing: [
    GeographyPoint(longitude: 0.0, latitude: 0.0),
    GeographyPoint(longitude: 1.0, latitude: 0.0),
    GeographyPoint(longitude: 1.0, latitude: 1.0),
    GeographyPoint(longitude: 0.0, latitude: 0.0),
  ],
);

void main() {
  group(
    'Given a GeographyGeometryCollection created with two GeographyPoints',
    () {
      const collection = GeographyGeometryCollection(
        geometries: [london, paris],
      );

      test('when getting the geometries then they match the input.', () {
        expect(collection.geometries, [london, paris]);
      });

      test('when getting the SRID then it defaults to 4326.', () {
        expect(collection.srid, Geography.defaultSrid);
      });

      test(
        'when converted to EWKT then it matches the SRID and GEOMETRYCOLLECTION '
        'string with sub-geometries emitted without their own SRID prefix.',
        () {
          expect(
            collection.toEwkt(),
            'SRID=4326;GEOMETRYCOLLECTION('
            'POINT(-0.1278 51.5074), POINT(2.3522 48.8566)'
            ')',
          );
        },
      );

      test('when converted to a string then it matches the EWKT.', () {
        expect(collection.toString(), collection.toEwkt());
      });
    },
  );

  group(
    'Given a GeographyGeometryCollection created with mixed geometry types',
    () {
      const collection = GeographyGeometryCollection(
        geometries: [london, routeLP, squarePolygon],
      );

      test('when getting the geometries then all types are preserved.', () {
        expect(collection.geometries[0], isA<GeographyPoint>());
        expect(collection.geometries[1], isA<GeographyLineString>());
        expect(collection.geometries[2], isA<GeographyPolygon>());
      });

      test(
        'when converted to EWKT then it nests each geometry without its SRID.',
        () {
          expect(
            collection.toEwkt(),
            'SRID=4326;GEOMETRYCOLLECTION('
            'POINT(-0.1278 51.5074), '
            'LINESTRING(-0.1278 51.5074, 2.3522 48.8566), '
            'POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 0.0))'
            ')',
          );
        },
      );
    },
  );

  group('Given a GeographyGeometryCollection created with a custom SRID', () {
    const collection = GeographyGeometryCollection(
      geometries: [london],
      srid: 3857,
    );

    test('when getting the SRID then it matches the custom value.', () {
      expect(collection.srid, 3857);
    });

    test('when converted to EWKT then it starts with the custom SRID.', () {
      expect(
        collection.toEwkt(),
        'SRID=3857;GEOMETRYCOLLECTION(POINT(-0.1278 51.5074))',
      );
    });
  });

  group('Given a GeographyGeometryCollection created with an empty list', () {
    const collection = GeographyGeometryCollection(geometries: []);

    test('when getting the geometries then they are empty.', () {
      expect(collection.geometries, isEmpty);
    });

    test('when converted to EWKT then it has an empty GEOMETRYCOLLECTION.', () {
      expect(collection.toEwkt(), 'SRID=4326;GEOMETRYCOLLECTION()');
    });
  });

  group('Given two GeographyGeometryCollections with the same geometries and '
      'SRID', () {
    const a = GeographyGeometryCollection(geometries: [london, paris]);
    const b = GeographyGeometryCollection(geometries: [london, paris]);

    test('when compared then they are equal.', () {
      expect(a, equals(b));
    });

    test('when getting their hashCodes then they match.', () {
      expect(a.hashCode, b.hashCode);
    });
  });

  group('Given two GeographyGeometryCollections that differ', () {
    test('when the geometries differ then they are not equal.', () {
      const a = GeographyGeometryCollection(geometries: [london]);
      const b = GeographyGeometryCollection(geometries: [paris]);
      expect(a, isNot(equals(b)));
    });

    test('when the SRID differs then they are not equal.', () {
      const a = GeographyGeometryCollection(geometries: [london], srid: 4326);
      const b = GeographyGeometryCollection(geometries: [london], srid: 3857);
      expect(a, isNot(equals(b)));
    });
  });
}
