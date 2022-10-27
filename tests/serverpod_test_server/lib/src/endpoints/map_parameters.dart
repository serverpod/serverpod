import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class MapParametersEndpoint extends Endpoint {
  Future<Map<String, int>> returnIntMap(
      Session session, Map<String, int> map) async {
    return map;
  }

  Future<Map<String, int>?> returnIntMapNullable(
    Session session,
    Map<String, int>? map,
  ) async {
    return map;
  }

  Future<Map<String, Map<String, int>>> returnNestedIntMap(
      Session session, Map<String, Map<String, int>> map) async {
    return map;
  }

  Future<Map<String, int?>> returnIntMapNullableInts(
    Session session,
    Map<String, int?> map,
  ) async {
    return map;
  }

  Future<Map<String, int?>?> returnNullableIntMapNullableInts(
    Session session,
    Map<String, int?>? map,
  ) async {
    return map;
  }

  Future<Map<int, int>> returnIntIntMap(
    Session session,
    Map<int, int> map,
  ) async {
    return map;
  }

  Future<Map<TestEnum, int>> returnEnumIntMap(
    Session session,
    Map<TestEnum, int> map,
  ) async {
    return map;
  }

  Future<Map<String, double>> returnDoubleMap(
    Session session,
    Map<String, double> map,
  ) async {
    return map;
  }

  Future<Map<String, double?>> returnDoubleMapNullableDoubles(
    Session session,
    Map<String, double?> map,
  ) async {
    return map;
  }

  Future<Map<String, bool>> returnBoolMap(
    Session session,
    Map<String, bool> map,
  ) async {
    return map;
  }

  Future<Map<String, bool?>> returnBoolMapNullableBools(
    Session session,
    Map<String, bool?> map,
  ) async {
    return map;
  }

  Future<Map<String, String>> returnStringMap(
    Session session,
    Map<String, String> map,
  ) async {
    return map;
  }

  Future<Map<String, String?>> returnStringMapNullableStrings(
    Session session,
    Map<String, String?> map,
  ) async {
    return map;
  }

  Future<Map<String, DateTime>> returnDateTimeMap(
    Session session,
    Map<String, DateTime> map,
  ) async {
    return map;
  }

  Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
    Session session,
    Map<String, DateTime?> map,
  ) async {
    return map;
  }

  Future<Map<String, ByteData>> returnByteDataMap(
    Session session,
    Map<String, ByteData> map,
  ) async {
    return map;
  }

  Future<Map<String, ByteData?>> returnByteDataMapNullableByteDatas(
    Session session,
    Map<String, ByteData?> map,
  ) async {
    return map;
  }

  Future<Map<String, SimpleData>> returnSimpleDataMap(
    Session session,
    Map<String, SimpleData> map,
  ) async {
    return map;
  }

  Future<Map<String, SimpleData?>> returnSimpleDataMapNullableSimpleData(
    Session session,
    Map<String, SimpleData?> map,
  ) async {
    return map;
  }

  Future<Map<String, SimpleData>?> returnSimpleDataMapNullable(
    Session session,
    Map<String, SimpleData>? map,
  ) async {
    return map;
  }

  Future<Map<String, SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
    Session session,
    Map<String, SimpleData?>? map,
  ) async {
    return map;
  }
}
