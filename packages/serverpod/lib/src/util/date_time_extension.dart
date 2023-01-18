/// Convenience methods for DateTime. Use only with UTC times.
extension DateTimeExt on DateTime {
  /// Returns true if [other] is the same hour.
  bool isSameHour(DateTime other) =>
      year == other.year &&
      month == other.month &&
      day == other.day &&
      hour == other.hour;

  /// Returns true if [other] is the same day.
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns a copy of the timestamp with anything smaller than an hour
  /// stripped.
  DateTime get asHour => DateTime.utc(year, month, day, hour);

  /// Returns a copy of the timestamp with anything smaller than a day
  /// stripped.
  DateTime get asDay => DateTime.utc(year, month, day);
}
