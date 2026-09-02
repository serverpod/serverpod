@TestOn('browser')
library;

import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/serverpod_client_browser.dart';
import 'package:test/test.dart';

import '../test_utils/test_serverpod_client.dart';

class TestSerializationManager extends SerializationManager {}

void main() {
  group('Given a browser request delegate with a BrowserClient', () {
    late BrowserClient httpClient;
    late ServerpodClientRequestDelegateImpl delegate;

    setUp(() {
      httpClient = BrowserClient();
      delegate = ServerpodClientRequestDelegateImpl(
        connectionTimeout: const Duration(seconds: 20),
        serializationManager: TestSerializationManager(),
        httpClientOverride: httpClient,
      );
    });

    tearDown(() => delegate.close());

    test(
      'when cookie auth is enabled '
      'then the client sends credentialed requests.',
      () {
        delegate.cookieAuth = true;

        expect(httpClient.withCredentials, isTrue);
      },
    );

    test(
      'when cookie auth is enabled and disabled again '
      'then the client reverts to uncredentialed requests.',
      () {
        delegate.cookieAuth = true;
        delegate.cookieAuth = false;

        expect(httpClient.withCredentials, isFalse);
      },
    );
  });

  group('Given a browser client with a non-BrowserClient http override', () {
    late TestServerpodClient client;

    setUp(() {
      client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080'),
        httpClientOverride: _NonBrowserHttpClient(),
      );
    });

    tearDown(() => client.close());

    test(
      'when cookie auth is enabled '
      'then it fails loudly instead of sending uncredentialed requests.',
      () {
        expect(
          () => client.cookieAuth = true,
          throwsA(isA<UnsupportedError>()),
        );
        expect(client.cookieAuth, isFalse);
      },
    );
  });
}

class _NonBrowserHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError();
  }
}
