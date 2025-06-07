import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/business/auth_session_secrets.dart';

/// Uses SHA512 to create a hash for a string using the specified pepper.
({Uint8List hash, Uint8List salt}) createSessionKeyHash({
  required final Uint8List secret,
  @protected Uint8List? salt,
}) {
  final pepper = utf8.encode(AuthSessionSecrets.sessionKeyHashPepper);

  salt ??= generateRandomBytes(
    AuthSessionConfig.current.sessionKeyHashSaltLength,
  );

  if (pepper.length < 10) {
    throw ArgumentError.value(pepper, 'pepper', 'Value is too short');
  }

  final hash = Uint8List.fromList(sha512.convert(secret + pepper).bytes);

  return (hash: hash, salt: salt);
}

/// Validates the sesseion key hash
bool validateSessionKeyHash({
  required final Uint8List secret,
  required final Uint8List hash,
  required final Uint8List salt,
}) {
  return uint8ListAreEqual(
    hash,
    createSessionKeyHash(secret: secret, salt: salt).hash,
  );
}

// TODO: Import these from `serverpod_shared` in the future

/// Checks whether the 2 given lists contain the same data.
bool uint8ListAreEqual(final Uint8List a, final Uint8List b) {
  if (a.length != b.length) {
    return false;
  }

  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}

final Random _random = Random.secure();

/// Generates a list of secure random bytes of the specified length.
Uint8List generateRandomBytes(final int length) {
  return Uint8List.fromList(
    List<int>.generate(length, (final int i) => _random.nextInt(256)),
  );
}
