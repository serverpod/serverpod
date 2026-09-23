import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_serialization/undefined_sentinel.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given typed collection defaults, '
    'when distinguishing omitted arguments, '
    'then nested lists, maps and sets are undefined sentinels.',
    () {
      const List<List<String?>> list = $UndefinedList<List<String?>>();
      const Map<String, List<int>> map = $UndefinedMap<String, List<int>>();
      const Set<Uri> set = $UndefinedSet<Uri>();

      expect(list, isA<UndefinedSentinel>());
      expect(map, isA<UndefinedSentinel>());
      expect(set, isA<UndefinedSentinel>());
    },
  );

  test(
    'Given typed value defaults, '
    'when distinguishing omitted arguments, '
    'then dates, UUIDs, durations and URIs are undefined sentinels.',
    () {
      const DateTime date = $UndefinedDateTime();
      const UuidValue uuid = $UndefinedUuidValue();
      const Duration duration = $UndefinedDuration();
      const Uri uri = $UndefinedUri();

      expect(date, isA<UndefinedSentinel>());
      expect(uuid, isA<UndefinedSentinel>());
      expect(duration, isA<UndefinedSentinel>());
      expect(uri, isA<UndefinedSentinel>());
    },
  );

  test(
    'Given typed vector defaults, '
    'when distinguishing omitted arguments, '
    'then vectors, half vectors, sparse vectors and bits are undefined sentinels.',
    () {
      const Vector vector = $UndefinedVector();
      const HalfVector halfVector = $UndefinedHalfVector();
      const SparseVector sparseVector = $UndefinedSparseVector();
      const Bit bit = $UndefinedBit();

      expect(vector, isA<UndefinedSentinel>());
      expect(halfVector, isA<UndefinedSentinel>());
      expect(sparseVector, isA<UndefinedSentinel>());
      expect(bit, isA<UndefinedSentinel>());
    },
  );

  test(
    'Given typed geography defaults, '
    'when distinguishing omitted arguments, '
    'then points, lines, polygons and collections are undefined sentinels.',
    () {
      const GeographyPoint point = $UndefinedGeographyPoint();
      const GeographyLineString line = $UndefinedGeographyLineString();
      const GeographyPolygon polygon = $UndefinedGeographyPolygon();
      const GeographyGeometryCollection collection =
          $UndefinedGeographyGeometryCollection();

      expect(point, isA<UndefinedSentinel>());
      expect(line, isA<UndefinedSentinel>());
      expect(polygon, isA<UndefinedSentinel>());
      expect(collection, isA<UndefinedSentinel>());
    },
  );

  test(
    'Given an undefined vector argument, '
    'when reading it as a field value, '
    'then it fails instead of behaving like an empty vector.',
    () {
      const Vector vector = $UndefinedVector();

      expect(() => vector.length, throwsUnsupportedError);
    },
  );

  test(
    'Given an undefined geography argument, '
    'when reading it as a field value, '
    'then it fails instead of supplying real coordinates.',
    () {
      const GeographyPoint point = $UndefinedGeographyPoint();

      expect(() => point.latitude, throwsUnsupportedError);
    },
  );

  test(
    'Given an undefined list argument, '
    'when reading it as a field value, '
    'then it fails instead of behaving like an empty list.',
    () {
      const List<String> list = $UndefinedList<String>();

      expect(() => list.length, throwsUnsupportedError);
    },
  );

  test(
    'Given an undefined date argument, '
    'when reading it as a field value, '
    'then it fails instead of supplying a real date.',
    () {
      const DateTime date = $UndefinedDateTime();

      expect(() => date.year, throwsUnsupportedError);
    },
  );
}
