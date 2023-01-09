extension NullableString on String? {
  /// Add [other] to [this], if and only if [this] is not [null].
  String? operator +(String other) {
    // print('$this + $other');
    if (this == null) {
      return null;
    } else {
      return '${this!}$other';
    }
  }
}
