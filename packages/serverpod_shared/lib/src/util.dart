import 'dart:convert';
import 'dart:math';

final Random _random = Random.secure();

/// Generates a random string of the specified length.
String generateRandomString([int length = 32]) {
  var values = List<int>.generate(length, (int i) => _random.nextInt(256));
  return base64Url.encode(values).substring(0, length);
}

/// Splits at spaces and joins to lowerCamelCase.
String databaseTypeToLowerCamelCase(String databaseType) {
  return databaseType.split(' ').fold('', (previousValue, element) {
    if (previousValue.isEmpty || element.isEmpty) {
      return '$previousValue${element.toLowerCase()}';
    } else {
      return '$previousValue${element.substring(0, 1).toUpperCase()}${element.substring(1).toLowerCase()}';
    }
  });
}
