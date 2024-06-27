import 'dart:convert';
import 'dart:typed_data';

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
}
