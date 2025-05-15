import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Uses SHA256 to create a hash for a string using the specified pepper.
///
/// [pepper] must be at least 10 characters long.
String hashSessionKey(final String secret, {required final String pepper}) {
  if (pepper.length < 10) {
    throw ArgumentError.value(pepper, 'pepper', 'Value is too short');
  }

  return 'sha256p:${sha256.convert(utf8.encode(secret + pepper)).toString()}';
}
