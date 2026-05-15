import 'dart:typed_data';

import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

const london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
const paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

void main() {
  group('GeographyLineString construction', () {
    test('stores points and default SRID.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(ls.points, [london, paris]);
      expect(ls.srid, 4326);
    });

    test('accepts custom SRID.', () {
      const ls = GeographyLineString(points: [london], srid: 3857);
      expect(ls.srid, 3857);
    });
  });

  group('GeographyLineString.toEwkt', () {
    test('returns EWKT with default SRID.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(
        ls.toEwkt(),
        'SRID=4326;LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
      );
    });

    test('toString returns same as toEwkt.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(ls.toString(), ls.toEwkt());
    });

    test('returns EWKT with custom SRID.', () {
      const ls = GeographyLineString(points: [london, paris], srid: 3857);
      expect(ls.toEwkt(), startsWith('SRID=3857;'));
    });
  });

  group('GeographyLineStringJsonExtension.toJson', () {
    test('returns a String.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(ls.toJson(), isA<String>());
    });

    test('returns EWKT matching toEwkt.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(ls.toJson(), ls.toEwkt());
    });
  });

  group('GeographyLineStringJsonExtension.fromJson', () {
    test('given GeographyLineString returns it unchanged.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(GeographyLineStringJsonExtension.fromJson(ls), same(ls));
    });

    test('given EWKT string parses correctly.', () {
      final ls = GeographyLineStringJsonExtension.fromJson(
        'SRID=4326;LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
      );
      expect(ls.srid, 4326);
      expect(ls.points.length, 2);
      expect(ls.points[0].longitude, -0.1278);
      expect(ls.points[0].latitude, 51.5074);
      expect(ls.points[1].longitude, 2.3522);
      expect(ls.points[1].latitude, 48.8566);
    });

    test('given EWKT with custom SRID parses SRID correctly.', () {
      final ls = GeographyLineStringJsonExtension.fromJson(
        'SRID=3857;LINESTRING(0.0 0.0, 1.0 1.0)',
      );
      expect(ls.srid, 3857);
    });

    test('given Map parses correctly.', () {
      final ls = GeographyLineStringJsonExtension.fromJson({
        'srid': 4326,
        'points': [
          {'longitude': -0.1278, 'latitude': 51.5074},
          {'longitude': 2.3522, 'latitude': 48.8566},
        ],
      });
      expect(ls.srid, 4326);
      expect(ls.points.length, 2);
      expect(ls.points[0], equals(london));
    });

    test('given Map without srid defaults to 4326.', () {
      final ls = GeographyLineStringJsonExtension.fromJson({
        'points': [
          {'longitude': 0.0, 'latitude': 0.0},
        ],
      });
      expect(ls.srid, 4326);
    });

    test('given Uint8List (EWKB) decodes binary representation.', () {
      // Little-endian EWKB for SRID=4326;LINESTRING(0.0 0.0, 1.0 2.0)
      final ewkb = Uint8List.fromList([
        0x01, // LE
        0x02, 0x00, 0x00, 0x20, // LineString | SRID_FLAG
        0xE6, 0x10, 0x00, 0x00, // SRID 4326
        0x02, 0x00, 0x00, 0x00, // numPoints = 2
        // point 1 (0.0, 0.0)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        // point 2 (1.0, 2.0)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40,
      ]);
      final ls = GeographyLineStringJsonExtension.fromJson(ewkb);
      expect(ls.srid, 4326);
      expect(ls.points.length, 2);
      expect(ls.points[0].longitude, 0.0);
      expect(ls.points[0].latitude, 0.0);
      expect(ls.points[1].longitude, 1.0);
      expect(ls.points[1].latitude, 2.0);
    });

    test('given unsupported type throws ArgumentError.', () {
      expect(
        () => GeographyLineStringJsonExtension.fromJson(42),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('GeographyLineString round-trip', () {
    test('toJson then fromJson preserves values.', () {
      const original = GeographyLineString(points: [london, paris]);
      final restored = GeographyLineStringJsonExtension.fromJson(
        original.toJson(),
      );
      expect(restored, equals(original));
    });

    test('round-trip preserves custom SRID.', () {
      const original = GeographyLineString(points: [london, paris], srid: 3857);
      final restored = GeographyLineStringJsonExtension.fromJson(
        original.toJson(),
      );
      expect(restored.srid, 3857);
    });
  });

  group('GeographyLineString equality', () {
    test('two line strings with same points and SRID are equal.', () {
      const a = GeographyLineString(points: [london, paris]);
      const b = GeographyLineString(points: [london, paris]);
      expect(a, equals(b));
    });

    test('two line strings with different points are not equal.', () {
      const a = GeographyLineString(points: [london, paris]);
      const b = GeographyLineString(
        points: [london, GeographyPoint(longitude: 0.0, latitude: 0.0)],
      );
      expect(a, isNot(equals(b)));
    });

    test('two line strings with different SRIDs are not equal.', () {
      const a = GeographyLineString(points: [london], srid: 4326);
      const b = GeographyLineString(points: [london], srid: 3857);
      expect(a, isNot(equals(b)));
    });

    test('equal line strings have the same hashCode.', () {
      const a = GeographyLineString(points: [london, paris]);
      const b = GeographyLineString(points: [london, paris]);
      expect(a.hashCode, b.hashCode);
    });
  });
}
