import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given GeographyMultiPolygon with values when created then toString and toWkt work correctly.',
    () {
      var multiPolygon = GeographyMultiPolygon([
        GeographyPolygon([
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(1, 0),
            const GeographyPoint(1, 1),
            const GeographyPoint(0, 1),
            const GeographyPoint(0, 0),
          ],
        ]),
        GeographyPolygon([
          [
            const GeographyPoint(2, 2),
            const GeographyPoint(3, 2),
            const GeographyPoint(3, 3),
            const GeographyPoint(2, 3),
            const GeographyPoint(2, 2),
          ],
        ]),
      ]);
      expect(
        multiPolygon.toString(),
        equals(
          'MULTIPOLYGON(((0 0, 1 0, 1 1, 0 1, 0 0)),((2 2, 3 2, 3 3, 2 3, 2 2)))',
        ),
      );
      expect(
        multiPolygon.toWkt(),
        equals(
          'MULTIPOLYGON(((0 0, 1 0, 1 1, 0 1, 0 0)),((2 2, 3 2, 3 3, 2 3, 2 2)))',
        ),
      );
      expect(
        multiPolygon.toWktWithSrid(),
        equals(
          'MULTIPOLYGON(((0 0, 1 0, 1 1, 0 1, 0 0)),((2 2, 3 2, 3 3, 2 3, 2 2)))',
        ),
      );
    },
  );

  test(
    'Given GeographyMultiPolygon with decimal values then toString preserves decimal format.',
    () {
      var multiPolygon = GeographyMultiPolygon([
        GeographyPolygon([
          [
            const GeographyPoint(0.5, 0.5),
            const GeographyPoint(1.5, 0.5),
            const GeographyPoint(1.5, 1.5),
            const GeographyPoint(0.5, 1.5),
            const GeographyPoint(0.5, 0.5),
          ],
        ]),
      ]);
      expect(
        multiPolygon.toString(),
        equals('MULTIPOLYGON(((0.5 0.5, 1.5 0.5, 1.5 1.5, 0.5 1.5, 0.5 0.5)))'),
      );
    },
  );

  test(
    'Given GeographyMultiPolygon with single polygon when created then format is correct.',
    () {
      var multiPolygon = GeographyMultiPolygon([
        GeographyPolygon([
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(1, 0),
            const GeographyPoint(1, 1),
            const GeographyPoint(0, 1),
            const GeographyPoint(0, 0),
          ],
        ]),
      ]);
      expect(
        multiPolygon.toString(),
        equals('MULTIPOLYGON(((0 0, 1 0, 1 1, 0 1, 0 0)))'),
      );
    },
  );

  test(
    'Given two GeographyMultiPolygons when comparing then equality works correctly.',
    () {
      var a = GeographyMultiPolygon([
        GeographyPolygon([
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(1, 0),
            const GeographyPoint(1, 1),
            const GeographyPoint(0, 1),
            const GeographyPoint(0, 0),
          ],
        ]),
      ]);
      var b = GeographyMultiPolygon([
        GeographyPolygon([
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(1, 0),
            const GeographyPoint(1, 1),
            const GeographyPoint(0, 1),
            const GeographyPoint(0, 0),
          ],
        ]),
      ]);
      var c = GeographyMultiPolygon([
        GeographyPolygon([
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(2, 0),
            const GeographyPoint(2, 2),
            const GeographyPoint(0, 2),
            const GeographyPoint(0, 0),
          ],
        ]),
      ]);

      expect(a.toString(), equals(b.toString()));
      expect(a.toString(), isNot(equals(c.toString())));
    },
  );

  test(
    'Given GeographyMultiPolygon when converted to json then round-trip works.',
    () {
      var original = GeographyMultiPolygon([
        GeographyPolygon([
          [
            const GeographyPoint(0, 0),
            const GeographyPoint(1, 0),
            const GeographyPoint(1, 1),
            const GeographyPoint(0, 1),
            const GeographyPoint(0, 0),
          ],
        ]),
        GeographyPolygon([
          [
            const GeographyPoint(2, 2),
            const GeographyPoint(3, 2),
            const GeographyPoint(3, 3),
            const GeographyPoint(2, 3),
            const GeographyPoint(2, 2),
          ],
        ]),
      ]);
      var json = original.toJson();
      var restored = GeographyMultiPolygon.fromJson(json);

      expect(restored.toString(), equals(original.toString()));
      expect(restored.polygons.length, equals(2));
    },
  );

  test(
    'Given WKT string when parsing then GeographyMultiPolygon is created correctly.',
    () {
      var multiPolygon = GeographyMultiPolygon.fromWkt(
        'MULTIPOLYGON(((0 0, 1 0, 1 1, 0 1, 0 0)))',
      );
      expect(multiPolygon.polygons.length, equals(1));
      expect(multiPolygon.polygons[0].rings[0].length, equals(5));
    },
  );

  test(
    'Given WKT string with SRID when parsing then GeographyMultiPolygon is created with SRID.',
    () {
      var multiPolygon = GeographyMultiPolygon.fromWkt(
        'SRID=4326;MULTIPOLYGON(((0 0, 1 0, 1 1, 0 1, 0 0)))',
      );
      expect(multiPolygon.polygons.length, equals(1));
      expect(multiPolygon.srid, equals(4326));
    },
  );

  test(
    'Given GeographyMultiPolygon with custom SRID when converted then SRID is included.',
    () {
      var multiPolygon = GeographyMultiPolygon(
        [
          GeographyPolygon([
            [
              const GeographyPoint(0, 0),
              const GeographyPoint(1, 0),
              const GeographyPoint(1, 1),
              const GeographyPoint(0, 1),
              const GeographyPoint(0, 0),
            ],
          ]),
        ],
        srid: 3857,
      );
      expect(
        multiPolygon.toWktWithSrid(),
        equals('SRID=3857;MULTIPOLYGON(((0 0, 1 0, 1 1, 0 1, 0 0)))'),
      );
    },
  );
}
