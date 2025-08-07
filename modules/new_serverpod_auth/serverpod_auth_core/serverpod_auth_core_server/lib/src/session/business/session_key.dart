import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Prefix for sessions keys
/// "sas" being abbreviated of "serverpod_auth_session"
const _sessionKeyPrefix = 'sas';

/// Creates the String representation to map to an `AuthSession`.
@internal
String buildSessionKey({
  required final UuidValue authSessionId,
  required final Uint8List secret,
}) {
  // Since the session key is sent as a `Basic` HTTP `Authorization` header by the Serverpod client,
  // it's important that it contains at least one `:` so the `user:pass` schema is obeyed.
  return '$_sessionKeyPrefix:${base64Url.encode(authSessionId.toBytes())}:${base64Url.encode(secret)}';
}

/// Tries parsing a session key String created by [buildSessionKey] into its
/// parts.
///
/// Returns `null` if it does not match the spec or parsing fails for any reason.
@internal
SessionKeyData? tryParseSessionKey(
  final Session session,
  final String key,
) {
  if (!key.startsWith('$_sessionKeyPrefix:')) {
    return null;
  }

  final parts = key.split(':');
  if (parts.length != 3) {
    session.log(
      'Unexpected key format',
      level: LogLevel.debug,
    );

    return null;
  }

  final UuidValue authSessionId;
  try {
    authSessionId = UuidValue.fromByteList(base64Url.decode(parts[1]))
      ..validate();
  } catch (e, stackTrace) {
    session.log(
      'Failed to parse auth session ID',
      level: LogLevel.debug,
      exception: e,
      stackTrace: stackTrace,
    );

    return null;
  }

  final Uint8List secret;
  try {
    secret = base64Url.decode(parts[2]);
  } catch (e, stackTrace) {
    session.log(
      'Failed to parse secret ID',
      level: LogLevel.debug,
      exception: e,
      stackTrace: stackTrace,
    );

    return null;
  }

  return (authSessionId: authSessionId, secret: secret);
}

/// The data retrieved from a session key string.
@internal
typedef SessionKeyData = ({UuidValue authSessionId, Uint8List secret});
