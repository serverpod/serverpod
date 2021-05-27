import 'dart:convert';
import 'dart:math';

final Random _random = Random.secure();

/// Generates a random string of the specified length.
String generateRandomString([int length = 32]) {
  var values = List<int>.generate(length, (int i) => _random.nextInt(256));
  return base64Url.encode(values).substring(0, length);
}