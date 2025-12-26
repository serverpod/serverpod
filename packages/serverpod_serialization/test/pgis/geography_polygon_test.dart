import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given GeographyPolygon with values when created then toString and toWkt work correctly.',
    () {
      var polygon = GeographyPolygon([
        [
          const GeographyPoint(0, 0),
          const GeographyPoint(1, 0),
          const GeographyPoint(1, 1),
          const GeographyPoint(0, 1),
          const GeographyPoint(0, 0),
        ],
      ]);
      expect(
        polygon.toString(),
        equals('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
      );
      expect(
        polygon.toWkt(),
        equals('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
      );
      expect(
        polygon.toWktWithSrid(),
        equals('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
      );
    },
  );

  test(
    'Given GeographyPolygon with decimal values then toString preserves decimal format.',
    () {
      var polygon = GeographyPolygon([
        [
          const GeographyPoint(0.5, 0.5),
          const GeographyPoint(1.5, 0.5),
          const GeographyPoint(1.5, 1.5),
          const GeographyPoint(0.5, 1.5),
          const GeographyPoint(0.5, 0.5),
        ],
      ]);
      expect(
        polygon.toString(),
        equals('POLYGON((0.5 0.5, 1.5 0.5, 1.5 1.5, 0.5 1.5, 0.5 0.5))'),
      );
    },
  );

  test(
    'Given GeographyPolygon with hole when created then toString includes hole.',
    () {
      var polygon = GeographyPolygon(
        [
          // Outer ring
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(4, 0),
            const GeographyPoint(4, 4),
            const GeographyPoint(0, 4),
            const GeographyPoint(0, 0),
          ],
          // Hole
          [
            const GeographyPoint(1, 1),
            const GeographyPoint(3, 1),
            const GeographyPoint(3, 3),
            const GeographyPoint(1, 3),
            const GeographyPoint(1, 1),
          ],
        ],
      );
      expect(
        polygon.toString(),
        contains('POLYGON('),
      );
      expect(polygon.toString(), contains('0 0, 4 0, 4 4, 0 4, 0 0'));
      expect(polygon.toString(), contains('1 1, 3 1, 3 3, 1 3, 1 1'));
    },
  );

  test(
    'Given two GeographyPolygons when comparing then equality works correctly.',
    () {
      var a = GeographyPolygon([
        [
          const GeographyPoint(0, 0),
          const GeographyPoint(1, 0),
          const GeographyPoint(1, 1),
          const GeographyPoint(0, 1),
          const GeographyPoint(0, 0),
        ],
      ]);
      var b = GeographyPolygon([
        [
          const GeographyPoint(0, 0),
          const GeographyPoint(1, 0),
          const GeographyPoint(1, 1),
          const GeographyPoint(0, 1),
          const GeographyPoint(0, 0),
        ],
      ]);
      var c = GeographyPolygon([
        [
          const GeographyPoint(0, 0),
          const GeographyPoint(2, 0),
          const GeographyPoint(2, 2),
          const GeographyPoint(0, 2),
          const GeographyPoint(0, 0),
        ],
      ]);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    },
  );

  test(
    'Given GeographyPolygon when converted to json then round-trip works.',
    () {
      var original = GeographyPolygon([
        [
          const GeographyPoint(0, 0),
          const GeographyPoint(1, 0),
          const GeographyPoint(1, 1),
          const GeographyPoint(0, 1),
          const GeographyPoint(0, 0),
        ],
      ]);
      var json = original.toJson();
      var restored = GeographyPolygon.fromJson(json);

      expect(restored, equals(original));
      expect(restored.rings.length, equals(1));
      expect(restored.rings[0].length, equals(5));
    },
  );

  test(
    'Given WKT string when parsing then GeographyPolygon is created correctly.',
    () {
      var polygon = GeographyPolygon.fromWkt(
        'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))',
      );
      expect(polygon.rings.length, equals(1));
      expect(polygon.rings[0].length, equals(5));
      expect(polygon.rings[0][0].longitude, equals(0));
      expect(polygon.rings[0][0].latitude, equals(0));
    },
  );

  test(
    'Given WKT string with SRID when parsing then GeographyPolygon is created with SRID.',
    () {
      var polygon = GeographyPolygon.fromWkt(
        'SRID=4326;POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))',
      );
      expect(polygon.rings.length, equals(1));
      expect(polygon.srid, equals(4326));
    },
  );

  test(
    'Given GeographyPolygon with custom SRID when converted then SRID is included.',
    () {
      var polygon = GeographyPolygon(
        [
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(1, 0),
            const GeographyPoint(1, 1),
            const GeographyPoint(0, 1),
            const GeographyPoint(0, 0),
          ],
        ],
        srid: 3857,
      );
      expect(
        polygon.toWktWithSrid(),
        equals('SRID=3857;POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
      );
    },
  );
}
