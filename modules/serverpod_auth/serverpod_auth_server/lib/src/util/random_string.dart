import 'dart:math';

/// An extension for generating random strings.
extension RandomString on Random {
  /// Returns a random [String] consisting of letters and numbers, by default
  /// the [length] of the string will be 16 characters.
  String nextString([int length = 16]) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(nextInt(chars.length))));
  }
}