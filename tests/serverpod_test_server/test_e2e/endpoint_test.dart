import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );

  group('Given an endpoint that is defined outside of the endpoint directory',
      () {
    test('when calling the endpoint then call is successful', () async {
      var response = client.myFeature.myFeatureMethod();
      await expectLater(response, completion('Hello, world!'));
    });
  });
}
