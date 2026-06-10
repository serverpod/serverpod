import 'dart:typed_data';

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
  group('Given a GeographyGeometryCollection', () {
    test(
      'when constructed with geometries then they and default SRID 4326 are stored.',
      () {
        const col = GeographyGeometryCollection(
          geometries: [london, routeLP],
        );
        expect(col.geometries.length, 2);
        expect(col.srid, 4326);
      },
    );

    test('when constructed with custom SRID then that SRID is stored.', () {
      const col = GeographyGeometryCollection(
        geometries: [london],
        srid: 3857,
      );
      expect(col.srid, 3857);
    });

    test('when constructed with empty list then geometries is empty.', () {
      const col = GeographyGeometryCollection(geometries: []);
      expect(col.geometries, isEmpty);
    });
  });

  group('Given a GeographyGeometryCollection is converted to a string', () {
    test(
      'when called then returns EWKT starting with SRID and GEOMETRYCOLLECTION.',
      () {
        const col = GeographyGeometryCollection(
          geometries: [london, paris],
        );
        expect(col.toEwkt(), startsWith('SRID=4326;GEOMETRYCOLLECTION('));
        expect(col.toEwkt(), contains('POINT(-0.1278 51.5074)'));
        expect(col.toEwkt(), contains('POINT(2.3522 48.8566)'));
      },
    );

    test(
      'when called then sub-geometries are emitted without their SRID prefix.',
      () {
        const col = GeographyGeometryCollection(geometries: [london]);
        expect(col.toEwkt(), isNot(contains('SRID=4326;POINT')));
      },
    );

    test('when toString is called then returns same as toEwkt.', () {
      const col = GeographyGeometryCollection(geometries: [london]);
      expect(col.toString(), col.toEwkt());
    });
  });

  group('Given a GeographyGeometryCollection is serialized', () {
    test('when called then returns a String.', () {
      const col = GeographyGeometryCollection(geometries: [london]);
      expect(col.toJson(), isA<String>());
    });

    test('when called then returns EWKT matching toEwkt.', () {
      const col = GeographyGeometryCollection(geometries: [london, paris]);
      expect(col.toJson(), col.toEwkt());
    });
  });

  group('Given GeographyGeometryCollectionJsonExtension.fromJson', () {
    test(
      'when called with a GeographyGeometryCollection then it is returned unchanged.',
      () {
        const col = GeographyGeometryCollection(geometries: [london]);
        expect(
          GeographyGeometryCollectionJsonExtension.fromJson(col),
          same(col),
        );
      },
    );

    test(
      'when called with an EWKT string with two points then it parses correctly.',
      () {
        final col = GeographyGeometryCollectionJsonExtension.fromJson(
          'SRID=4326;GEOMETRYCOLLECTION(POINT(-0.1278 51.5074), POINT(2.3522 48.8566))',
        );
        expect(col.srid, 4326);
        expect(col.geometries.length, 2);
        expect(col.geometries[0], isA<GeographyPoint>());
        expect(col.geometries[1], isA<GeographyPoint>());
      },
    );

    test(
      'when called with an EWKT string with mixed types then all types are parsed.',
      () {
        final col = GeographyGeometryCollectionJsonExtension.fromJson(
          'SRID=4326;GEOMETRYCOLLECTION('
          'POINT(-0.1278 51.5074), '
          'LINESTRING(-0.1278 51.5074, 2.3522 48.8566), '
          'POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 0.0))'
          ')',
        );
        expect(col.geometries.length, 3);
        expect(col.geometries[0], isA<GeographyPoint>());
        expect(col.geometries[1], isA<GeographyLineString>());
        expect(col.geometries[2], isA<GeographyPolygon>());
      },
    );

    test(
      'when called with an EWKT string for an empty collection then geometries is empty.',
      () {
        final col = GeographyGeometryCollectionJsonExtension.fromJson(
          'SRID=4326;GEOMETRYCOLLECTION()',
        );
        expect(col.geometries, isEmpty);
      },
    );

    test(
      'when called with a Map with string geometries then it parses correctly.',
      () {
        final col = GeographyGeometryCollectionJsonExtension.fromJson({
          'srid': 4326,
          'geometries': [
            'POINT(-0.1278 51.5074)',
            'LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
          ],
        });
        expect(col.geometries.length, 2);
        expect(col.geometries[0], isA<GeographyPoint>());
        expect(col.geometries[1], isA<GeographyLineString>());
      },
    );

    test(
      'when called with a Map without srid then it defaults to Geography.defaultSrid.',
      () {
        final col = GeographyGeometryCollectionJsonExtension.fromJson({
          'geometries': ['POINT(0.0 0.0)'],
        });
        expect(col.srid, 4326);
      },
    );

    test(
      'when called with a Uint8List (EWKB) with one Point sub-geometry then it decodes correctly.',
      () {
        // LE EWKB for SRID=4326;GEOMETRYCOLLECTION(POINT(1.0 2.0))
        final ewkb = Uint8List.fromList([
          0x01, // LE
          0x07, 0x00, 0x00, 0x20, // GeometryCollection | SRID_FLAG
          0xE6, 0x10, 0x00, 0x00, // SRID 4326
          0x01, 0x00, 0x00, 0x00, // numGeoms = 1
          // sub-geom: POINT(1.0 2.0) without SRID
          0x01, // LE
          0x01, 0x00, 0x00, 0x00, // Point (no SRID flag)
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F, // lon 1.0
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, // lat 2.0
        ]);
        final col = GeographyGeometryCollectionJsonExtension.fromJson(ewkb);
        expect(col.srid, 4326);
        expect(col.geometries.length, 1);
        expect(col.geometries[0], isA<GeographyPoint>());
        final pt = col.geometries[0] as GeographyPoint;
        expect(pt.longitude, 1.0);
        expect(pt.latitude, 2.0);
      },
    );

    test(
      'when called with an unsupported type then an ArgumentError is thrown.',
      () {
        expect(
          () => GeographyGeometryCollectionJsonExtension.fromJson(42),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  group(
    'Given a GeographyGeometryCollection is serialized to JSON and deserialized',
    () {
      test(
        'when serialized to JSON and deserialized then point sub-geometries are preserved.',
        () {
          const original = GeographyGeometryCollection(
            geometries: [london, paris],
          );
          final restored = GeographyGeometryCollectionJsonExtension.fromJson(
            original.toJson(),
          );
          expect(restored.geometries.length, 2);
          expect(restored.geometries[0], isA<GeographyPoint>());
          expect(restored.geometries[0], equals(london));
        },
      );

      test(
        'when serialized with mixed types and deserialized then all sub-geometry types are preserved.',
        () {
          const original = GeographyGeometryCollection(
            geometries: [london, routeLP, squarePolygon],
          );
          final restored = GeographyGeometryCollectionJsonExtension.fromJson(
            original.toJson(),
          );
          expect(restored.geometries.length, 3);
          expect(restored.geometries[0], isA<GeographyPoint>());
          expect(restored.geometries[1], isA<GeographyLineString>());
          expect(restored.geometries[2], isA<GeographyPolygon>());
        },
      );

      test(
        'when serialized with custom SRID and deserialized then that SRID is preserved.',
        () {
          const original = GeographyGeometryCollection(
            geometries: [london],
            srid: 3857,
          );
          final restored = GeographyGeometryCollectionJsonExtension.fromJson(
            original.toJson(),
          );
          expect(restored.srid, 3857);
        },
      );
    },
  );

  group('Given two GeographyGeometryCollections', () {
    test(
      'when two collections have the same geometries and SRID then they are equal.',
      () {
        const a = GeographyGeometryCollection(geometries: [london, paris]);
        const b = GeographyGeometryCollection(geometries: [london, paris]);
        expect(a, equals(b));
      },
    );

    test(
      'when two collections have different geometries then they are not equal.',
      () {
        const a = GeographyGeometryCollection(geometries: [london]);
        const b = GeographyGeometryCollection(geometries: [paris]);
        expect(a, isNot(equals(b)));
      },
    );

    test(
      'when two collections have different SRIDs then they are not equal.',
      () {
        const a = GeographyGeometryCollection(geometries: [london], srid: 4326);
        const b = GeographyGeometryCollection(geometries: [london], srid: 3857);
        expect(a, isNot(equals(b)));
      },
    );

    test(
      'when two collections are equal then they have the same hashCode.',
      () {
        const a = GeographyGeometryCollection(geometries: [london, paris]);
        const b = GeographyGeometryCollection(geometries: [london, paris]);
        expect(a.hashCode, b.hashCode);
      },
    );
  });
}
