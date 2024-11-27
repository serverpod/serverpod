/// Extensions on [DateTime].
extension DatetimeExtension on DateTime {
  /// Returns a new [DateTime] with the milliseconds set to 0.
  DateTime get toSecondResolution {
    if (millisecond == 0) return this;
    return subtract(Duration(milliseconds: millisecond));
  }
}
