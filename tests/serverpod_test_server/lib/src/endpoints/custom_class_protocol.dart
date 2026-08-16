import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_shared/src/protocol_custom_classes.dart';

class CustomClassProtocolEndpoint extends Endpoint {
  Future<ProtocolCustomClass> getProtocolField(
    Session session,
  ) async {
    return ProtocolCustomClass(
      value: "Value",
      serverOnlyValue: "ServerOnlyValue",
    );
  }
}
