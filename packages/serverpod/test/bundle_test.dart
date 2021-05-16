import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_bundle_client/bundle.dart' as bundle;

void main() {
  Client client = Client('http://localhost:8080/');
  client.registerBundleProtocol(bundle.Protocol());

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

    test('Passing bundle object', () async {
      var bundleClass = bundle.BundleClass(
        name: 'foo',
        data: 0,
      );
      var result = await client.bundleSerialization.modifyBundleObject(bundleClass);
      expect(result.data, equals(42));
    });

    test('Passing bundle object to bundle', () async {
      var bundleClass = bundle.BundleClass(
          name: 'foo',
          data: 0,
      );
      var result = await client.bundles.bundle.bundle.modifyBundleObject(bundleClass);
      expect(result.data, equals(42));
    });
  });
}