import 'dart:math';

final Random _random = Random.secure();

/// Returns a secure random numeric string to be used for passwordless
/// verification codes.
///
/// Excludes the digit 0 to avoid confusion with the letter 'o'.
String defaultPasswordlessVerificationCodeGenerator({final int length = 8}) {
  const characters = '123456789';

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(_random.nextInt(characters.length)),
    ),
  );
}
