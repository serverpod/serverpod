import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Uses SHA256 to create a hash for a string using the specified pepper.
String hashSessionKey(final String secret, {required final String pepper}) {
  return 'sha256p:${sha256.convert(utf8.encode(secret + pepper)).toString()}';
}
