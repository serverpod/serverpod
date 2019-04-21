import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

final Random _random = Random.secure();

String generateRandomString([int length = 32]) {
  var values = List<int>.generate(length, (int i) => _random.nextInt(256));
  return base64Url.encode(values).substring(0, length);
}

String hashString(String secret, String string) {
  return sha256.convert(utf8.encode(secret + string)).toString();
}
