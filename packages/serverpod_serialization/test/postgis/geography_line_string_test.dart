import 'dart:typed_data';

import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

const london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
const paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

void main() {
  group('Given a GeographyLineString', () {
    test(
      'when constructed with points then points and default SRID 4326 are stored.',
      () {
        const ls = GeographyLineString(points: [london, paris]);
        expect(ls.points, [london, paris]);
        expect(ls.srid, 4326);
      },
    );

    test('when constructed with custom SRID then that SRID is stored.', () {
      const ls = GeographyLineString(points: [london], srid: 3857);
      expect(ls.srid, 3857);
    });
  });

  group('Given a GeographyLineString is converted to a string', () {
    test('when called then returns EWKT with SRID=4326.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(
        ls.toEwkt(),
        'SRID=4326;LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
      );
    });

    test('when toString is called then returns same as toEwkt.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(ls.toString(), ls.toEwkt());
    });

    test('when called with custom SRID then returns EWKT with that SRID.', () {
      const ls = GeographyLineString(points: [london, paris], srid: 3857);
      expect(ls.toEwkt(), startsWith('SRID=3857;'));
    });
  });

  group('Given a GeographyLineString is serialized', () {
    test('when called then returns a String.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(ls.toJson(), isA<String>());
    });

    test('when called then returns EWKT matching toEwkt.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(ls.toJson(), ls.toEwkt());
    });
  });

  group('Given GeographyLineStringJsonExtension.fromJson', () {
    test('when called with a GeographyLineString then it is returned unchanged.', () {
      const ls = GeographyLineString(points: [london, paris]);
      expect(GeographyLineStringJsonExtension.fromJson(ls), same(ls));
    });

    test('when called with an EWKT string then it parses correctly.', () {
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

    test('when called with an EWKT string with custom SRID then the SRID is parsed correctly.', () {
      final ls = GeographyLineStringJsonExtension.fromJson(
        'SRID=3857;LINESTRING(0.0 0.0, 1.0 1.0)',
      );
      expect(ls.srid, 3857);
    });

    test('when called with a Map then it parses correctly.', () {
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

    test('when called with a Map without srid then it defaults to Geography.defaultSrid.', () {
      final ls = GeographyLineStringJsonExtension.fromJson({
        'points': [
          {'longitude': 0.0, 'latitude': 0.0},
        ],
      });
      expect(ls.srid, 4326);
    });

    test('when called with a Uint8List (EWKB) then it decodes the binary representation.', () {
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

    test(
      'when called with an unsupported type then an ArgumentError is thrown.',
      () {
        expect(
          () => GeographyLineStringJsonExtension.fromJson(42),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  group('Given a GeographyLineString is serialized to JSON and deserialized', () {
    test(
      'when serialized to JSON and deserialized then all values are preserved.',
      () {
        const original = GeographyLineString(points: [london, paris]);
        final restored = GeographyLineStringJsonExtension.fromJson(
          original.toJson(),
        );
        expect(restored, equals(original));
      },
    );

    test(
      'when serialized with custom SRID and deserialized then that SRID is preserved.',
      () {
        const original = GeographyLineString(
          points: [london, paris],
          srid: 3857,
        );
        final restored = GeographyLineStringJsonExtension.fromJson(
          original.toJson(),
        );
        expect(restored.srid, 3857);
      },
    );
  });

  group('Given two GeographyLineStrings', () {
    test(
      'when two line strings have the same points and SRID then they are equal.',
      () {
        const a = GeographyLineString(points: [london, paris]);
        const b = GeographyLineString(points: [london, paris]);
        expect(a, equals(b));
      },
    );

    test(
      'when two line strings have different points then they are not equal.',
      () {
        const a = GeographyLineString(points: [london, paris]);
        const b = GeographyLineString(
          points: [london, GeographyPoint(longitude: 0.0, latitude: 0.0)],
        );
        expect(a, isNot(equals(b)));
      },
    );

    test(
      'when two line strings have different SRIDs then they are not equal.',
      () {
        const a = GeographyLineString(points: [london], srid: 4326);
        const b = GeographyLineString(points: [london], srid: 3857);
        expect(a, isNot(equals(b)));
      },
    );

    test(
      'when two line strings are equal then they have the same hashCode.',
      () {
        const a = GeographyLineString(points: [london, paris]);
        const b = GeographyLineString(points: [london, paris]);
        expect(a.hashCode, b.hashCode);
      },
    );
  });
}
