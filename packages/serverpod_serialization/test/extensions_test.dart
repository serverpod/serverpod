import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test(
    'Given a bool true, when passed to BoolJsonExtension.fromJson, then it returns true',
    () {
      expect(BoolJsonExtension.fromJson(true), isTrue);
    },
  );

  test(
    'Given a bool false, when passed to BoolJsonExtension.fromJson, then it returns false',
    () {
      expect(BoolJsonExtension.fromJson(false), isFalse);
    },
  );

  test(
    'Given an int 1 (SQL boolean true), when passed to BoolJsonExtension.fromJson, then it returns true',
    () {
      expect(BoolJsonExtension.fromJson(1), isTrue);
    },
  );

  test(
    'Given an int 0 (SQL boolean false), when passed to BoolJsonExtension.fromJson, then it returns false',
    () {
      expect(BoolJsonExtension.fromJson(0), isFalse);
    },
  );

  test(
    'Given an int other than 0 or 1, when passed to BoolJsonExtension.fromJson, then it throws a DeserializationTypeNotFoundException',
    () {
      expect(
        () => BoolJsonExtension.fromJson(2),
        throwsA(
          isA<DeserializationTypeNotFoundException>().having(
            (e) => e.message,
            'message',
            'Expected int to be 0 or 1, but got 2',
          ),
        ),
      );
    },
  );

  test(
    'Given an unsupported type, when deserialized to a bool using BoolJsonExtension.fromJson, then it throws a DeserializationTypeNotFoundException',
    () {
      expect(
        () => BoolJsonExtension.fromJson('true'),
        throwsA(isA<DeserializationTypeNotFoundException>()),
      );
    },
  );

  test(
    'Given a JSON-formatted UTC date string, when deserialized and then serialized back to JSON, then it matches the original string',
    () {
      String time = '2024-01-01T00:00:00.000Z';
      DateTime dateTime = DateTimeJsonExtension.fromJson(time);

      expect(
        dateTime.toJson(),
        time,
      );
    },
  );

  test(
    'Given a DateTime object, when passed to DateTimeJsonExtension.fromJson, then it matches the original DateTime',
    () {
      DateTime time = DateTime.parse('2024-01-01T00:00:00.000Z');
      DateTime dateTime = DateTimeJsonExtension.fromJson(time);

      expect(
        dateTime,
        time,
      );
    },
  );

  test(
    'Given a JSON-formatted non-UTC date string, when deserialized and then serialized back to JSON, then it does not match the original string due to precision differences',
    () {
      String time = '2024-01-01T00:00:00.000';
      DateTime dateTime = DateTimeJsonExtension.fromJson(time);

      expect(
        dateTime.toJson(),
        isNot(time),
      );
    },
  );

  test(
    'Given a JSON-formatted integer representing milliseconds, when deserialized then it matches the original time',
    () {
      DateTime time = DateTime.utc(2024, 1, 1, 10, 11, 12, 13);
      int milliseconds = time.millisecondsSinceEpoch;

      DateTime dateTime = DateTimeJsonExtension.fromJson(milliseconds);

      expect(dateTime, time);
    },
  );

  test(
    'Given an integer representing milliseconds, when deserialized to a Duration and then serialized back to milliseconds, then it matches the original integer',
    () {
      int milliseconds = 100000;
      Duration duration = DurationJsonExtension.fromJson(milliseconds);

      expect(
        duration.toJson(),
        milliseconds,
      );
    },
  );

  test(
    'Given a Duration object, when passed to DurationJsonExtension.fromJson, then it remains unchanged',
    () {
      Duration value = const Duration(milliseconds: 100000);
      Duration duration = DurationJsonExtension.fromJson(value);

      expect(
        duration,
        value,
      );
    },
  );

  test(
    'Given a UUID string, when deserialized to a UuidValue and then serialized back to a string, then it matches the original string',
    () {
      String value = '00000000-0000-0000-0000-000000000000';
      UuidValue uuidValue = UuidValueJsonExtension.fromJson(value);

      expect(
        uuidValue.toJson(),
        value,
      );
    },
  );

  test(
    'Given a UuidValue object, when passed to UuidValueJsonExtension.fromJson, then it remains unchanged',
    () {
      UuidValue value = UuidValue.fromString(
        '00000000-0000-0000-0000-000000000000',
      );
      UuidValue uuidValue = UuidValueJsonExtension.fromJson(value);

      expect(
        uuidValue,
        value,
      );
    },
  );

  test(
    'Given a Uint8List, when deserialized to a UuidValue and then serialized back to a UuidValue, then it matches the original UuidValue',
    () {
      UuidValue uuidValue = const Uuid().v4obj();
      Uint8List value = uuidValue.toBytes();
      UuidValue uuidValue2 = UuidValueJsonExtension.fromJson(value);

      expect(
        uuidValue2,
        uuidValue,
      );
    },
  );

  test(
    'Given invalid UUID string, when deserialized to a UuidValue, then it throws an exception',
    () {
      String value = 'hello world';
      expect(
        () => UuidValueJsonExtension.fromJson(value),
        throwsA(isA<FormatException>()),
      );
    },
  );
  test(
    'Given a base64-encoded string, when deserialized to ByteData and then serialized back to a string, then it matches the original string',
    () {
      String value = 'decode(\'AAECAwQFBgc=\', \'base64\')';
      ByteData byteData = ByteDataJsonExtension.fromJson(value);

      expect(
        byteData.toJson(),
        value,
      );
    },
  );

  test(
    'Given a ByteData object, when passed to ByteDataJsonExtension.fromJson, then it remains unchanged',
    () {
      String strValue = 'decode(\'AAECAwQFBgc=\', \'base64\')';
      ByteData value = ByteData.view(
        base64Decode(strValue.substring(8, strValue.length - 12)).buffer,
      );
      ByteData byteData = ByteDataJsonExtension.fromJson(value);

      expect(
        byteData,
        value,
      );
    },
  );

  test(
    'Given a Uint8List, when converted to ByteData via ByteDataJsonExtension.fromJson, then the length of ByteData matches the length of Uint8List',
    () {
      String strValue = 'AAECAwQFBgc=';
      Uint8List value = base64Decode(strValue);
      ByteData byteData = ByteDataJsonExtension.fromJson(value);

      expect(
        byteData.lengthInBytes,
        value.length,
      );
    },
  );

  test(
    'Given a Vector object, when serializing to JSON returns a List<double> representation.',
    () {
      Vector vector = const Vector([1.0, 2.0, 3.0]);

      expect(vector.toJson(), isA<List<double>>());
      expect(vector.toJson(), [1.0, 2.0, 3.0]);
    },
  );

  test(
    'Given a string representing a List<double>, when deserialized to a Vector using VectorJsonExtension.fromJson, then it creates a valid Vector.',
    () {
      String listAsString = '[1.0, 2.0, 3.0]';
      Vector vector = VectorJsonExtension.fromJson(listAsString);

      expect(vector.toJson(), [1.0, 2.0, 3.0]);
    },
  );

  test(
    'Given a List<double>, when deserialized to a Vector and then serialized back to a List<double>, then it matches the original list.',
    () {
      List<double> value = [1.0, 2.0, 3.0];
      Vector vector = VectorJsonExtension.fromJson(value);

      expect(vector.toJson(), value);
    },
  );

  test(
    'Given a Uint8List representing a Vector, when deserialized using VectorJsonExtension.fromJson, then it creates a valid Vector.',
    () {
      Vector originalVector = const Vector([1.0, 2.0, 3.0]);
      Vector vector = VectorJsonExtension.fromJson(originalVector.toBinary());

      expect(vector.toJson(), originalVector.toJson());
    },
  );

  test(
    'Given a String representation of a Vector, when deserialized using VectorJsonExtension.fromJson, then it creates a valid Vector.',
    () {
      Vector originalVector = const Vector([1.0, 2.0, 3.0]);
      Vector vector = VectorJsonExtension.fromJson(originalVector.toString());

      expect(originalVector.toString(), '[1.0, 2.0, 3.0]');
      expect(vector.toJson(), originalVector.toJson());
    },
  );

  test(
    'Given a Vector object, when passed to VectorJsonExtension.fromJson, then it remains unchanged.',
    () {
      Vector value = const Vector([1.0, 2.0, 3.0]);
      Vector vector = VectorJsonExtension.fromJson(value);

      expect(vector, value);
    },
  );

  test(
    'Given an unsupported type, when deserialized to a Vector using VectorJsonExtension.fromJson, then it throws a DeserializationTypeNotFoundException.',
    () {
      expect(
        () => VectorJsonExtension.fromJson(123),
        throwsA(isA<DeserializationTypeNotFoundException>()),
      );
    },
  );

  test(
    'Given a HalfVector, serializing to JSON returns a List<double> representation.',
    () {
      HalfVector vector = const HalfVector([1.0, 2.0, 3.0]);

      expect(vector.toJson(), isA<List<double>>());
      expect(vector.toJson(), [1.0, 2.0, 3.0]);
    },
  );

  test(
    'Given a string representing a List<double>, when deserialized to a HalfVector using HalfVectorJsonExtension.fromJson, then it creates a valid HalfVector.',
    () {
      String listAsString = '[1.0, 2.0, 3.0]';
      HalfVector vector = HalfVectorJsonExtension.fromJson(listAsString);

      expect(vector.toJson(), [1.0, 2.0, 3.0]);
    },
  );

  test(
    'Given a List<double>, when deserialized to a HalfVector and then serialized back to a List<double>, then it matches the original list.',
    () {
      List<double> value = [1.0, 2.0, 3.0];
      HalfVector vector = HalfVectorJsonExtension.fromJson(value);

      expect(vector.toJson(), value);
    },
  );

  test(
    'Given a String representation of a HalfVector, when deserialized using HalfVectorJsonExtension.fromJson, then it creates a valid HalfVector.',
    () {
      HalfVector original = const HalfVector([1.0, 2.0, 3.0]);
      HalfVector vector = HalfVectorJsonExtension.fromJson(original.toString());

      expect(original.toString(), '[1.0, 2.0, 3.0]');
      expect(vector.toJson(), original.toJson());
    },
  );

  test(
    'Given a HalfVector object, when passed to HalfVectorJsonExtension.fromJson, then it remains unchanged.',
    () {
      HalfVector value = const HalfVector([1.0, 2.0, 3.0]);
      HalfVector vector = HalfVectorJsonExtension.fromJson(value);

      expect(vector, value);
    },
  );

  test(
    'Given an unsupported type, when deserialized to a HalfVector using HalfVectorJsonExtension.fromJson, then it throws a DeserializationTypeNotFoundException.',
    () {
      expect(
        () => HalfVectorJsonExtension.fromJson(123),
        throwsA(isA<DeserializationTypeNotFoundException>()),
      );
    },
  );

  test(
    'Given a SparseVector, serializing to JSON returns a String representation.',
    () {
      SparseVector vector = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);

      expect(vector.toJson(), isA<String>());
      expect(vector.toJson(), '{1:1.0,3:2.0,5:3.0}/5');
    },
  );

  test(
    'Given a string representing a List<double>, when deserialized to a SparseVector using SparseVectorJsonExtension.fromJson, then it creates a valid SparseVector.',
    () {
      String listAsString = '[1.0, 0.0, 2.0, 0.0, 3.0]';
      SparseVector vector = SparseVectorJsonExtension.fromJson(listAsString);

      expect(vector.toList(), [1.0, 0.0, 2.0, 0.0, 3.0]);
    },
  );

  test(
    'Given a List<double>, when deserialized to a SparseVector and then serialized back to a String, then it matches the expected sparse format.',
    () {
      List<double> value = [1.0, 0.0, 2.0, 0.0, 3.0];
      SparseVector vector = SparseVectorJsonExtension.fromJson(value);

      expect(vector.toJson(), '{1:1.0,3:2.0,5:3.0}/5');
    },
  );

  test(
    'Given a SparseVector special format string, when deserialized using SparseVectorJsonExtension.fromJson, then it creates a valid SparseVector.',
    () {
      String sparseFormat = '{1:1.0,3:2.0,5:3.0}/5';
      SparseVector vector = SparseVectorJsonExtension.fromJson(sparseFormat);

      expect(vector.dimensions, 5);
      expect(vector.toList(), [1.0, 0.0, 2.0, 0.0, 3.0]);
    },
  );

  test(
    'Given a SparseVector object, when passed to SparseVectorJsonExtension.fromJson, then it remains unchanged.',
    () {
      SparseVector value = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);
      SparseVector vector = SparseVectorJsonExtension.fromJson(value);

      expect(vector, value);
    },
  );

  test(
    'Given an unsupported type, when deserialized to a SparseVector using SparseVectorJsonExtension.fromJson, then it throws a DeserializationTypeNotFoundException.',
    () {
      expect(
        () => SparseVectorJsonExtension.fromJson(123),
        throwsA(isA<DeserializationTypeNotFoundException>()),
      );
    },
  );

  test(
    'Given a Bit vector, serializing to JSON returns a String representation.',
    () {
      Bit vector = Bit([true, false, true, false, true]);

      expect(vector.toJson(), isA<String>());
      expect(vector.toJson(), '10101');
    },
  );

  test(
    'Given a list of 1\'s and 0\'s, when deserialized to a Bit using BitJsonExtension.fromJson, then it creates a valid Bit vector.',
    () {
      List<int> value = [1, 0, 1, 0, 1];
      Bit vector = BitJsonExtension.fromJson(value);

      expect(vector.toList(), [true, false, true, false, true]);
    },
  );

  test(
    'Given a string representing a List<bool>, when deserialized to a Bit using BitJsonExtension.fromJson, then it creates a valid Bit vector.',
    () {
      String listAsString = '[true, false, true, false, true]';
      Bit vector = BitJsonExtension.fromJson(listAsString);

      expect(vector.toList(), [true, false, true, false, true]);
    },
  );

  test(
    'Given a List<bool>, when deserialized to a Bit and then serialized back to a String, then it matches the expected bit format.',
    () {
      List<bool> value = [true, false, true, false, true];
      Bit vector = BitJsonExtension.fromJson(value);

      expect(vector.toJson(), '10101');
    },
  );

  test(
    'Given a binary string, when deserialized using BitJsonExtension.fromJson, then it creates a valid Bit vector.',
    () {
      String bitString = '10101';
      Bit vector = BitJsonExtension.fromJson(bitString);

      expect(vector.toList(), [true, false, true, false, true]);
    },
  );

  test(
    'Given a Bit object, when passed to BitJsonExtension.fromJson, then it remains unchanged.',
    () {
      Bit value = Bit([true, false, true, false, true]);
      Bit vector = BitJsonExtension.fromJson(value);

      expect(vector, value);
    },
  );

  test(
    'Given an unsupported type, when deserialized to a Bit using BitJsonExtension.fromJson, then it throws a DeserializationTypeNotFoundException.',
    () {
      expect(
        () => BitJsonExtension.fromJson(123),
        throwsA(isA<DeserializationTypeNotFoundException>()),
      );
    },
  );

  test(
    'Given a GeographyPoint, when serializing to JSON then it returns the EWKT string.',
    () {
      const point = GeographyPoint(longitude: 2.3522, latitude: 48.8566);

      expect(point.toJson(), isA<String>());
      expect(point.toJson(), 'SRID=4326;POINT(2.3522 48.8566)');
    },
  );

  test(
    'Given an EWKT string, when deserialized using GeographyPointJsonExtension.fromJson, then it creates a valid GeographyPoint.',
    () {
      GeographyPoint point = GeographyPointJsonExtension.fromJson(
        'SRID=3857;POINT(2.3522 48.8566)',
      );

      expect(point.longitude, 2.3522);
      expect(point.latitude, 48.8566);
      expect(point.srid, 3857);
    },
  );

  test(
    'Given a Map, when deserialized using GeographyPointJsonExtension.fromJson, then it creates a valid GeographyPoint.',
    () {
      GeographyPoint point = GeographyPointJsonExtension.fromJson({
        'longitude': -74.006,
        'latitude': 40.7128,
        'srid': 4326,
      });

      expect(point.longitude, -74.006);
      expect(point.latitude, 40.7128);
      expect(point.srid, 4326);
    },
  );

  test(
    'Given a Map without srid, when deserialized using GeographyPointJsonExtension.fromJson, then it defaults to Geography.defaultSrid.',
    () {
      GeographyPoint point = GeographyPointJsonExtension.fromJson({
        'longitude': 1.0,
        'latitude': 2.0,
      });

      expect(point.srid, Geography.defaultSrid);
    },
  );

  test(
    'Given a Uint8List (EWKB), when deserialized using GeographyPointJsonExtension.fromJson, then it decodes the binary representation.',
    () {
      // Little-endian EWKB for SRID=4326;POINT(1.0 2.0)
      final ewkb = Uint8List.fromList([
        0x01, // little-endian byte order
        0x01, 0x00, 0x00, 0x20, // type: Point | SRID_FLAG (0x20000001)
        0xE6, 0x10, 0x00, 0x00, // SRID: 4326 in LE
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F, // lon: 1.0
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, // lat: 2.0
      ]);
      GeographyPoint point = GeographyPointJsonExtension.fromJson(ewkb);

      expect(point.longitude, 1.0);
      expect(point.latitude, 2.0);
      expect(point.srid, 4326);
    },
  );

  test(
    'Given a GeographyPoint, when passed to GeographyPointJsonExtension.fromJson, then it remains unchanged.',
    () {
      const value = GeographyPoint(longitude: 1.0, latitude: 2.0);
      GeographyPoint point = GeographyPointJsonExtension.fromJson(value);

      expect(point, same(value));
    },
  );

  test(
    'Given a GeographyPoint, when serialized and deserialized, then all values are preserved.',
    () {
      const original = GeographyPoint(
        longitude: 2.3522,
        latitude: 48.8566,
        srid: 3857,
      );
      GeographyPoint restored = GeographyPointJsonExtension.fromJson(
        original.toJson(),
      );

      expect(restored, equals(original));
    },
  );

  test(
    'Given an unsupported type, when deserialized to a GeographyPoint using GeographyPointJsonExtension.fromJson, then it throws an ArgumentError.',
    () {
      expect(
        () => GeographyPointJsonExtension.fromJson(42),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a GeographyLineString, when serializing to JSON then it returns the EWKT string.',
    () {
      const lineString = GeographyLineString(
        points: [
          GeographyPoint(longitude: -0.1278, latitude: 51.5074),
          GeographyPoint(longitude: 2.3522, latitude: 48.8566),
        ],
      );

      expect(lineString.toJson(), isA<String>());
      expect(
        lineString.toJson(),
        'SRID=4326;LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
      );
    },
  );

  test(
    'Given an EWKT string, when deserialized using GeographyLineStringJsonExtension.fromJson, then it creates a valid GeographyLineString.',
    () {
      GeographyLineString lineString =
          GeographyLineStringJsonExtension.fromJson(
            'SRID=3857;LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
          );

      expect(lineString.srid, 3857);
      expect(lineString.points.length, 2);
      expect(lineString.points[0].longitude, -0.1278);
      expect(lineString.points[1].latitude, 48.8566);
    },
  );

  test(
    'Given a Map, when deserialized using GeographyLineStringJsonExtension.fromJson, then it creates a valid GeographyLineString.',
    () {
      GeographyLineString lineString =
          GeographyLineStringJsonExtension.fromJson({
            'srid': 4326,
            'points': [
              {'longitude': -0.1278, 'latitude': 51.5074},
              {'longitude': 2.3522, 'latitude': 48.8566},
            ],
          });

      expect(lineString.srid, 4326);
      expect(lineString.points.length, 2);
    },
  );

  test(
    'Given a Uint8List (EWKB), when deserialized using GeographyLineStringJsonExtension.fromJson, then it decodes the binary representation.',
    () {
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
      GeographyLineString lineString =
          GeographyLineStringJsonExtension.fromJson(ewkb);

      expect(lineString.srid, 4326);
      expect(lineString.points.length, 2);
      expect(lineString.points[1].longitude, 1.0);
      expect(lineString.points[1].latitude, 2.0);
    },
  );

  test(
    'Given a GeographyLineString, when serialized and deserialized, then all values are preserved.',
    () {
      const original = GeographyLineString(
        points: [
          GeographyPoint(longitude: -0.1278, latitude: 51.5074),
          GeographyPoint(longitude: 2.3522, latitude: 48.8566),
        ],
      );
      GeographyLineString restored = GeographyLineStringJsonExtension.fromJson(
        original.toJson(),
      );

      expect(restored, equals(original));
    },
  );

  test(
    'Given a GeographyLineString with a custom SRID, when serialized and deserialized, then the SRID is preserved.',
    () {
      const original = GeographyLineString(
        points: [
          GeographyPoint(longitude: -0.1278, latitude: 51.5074, srid: 3857),
          GeographyPoint(longitude: 2.3522, latitude: 48.8566, srid: 3857),
        ],
        srid: 3857,
      );
      GeographyLineString restored = GeographyLineStringJsonExtension.fromJson(
        original.toJson(),
      );

      expect(restored.srid, 3857);
    },
  );

  test(
    'Given an unsupported type, when deserialized to a GeographyLineString using GeographyLineStringJsonExtension.fromJson, then it throws an ArgumentError.',
    () {
      expect(
        () => GeographyLineStringJsonExtension.fromJson(42),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a GeographyPolygon, when serializing to JSON then it returns the EWKT string.',
    () {
      const polygon = GeographyPolygon(
        exteriorRing: [
          GeographyPoint(longitude: 0.0, latitude: 0.0),
          GeographyPoint(longitude: 1.0, latitude: 0.0),
          GeographyPoint(longitude: 1.0, latitude: 1.0),
          GeographyPoint(longitude: 0.0, latitude: 0.0),
        ],
      );

      expect(polygon.toJson(), isA<String>());
      expect(
        polygon.toJson(),
        'SRID=4326;POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 0.0))',
      );
    },
  );

  test(
    'Given an EWKT string with a hole, when deserialized using GeographyPolygonJsonExtension.fromJson, then both rings are parsed.',
    () {
      GeographyPolygon polygon = GeographyPolygonJsonExtension.fromJson(
        'SRID=4326;POLYGON('
        '(0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 0.0), '
        '(0.2 0.2, 0.8 0.2, 0.8 0.8, 0.2 0.2)'
        ')',
      );

      expect(polygon.srid, 4326);
      expect(polygon.exteriorRing.length, 4);
      expect(polygon.holes.length, 1);
      expect(polygon.holes[0].length, 4);
    },
  );

  test(
    'Given a Map, when deserialized using GeographyPolygonJsonExtension.fromJson, then it creates a valid GeographyPolygon.',
    () {
      GeographyPolygon polygon = GeographyPolygonJsonExtension.fromJson({
        'srid': 4326,
        'exteriorRing': [
          {'longitude': 0.0, 'latitude': 0.0},
          {'longitude': 1.0, 'latitude': 0.0},
          {'longitude': 1.0, 'latitude': 1.0},
          {'longitude': 0.0, 'latitude': 0.0},
        ],
        'holes': [],
      });

      expect(polygon.srid, 4326);
      expect(polygon.exteriorRing.length, 4);
      expect(polygon.holes, isEmpty);
    },
  );

  test(
    'Given a Uint8List (EWKB), when deserialized using GeographyPolygonJsonExtension.fromJson, then it decodes the binary representation.',
    () {
      // Little-endian EWKB for SRID=4326;POLYGON((0 0, 1 0, 1 1, 0 0))
      final ewkb = Uint8List.fromList([
        0x01, // LE
        0x03, 0x00, 0x00, 0x20, // Polygon | SRID_FLAG
        0xE6, 0x10, 0x00, 0x00, // SRID 4326
        0x01, 0x00, 0x00, 0x00, // numRings = 1
        0x04, 0x00, 0x00, 0x00, // ring[0] numPoints = 4
        // (0.0, 0.0)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        // (1.0, 0.0)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        // (1.0, 1.0)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
        // (0.0, 0.0) closing point
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      ]);
      GeographyPolygon polygon = GeographyPolygonJsonExtension.fromJson(ewkb);

      expect(polygon.srid, 4326);
      expect(polygon.exteriorRing.length, 4);
      expect(polygon.holes, isEmpty);
      expect(polygon.exteriorRing[1].longitude, 1.0);
    },
  );

  test(
    'Given a GeographyPolygon with holes, when serialized and deserialized, then the holes are preserved.',
    () {
      const original = GeographyPolygon(
        exteriorRing: [
          GeographyPoint(longitude: 0.0, latitude: 0.0),
          GeographyPoint(longitude: 1.0, latitude: 0.0),
          GeographyPoint(longitude: 1.0, latitude: 1.0),
          GeographyPoint(longitude: 0.0, latitude: 0.0),
        ],
        holes: [
          [
            GeographyPoint(longitude: 0.2, latitude: 0.2),
            GeographyPoint(longitude: 0.8, latitude: 0.2),
            GeographyPoint(longitude: 0.8, latitude: 0.8),
            GeographyPoint(longitude: 0.2, latitude: 0.2),
          ],
        ],
      );
      GeographyPolygon restored = GeographyPolygonJsonExtension.fromJson(
        original.toJson(),
      );

      expect(restored.holes.length, 1);
      expect(restored.holes[0].length, 4);
    },
  );

  test(
    'Given an unsupported type, when deserialized to a GeographyPolygon using GeographyPolygonJsonExtension.fromJson, then it throws an ArgumentError.',
    () {
      expect(
        () => GeographyPolygonJsonExtension.fromJson(42),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a GeographyGeometryCollection, when serializing to JSON then it returns the EWKT string.',
    () {
      const collection = GeographyGeometryCollection(
        geometries: [
          GeographyPoint(longitude: -0.1278, latitude: 51.5074),
          GeographyPoint(longitude: 2.3522, latitude: 48.8566),
        ],
      );

      expect(collection.toJson(), isA<String>());
      expect(
        collection.toJson(),
        'SRID=4326;GEOMETRYCOLLECTION('
        'POINT(-0.1278 51.5074), POINT(2.3522 48.8566)'
        ')',
      );
    },
  );

  test(
    'Given an EWKT string with mixed types, when deserialized using GeographyGeometryCollectionJsonExtension.fromJson, then all types are parsed.',
    () {
      GeographyGeometryCollection collection =
          GeographyGeometryCollectionJsonExtension.fromJson(
            'SRID=4326;GEOMETRYCOLLECTION('
            'POINT(-0.1278 51.5074), '
            'LINESTRING(-0.1278 51.5074, 2.3522 48.8566), '
            'POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 0.0))'
            ')',
          );

      expect(collection.geometries.length, 3);
      expect(collection.geometries[0], isA<GeographyPoint>());
      expect(collection.geometries[1], isA<GeographyLineString>());
      expect(collection.geometries[2], isA<GeographyPolygon>());
    },
  );

  test(
    'Given an EWKT string for an empty collection, when deserialized using GeographyGeometryCollectionJsonExtension.fromJson, then the geometries are empty.',
    () {
      GeographyGeometryCollection collection =
          GeographyGeometryCollectionJsonExtension.fromJson(
            'SRID=4326;GEOMETRYCOLLECTION()',
          );

      expect(collection.geometries, isEmpty);
    },
  );

  test(
    'Given a Map with string geometries, when deserialized using GeographyGeometryCollectionJsonExtension.fromJson, then it parses correctly.',
    () {
      GeographyGeometryCollection collection =
          GeographyGeometryCollectionJsonExtension.fromJson({
            'srid': 4326,
            'geometries': [
              'POINT(-0.1278 51.5074)',
              'LINESTRING(-0.1278 51.5074, 2.3522 48.8566)',
            ],
          });

      expect(collection.geometries.length, 2);
      expect(collection.geometries[0], isA<GeographyPoint>());
      expect(collection.geometries[1], isA<GeographyLineString>());
    },
  );

  test(
    'Given a Uint8List (EWKB), when deserialized using GeographyGeometryCollectionJsonExtension.fromJson, then it decodes the binary representation.',
    () {
      // LE EWKB for SRID=4326;GEOMETRYCOLLECTION(POINT(1.0 2.0))
      final ewkb = Uint8List.fromList([
        0x01, // LE
        0x07, 0x00, 0x00, 0x20, // GeometryCollection | SRID_FLAG
        0xE6, 0x10, 0x00, 0x00, // SRID 4326
        0x01, 0x00, 0x00, 0x00, // numGeoms = 1
        // sub-geom: POINT(1.0 2.0) without SRID
        0x01, // LE
        0x01, 0x00, 0x00, 0x00, // Point (no SRID flag)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F, // lon 1.0
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, // lat 2.0
      ]);
      GeographyGeometryCollection collection =
          GeographyGeometryCollectionJsonExtension.fromJson(ewkb);

      expect(collection.srid, 4326);
      expect(collection.geometries.length, 1);
      expect(collection.geometries[0], isA<GeographyPoint>());
    },
  );

  test(
    'Given a GeographyGeometryCollection with mixed types, when serialized and deserialized, then all sub-geometry types are preserved.',
    () {
      const original = GeographyGeometryCollection(
        geometries: [
          GeographyPoint(longitude: -0.1278, latitude: 51.5074),
          GeographyLineString(
            points: [
              GeographyPoint(longitude: -0.1278, latitude: 51.5074),
              GeographyPoint(longitude: 2.3522, latitude: 48.8566),
            ],
          ),
          GeographyPolygon(
            exteriorRing: [
              GeographyPoint(longitude: 0.0, latitude: 0.0),
              GeographyPoint(longitude: 1.0, latitude: 0.0),
              GeographyPoint(longitude: 1.0, latitude: 1.0),
              GeographyPoint(longitude: 0.0, latitude: 0.0),
            ],
          ),
        ],
      );
      GeographyGeometryCollection restored =
          GeographyGeometryCollectionJsonExtension.fromJson(original.toJson());

      expect(restored.geometries.length, 3);
      expect(restored.geometries[0], isA<GeographyPoint>());
      expect(restored.geometries[1], isA<GeographyLineString>());
      expect(restored.geometries[2], isA<GeographyPolygon>());
    },
  );

  test(
    'Given an unsupported type, when deserialized to a GeographyGeometryCollection using GeographyGeometryCollectionJsonExtension.fromJson, then it throws an ArgumentError.',
    () {
      expect(
        () => GeographyGeometryCollectionJsonExtension.fromJson(42),
        throwsA(isA<ArgumentError>()),
      );
    },
  );
}
