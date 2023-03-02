import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';

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

  Future<Duration?> testDuration(Session session, Duration? value) async {
    return value;
  }

  Future<UuidValue?> testUuid(Session session, UuidValue? value) async {
    return value;
  }
}
