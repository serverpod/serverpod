import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_auth_api_tokens_server/serverpod_auth_api_tokens_server.dart';
import 'package:serverpod_auth_api_tokens_server/src/business/api_token_secrets.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

@internal
final class ApiTokenHash {
  ApiTokenHash({
    required final ApiTokenSecrets secrets,
  }) : _secrets = secrets;

  final ApiTokenSecrets _secrets;

  /// Uses SHA512 to create a hash for a secret using the specified pepper.
  ({Uint8List hash, Uint8List salt}) createSessionKeyHash({
    required final Uint8List secret,
    @protected Uint8List? salt,
  }) {
    final pepper = utf8.encode(_secrets.apiTokenHashPepper);

    salt ??= generateRandomBytes(ApiTokens.config.apiTokenHashSaltLength);

    final hash = Uint8List.fromList(sha512.convert(secret + pepper).bytes);

    return (hash: hash, salt: salt);
  }

  /// Validates the API token hash.
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
}
