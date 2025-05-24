/// Extension method to compares two lists for equality.
extension ListEquals<T> on List<T> {
  /// Returns `true` if all elements of the lists are equal.
  bool equals(List<T> other) {
    if (length != other.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }

    return true;
  }
}
