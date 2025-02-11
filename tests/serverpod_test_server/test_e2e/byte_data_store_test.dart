import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given the database-roundtrip/echo server', () {
    test('When the byte data store is tested on the server, it succeeds',
        () async {
      var result = await client.basicDatabase.testByteDataStore();

      expect(result, equals(true));
    });
  });
}
