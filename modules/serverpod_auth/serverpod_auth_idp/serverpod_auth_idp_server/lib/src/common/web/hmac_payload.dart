import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:crypto/crypto.dart';

final _random = Random.secure();

/// Key in `passwords.yaml` for the HMAC that signs HTML OAuth state.
const String webAuthOAuthStatePepperPasswordKey = 'webAuthOAuthStatePepper';

/// Lifetime of HMAC'd OAuth state (cookie or Apple `state` field).
const Duration oauthStateMaxAge = Duration(minutes: 10);

/// A cryptographically random URL-safe string of [byteLength] bytes.
String generateSecureRandomString(final int byteLength) {
  final bytes = List<int>.generate(
    byteLength,
    (final _) => _random.nextInt(256),
  );
  return base64Url.encode(bytes).replaceAll('=', '');
}

/// Timing-safe equality for two strings of any length.
bool timingSafeEquals(final String a, final String b) {
  final aBytes = utf8.encode(a);
  final bBytes = utf8.encode(b);
  final length = aBytes.length > bBytes.length ? aBytes.length : bBytes.length;
  final paddedA = Uint8List(length)..setRange(0, aBytes.length, aBytes);
  final paddedB = Uint8List(length)..setRange(0, bBytes.length, bBytes);
  var diff = aBytes.length ^ bBytes.length;
  for (var i = 0; i < length; i++) {
    diff |= paddedA[i] ^ paddedB[i];
  }
  return diff == 0;
}

String _macB64(final String payloadB64, final String pepper) {
  final hmac = Hmac(sha256, utf8.encode(pepper));
  return base64Url
      .encode(hmac.convert(utf8.encode(payloadB64)).bytes)
      .replaceAll('=', '');
}

/// Encodes [payload] as `base64url(hmac).base64url(json)` keyed by [pepper].
///
/// Adds `iat` (UTC milliseconds) when the payload does not already include it.
String encodeHmacPayload(
  final Map<String, Object?> payload,
  final String pepper,
) {
  final withIat = Map<String, Object?>.from(payload);
  withIat.putIfAbsent(
    'iat',
    () => clock.now().toUtc().millisecondsSinceEpoch,
  );
  final payloadB64 = base64Url
      .encode(utf8.encode(jsonEncode(withIat)))
      .replaceAll('=', '');
  return '${_macB64(payloadB64, pepper)}.$payloadB64';
}

/// Decodes and verifies an [encodeHmacPayload] token.
///
/// Returns null if the token is malformed, the HMAC does not match, or [iat]
/// is missing / older than [maxAge]. A one-minute clock-skew allowance is
/// applied for tokens that appear slightly in the future.
Map<String, Object?>? decodeHmacPayload(
  final String token,
  final String pepper, {
  final Duration maxAge = oauthStateMaxAge,
}) {
  final dot = token.indexOf('.');
  if (dot <= 0 || dot == token.length - 1) return null;
  final mac = token.substring(0, dot);
  final payloadB64 = token.substring(dot + 1);
  if (!timingSafeEquals(mac, _macB64(payloadB64, pepper))) return null;

  Map<String, dynamic> json;
  try {
    final padded = payloadB64.padRight(
      payloadB64.length + (4 - payloadB64.length % 4) % 4,
      '=',
    );
    json =
        jsonDecode(utf8.decode(base64Url.decode(padded)))
            as Map<String, dynamic>;
  } on FormatException {
    return null;
  } on ArgumentError {
    return null;
  }

  final iat = json['iat'];
  if (iat is! int) return null;
  final issuedAt = DateTime.fromMillisecondsSinceEpoch(iat, isUtc: true);
  final now = clock.now().toUtc();
  if (now.difference(issuedAt) > maxAge) return null;
  if (issuedAt.isAfter(now.add(const Duration(minutes: 1)))) return null;
  return Map<String, Object?>.from(json);
}

/// SHA-256 S256 code challenge for [codeVerifier] (base64url, no padding).
String pkceS256Challenge(final String codeVerifier) {
  final digest = sha256.convert(utf8.encode(codeVerifier));
  return base64Url.encode(digest.bytes).replaceAll('=', '');
}
