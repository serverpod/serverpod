@TestOn('browser')
library;

import 'package:http/browser_client.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/serverpod_client_browser.dart';
import 'package:test/test.dart';

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
}
