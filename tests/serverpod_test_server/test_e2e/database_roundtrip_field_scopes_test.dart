import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given the database-roundtrip/echo server', () {
    test(
        'When an object with field scopes is stored in the database, then the `api` value will not be persisted and be unavailable on a later read',
        () async {
      var object = ObjectFieldScopes(
        normal: 'test normal',
        api: 'test api',
      );

      await client.fieldScopes.storeObject(object);

      var result = await client.fieldScopes.retrieveObject();

      expect(result, isNotNull);
      expect(result!.normal, equals('test normal'));
      expect(result.api, isNull);
    });
  });
}
