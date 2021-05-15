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

    test('Bundle call', () async {
      String result = await client.bundles.bundle.bundle.hello('World');
      expect(result, equals('Hello World'));
    });
  });
}