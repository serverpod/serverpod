import 'dart:typed_data';

import 'package:serverpod_argon2/serverpod_argon2.dart' as native;
import 'package:serverpod_auth_core_server/src/common/utils/argon2_hash_util.dart';
import 'package:test/test.dart';

/// Hashes of `test-secret-123` with the pepper `test-pepper`, computed by
/// pointycastle before hashing moved to the native library. The first stands
/// for rows that already exist in production databases. The second has a salt
/// below the 8 bytes Argon2 requires, which pointycastle accepted.
const _pointycastleHashWith16ByteSalt =
    r'$argon2id$v=19$m=64,t=2,p=2$AQIDBAUGBwgJCgsMDQ4PEA==$OocnDoOKtbK8ledblth5ISyhMY52gHhuzoazrDf8MYM=';
const _pointycastleHashWith4ByteSalt =
    r'$argon2id$v=19$m=64,t=2,p=2$AQIDBA==$rDjwEHTkW7CESVoTBjKikgnC2iui0T/AC5lNhw3+97k=';

/// The same inputs hashed with Argon2 version 1.0, which writes `v=16`.
const _pointycastleVersion10Hash =
    r'$argon2id$v=16$m=64,t=2,p=2$AQIDBAUGBwgJCgsMDQ4PEA==$8ktv/F9AHzAB44m9Ml4LDaqRxF2nSt6+TfaV5t2mXQ8=';

/// Configured with the pepper and cost the hashes above were computed with.
Argon2HashUtil _hashUtil() {
  return Argon2HashUtil(
    hashPepper: 'test-pepper',
    hashSaltLength: 16,
    parameters: Argon2HashParameters(memory: 64, iterations: 2, lanes: 2),
  );
}

Uint8List _sequentialSalt(final int length) {
  return Uint8List.fromList(List.generate(length, (final i) => i + 1));
}

void main() {
  test(
    'Given a test run with native assets, '
    'when loading the native Argon2 library, '
    'then it loads',
    () async {
      await expectLater(native.Argon2.load(), completes);
    },
  );

  test(
    'Given a hash with a 16 byte salt computed by pointycastle, '
    'when validating the secret, '
    'then it is valid',
    () async {
      final result = await _hashUtil().validateHashFromString(
        secret: 'test-secret-123',
        hashString: _pointycastleHashWith16ByteSalt,
      );

      expect(result, isTrue);
    },
  );

  test(
    'Given a hash with a 16 byte salt computed by pointycastle, '
    'when validating another secret, '
    'then it is invalid',
    () async {
      final result = await _hashUtil().validateHashFromString(
        secret: 'another-secret',
        hashString: _pointycastleHashWith16ByteSalt,
      );

      expect(result, isFalse);
    },
  );

  test(
    'Given a fixed 16 byte salt, '
    'when creating a hash, '
    'then it equals the hash pointycastle computed',
    () async {
      final result = await _hashUtil().createHashFromString(
        secret: 'test-secret-123',
        salt: _sequentialSalt(16),
      );

      expect(result, _pointycastleHashWith16ByteSalt);
    },
  );

  test(
    'Given a salt length of 7 bytes, '
    'when creating an Argon2HashUtil, '
    'then an ArgumentError is thrown',
    () {
      expect(
        () => Argon2HashUtil(hashPepper: 'test-pepper', hashSaltLength: 7),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a salt length of 8 bytes, '
    'when creating an Argon2HashUtil, '
    'then it is created',
    () {
      expect(
        () => Argon2HashUtil(hashPepper: 'test-pepper', hashSaltLength: 8),
        returnsNormally,
      );
    },
  );

  test(
    'Given a stored hash with a 4 byte salt, '
    'when validating the secret, '
    'then it is invalid',
    () async {
      final result = await _hashUtil().validateHashFromString(
        secret: 'test-secret-123',
        hashString: _pointycastleHashWith4ByteSalt,
      );

      expect(result, isFalse);
    },
  );

  test(
    'Given a hash computed with Argon2 version 1.0, '
    'when validating the secret, '
    'then it is invalid',
    () async {
      final result = await _hashUtil().validateHashFromString(
        secret: 'test-secret-123',
        hashString: _pointycastleVersion10Hash,
      );

      expect(result, isFalse);
    },
  );
}
