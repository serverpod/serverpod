import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ListParametersEndpoint extends Endpoint {
  Future<List<int>> returnIntList(Session session, List<int> list) async {
    return list;
  }

  Future<List<List<int>>> returnIntListList(
      Session session, List<List<int>> list) async {
    return list;
  }

  Future<List<int>?> returnIntListNullable(
    Session session,
    List<int>? list,
  ) async {
    return list;
  }

  Future<List<int?>> returnIntListNullableInts(
    Session session,
    List<int?> list,
  ) async {
    return list;
  }

  Future<List<int?>?> returnNullableIntListNullableInts(
    Session session,
    List<int?>? list,
  ) async {
    return list;
  }

  Future<List<double>> returnDoubleList(
    Session session,
    List<double> list,
  ) async {
    return list;
  }

  Future<List<double?>> returnDoubleListNullableDoubles(
    Session session,
    List<double?> list,
  ) async {
    return list;
  }

  Future<List<bool>> returnBoolList(
    Session session,
    List<bool> list,
  ) async {
    return list;
  }

  Future<List<bool?>> returnBoolListNullableBools(
    Session session,
    List<bool?> list,
  ) async {
    return list;
  }

  Future<List<String>> returnStringList(
    Session session,
    List<String> list,
  ) async {
    return list;
  }

  Future<List<String?>> returnStringListNullableStrings(
    Session session,
    List<String?> list,
  ) async {
    return list;
  }

  Future<List<DateTime>> returnDateTimeList(
    Session session,
    List<DateTime> list,
  ) async {
    return list;
  }

  Future<List<DateTime?>> returnDateTimeListNullableDateTimes(
    Session session,
    List<DateTime?> list,
  ) async {
    return list;
  }

  Future<List<ByteData>> returnByteDataList(
    Session session,
    List<ByteData> list,
  ) async {
    return list;
  }

  Future<List<ByteData?>> returnByteDataListNullableByteDatas(
    Session session,
    List<ByteData?> list,
  ) async {
    return list;
  }

  Future<List<SimpleData>> returnSimpleDataList(
    Session session,
    List<SimpleData> list,
  ) async {
    return list;
  }

  Future<List<SimpleData?>> returnSimpleDataListNullableSimpleData(
    Session session,
    List<SimpleData?> list,
  ) async {
    return list;
  }

  Future<List<SimpleData>?> returnSimpleDataListNullable(
    Session session,
    List<SimpleData>? list,
  ) async {
    return list;
  }

  Future<List<SimpleData?>?> returnNullableSimpleDataListNullableSimpleData(
    Session session,
    List<SimpleData?>? list,
  ) async {
    return list;
  }
}
