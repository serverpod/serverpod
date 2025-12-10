import 'package:test/test.dart';

import 'test_utils/test_serverpod_client.dart';

void main() {
  group(
    'Given a server address without trailing slash when initializing client',
    () {
      late TestServerpodClient client;

      setUp(() {
        client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080'),
        );
      });

      test('then host should have trailing slash added.', () {
        expect(client.host, 'http://localhost:8080/');
      });

      tearDown(() {
        client.close();
      });
    },
  );

  group(
    'Given a server address with trailing slash when initializing client',
    () {
      late TestServerpodClient client;

      setUp(() {
        client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080/'),
        );
      });

      test('then host should remain unchanged.', () {
        expect(client.host, 'http://localhost:8080/');
      });

      tearDown(() {
        client.close();
      });
    },
  );

  group(
    'Given an HTTPS server address without trailing slash when initializing client',
    () {
      late TestServerpodClient client;

      setUp(() {
        client = TestServerpodClient(
          host: Uri.parse('https://example.com'),
        );
      });

      test('then host should have trailing slash added.', () {
        expect(client.host, 'https://example.com/');
      });

      tearDown(() {
        client.close();
      });
    },
  );

  group(
    'Given a server address with path and without trailing slash when initializing client',
    () {
      late TestServerpodClient client;

      setUp(() {
        client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080/api'),
        );
      });

      test('then host should have trailing slash added.', () {
        expect(client.host, 'http://localhost:8080/api/');
      });

      tearDown(() {
        client.close();
      });
    },
  );

  group(
    'Given a server address with path and with trailing slash when initializing client',
    () {
      late TestServerpodClient client;

      setUp(() {
        client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080/api/'),
        );
      });

      test('then host should remain unchanged.', () {
        expect(client.host, 'http://localhost:8080/api/');
      });

      tearDown(() {
        client.close();
      });
    },
  );
}
