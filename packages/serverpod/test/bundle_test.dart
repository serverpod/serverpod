import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

void main() {
  Client client = Client('http://localhost:8080/');

  setUp(() {
  });

  group('Bundles', () {
    test('Serialization', () async {
      var success = await client.bundleSerialization.serializeBundleObject();
      expect(success, equals(true));
    });
  });
}