import 'dart:convert';
import 'dart:typed_data';

import 'package:postgres/postgres.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
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
      UuidValue value =
          UuidValue.fromString('00000000-0000-0000-0000-000000000000');
      UuidValue uuidValue = UuidValueJsonExtension.fromJson(value);

      expect(
        uuidValue,
        value,
      );
    },
  );

  test(
      'Given invalid UUID string, when deserialized to a UuidValue, then it throws an exception',
      () {
    String value = 'hello world';
    expect(() => UuidValueJsonExtension.fromJson(value),
        throwsA(isA<FormatException>()));
  });
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
          base64Decode(strValue.substring(8, strValue.length - 12)).buffer);
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
    'Given UndecodedBytes, when deserialized to a Vector using VectorJsonExtension.fromJson, then it creates a valid Vector.',
    () {
      Vector originalVector = const Vector([1.0, 2.0, 3.0]);
      UndecodedBytes undecoded = UndecodedBytes(
        typeOid: 0,
        isBinary: true,
        bytes: originalVector.toBinary(),
        encoding: Encoding.getByName('utf-8')!,
      );
      Vector vector = VectorJsonExtension.fromJson(undecoded);

      expect(vector.toJson(), originalVector.toJson());
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
}
