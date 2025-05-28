import 'dart:math';
import 'dart:typed_data';

final Random _random = Random.secure();

/// Generates a secure random =bytes of the specified length.
Uint8List generateRandomBytes(final int length) {
  return Uint8List.fromList(
    List<int>.generate(length, (final int i) => _random.nextInt(256)),
  );
}
