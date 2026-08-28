import 'package:http/http.dart' as http;
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import 'apple_test_utils.dart';

/// Tests that Apple's published signing keys are re-fetched rather than
/// cached for the lifetime of the process.
///
/// Apple rotates the keys behind `appleid.apple.com/auth/keys`. Caching the
/// first response forever breaks Sign in with Apple at the first rotation: to
/// a stale cache, a token signed with the new key looks forged.
///
/// The invariant: a `kid` the cache does not know is a reason to re-fetch, not
/// a reason to reject.
void main() {
  setUp(configureAppleTestAuth);
  tearDown(resetAppleTestAuth);

  test(
    'Given Apple has rotated its signing keys, '
    'when a token signed with the new key arrives, '
    'then the key set is re-fetched and the token verifies.',
    () async {
      var servedKeys = [appleTestRotatedPublicJwk];
      var fetches = 0;

      // The refetch floor is not what this test is about.
      AppleAuth.minRefetchInterval = Duration.zero;

      http.Client client() => appleKeysClient(
            keys: servedKeys,
            onKeysRequested: () => fetches++,
          );

      // Warm the cache with the pre-rotation key set.
      await expectLater(
        verifyAppleIdentityToken(
          signAppleIdentityToken(subject: '000123.abc.0001'),
          client: client,
        ),
        throwsA(isA<AppleIdentityTokenException>()),
      );

      servedKeys = [appleTestPublicJwk];

      var verified = await verifyAppleIdentityToken(
        signAppleIdentityToken(subject: '000123.abc.0001'),
        client: client,
      );

      expect(verified.subject, '000123.abc.0001');
      expect(
        fetches,
        greaterThan(1),
        reason: 'A pinned cache rejects valid tokens until restart.',
      );
    },
  );

  test(
    'Given a token whose key id is already in the cache, '
    'when its signature is invalid, then Apple is not re-fetched.',
    () async {
      var fetches = 0;
      http.Client client() => appleKeysClient(onKeysRequested: () => fetches++);

      var token = signAppleIdentityToken(subject: '000123.abc.0001');
      var tampered = '${token.substring(0, token.length - 6)}AAAAAA';

      await expectLater(
        verifyAppleIdentityToken(tampered, client: client),
        throwsA(isA<AppleIdentityTokenException>()),
      );

      expect(
        fetches,
        1,
        reason: 'A cached key id means a forgery, not a stale cache.',
      );
    },
  );

  test(
    'Given a stream of tokens naming key ids Apple never published, '
    'when they arrive, then Apple is not fetched for each.',
    () async {
      var fetches = 0;
      http.Client client() => appleKeysClient(
            keys: [appleTestRotatedPublicJwk],
            onKeysRequested: () => fetches++,
          );

      for (var i = 0; i < 20; i++) {
        await expectLater(
          verifyAppleIdentityToken(
            signAppleIdentityToken(subject: '000123.abc.000$i'),
            client: client,
          ),
          throwsA(isA<AppleIdentityTokenException>()),
        );
      }

      expect(
        fetches,
        lessThan(5),
        reason: 'The key id comes from the token, so refreshes stay bounded.',
      );
    },
  );

  test(
    'Given a burst of sign ins arriving on a cold cache, '
    'when they arrive together, then Apple is fetched once.',
    () async {
      var fetches = 0;
      http.Client client() => appleKeysClient(onKeysRequested: () => fetches++);

      var verified = await http.runWithClient(
        () => Future.wait([
          for (var i = 0; i < 10; i++)
            AppleAuth.verifyIdentityToken(
              signAppleIdentityToken(subject: '000123.abc.000$i'),
            ),
        ]),
        client,
      );

      expect(verified, hasLength(10));
      expect(
        fetches,
        1,
        reason: 'A cache check alone lets each open its own request.',
      );
    },
  );

  test(
    'Given a cached key set and Apple\'s key endpoint unavailable, '
    'when a token signed with a cached key arrives, then it still verifies.',
    () async {
      var token = signAppleIdentityToken(subject: '000123.abc.0001');

      // Prime the cache while the endpoint is healthy.
      await verifyAppleIdentityToken(token);

      var verified = await verifyAppleIdentityToken(
        signAppleIdentityToken(subject: '000123.abc.0002'),
        client: () => appleKeysClient(statusCode: 503),
      );

      expect(
        verified.subject,
        '000123.abc.0002',
        reason: 'An outage at Apple must not take sign-in down.',
      );
    },
  );

  test(
    'Given an empty cache and Apple\'s key endpoint unavailable, '
    'when a token arrives, then verification fails with the fetch error.',
    () async {
      await expectLater(
        verifyAppleIdentityToken(
          signAppleIdentityToken(subject: '000123.abc.0001'),
          client: () => appleKeysClient(statusCode: 503),
        ),
        throwsA(
          isA<AppleIdentityTokenException>().having(
            (e) => e.message,
            'message',
            contains('Failed to fetch'),
          ),
        ),
      );
    },
  );

  test(
    'Given an empty cache and Apple\'s key endpoint unavailable, '
    'when tokens keep arriving, then Apple is not asked again per sign in.',
    () async {
      var fetches = 0;
      http.Client client() =>
          appleKeysClient(statusCode: 503, onKeysRequested: () => fetches++);

      for (var i = 0; i < 5; i++) {
        await expectLater(
          verifyAppleIdentityToken(
            signAppleIdentityToken(subject: '000123.abc.000$i'),
            client: client,
          ),
          throwsA(
            isA<AppleIdentityTokenException>().having(
              (e) => e.message,
              'message',
              contains('Failed to fetch'),
            ),
          ),
        );
      }

      expect(
        fetches,
        1,
        reason: 'An outage with nothing cached is when this amplifies.',
      );
    },
  );
}
