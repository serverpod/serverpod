import 'dart:convert';
import 'dart:math';

/// Generates a secure random string of the specified length.
///
/// The [byteLength] parameter specifies the number of random bytes to generate.
/// The result is base64url-encoded without padding.
String generateSecureRandomString(int byteLength) {
  final random = Random.secure();
  final bytes = List<int>.generate(byteLength, (i) => random.nextInt(256));
  return base64UrlEncode(bytes).replaceAll('=', '');
}
