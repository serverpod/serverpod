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
}
