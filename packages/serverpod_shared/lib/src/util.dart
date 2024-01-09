import 'dart:convert';
import 'dart:math';
import 'package:super_string/super_string.dart';
import 'package:crypto/crypto.dart';

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
      return '$previousValue${element.capitalize()}';
    }
  });
}

/// Deterministically truncates an [identifier] to a [maxLength] String.
///
/// If the identifier is longer than the maximum length, the identifier is
/// truncated and [hashLength] number of characters are replaced at the
/// end of the identifier with and identifier digest.
///
/// The hash length cannot be longer than the length of the hash returned
/// from the hash algorithm.
/// The function will silently use the generated hash length it is is shorter
/// than the provided [hashLength].
String truncateIdentifier(
  String identifier,
  int maxLength, {
  int hashLength = 4,
}) {
  if (identifier.length <= maxLength) {
    return identifier;
  }

  if (hashLength > maxLength) {
    throw ArgumentError(
      'Hash length cannot be longer than max length of identifier.',
    );
  }
  var hash = sha256.convert(utf8.encode(identifier)).toString();

  if (hashLength > hash.length) {
    hashLength = hash.length - 1;
  }

  var digest = hash.substring(0, hashLength);

  return identifier.substring(0, maxLength - hashLength) + digest;
}
