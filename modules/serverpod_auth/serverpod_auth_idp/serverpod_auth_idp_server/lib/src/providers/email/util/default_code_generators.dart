import 'dart:math';

final Random _random = Random.secure();

/// Returns a secure random string to be used for short-lived verification codes.
///
/// The code is [length] digits long, 8 by default. Excludes the digit 0 to
/// avoid confusion with the letter 'o'.
String defaultVerificationCodeGenerator({final int length = 8}) {
  const characters = '123456789';

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(_random.nextInt(characters.length)),
    ),
  );
}

/// Returns a secure random 6 digit code to be used for one-time passwords.
///
/// Uses [defaultVerificationCodeGenerator] with a length of 6.
String defaultOtpVerificationCodeGenerator() =>
    defaultVerificationCodeGenerator(length: 6);
