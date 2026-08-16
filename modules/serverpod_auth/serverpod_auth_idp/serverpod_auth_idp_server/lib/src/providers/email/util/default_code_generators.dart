import 'dart:math';

final Random _random = Random.secure();

/// Returns a secure random string to be used for short-lived verification codes.
///
/// Excludes the digit 0 to avoid confusion with the letter 'o'.
String defaultVerificationCodeGenerator() {
  const characters = '123456789';

  return String.fromCharCodes(
    Iterable.generate(
      8,
      (_) => characters.codeUnitAt(_random.nextInt(characters.length)),
    ),
  );
}
