import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Default salt used for hashing authentication keys if no salt is provided.
const String defaultAuthKeySalt = 'salty';

/// Uses SHA256 to create a hash for a string using the specified secret.
String hashString(String secret, String string) {
  return sha256.convert(utf8.encode(secret + string)).toString();
}
