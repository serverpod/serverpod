import 'dart:typed_data';

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
void main() {
  group('Given a session key hash util', () {
    final sessionKeyHash = ServerSideSessionKeyHash(
      sessionKeyHashSaltLength: 16,
      sessionKeyHashPepper: 'test-pepper',
      fallbackSessionKeyHashPeppers: const [],
    );

    final secret = Uint8List.fromList(List.generate(32, (final i) => i));

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
          isFalse,
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
          isTrue,
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
          isFalse,
        );
      },
    );
  });
}
