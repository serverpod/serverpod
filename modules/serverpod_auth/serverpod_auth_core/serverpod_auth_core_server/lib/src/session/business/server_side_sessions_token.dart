import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Prefix for sessions keys
/// "sas" being abbreviated of "serverpod_auth_session"
final _sessionKeyPrefix = utf8.encode('sas');

/// The URL-safe base64 Prefix of the session key.
/// This only works for the prefix length of 3, as that result in exactly 4
/// characters and thus does not change with the later data.
final _sessionKeyPrefixBase64 = base64Url.encode(_sessionKeyPrefix);

/// Creates the String representation to map to a `ServerSideSession`.
@internal
String buildServerSideSessionToken({
  required final UuidValue serverSideSessionId,
  required final Uint8List secret,
}) {
  return base64Url.encode([
    ..._sessionKeyPrefix,
    ...serverSideSessionId.toBytes(),
    ...secret,
  ]);
}

/// Tries parsing a server side session token String created by [buildServerSideSessionToken] into its
/// parts.
///
/// Returns `null` if it does not match the spec or parsing fails for any reason.
///
/// If the [session] is provided, it will be used to log a warning if the parsing fails.
/// Otherwise, the error is ignored.
@internal
SessionKeyData? tryParseServerSideSessionToken(
  final Session? session,
  final String key,
) {
  try {
    if (!key.startsWith(_sessionKeyPrefixBase64)) {
      return null;
    }

    final decoded = base64Url.decode(key);

    final serverSideSessionId = UuidValue.fromByteList(
      Uint8List.sublistView(
        decoded,
        _sessionKeyPrefix.lengthInBytes,
        _sessionKeyPrefix.lengthInBytes + 16,
      ),
    )..validate();

    final secret = Uint8List.sublistView(
      decoded,
      _sessionKeyPrefix.lengthInBytes + 16,
    );

    return (serverSideSessionId: serverSideSessionId, secret: secret);
  } catch (e, stackTrace) {
    session?.log(
      'Failed to parse session key: "$key"',
      level: LogLevel.error,
      exception: e,
      stackTrace: stackTrace,
    );

    return null;
  }
}

/// The data retrieved from a session key string.
@internal
typedef SessionKeyData = ({UuidValue serverSideSessionId, Uint8List secret});
