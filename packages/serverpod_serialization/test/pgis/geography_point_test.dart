import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given GeographyPoint with values when created then toString and toWkt work correctly.',
    () {
      var point = const GeographyPoint(1.5, 2.5);
      expect(point.toString(), equals('POINT(1.5 2.5)'));
      expect(point.toWkt(), equals('POINT(1.5 2.5)'));
      expect(point.toWktWithSrid(), equals('POINT(1.5 2.5)'));
    },
  );

  test(
    'Given GeographyPoint with integer values then toString preserves integer format.',
    () {
      var point = const GeographyPoint(1, 2);
      expect(point.toString(), equals('POINT(1 2)'));
      expect(point.toWkt(), equals('POINT(1 2)'));
      expect(point.toWktWithSrid(), equals('POINT(1 2)'));
    },
  );

  test(
    'Given two GeographyPoints when comparing then equality works correctly.',
    () {
      var a = const GeographyPoint(1.5, 2.5);
      var b = const GeographyPoint(1.5, 2.5);
      var c = const GeographyPoint(1.5, 2.6);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    },
  );

  test(
    'Given GeographyPoint when converted to json then round-trip works.',
    () {
      var original = const GeographyPoint(1.5, 2.5);
      var json = original.toJson();
      var restored = GeographyPoint.fromJson(json);

      expect(restored, equals(original));
      expect(restored.longitude, equals(1.5));
      expect(restored.latitude, equals(2.5));
    },
  );

  test(
    'Given WKT string when parsing then GeographyPoint is created correctly.',
    () {
      var point = GeographyPoint.fromWkt('POINT(1.5 2.5)');
      expect(point.longitude, equals(1.5));
      expect(point.latitude, equals(2.5));
    },
  );

  test(
    'Given WKT string with SRID when parsing then GeographyPoint is created with SRID.',
    () {
      var point = GeographyPoint.fromWkt('SRID=4326;POINT(1.5 2.5)');
      expect(point.longitude, equals(1.5));
      expect(point.latitude, equals(2.5));
      expect(point.srid, equals(4326));
    },
  );

  test(
    'Given GeographyPoint with custom SRID when converted then SRID is included.',
    () {
      var point = const GeographyPoint(1.5, 2.5, srid: 3857);
      expect(point.toWktWithSrid(), equals('SRID=3857;POINT(1.5 2.5)'));
    },
  );
}
