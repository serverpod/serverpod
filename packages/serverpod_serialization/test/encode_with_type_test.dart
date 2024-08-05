import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';
import 'dart:typed_data';

class _TestProtocol extends SerializationManager {}

void main() {
  var protocol = _TestProtocol();

  test(
      'Given an integer when encoding then output is the type name and value as a JSON string',
      () {
    int number = 1;
    var typeName = protocol.encodeWithType(number);
    expect(typeName, '{"className":"int","data":1}');
  });

  test(
      'Given a non-null nullable integer when encoding then output is the type name and value as a JSON string',
      () {
    int? number = 1;
    var typeName = protocol.encodeWithType(number);
    expect(typeName, '{"className":"int","data":1}');
  });

  test(
      'Given a null nullable integer when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    int? number;
    var typeName = protocol.encodeWithType(number);
    expect(typeName, '{"className":"null","data":null}');
  });

  test(
      'Given a double when encoding then output is the type name and value as a JSON string',
      () {
    double number = 1.0;
    var typeName = protocol.encodeWithType(number);
    expect(typeName, '{"className":"double","data":1.0}');
  });

  test(
      'Given a non-null nullable double when encoding then output is the type name and value as a JSON string',
      () {
    double? number = 1.0;
    var typeName = protocol.encodeWithType(number);
    expect(typeName, '{"className":"double","data":1.0}');
  });

  test(
      'Given a null nullable double when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    double? number;
    var typeName = protocol.encodeWithType(number);
    expect(typeName, '{"className":"null","data":null}');
  });

  test(
      'Given a string when encoding then output is the type name and value as a JSON string',
      () {
    String text = 'hello';
    var typeName = protocol.encodeWithType(text);
    expect(typeName, '{"className":"String","data":"hello"}');
  });

  test(
      'Given a non-null nullable string when encoding then output is the type name and value as a JSON string',
      () {
    String? text = 'hello';
    var typeName = protocol.encodeWithType(text);
    expect(typeName, '{"className":"String","data":"hello"}');
  });

  test(
      'Given a null nullable string when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    String? text;
    var typeName = protocol.encodeWithType(text);
    expect(typeName, '{"className":"null","data":null}');
  });

  test(
      'Given a boolean when encoding then output is the type name and value as a JSON string',
      () {
    bool flag = true;
    var typeName = protocol.encodeWithType(flag);
    expect(typeName, '{"className":"bool","data":true}');
  });

  test(
      'Given a non-null nullable boolean when encoding then output is the type name and value as a JSON string',
      () {
    bool? flag = true;
    var typeName = protocol.encodeWithType(flag);
    expect(typeName, '{"className":"bool","data":true}');
  });

  test(
      'Given a null nullable boolean when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    bool? flag;
    var typeName = protocol.encodeWithType(flag);
    expect(typeName, '{"className":"null","data":null}');
  });

  test(
      'Given a DateTime when encoding then output is the type name and value as a JSON string',
      () {
    DateTime dateTime = DateTime.now();
    var typeName = protocol.encodeWithType(dateTime);
    expect(
      typeName,
      '{"className":"DateTime","data":"${dateTime.toJson()}"}',
    );
  });

  test(
      'Given a non-null nullable DateTime when encoding then output is the type name and value as a JSON string',
      () {
    DateTime? dateTime = DateTime.now();
    var typeName = protocol.encodeWithType(dateTime);
    expect(
      typeName,
      '{"className":"DateTime","data":"${dateTime.toJson()}"}',
    );
  });

  test(
      'Given a null nullable DateTime when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    DateTime? dateTime;
    var typeName = protocol.encodeWithType(dateTime);
    expect(typeName, '{"className":"null","data":null}');
  });

  test(
      'Given a ByteData when encoding then output is the type name and value as a JSON string',
      () {
    ByteData byteData = ByteData(4);
    byteData.setInt32(0, 123456789);
    var typeName = protocol.encodeWithType(byteData);
    expect(
      typeName,
      '{"className":"ByteData","data":"${byteData.toJson()}"}',
    );
  });

  test(
      'Given a non-null nullable ByteData when encoding then output is the type name and value as a JSON string',
      () {
    ByteData? byteData = ByteData(4);
    byteData.setInt32(0, 123456789);
    var typeName = protocol.encodeWithType(byteData);
    expect(
      typeName,
      '{"className":"ByteData","data":"${byteData.toJson()}"}',
    );
  });

  test(
      'Given a null nullable ByteData when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    ByteData? byteData;
    var typeName = protocol.encodeWithType(byteData);
    expect(typeName, '{"className":"null","data":null}');
  });

  test(
      'Given a Duration when encoding then output is the type name and value as a JSON string',
      () {
    Duration duration = const Duration(seconds: 60);
    var typeName = protocol.encodeWithType(duration);
    expect(typeName, '{"className":"Duration","data":${duration.toJson()}}');
  });

  test(
      'Given a non-null nullable Duration when encoding then output is the type name and value as a JSON string',
      () {
    Duration? duration = const Duration(seconds: 60);
    var typeName = protocol.encodeWithType(duration);
    expect(typeName, '{"className":"Duration","data":${duration.toJson()}}');
  });

  test(
      'Given a null nullable Duration when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    Duration? duration;
    var typeName = protocol.encodeWithType(duration);
    expect(typeName, '{"className":"null","data":null}');
  });

  test(
      'Given a UuidValue when encoding then output is the type name and value as a JSON string',
      () {
    UuidValue uuid = const Uuid().v4obj();
    var typeName = protocol.encodeWithType(uuid);
    expect(typeName, '{"className":"UuidValue","data":"${uuid.toJson()}"}');
  });

  test(
      'Given a non-null nullable UuidValue when encoding then output is the type name and value as a JSON string',
      () {
    UuidValue? uuid = const Uuid().v4obj();
    var typeName = protocol.encodeWithType(uuid);
    expect(typeName, '{"className":"UuidValue","data":"${uuid.toJson()}"}');
  });

  test(
      'Given a null nullable UuidValue when encoding then output is \'null\' for both the type name and data as a JSON string',
      () {
    UuidValue? uuid;
    var typeName = protocol.encodeWithType(uuid);
    expect(typeName, '{"className":"null","data":null}');
  });
}
