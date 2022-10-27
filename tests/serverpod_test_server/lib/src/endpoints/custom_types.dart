import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/custom_classes.dart';

class CustomTypesEndpoint extends Endpoint {
  Future<CustomClass> returnCustomClass(
      Session session, CustomClass data) async {
    return data;
  }

  Future<CustomClass?> returnCustomClassNullable(
      Session session, CustomClass? data) async {
    return data;
  }

  Future<CustomClass2> returnCustomClass2(
      Session session, CustomClass2 data) async {
    return data;
  }

  Future<CustomClass2?> returnCustomClass2Nullable(
      Session session, CustomClass2? data) async {
    return data;
  }
}
