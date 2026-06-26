import 'package:serverpod_serialization/src/postgis.dart';
import 'package:test/test.dart';

const london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
const paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

void main() {
  group('Given a GeographyLineString created with points', () {
    const lineString = GeographyLineString(points: [london, paris]);

    test('when getting the points then they match the input.', () {
      expect(lineString.points, [london, paris]);
    });

    test('when getting the SRID then it defaults to 4326.', () {
      expect(lineString.srid, Geography.defaultSrid);
    });

    test(
      'when converted to EWKT then it matches the SRID and LINESTRING string.',
      () {
        expect(
          lineString.toEwkt(),
          'SRID=4326;LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
        );
      },
    );

    test('when converted to a string then it matches the EWKT.', () {
      expect(lineString.toString(), lineString.toEwkt());
    });
  });

  group('Given a GeographyLineString created with a custom SRID', () {
    const lineString = GeographyLineString(points: [london, paris], srid: 3857);

    test('when getting the SRID then it matches the custom value.', () {
      expect(lineString.srid, 3857);
    });

    test(
      'when converted to EWKT then it matches the custom SRID and LINESTRING '
      'string.',
      () {
        expect(
          lineString.toEwkt(),
          'SRID=3857;LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
        );
      },
    );
  });

  group('Given two GeographyLineStrings with the same points and SRID', () {
    const a = GeographyLineString(points: [london, paris]);
    const b = GeographyLineString(points: [london, paris]);

    test('when compared then they are equal.', () {
      expect(a, equals(b));
    });

    test('when getting their hashCodes then they match.', () {
      expect(a.hashCode, b.hashCode);
    });
  });

  group('Given two GeographyLineStrings that differ', () {
    test('when the points differ then they are not equal.', () {
      const a = GeographyLineString(points: [london, paris]);
      const b = GeographyLineString(
        points: [london, GeographyPoint(longitude: 0.0, latitude: 0.0)],
      );
      expect(a, isNot(equals(b)));
    });

    test('when the SRID differs then they are not equal.', () {
      const a = GeographyLineString(points: [london], srid: 4326);
      const b = GeographyLineString(points: [london], srid: 3857);
      expect(a, isNot(equals(b)));
    });
  });
}
