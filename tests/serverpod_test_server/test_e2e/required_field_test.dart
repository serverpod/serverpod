import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  test(
    'Given a model with a required filed when sending it to the echo server it is returned unmodified',
    () async {
      var model = ModelWithRequiredField(name: 'John Doe', email: null);
      var result = await client.echoRequiredField.echoModel(model);

      expect(result, isNotNull);
      expect(result.name, model.name);
      expect(result.email, model.email);
    },
  );

  test(
    'Given endpoint that throws an exception with a required field, when calling it, the exception is received',
    () async {
      await expectLater(
        client.echoRequiredField.throwException(),
        throwsA(isA<ExceptionWithRequiredField>()),
      );
    },
  );
}
