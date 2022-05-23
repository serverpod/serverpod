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

  Future<List<DateTime>> testListOfDateTime(
      Session session, List<DateTime> value) async {
    return value;
  }

  Future<List<bool>> testListOfbool(Session session, List<bool> value) async {
    return value;
  }

  Future<Map<String, dynamic>> testListOfmapDynamic(
      Session session, Map<String, dynamic> value) async {
    return value;
  }

  Future<List<SimpleData>> testListOfSimpleData(
      Session session, List<SimpleData> object) async {
    int i = 0;
    for (var e in object) {
      i++;
      e.num = i;
    }
    return object;
  }
}
