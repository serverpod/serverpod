import 'dart:math';

final Random _random = Random.secure();

/// Returns a secure random string to be used for short-lived verification codes.
///
/// The code uses a slightly reduced alphabet from [a-z0-9] to exclude easily confused characters.
String defaultVerificationCodeGenerator() {
  const alphabet = 'abcdefghikmnpqrstuvwxyz123456789';

  return List<String>.generate(
    8,
    (final _) {
      final i = _random.nextInt(alphabet.length);
      return alphabet.substring(i, i + 1);
    },
  ).join();
}
