import 'dart:typed_data';

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
  group('Given a GeographyPolygon', () {
    test(
      'when constructed with exterior ring then ring, empty holes, and default SRID 4326 are stored.',
      () {
        const poly = GeographyPolygon(exteriorRing: squareRing);
        expect(poly.exteriorRing, squareRing);
        expect(poly.holes, isEmpty);
        expect(poly.srid, 4326);
      },
    );

    test('when constructed with holes then holes are stored.', () {
      const poly = GeographyPolygon(
        exteriorRing: squareRing,
        holes: [holeRing],
      );
      expect(poly.holes.length, 1);
    });

    test('when constructed with custom SRID then that SRID is stored.', () {
      const poly = GeographyPolygon(exteriorRing: squareRing, srid: 3857);
      expect(poly.srid, 3857);
    });
  });

  group('Given a GeographyPolygon is converted to a string', () {
    test(
      'when called on a simple polygon then returns EWKT with SRID=4326.',
      () {
        const poly = GeographyPolygon(exteriorRing: squareRing);
        final ewkt = poly.toEwkt();
        expect(ewkt, startsWith('SRID=4326;POLYGON('));
        expect(ewkt, contains('0.0 0.0'));
        expect(ewkt, contains('1.0 0.0'));
      },
    );

    test('when polygon has a hole then EWKT contains interior ring.', () {
      const poly = GeographyPolygon(
        exteriorRing: squareRing,
        holes: [holeRing],
      );
      // toEwkt joins rings with '), (' (close + comma + space + open).
      final rings = poly.toEwkt().split('), (');
      expect(rings.length, 2, reason: 'EWKT should contain two rings');
    });

    test('when toString is called then returns same as toEwkt.', () {
      const poly = GeographyPolygon(exteriorRing: squareRing);
      expect(poly.toString(), poly.toEwkt());
    });
  });

  group('Given a GeographyPolygon is serialized', () {
    test('when called then returns a String.', () {
      const poly = GeographyPolygon(exteriorRing: squareRing);
      expect(poly.toJson(), isA<String>());
    });

    test('when called then returns EWKT matching toEwkt.', () {
      const poly = GeographyPolygon(exteriorRing: squareRing);
      expect(poly.toJson(), poly.toEwkt());
    });
  });

  group('Given GeographyPolygonJsonExtension.fromJson', () {
    test(
      'when called with a GeographyPolygon then it is returned unchanged.',
      () {
        const poly = GeographyPolygon(exteriorRing: squareRing);
        expect(GeographyPolygonJsonExtension.fromJson(poly), same(poly));
      },
    );

    test(
      'when called with an EWKT string (no holes) then it parses correctly.',
      () {
        final poly = GeographyPolygonJsonExtension.fromJson(
          'SRID=4326;POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 0.0))',
        );
        expect(poly.srid, 4326);
        expect(poly.exteriorRing.length, 4);
        expect(poly.holes, isEmpty);
      },
    );

    test(
      'when called with an EWKT string with a hole then both rings are parsed.',
      () {
        final poly = GeographyPolygonJsonExtension.fromJson(
          'SRID=4326;POLYGON('
          '(0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 0.0), '
          '(0.2 0.2, 0.8 0.2, 0.8 0.8, 0.2 0.2)'
          ')',
        );
        expect(poly.holes.length, 1);
        expect(poly.holes[0].length, 4);
      },
    );

    test('when called with a Map (no holes) then it parses correctly.', () {
      final poly = GeographyPolygonJsonExtension.fromJson({
        'srid': 4326,
        'exteriorRing': [
          {'longitude': 0.0, 'latitude': 0.0},
          {'longitude': 1.0, 'latitude': 0.0},
          {'longitude': 1.0, 'latitude': 1.0},
          {'longitude': 0.0, 'latitude': 0.0},
        ],
        'holes': [],
      });
      expect(poly.srid, 4326);
      expect(poly.exteriorRing.length, 4);
      expect(poly.holes, isEmpty);
    });

    test(
      'when called with a Map without srid then it defaults to Geography.defaultSrid.',
      () {
        final poly = GeographyPolygonJsonExtension.fromJson({
          'exteriorRing': [
            {'longitude': 0.0, 'latitude': 0.0},
            {'longitude': 1.0, 'latitude': 0.0},
            {'longitude': 0.0, 'latitude': 0.0},
          ],
        });
        expect(poly.srid, 4326);
      },
    );

    test(
      'when called with a Uint8List (EWKB) then it decodes the binary representation.',
      () {
        // Little-endian EWKB for SRID=4326;POLYGON((0 0, 1 0, 1 1, 0 0))
        final ewkb = Uint8List.fromList([
          0x01, // LE
          0x03, 0x00, 0x00, 0x20, // Polygon | SRID_FLAG
          0xE6, 0x10, 0x00, 0x00, // SRID 4326
          0x01, 0x00, 0x00, 0x00, // numRings = 1
          0x04, 0x00, 0x00, 0x00, // ring[0] numPoints = 4
          // (0.0, 0.0)
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          // (1.0, 0.0)
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          // (1.0, 1.0)
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
          // (0.0, 0.0) closing point
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        ]);
        final poly = GeographyPolygonJsonExtension.fromJson(ewkb);
        expect(poly.srid, 4326);
        expect(poly.exteriorRing.length, 4);
        expect(poly.holes, isEmpty);
        expect(poly.exteriorRing[0].longitude, 0.0);
        expect(poly.exteriorRing[1].longitude, 1.0);
      },
    );

    test(
      'when called with an unsupported type then an ArgumentError is thrown.',
      () {
        expect(
          () => GeographyPolygonJsonExtension.fromJson(42),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  group('Given a GeographyPolygon is serialized to JSON and deserialized', () {
    test(
      'when serialized to JSON and deserialized then exterior ring and SRID are preserved.',
      () {
        const original = GeographyPolygon(exteriorRing: squareRing);
        final restored = GeographyPolygonJsonExtension.fromJson(
          original.toJson(),
        );
        expect(restored.exteriorRing.length, original.exteriorRing.length);
        expect(restored.srid, original.srid);
      },
    );

    test(
      'when serialized with holes and deserialized then holes are preserved.',
      () {
        const original = GeographyPolygon(
          exteriorRing: squareRing,
          holes: [holeRing],
        );
        final restored = GeographyPolygonJsonExtension.fromJson(
          original.toJson(),
        );
        expect(restored.holes.length, 1);
        expect(restored.holes[0].length, holeRing.length);
      },
    );

    test(
      'when serialized with custom SRID and deserialized then that SRID is preserved.',
      () {
        const original = GeographyPolygon(exteriorRing: squareRing, srid: 3857);
        final restored = GeographyPolygonJsonExtension.fromJson(
          original.toJson(),
        );
        expect(restored.srid, 3857);
      },
    );
  });

  group('Given two GeographyPolygons', () {
    test(
      'when two polygons have the same exterior ring and SRID then they are equal.',
      () {
        const a = GeographyPolygon(exteriorRing: squareRing);
        const b = GeographyPolygon(exteriorRing: squareRing);
        expect(a, equals(b));
      },
    );

    test(
      'when a polygon has a hole and the other does not then they are not equal.',
      () {
        const a = GeographyPolygon(exteriorRing: squareRing);
        const b = GeographyPolygon(
          exteriorRing: squareRing,
          holes: [holeRing],
        );
        expect(a, isNot(equals(b)));
      },
    );

    test('when two polygons have different SRIDs then they are not equal.', () {
      const a = GeographyPolygon(exteriorRing: squareRing, srid: 4326);
      const b = GeographyPolygon(exteriorRing: squareRing, srid: 3857);
      expect(a, isNot(equals(b)));
    });

    test('when two polygons are equal then they have the same hashCode.', () {
      const a = GeographyPolygon(exteriorRing: squareRing);
      const b = GeographyPolygon(exteriorRing: squareRing);
      expect(a.hashCode, b.hashCode);
    });
  });
}
