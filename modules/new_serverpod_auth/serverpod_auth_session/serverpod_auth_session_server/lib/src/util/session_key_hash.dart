import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/business/auth_session_secrets.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Uses SHA512 to create a hash for a string using the specified pepper.
({Uint8List hash, Uint8List salt}) createSessionKeyHash({
  required final Uint8List secret,
  @protected Uint8List? salt,
}) {
  final pepper = utf8.encode(AuthSessionSecrets.sessionKeyHashPepper);

  salt ??= generateRandomBytes(AuthSessions.config.sessionKeyHashSaltLength);

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
