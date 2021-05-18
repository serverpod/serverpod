import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

final Random _random = Random.secure();

/// Generates a random string of the specified length.
String generateRandomString([int length = 32]) {
  var values = List<int>.generate(length, (int i) => _random.nextInt(256));
  return base64Url.encode(values).substring(0, length);
}

/// Uses SHA256 to create a hash for a string using the specified secret.
String hashString(String secret, String string) {
  return sha256.convert(utf8.encode(secret + string)).toString();
}
