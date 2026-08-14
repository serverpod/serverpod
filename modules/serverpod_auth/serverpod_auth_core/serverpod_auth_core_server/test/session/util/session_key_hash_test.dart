import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod_auth_core_server/src/session/util/session_key_hash.dart';
import 'package:test/test.dart';

/// `ServerSideSession.sessionKeySalt` is documented as "the salt used for
/// computing the [sessionKeyHash]", and `sessionKeyHashSaltLength` as the
/// length of "the salt used for the session key hash". A salt is generated per
/// session, stored alongside the hash, read back, and handed to
/// `validateSessionKeyHash` - but it never reaches the digest, which covers
/// only the secret and the pepper.
///
/// The consequence is that two sessions sharing a secret share a hash, and a
/// hash validates against any salt at all. Session key secrets are 32 bytes of
/// CSPRNG output by default, so nothing is currently at risk - the point of a
/// per-session salt is to keep a shortened or lower-entropy secret from being
/// attacked across every row at once, and that layer is simply absent.
///
/// The fix folds the salt into the digest and tags each hash with a leading
/// version byte, so sessions issued under the old, saltless scheme keep working
/// and are re-hashed in place on next use rather than being invalidated.
void main() {
  group('Given a session key hash util,', () {
    late final sessionKeyHash = ServerSideSessionKeyHash(
      sessionKeyHashSaltLength: 16,
      sessionKeyHashPepper: 'test-pepper',
      fallbackSessionKeyHashPeppers: const [],
    );

    late final secret = Uint8List.fromList(List.generate(32, (final i) => i));

    test(
      'when the same secret is hashed twice, then the two hashes differ.',
      () {
        final first = sessionKeyHash.createSessionKeyHash(secret: secret);
        final second = sessionKeyHash.createSessionKeyHash(secret: secret);

        expect(
          first.salt,
          isNot(orderedEquals(second.salt)),
          reason: 'Precondition: each hash must get its own random salt.',
        );

        expect(
          first.hash,
          isNot(orderedEquals(second.hash)),
          reason:
              'Two sessions holding the same secret must not share a hash, or '
              'the stored salt is not reaching the digest.',
        );
      },
    );

    test(
      'when a hash is validated against a different salt, then it is rejected.',
      () {
        final stored = sessionKeyHash.createSessionKeyHash(secret: secret);
        final other = sessionKeyHash.createSessionKeyHash(secret: secret);

        expect(
          sessionKeyHash.validateSessionKeyHash(
            secret: secret,
            hash: stored.hash,
            salt: other.salt,
          ),
          SessionKeyHashValidation.invalid,
          reason:
              'A hash bound to one salt must not validate under another, or '
              'the salt is not part of what is being verified.',
        );
      },
    );

    test(
      'when a hash is validated against its own salt, then it is accepted.',
      () {
        final stored = sessionKeyHash.createSessionKeyHash(secret: secret);

        expect(
          sessionKeyHash.validateSessionKeyHash(
            secret: secret,
            hash: stored.hash,
            salt: stored.salt,
          ),
          SessionKeyHashValidation.valid,
        );
      },
    );

    test(
      'when a hash is validated against a different secret, '
      'then it is rejected.',
      () {
        final stored = sessionKeyHash.createSessionKeyHash(secret: secret);
        final otherSecret = Uint8List.fromList(
          List.generate(32, (final i) => i + 1),
        );

        expect(
          sessionKeyHash.validateSessionKeyHash(
            secret: otherSecret,
            hash: stored.hash,
            salt: stored.salt,
          ),
          SessionKeyHashValidation.invalid,
        );
      },
    );
  });

  group(
    'Given a session key hash stored under the pre-fix saltless scheme,',
    () {
      late final sessionKeyHash = ServerSideSessionKeyHash(
        sessionKeyHashSaltLength: 16,
        sessionKeyHashPepper: 'test-pepper',
        fallbackSessionKeyHashPeppers: const [],
      );

      late final secret = Uint8List.fromList(List.generate(32, (final i) => i));

      // Any stored salt: the pre-fix digest never mixed it in.
      late final salt = Uint8List.fromList(
        List.generate(16, (final i) => 255 - i),
      );

      late final legacyHash = _legacySaltlessHash(secret, 'test-pepper');

      test(
        'when it is validated with the right secret, '
        'then it is accepted as outdated so the caller upgrades it.',
        () {
          expect(
            legacyHash,
            hasLength(64),
            reason: 'Precondition: a bare digest with no version byte.',
          );

          expect(
            sessionKeyHash.validateSessionKeyHash(
              secret: secret,
              hash: legacyHash,
              salt: salt,
            ),
            SessionKeyHashValidation.validButOutdated,
          );
        },
      );

      test(
        'when it is validated with the wrong secret, then it is rejected.',
        () {
          final otherSecret = Uint8List.fromList(
            List.generate(32, (final i) => i + 1),
          );

          expect(
            sessionKeyHash.validateSessionKeyHash(
              secret: otherSecret,
              hash: legacyHash,
              salt: salt,
            ),
            SessionKeyHashValidation.invalid,
          );
        },
      );

      group('when it is re-hashed,', () {
        late Uint8List upgraded;

        setUp(() {
          upgraded = sessionKeyHash.rehashSessionKeyHash(
            secret: secret,
            salt: salt,
          );
        });

        test('then the result is versioned.', () {
          expect(
            upgraded,
            hasLength(65),
            reason: 'A one-byte version tag followed by the 64-byte digest.',
          );
          expect(
            upgraded.first,
            1,
            reason: 'The current scheme version.',
          );
        });

        test('then it validates as current under the same salt.', () {
          expect(
            sessionKeyHash.validateSessionKeyHash(
              secret: secret,
              hash: upgraded,
              salt: salt,
            ),
            SessionKeyHashValidation.valid,
            reason: 'The upgraded row must validate under the current scheme.',
          );
        });
      });

      test(
        'when its pepper has since been rotated to a fallback, '
        'then it still validates as outdated.',
        () {
          final rotated = ServerSideSessionKeyHash(
            sessionKeyHashSaltLength: 16,
            sessionKeyHashPepper: 'new-pepper',
            fallbackSessionKeyHashPeppers: const ['test-pepper'],
          );

          expect(
            rotated.validateSessionKeyHash(
              secret: secret,
              hash: legacyHash,
              salt: salt,
            ),
            SessionKeyHashValidation.validButOutdated,
          );
        },
      );
    },
  );

  group(
    'Given a stored hash of a length no scheme produces,',
    () {
      late final sessionKeyHash = ServerSideSessionKeyHash(
        sessionKeyHashSaltLength: 16,
        sessionKeyHashPepper: 'test-pepper',
        fallbackSessionKeyHashPeppers: const [],
      );

      late final secret = Uint8List.fromList(List.generate(32, (final i) => i));
      late final salt = Uint8List.fromList(
        List.generate(16, (final i) => 255 - i),
      );

      // An empty hash reached `hash[0]` and threw a RangeError, turning a
      // corrupt row into a server error rather than a failed authentication.
      for (final (label, hash) in [
        ('an empty hash', Uint8List(0)),
        ('a truncated hash', Uint8List(32)),
        ('a hash longer than the versioned scheme', Uint8List(128)),
      ]) {
        test(
          'when $label is validated, '
          'then it is rejected rather than throwing.',
          () {
            expect(
              () => sessionKeyHash.validateSessionKeyHash(
                secret: secret,
                hash: hash,
                salt: salt,
              ),
              returnsNormally,
              reason: 'A corrupt row must not throw out of validation.',
            );

            expect(
              sessionKeyHash.validateSessionKeyHash(
                secret: secret,
                hash: hash,
                salt: salt,
              ),
              SessionKeyHashValidation.invalid,
            );
          },
        );
      }
    },
  );
}

/// The pre-fix digest: `sha512(secret + pepper)`, with the salt never mixed in.
Uint8List _legacySaltlessHash(final Uint8List secret, final String pepper) {
  return Uint8List.fromList(
    sha512.convert(secret + utf8.encode(pepper)).bytes,
  );
}
