import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Hex-encoded SHA-256 of [value], used as `PushDevice.identityHash`.
String sha256Hex(final String value) {
  return sha256.convert(utf8.encode(value)).toString();
}
