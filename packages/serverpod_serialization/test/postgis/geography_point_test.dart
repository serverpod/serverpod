import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

void main() {
  group('Given a GeographyPoint created with longitude and latitude', () {
    const point = GeographyPoint(longitude: -0.1278, latitude: 51.5074);

    test('when getting the coordinates then they match the input.', () {
      expect(point.longitude, -0.1278);
      expect(point.latitude, 51.5074);
    });

    test('when getting the SRID then it defaults to 4326.', () {
      expect(point.srid, Geography.defaultSrid);
    });

    test(
      'when converted to EWKT then it matches the SRID and POINT string.',
      () {
        expect(point.toEwkt(), 'SRID=4326;POINT(-0.1278 51.5074)');
      },
    );

    test('when converted to a string then it matches the EWKT.', () {
      expect(point.toString(), point.toEwkt());
    });
  });

  group('Given a GeographyPoint created with a custom SRID', () {
    const point = GeographyPoint(
      longitude: 2.3522,
      latitude: 48.8566,
      srid: 3857,
    );

    test('when getting the SRID then it matches the custom value.', () {
      expect(point.srid, 3857);
    });

    test(
      'when converted to EWKT then it matches the custom SRID and POINT string.',
      () {
        expect(point.toEwkt(), 'SRID=3857;POINT(2.3522 48.8566)');
      },
    );
  });

  group('Given two GeographyPoints with the same coordinates and SRID', () {
    const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
    const b = GeographyPoint(longitude: 1.0, latitude: 2.0);

    test('when compared then they are equal.', () {
      expect(a, equals(b));
    });

    test('when getting their hashCodes then they match.', () {
      expect(a.hashCode, b.hashCode);
    });
  });

  group('Given two GeographyPoints that differ', () {
    test('when the latitude differs then they are not equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 1.0, latitude: 3.0);
      expect(a, isNot(equals(b)));
    });

    test('when the longitude differs then they are not equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0);
      const b = GeographyPoint(longitude: 2.0, latitude: 2.0);
      expect(a, isNot(equals(b)));
    });

    test('when the SRID differs then they are not equal.', () {
      const a = GeographyPoint(longitude: 1.0, latitude: 2.0, srid: 4326);
      const b = GeographyPoint(longitude: 1.0, latitude: 2.0, srid: 3857);
      expect(a, isNot(equals(b)));
    });
  });
}
