import 'dart:typed_data';

import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

void main() {
  group('Given a GeographyPoint', () {
    test(
      'when constructed with longitude and latitude then values and default SRID are stored.',
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

  group('Given a GeographyPoint is converted to a string', () {
    test('when toString is called then EWKT with SRID=4326 is returned.', () {
      const p = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
      expect(p.toString(), 'SRID=4326;POINT(-0.1278 51.5074)');
    });

    test(
      'when toString is called with custom SRID then EWKT with that SRID is returned.',
      () {
        const p = GeographyPoint(
          longitude: 2.3522,
          latitude: 48.8566,
          srid: 3857,
        );
        expect(p.toString(), 'SRID=3857;POINT(2.3522 48.8566)');
      },
    );
  });

  group('Given a GeographyPoint is serialized', () {
    test('when toJson is called then a String is returned.', () {
      const p = GeographyPoint(longitude: 1.0, latitude: 2.0);
      expect(p.toJson(), isA<String>());
    });

    test('when toJson is called then EWKT matching toString is returned.', () {
      const p = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
      expect(p.toJson(), p.toString());
    });
  });

  group('Given GeographyPointJsonExtension.fromJson', () {
    test(
      'when called with a GeographyPoint then it is returned unchanged.',
      () {
        const p = GeographyPoint(longitude: 1.0, latitude: 2.0);
        expect(GeographyPointJsonExtension.fromJson(p), same(p));
      },
    );

    test('when called with an EWKT string then it parses correctly.', () {
      final p = GeographyPointJsonExtension.fromJson(
        'SRID=4326;POINT(-0.1278 51.5074)',
      );
      expect(p.longitude, -0.1278);
      expect(p.latitude, 51.5074);
      expect(p.srid, 4326);
    });

    test(
      'when called with an EWKT string with custom SRID then it parses correctly.',
      () {
        final p = GeographyPointJsonExtension.fromJson(
          'SRID=3857;POINT(2.3522 48.8566)',
        );
        expect(p.longitude, 2.3522);
        expect(p.latitude, 48.8566);
        expect(p.srid, 3857);
      },
    );

    test('when called with a Map then it parses correctly.', () {
      final p = GeographyPointJsonExtension.fromJson({
        'longitude': -74.006,
        'latitude': 40.7128,
        'srid': 4326,
      });
      expect(p.longitude, -74.006);
      expect(p.latitude, 40.7128);
      expect(p.srid, 4326);
    });

    test(
      'when called with a Map without srid then it defaults to Geography.defaultSrid.',
      () {
        final p = GeographyPointJsonExtension.fromJson({
          'longitude': 1.0,
          'latitude': 2.0,
        });
        expect(p.srid, Geography.defaultSrid);
      },
    );

    test(
      'when called with a Uint8List (EWKB) then it decodes the binary representation.',
      () {
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
      },
    );

    test(
      'when called with an unsupported type then an ArgumentError is thrown.',
      () {
        expect(
          () => GeographyPointJsonExtension.fromJson(42),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  group('Given a GeographyPoint is serialized to JSON and deserialized', () {
    test('when serialized to JSON and deserialized then all values are preserved.', () {
      const original = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
      final restored = GeographyPointJsonExtension.fromJson(
        original.toJson(),
      );
      expect(restored, equals(original));
    });

    test(
      'when constructed with custom SRID then that SRID is preserved.',
      () {
        const original = GeographyPoint(
          longitude: 0.0,
          latitude: 0.0,
          srid: 3857,
        );
        final restored = GeographyPointJsonExtension.fromJson(
          original.toJson(),
        );
        expect(restored.srid, 3857);
      },
    );
  });

  group('Given two GeographyPoints', () {
    test('when they have the same values then they are equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 1.0, latitude: 2.0);
      expect(a, equals(b));
    });

    test(
      'when they have different latitude then they are not equal.',
      () {
        const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
        const b = GeographyPoint(longitude: 1.0, latitude: 3.0);
        expect(a, isNot(equals(b)));
      },
    );

    test(
      'when they have different longitude then they are not equal.',
      () {
        const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
        const b = GeographyPoint(longitude: 2.0, latitude: 2.0);
        expect(a, isNot(equals(b)));
      },
    );

    test('when they have different SRID then they are not equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0, srid: 4326);
      const b = GeographyPoint(longitude: 1.0, latitude: 2.0, srid: 3857);
      expect(a, isNot(equals(b)));
    });

    test('when they are equal then they have the same hashCode.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 1.0, latitude: 2.0);
      expect(a.hashCode, b.hashCode);
    });
  });
}
