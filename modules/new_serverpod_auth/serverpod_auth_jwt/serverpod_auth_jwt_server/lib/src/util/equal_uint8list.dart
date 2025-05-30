import 'dart:typed_data';

/// Checks whether the 2 given lists contain the same data.
bool uint8ListAreEqual(final Uint8List a, final Uint8List b) {
  if (a.length != b.length) {
    return false;
  }

  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}
