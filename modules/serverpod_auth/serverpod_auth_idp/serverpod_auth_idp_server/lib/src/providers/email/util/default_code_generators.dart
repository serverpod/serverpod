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

/// Returns a secure random string of 6 decimal digits (`0`-`9`).
///
/// Suited for short-lived, attempt-limited codes such as the ones used by the
/// passwordless email login. Digits only, so the code is easy to type and
/// satisfies the Serverpod Cloud email service constraint of 1-16 alphanumeric
/// characters.
String defaultSixDigitVerificationCodeGenerator() {
  const characters = '0123456789';

  return String.fromCharCodes(
    Iterable.generate(
      6,
      (_) => characters.codeUnitAt(_random.nextInt(characters.length)),
    ),
  );
}
