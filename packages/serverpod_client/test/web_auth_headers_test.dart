import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a request delegate with cookie auth enabled', () {
    late _MinimalDelegate delegate;

    setUp(() {
      delegate = _MinimalDelegate()
        ..cookieAuth = true
        ..cookieAuthBasePath = '/api';
    });

    test(
      'when building the headers for an authenticated call '
      'then the cookie marker and base path are included.',
      () {
        expect(delegate.webAuthHeaders(authenticated: true), {
          webAuthModeHeaderName: webAuthModeCookie,
          webBasePathHeaderName: '/api',
        });
      },
    );

    test(
      'when building the headers for an unauthenticated call '
      'then the transport-only marker is included.',
      () {
        expect(delegate.webAuthHeaders(authenticated: false), {
          webAuthModeHeaderName: webAuthModeCookieTransport,
          webBasePathHeaderName: '/api',
        });
      },
    );
  });

  test(
    'Given a request delegate with cookie auth disabled '
    'when building the headers '
    'then they are empty.',
    () {
      expect(_MinimalDelegate().webAuthHeaders(authenticated: true), isEmpty);
    },
  );
}

class _MinimalDelegate extends ServerpodClientRequestDelegate {
  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }

  @override
  void close() {}
}
