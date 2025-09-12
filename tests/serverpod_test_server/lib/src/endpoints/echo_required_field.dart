import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class EchoRequiredFieldEndpoint extends Endpoint {
  Future<ModelWithRequiredField> echoModel(
    Session session,
    ModelWithRequiredField model,
  ) async {
    return model;
  }

  Future<void> throwException(Session session) async {
    throw ExceptionWithRequiredField(
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
  }
}
