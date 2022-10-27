import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/custom_classes.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

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

  @override
  Future<void> handleStreamMessage(
      StreamingSession session, SerializableEntity message) async {
    if (message is CustomClass) {
      await sendStreamMessage(
          session, CustomClass('${message.value}${message.value}'));
    }
  }
}
