extension DatetimeExtension on DateTime {
  DateTime get toSecondResolution {
    if (millisecond == 0) return this;
    return subtract(Duration(milliseconds: millisecond));
  }
}
