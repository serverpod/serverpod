import 'dart:math';

final Random _random = Random.secure();

/// Returns a secure random numeric string to be used for SMS verification codes.
///
/// Default length is 6 digits.
String defaultSmsVerificationCodeGenerator({int length = 6}) {
  return List.generate(length, (_) => _random.nextInt(10)).join();
}
