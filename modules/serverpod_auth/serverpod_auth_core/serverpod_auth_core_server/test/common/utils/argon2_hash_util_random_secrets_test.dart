import 'dart:typed_data';

import 'package:serverpod_auth_core_server/src/common/utils/argon2_hash_util.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given an Argon2HashUtil for random secrets, '
    'when hashing a 16 byte secret, '
    'then the hash is created at the minimal Argon2 cost',
    () async {
      final hashUtil = Argon2HashUtil.forRandomSecrets(
        hashPepper: 'test-pepper',
        hashSaltLength: 16,
      );

      final result = await hashUtil.createHashFromBytes(secret: Uint8List(16));

      expect(result, startsWith(r'$argon2id$v=19$m=8,t=1,p=1$'));
    },
  );

  test(
    'Given an Argon2HashUtil for random secrets, '
    'when hashing a 15 byte secret, '
    'then an AssertionError is thrown',
    () async {
      final hashUtil = Argon2HashUtil.forRandomSecrets(
        hashPepper: 'test-pepper',
        hashSaltLength: 16,
      );

      await expectLater(
        hashUtil.createHashFromBytes(secret: Uint8List(15)),
        throwsA(isA<AssertionError>()),
      );
    },
  );

  test(
    'Given a hash created for random secrets, '
    'when validating the secret with an Argon2HashUtil at the default cost, '
    'then it is valid',
    () async {
      final hashString = await Argon2HashUtil.forRandomSecrets(
        hashPepper: 'test-pepper',
        hashSaltLength: 16,
      ).createHashFromBytes(secret: Uint8List(64));
      final defaultCostHashUtil = Argon2HashUtil(
        hashPepper: 'test-pepper',
        hashSaltLength: 16,
      );

      final result = await defaultCostHashUtil.validateHashFromBytes(
        secret: Uint8List(64),
        hashString: hashString,
      );

      expect(result, isTrue);
    },
  );

  test(
    'Given a hash created at the default cost, '
    'when validating the secret with an Argon2HashUtil for random secrets, '
    'then it is valid',
    () async {
      final hashString = await Argon2HashUtil(
        hashPepper: 'test-pepper',
        hashSaltLength: 16,
      ).createHashFromBytes(secret: Uint8List(64));
      final randomSecretsHashUtil = Argon2HashUtil.forRandomSecrets(
        hashPepper: 'test-pepper',
        hashSaltLength: 16,
      );

      final result = await randomSecretsHashUtil.validateHashFromBytes(
        secret: Uint8List(64),
        hashString: hashString,
      );

      expect(result, isTrue);
    },
  );

  test(
    'Given a hash created for random secrets, '
    'when validating a secret shorter than 16 bytes, '
    'then it returns false instead of throwing',
    () async {
      final hashUtil = Argon2HashUtil.forRandomSecrets(
        hashPepper: 'test-pepper',
        hashSaltLength: 16,
      );
      final hashString = await hashUtil.createHashFromBytes(
        secret: Uint8List(64),
      );

      final result = await hashUtil.validateHashFromBytes(
        secret: Uint8List(8),
        hashString: hashString,
      );

      expect(result, isFalse);
    },
  );
}
