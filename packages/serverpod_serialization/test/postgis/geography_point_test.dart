import 'dart:typed_data';

import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

void main() {
  group('GeographyPoint construction', () {
    test(
      'when constructed with longitude and latitude then values and default SRID 4326 are stored.',
      () {
        const p = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
        expect(p.longitude, -0.1278);
        expect(p.latitude, 51.5074);
        expect(p.srid, 4326);
      },
    );

    test('when constructed with custom SRID then that SRID is stored.', () {
      const p = GeographyPoint(longitude: 0, latitude: 0, srid: 3857);
      expect(p.srid, 3857);
    });
  });

  group('GeographyPoint.toString', () {
    test('when called then returns EWKT with SRID=4326.', () {
      const p = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
      expect(p.toString(), 'SRID=4326;POINT(-0.1278 51.5074)');
    });

    test('when called with custom SRID then returns EWKT with that SRID.', () {
      const p = GeographyPoint(
        longitude: 2.3522,
        latitude: 48.8566,
        srid: 3857,
      );
      expect(p.toString(), 'SRID=3857;POINT(2.3522 48.8566)');
    });
  });

  group('GeographyPointJsonExtension.toJson', () {
    test('when called then returns a String.', () {
      const p = GeographyPoint(longitude: 1.0, latitude: 2.0);
      expect(p.toJson(), isA<String>());
    });

    test('when called then returns EWKT matching toString.', () {
      const p = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
      expect(p.toJson(), p.toString());
    });
  });

  group('GeographyPointJsonExtension.fromJson', () {
    test('given GeographyPoint returns it unchanged.', () {
      const p = GeographyPoint(longitude: 1.0, latitude: 2.0);
      expect(GeographyPointJsonExtension.fromJson(p), same(p));
    });

    test('given EWKT string parses correctly.', () {
      final p = GeographyPointJsonExtension.fromJson(
        'SRID=4326;POINT(-0.1278 51.5074)',
      );
      expect(p.longitude, -0.1278);
      expect(p.latitude, 51.5074);
      expect(p.srid, 4326);
    });

    test('given EWKT string with custom SRID parses correctly.', () {
      final p = GeographyPointJsonExtension.fromJson(
        'SRID=3857;POINT(2.3522 48.8566)',
      );
      expect(p.longitude, 2.3522);
      expect(p.latitude, 48.8566);
      expect(p.srid, 3857);
    });

    test('given Map with longitude/latitude/srid parses correctly.', () {
      final p = GeographyPointJsonExtension.fromJson({
        'longitude': -74.006,
        'latitude': 40.7128,
        'srid': 4326,
      });
      expect(p.longitude, -74.006);
      expect(p.latitude, 40.7128);
      expect(p.srid, 4326);
    });

    test('given Map without srid defaults to 4326.', () {
      final p = GeographyPointJsonExtension.fromJson({
        'longitude': 1.0,
        'latitude': 2.0,
      });
      expect(p.srid, 4326);
    });

    test('given Uint8List (EWKB) decodes binary representation.', () {
      // Little-endian EWKB for SRID=4326;POINT(1.0 2.0)
      final ewkb = Uint8List.fromList([
        0x01, // little-endian byte order
        0x01, 0x00, 0x00, 0x20, // type: Point | SRID_FLAG (0x20000001)
        0xE6, 0x10, 0x00, 0x00, // SRID: 4326 in LE
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0xF0,
        0x3F, // lon: 1.0 (IEEE-754 LE)
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x40, // lat: 2.0 (IEEE-754 LE)
      ]);
      final p = GeographyPointJsonExtension.fromJson(ewkb);
      expect(p.longitude, 1.0);
      expect(p.latitude, 2.0);
      expect(p.srid, 4326);
    });

    test('given an unsupported type when fromJson is called then throws ArgumentError.', () {
      expect(
        () => GeographyPointJsonExtension.fromJson(42),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('GeographyPoint round-trip', () {
    test('when serialized to JSON and deserialized then all values are preserved.', () {
      const original = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
      final restored = GeographyPointJsonExtension.fromJson(original.toJson());
      expect(restored, equals(original));
    });

    test('when serialized with custom SRID and deserialized then that SRID is preserved.', () {
      const original = GeographyPoint(
        longitude: 0.0,
        latitude: 0.0,
        srid: 3857,
      );
      final restored = GeographyPointJsonExtension.fromJson(original.toJson());
      expect(restored.srid, 3857);
    });
  });

  group('GeographyPoint equality', () {
    test('when two points have the same values then they are equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 1.0, latitude: 2.0);
      expect(a, equals(b));
    });

    test('when two points have different latitude then they are not equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 1.0, latitude: 3.0);
      expect(a, isNot(equals(b)));
    });

    test('when two points have different longitude then they are not equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 2.0, latitude: 2.0);
      expect(a, isNot(equals(b)));
    });

    test('when two points have different SRID then they are not equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0, srid: 4326);
      const b = GeographyPoint(longitude: 1.0, latitude: 2.0, srid: 3857);
      expect(a, isNot(equals(b)));
    });

    test('when two points are equal then they have the same hashCode.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 1.0, latitude: 2.0);
      expect(a.hashCode, b.hashCode);
    });
  });
}
