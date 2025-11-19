import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );

  group(
    'Given an endpoint that is defined outside of the endpoint directory',
    () {
      test('when calling the endpoint then call is successful', () async {
        var response = client.myFeature.myFeatureMethod();
        await expectLater(response, completion('Hello, world!'));
      });
    },
  );

  group(
    'Given a module endpoint that is defined outside of the endpoint directory',
    () {
      test('when calling the endpoint then call is successful', () async {
        var response = client.modules.module.myModuleFeature.myFeatureMethod();
        await expectLater(response, completion('Hello, world!'));
      });
    },
  );

  group(
    'Given an endpoint that returns a model defined outside of the models directory',
    () {
      test('when calling the endpoint then call is successful', () async {
        var response = client.myFeature.myFeatureModel();
        await expectLater(
          response,
          completion(
            isA<MyFeatureModel>().having((model) => model.name, 'name', 'Alex'),
          ),
        );
      });
    },
  );

  group(
    'Given a module endpoint that returns a model defined outside of the models directory',
    () {
      test('when calling the endpoint then call is successful', () async {
        var response = client.modules.module.myModuleFeature.myFeatureModel();
        await expectLater(
          response,
          completion(
            isA<MyModuleFeatureModel>().having(
              (model) => model.name,
              'name',
              'Isak',
            ),
          ),
        );
      });
    },
  );
}
