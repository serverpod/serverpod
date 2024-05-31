import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/custom_classes.dart';
import 'package:serverpod_test_shared/serverpod_test_shared.dart';

class CustomTypesEndpoint extends Endpoint {
  Future<CustomClass> returnCustomClass(
    Session session,
    CustomClass data,
  ) async {
    return data;
  }

  Future<CustomClass?> returnCustomClassNullable(
    Session session,
    CustomClass? data,
  ) async {
    return data;
  }

  Future<CustomClass2> returnCustomClass2(
    Session session,
    CustomClass2 data,
  ) async {
    return data;
  }

  Future<CustomClass2?> returnCustomClass2Nullable(
    Session session,
    CustomClass2? data,
  ) async {
    return data;
  }

  Future<ExternalCustomClass> returnExternalCustomClass(
    Session session,
    ExternalCustomClass data,
  ) async {
    return data;
  }

  Future<ExternalCustomClass?> returnExternalCustomClassNullable(
    Session session,
    ExternalCustomClass? data,
  ) async {
    return data;
  }

  Future<FreezedCustomClass> returnFreezedCustomClass(
    Session session,
    FreezedCustomClass data,
  ) async {
    return data;
  }

  Future<FreezedCustomClass?> returnFreezedCustomClassNullable(
    Session session,
    FreezedCustomClass? data,
  ) async {
    return data;
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    if (message is CustomClass) {
      await sendStreamMessage(
          session, CustomClass('${message.value}${message.value}'));
    }
  }
}
