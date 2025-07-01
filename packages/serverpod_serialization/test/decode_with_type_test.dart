import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _TestProtocol extends SerializationManager {}

void main() {
  var protocol = _TestProtocol();

  test(
    'Given an integer when encoding and decoding with type then output matches input',
    () {
      int number = 1;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a non-null nullable integer when encoding and decoding with type then output matches input',
    () {
      int? number = 1;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a null nullable integer when encoding and decoding with type then output matches input',
    () {
      int? number;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a double when encoding and decoding with type then output matches input',
    () {
      double number = 1.0;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a non-null nullable double when encoding and decoding with type then output matches input',
    () {
      double? number = 1.0;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a null nullable double when encoding and decoding with type then output matches input',
    () {
      double? number;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a string when encoding and decoding with type then output matches input',
    () {
      String text = 'hello';
      var encoded = protocol.encodeWithType(text);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, text);
    },
  );

  test(
    'Given a non-null nullable string when encoding and decoding with type then output matches input',
    () {
      String? text = 'hello';
      var encoded = protocol.encodeWithType(text);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, text);
    },
  );

  test(
    'Given a null nullable string when encoding and decoding with type then output matches input',
    () {
      String? text;
      var encoded = protocol.encodeWithType(text);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, text);
    },
  );

  test(
    'Given a boolean when encoding and decoding with type then output matches input',
    () {
      bool flag = true;
      var encoded = protocol.encodeWithType(flag);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, flag);
    },
  );

  test(
    'Given a non-null nullable boolean when encoding and decoding with type then output matches input',
    () {
      bool? flag = true;
      var encoded = protocol.encodeWithType(flag);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, flag);
    },
  );

  test(
    'Given a null nullable boolean when encoding and decoding with type then output matches input',
    () {
      bool? flag;
      var encoded = protocol.encodeWithType(flag);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, flag);
    },
  );

  test(
    'Given a DateTime when encoding and decoding with type then output matches input',
    () {
      DateTime dateTime = DateTime.now();
      var encoded = protocol.encodeWithType(dateTime);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, dateTime.toUtc());
    },
  );

  test(
    'Given a non-null nullable DateTime when encoding and decoding with type then output matches input',
    () {
      DateTime? dateTime = DateTime.now();
      var encoded = protocol.encodeWithType(dateTime);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, dateTime.toUtc());
    },
  );

  test(
    'Given a null nullable DateTime when encoding and decoding with type then output matches input',
    () {
      DateTime? dateTime;
      var encoded = protocol.encodeWithType(dateTime);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, dateTime);
    },
  );

  test(
    'Given a ByteData when encoding and decoding with type then output matches input',
    () {
      ByteData byteData = ByteData(4);
      byteData.setInt32(0, 123456789);
      var encoded = protocol.encodeWithType(byteData);
      var decoded = protocol.decodeWithType(encoded);
      expect((decoded as ByteData).getInt32(0), byteData.getInt32(0));
    },
  );

  test(
    'Given a non-null nullable ByteData when encoding and decoding with type then output matches input',
    () {
      ByteData? byteData = ByteData(4);
      byteData.setInt32(0, 123456789);
      var encoded = protocol.encodeWithType(byteData);
      var decoded = protocol.decodeWithType(encoded);
      expect((decoded as ByteData).getInt32(0), byteData.getInt32(0));
    },
  );

  test(
    'Given a null nullable ByteData when encoding and decoding with type then output matches input',
    () {
      ByteData? byteData;
      var encoded = protocol.encodeWithType(byteData);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, byteData);
    },
  );

  test(
    'Given a Duration when encoding and decoding with type then output matches input',
    () {
      Duration duration = const Duration(seconds: 60);
      var encoded = protocol.encodeWithType(duration);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, duration);
    },
  );

  test(
    'Given a non-null nullable Duration when encoding and decoding with type then output matches input',
    () {
      Duration? duration = const Duration(seconds: 60);
      var encoded = protocol.encodeWithType(duration);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, duration);
    },
  );

  test(
    'Given a null nullable Duration when encoding and decoding with type then output matches input',
    () {
      Duration? duration;
      var encoded = protocol.encodeWithType(duration);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, duration);
    },
  );

  test(
    'Given a UuidValue when encoding and decoding with type then output matches input',
    () {
      UuidValue uuid = const Uuid().v4obj();
      var encoded = protocol.encodeWithType(uuid);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, uuid);
    },
  );

  test(
    'Given a non-null nullable UuidValue when encoding and decoding with type then output matches input',
    () {
      UuidValue? uuid = const Uuid().v4obj();
      var encoded = protocol.encodeWithType(uuid);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, uuid);
    },
  );

  test(
    'Given a null nullable UuidValue when encoding and decoding with type then output matches input',
    () {
      UuidValue? uuid;
      var encoded = protocol.encodeWithType(uuid);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, uuid);
    },
  );

  test(
    'Given a Uri when encoding and decoding with type then output matches input',
    () {
      Uri uri = Uri.parse('https://docs.serverpod.dev/contribute');
      var encoded = protocol.encodeWithType(uri);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, uri);
    },
  );

  test(
    'Given a non-null nullable Uri when encoding and decoding with type then output matches input',
    () {
      Uri? uri = Uri.parse('https://docs.serverpod.dev/contribute');
      var encoded = protocol.encodeWithType(uri);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, uri);
    },
  );

  test(
    'Given a null nullable Uri when encoding and decoding with type then output matches input',
    () {
      Uri? uri;
      var encoded = protocol.encodeWithType(uri);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, uri);
    },
  );

  test(
    'Given a BigInt when encoding and decoding with type then output matches input',
    () {
      BigInt bigInt = BigInt.parse('12345678901234567890');
      var encoded = protocol.encodeWithType(bigInt);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, bigInt);
    },
  );

  test(
    'Given a non-null nullable BigInt when encoding and decoding with type then output matches input',
    () {
      BigInt? bigInt = BigInt.parse('-12345678901234567890');
      var encoded = protocol.encodeWithType(bigInt);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, bigInt);
    },
  );

  test(
    'Given a null nullable BigInt when encoding and decoding with type then output matches input',
    () {
      BigInt? bigInt;
      var encoded = protocol.encodeWithType(bigInt);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, bigInt);
    },
  );

  test(
    'Given a Vector when encoding and decoding with type then output matches input.',
    () {
      Vector vector = const Vector([1.0, 2.0, 3.0]);
      var encoded = protocol.encodeWithType(vector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, vector);
    },
  );

  test(
    'Given a non-null nullable Vector when encoding and decoding with type then output matches input.',
    () {
      Vector? vector = const Vector([1.0, 2.0, 3.0]);
      var encoded = protocol.encodeWithType(vector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, vector);
    },
  );

  test(
    'Given a null nullable Vector when encoding and decoding with type then output matches input.',
    () {
      Vector? vector;
      var encoded = protocol.encodeWithType(vector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, vector);
    },
  );

  test(
    'Given a HalfVector when encoding and decoding with type then output matches input',
    () {
      HalfVector halfVector = const HalfVector([1.0, 2.0, 3.0]);
      var encoded = protocol.encodeWithType(halfVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, halfVector);
    },
  );

  test(
    'Given a non-null nullable HalfVector when encoding and decoding with type then output matches input',
    () {
      HalfVector? halfVector = const HalfVector([1.0, 2.0, 3.0]);
      var encoded = protocol.encodeWithType(halfVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, halfVector);
    },
  );

  test(
    'Given a null nullable HalfVector when encoding and decoding with type then output matches input',
    () {
      HalfVector? halfVector;
      var encoded = protocol.encodeWithType(halfVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, halfVector);
    },
  );

  test(
    'Given a SparseVector when encoding and decoding with type then output matches input',
    () {
      SparseVector sparseVector = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);
      var encoded = protocol.encodeWithType(sparseVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, sparseVector);
    },
  );

  test(
    'Given a non-null nullable SparseVector when encoding and decoding with type then output matches input',
    () {
      SparseVector? sparseVector = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);
      var encoded = protocol.encodeWithType(sparseVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, sparseVector);
    },
  );

  test(
    'Given a null nullable SparseVector when encoding and decoding with type then output matches input',
    () {
      SparseVector? sparseVector;
      var encoded = protocol.encodeWithType(sparseVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, sparseVector);
    },
  );

  test(
    'Given a Bit vector when encoding and decoding with type then output matches input',
    () {
      Bit bitVector = Bit([true, false, true, false, true]);
      var encoded = protocol.encodeWithType(bitVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, bitVector);
    },
  );

  test(
    'Given a non-null nullable Bit vector when encoding and decoding with type then output matches input',
    () {
      Bit? bitVector = Bit([true, false, true, false, true]);
      var encoded = protocol.encodeWithType(bitVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, bitVector);
    },
  );

  test(
    'Given a null nullable Bit vector when encoding and decoding with type then output matches input',
    () {
      Bit? bitVector;
      var encoded = protocol.encodeWithType(bitVector);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, bitVector);
    },
  );
}
