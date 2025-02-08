import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class SetParametersEndpoint extends Endpoint {
  Future<Set<int>> returnIntSet(Session session, Set<int> set) async {
    return set;
  }

  Future<Set<Set<int>>> returnIntSetSet(
    Session session,
    Set<Set<int>> set,
  ) async {
    return set;
  }

  Future<Set<List<int>>> returnIntListSet(
    Session session,
    Set<List<int>> set,
  ) async {
    return set;
  }

  Future<Set<int>?> returnIntSetNullable(
    Session session,
    Set<int>? set,
  ) async {
    return set;
  }

  Future<Set<Set<int>?>> returnIntSetNullableSet(
    Session session,
    Set<Set<int>?> set,
  ) async {
    return set;
  }

  Future<Set<Set<int>>?> returnIntSetSetNullable(
    Session session,
    Set<Set<int>>? set,
  ) async {
    return set;
  }

  Future<Set<int?>> returnIntSetNullableInts(
    Session session,
    Set<int?> set,
  ) async {
    return set;
  }

  Future<Set<int?>?> returnNullableIntSetNullableInts(
    Session session,
    Set<int?>? set,
  ) async {
    return set;
  }

  Future<Set<double>> returnDoubleSet(
    Session session,
    Set<double> set,
  ) async {
    return set;
  }

  Future<Set<double?>> returnDoubleSetNullableDoubles(
    Session session,
    Set<double?> set,
  ) async {
    return set;
  }

  Future<Set<bool>> returnBoolSet(
    Session session,
    Set<bool> set,
  ) async {
    return set;
  }

  Future<Set<bool?>> returnBoolSetNullableBools(
    Session session,
    Set<bool?> set,
  ) async {
    return set;
  }

  Future<Set<String>> returnStringSet(
    Session session,
    Set<String> set,
  ) async {
    return set;
  }

  Future<Set<String?>> returnStringSetNullableStrings(
    Session session,
    Set<String?> set,
  ) async {
    return set;
  }

  Future<Set<DateTime>> returnDateTimeSet(
    Session session,
    Set<DateTime> set,
  ) async {
    return set;
  }

  Future<Set<DateTime?>> returnDateTimeSetNullableDateTimes(
    Session session,
    Set<DateTime?> set,
  ) async {
    return set;
  }

  Future<Set<ByteData>> returnByteDataSet(
    Session session,
    Set<ByteData> set,
  ) async {
    return set;
  }

  Future<Set<ByteData?>> returnByteDataSetNullableByteDatas(
    Session session,
    Set<ByteData?> set,
  ) async {
    return set;
  }

  Future<Set<SimpleData>> returnSimpleDataSet(
    Session session,
    Set<SimpleData> set,
  ) async {
    return set;
  }

  Future<Set<SimpleData?>> returnSimpleDataSetNullableSimpleData(
    Session session,
    Set<SimpleData?> set,
  ) async {
    return set;
  }

  Future<Set<Duration>> returnDurationSet(
    Session session,
    Set<Duration> set,
  ) async {
    return set;
  }

  Future<Set<Duration?>> returnDurationSetNullableDurations(
    Session session,
    Set<Duration?> set,
  ) async {
    return set;
  }
}
