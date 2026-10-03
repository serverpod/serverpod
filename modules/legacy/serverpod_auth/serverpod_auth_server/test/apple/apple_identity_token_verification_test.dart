import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import 'apple_test_utils.dart';

/// Tests that a Sign in with Apple identity token is only accepted when Apple
/// minted it for *this* application, and while it is still current.
///
/// Apple signs every developer team's tokens with the same keys, published at
/// one global JWKS endpoint, so a valid signature says only that the token
/// came from Apple. The `aud` claim carries which app it was issued to.
///
/// The invariant: a token verifies only if Apple issued it, for a configured
/// client id, and it has not expired.
void main() {
  setUp(configureAppleTestAuth);
  tearDown(resetAppleTestAuth);

  test(
    'Given an identity token signed by Apple for another application, '
    'when verifying it, then it is rejected for its audience.',
    () async {
      var token = signAppleIdentityToken(
        subject: '000123.abc.0001',
        audience: 'com.attacker.their-own-app',
      );

      await expectLater(
        verifyAppleIdentityToken(token),
        throwsA(
          isA<AppleIdentityTokenException>().having(
            (e) => e.message,
            'message',
            contains('audience'),
          ),
        ),
      );
    },
  );

  test(
    'Given an identity token from an issuer other than Apple, '
    'when verifying it, then it is rejected.',
    () async {
      var token = signAppleIdentityToken(
        subject: '000123.abc.0001',
        issuer: 'https://login.attacker.example',
      );

      await expectLater(
        verifyAppleIdentityToken(token),
        throwsA(isA<AppleIdentityTokenException>()),
      );
    },
  );

  test(
    'Given an identity token that expired long ago, '
    'when verifying it, then it is rejected.',
    () async {
      var longAgo = DateTime.now().toUtc().subtract(const Duration(days: 30));
      var token = signAppleIdentityToken(
        subject: '000123.abc.0001',
        issuedAt: longAgo,
        expiresAt: longAgo.add(const Duration(minutes: 10)),
      );

      await expectLater(
        verifyAppleIdentityToken(token),
        throwsA(
          isA<AppleIdentityTokenException>().having(
            (e) => e.message,
            'message',
            contains('expired'),
          ),
        ),
        reason: 'A token captured once must not stay valid forever.',
      );
    },
  );

  test(
    'Given an identity token that expired within the clock skew tolerance, '
    'when verifying it, then it is accepted.',
    () async {
      var token = signAppleIdentityToken(
        subject: '000123.abc.0001',
        expiresAt: DateTime.now().toUtc().subtract(const Duration(seconds: 5)),
      );

      var verified = await verifyAppleIdentityToken(token);

      expect(verified.subject, '000123.abc.0001');
    },
  );

  test(
    'Given an identity token issued in the future, '
    'when verifying it, then it is rejected.',
    () async {
      var soon = DateTime.now().toUtc().add(const Duration(hours: 1));
      var token = signAppleIdentityToken(
        subject: '000123.abc.0001',
        issuedAt: soon,
        expiresAt: soon.add(const Duration(minutes: 10)),
      );

      await expectLater(
        verifyAppleIdentityToken(token),
        throwsA(
          isA<AppleIdentityTokenException>().having(
            (e) => e.message,
            'message',
            contains('future'),
          ),
        ),
      );
    },
  );

  test(
    'Given an identity token whose signature has been tampered with, '
    'when verifying it, then it is rejected.',
    () async {
      var token = signAppleIdentityToken(subject: '000123.abc.0001');
      var tampered = '${token.substring(0, token.length - 6)}AAAAAA';

      await expectLater(
        verifyAppleIdentityToken(tampered),
        throwsA(isA<AppleIdentityTokenException>()),
      );
    },
  );

  test(
    'Given an identity token that is not a JWT at all, '
    'when verifying it, then it is rejected.',
    () async {
      await expectLater(
        verifyAppleIdentityToken('not-a-token'),
        throwsA(isA<AppleIdentityTokenException>()),
      );
    },
  );

  test(
    'Given an identity token whose header names its key with a number, '
    'when verifying it, then it is rejected.',
    () async {
      var token = withProtectedHeader(
        signAppleIdentityToken(subject: '000123.abc.0001'),
        {'alg': 'RS256', 'kid': 123},
      );

      await expectLater(
        verifyAppleIdentityToken(token),
        throwsA(isA<AppleIdentityTokenException>()),
        reason:
            'A cast failure on `kid` must not escape as an unhandled error.',
      );
    },
  );

  test(
    'Given a current identity token minted for this application, '
    'when verifying it, then its claims are returned.',
    () async {
      var token = signAppleIdentityToken(
        subject: '000123.abc.0001',
        email: 'User@Example.com',
      );

      var verified = await verifyAppleIdentityToken(token);

      expect(verified.subject, '000123.abc.0001');
      expect(verified.email, 'user@example.com');
      expect(verified.isEmailVerified, isTrue);
    },
  );

  test(
    'Given an identity token sending `email_verified` as a string, '
    'when verifying it, then the claim is understood.',
    () async {
      var token = signAppleIdentityToken(
        subject: '000123.abc.0001',
        email: 'user@example.com',
        emailVerified: 'true',
      );

      var verified = await verifyAppleIdentityToken(token);

      expect(
        verified.isEmailVerified,
        isTrue,
        reason: 'Apple sends the boolean claims as JSON strings on some flows.',
      );
    },
  );

  group('Given no configured Apple client ids,', () {
    setUp(() => AuthConfig.set(AuthConfig()));

    test(
      'when verifying an otherwise valid token, then it is rejected.',
      () async {
        var token = signAppleIdentityToken(subject: '000123.abc.0001');

        await expectLater(
          verifyAppleIdentityToken(token),
          throwsA(
            isA<AppleAuthUnavailableException>().having(
              (e) => e.message,
              'message',
              contains('not configured'),
            ),
          ),
          reason: 'The distinct type lets callers report a deployment error.',
        );
      },
    );
  });

  group('Given several configured Apple client ids,', () {
    setUp(
      () => AuthConfig.set(
        AuthConfig(appleClientIds: {'dev.serverpod.other', appleClientId}),
      ),
    );

    test(
      'when verifying a token minted for one of them, then it is accepted.',
      () async {
        var token = signAppleIdentityToken(subject: '000123.abc.0001');

        var verified = await verifyAppleIdentityToken(token);

        expect(verified.subject, '000123.abc.0001');
      },
    );
  });
}
