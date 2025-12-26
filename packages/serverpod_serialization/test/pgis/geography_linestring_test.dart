import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given GeographyLineString with values when created then toString and toWkt work correctly.',
    () {
      var lineString = GeographyLineString([
        const GeographyPoint(1, 2),
        const GeographyPoint(3, 4),
        const GeographyPoint(5, 6),
      ]);
      expect(lineString.toString(), equals('LINESTRING(1 2, 3 4, 5 6)'));
      expect(lineString.toWkt(), equals('LINESTRING(1 2, 3 4, 5 6)'));
      expect(lineString.toWktWithSrid(), equals('LINESTRING(1 2, 3 4, 5 6)'));
    },
  );

  test(
    'Given GeographyLineString with double values when created then toString and toWkt work correctly.',
    () {
      var lineString = GeographyLineString([
        const GeographyPoint(1.2, 2.3),
        const GeographyPoint(3.4, 4.5),
        const GeographyPoint(5.6, 6.7),
      ]);
      expect(
        lineString.toString(),
        equals('LINESTRING(1.2 2.3, 3.4 4.5, 5.6 6.7)'),
      );
      expect(
        lineString.toWkt(),
        equals('LINESTRING(1.2 2.3, 3.4 4.5, 5.6 6.7)'),
      );
      expect(
        lineString.toWktWithSrid(),
        equals('LINESTRING(1.2 2.3, 3.4 4.5, 5.6 6.7)'),
      );
    },
  );

  test(
    'Given two GeographyLineStrings when comparing then equality works correctly.',
    () {
      var a = GeographyLineString([
        const GeographyPoint(1, 2),
        const GeographyPoint(3, 4),
        const GeographyPoint(5, 6),
      ]);
      var b = GeographyLineString([
        const GeographyPoint(1, 2),
        const GeographyPoint(3, 4),
        const GeographyPoint(5, 6),
      ]);
      var c = GeographyLineString([
        const GeographyPoint(1, 2),
        const GeographyPoint(3, 4),
        const GeographyPoint(5, 7),
      ]);

      expect(a == b, isTrue);
      expect(a == c, isFalse);
    },
  );
}
