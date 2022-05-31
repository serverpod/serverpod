import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class BasicTypesEndpoint extends Endpoint {
  Future<int?> testInt(Session session, int? value) async {
    return value;
  }

  Future<double?> testDouble(Session session, double? value) async {
    return value;
  }

  Future<bool?> testBool(Session session, bool? value) async {
    return value;
  }

  Future<DateTime?> testDateTime(Session session, DateTime? dateTime) async {
    return dateTime;
  }

  Future<String?> testString(Session session, String? value) async {
    return value;
  }

  Future<ByteData?> testByteData(Session session, ByteData? value) async {
    return value;
  }

  Future<List<String>> testListOfString(
      Session session, List<String> value) async {
    return value;
  }

  Future<List> testListOfdynamic(Session session, List value) async {
    return value;
  }

  Future<List<double>> testListOfdouble(
      Session session, List<double> value) async {
    return value;
  }

  Future<List<int>> testListOfint(Session session, List<int> value) async {
    return value;
  }

  Future<List<DateTime>> testListOfDateTime(
      Session session, List<DateTime> value) async {
    return value;
  }

  Future<List<bool>> testListOfbool(Session session, List<bool> value) async {
    return value;
  }

  Future<List<SimpleData>> testListOfSimpleData(
      Session session, List<SimpleData> object) async {
    return object;
  }

  Future<Map<String, String>> testMapOfString(
      Session session, Map<String, String> value) async {
    return value;
  }

  Future<Map<String, bool>> testMapOfBool(
      Session session, Map<String, bool> value) async {
    return value;
  }

  Future<Map<String, int>> testMapOfInt(
      Session session, Map<String, int> value) async {
    return value;
  }

  Future<Map<String, double>> testMapOfDouble(
      Session session, Map<String, double> value) async {
    return value;
  }

  Future<Map<String, DateTime>> testMapOfDateTime(
      Session session, Map<String, DateTime> value) async {
    return value;
  }

  Future<Map<String, SimpleData>> testMapOfSimpleData(
      Session session, Map<String, SimpleData> value) async {
    return value;
  }

  Future<Map<String, String?>> testMapOfStringNullable(
      Session session, Map<String, String?> value) async {
    return value;
  }

  Future<Map<String, bool?>> testMapOfBoolNullable(
      Session session, Map<String, bool?> value) async {
    return value;
  }

  Future<Map<String, int?>> testMapOfIntNullable(
      Session session, Map<String, int?> value) async {
    return value;
  }

  Future<Map<String, double?>> testMapOfDoubleNullable(
      Session session, Map<String, double?> value) async {
    return value;
  }

  Future<Map<String, DateTime?>> testMapOfDateTimeNullable(
      Session session, Map<String, DateTime?> value) async {
    return value;
  }

  Future<Map<String, SimpleData?>> testMapOfSimpleDataNullable(
      Session session, Map<String, SimpleData?> value) async {
    return value;
  }
}
