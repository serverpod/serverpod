import 'package:test/test.dart';

import 'test_utils/test_serverpod_client.dart';

void main() {
  test(
    'Given a server address without trailing slash when initializing client then host should have trailing slash added.',
    () {
      var client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080'),
      );
      expect(client.host, 'http://localhost:8080/');
    },
  );

  test(
    'Given a server address with trailing slash when initializing client then host should remain unchanged.',
    () {
      var client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080/'),
      );
      expect(client.host, 'http://localhost:8080/');
    },
  );

  test(
    'Given an HTTPS server address without trailing slash when initializing client then host should have trailing slash added.',
    () {
      var client = TestServerpodClient(
        host: Uri.parse('https://example.com'),
      );
      expect(client.host, 'https://example.com/');
    },
  );

  test(
    'Given a server address with path and without trailing slash when initializing client then host should have trailing slash added.',
    () {
      var client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080/api'),
      );
      expect(client.host, 'http://localhost:8080/api/');
    },
  );

  test(
    'Given a server address with path and with trailing slash when initializing client then host should remain unchanged.',
    () {
      var client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080/api/'),
      );
      expect(client.host, 'http://localhost:8080/api/');
    },
  );
}
