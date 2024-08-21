/// Regular expression pattern that matches a duration component with
/// an integer value followed by a valid unit (d, h, min, s, ms).
///
/// Example Matches:
/// - `1d`
/// - `12h`
/// - `30min`
/// - `45s`
/// - `250ms`
const durationComponentPattern = r'(\d+)(d|h|min|s|ms)';

/// Regular expression pattern that matches a complete duration string
/// consisting of multiple duration components separated by spaces.
///
/// Example Matches:
/// - `1d 12h 30min 45s 250ms`
/// - `30min 45s`
/// - `1h 250ms`
const fullDurationPattern = r'^(\d+(d|h|min|s|ms)\s*)+$';

/// Checks if the given value is a valid duration string, using the fullDurationPattern.
///
/// Example:
/// - Input: `1d 12h 30min 45s 250ms`
/// - Returns: `true`
///
/// - Input: `12h 45x`
/// - Returns: `false`
bool isValidDuration(dynamic value) {
  if (value is! String) return false;
  return RegExp(fullDurationPattern).hasMatch(value.trim());
}

/// Parses the valid duration string into a `CustomDuration` object.
/// This allows for easy access to individual components such as days, hours, minutes, seconds, and milliseconds.
///
/// Example:
/// - Input: `1d 12h 30min 45s 250ms`
/// - Output: `CustomDuration` object with corresponding values
///
/// - Input: `30min 250ms`
/// - Output: `CustomDuration` object with corresponding values
Duration parseDuration(dynamic input) {
  if (input is Duration) return input;

  var durationPattern = RegExp(durationComponentPattern);
  var matches = durationPattern.allMatches(input);

  int days = 0, hours = 0, minutes = 0, seconds = 0, milliseconds = 0;

  for (var match in matches) {
    var value = int.parse(match.group(1)!);
    var unit = match.group(2);
    switch (unit) {
      case 'd':
        days = value;
        break;
      case 'h':
        hours = value;
        break;
      case 'min':
        minutes = value;
        break;
      case 's':
        seconds = value;
        break;
      case 'ms':
        milliseconds = value;
        break;
      default:
        throw ArgumentError('Invalid duration unit: $unit');
    }
  }

  return Duration(
    days: days,
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}

/// Extension on Dart's `Duration` class to provide access to individual
/// time components like days, hours, minutes, seconds, and milliseconds.
///
/// This is useful for scenarios where you need to extract specific components
/// from a `Duration` object without converting everything to the largest unit.
extension DurationComponentsExtension on Duration {
  /// Returns the number of days in this `Duration`.
  ///
  /// This is equivalent to `inDays`, which gives the total number of days
  /// represented by the `Duration`.
  int get days => inDays;

  /// Returns the number of hours in this `Duration` that do not complete a full day.
  ///
  /// This is calculated as the remainder of `inHours` divided by 24.
  /// Useful for extracting the hour component in scenarios where days are also tracked.
  int get hours => inHours % 24;

  /// Returns the number of minutes in this `Duration` that do not complete a full hour.
  ///
  /// This is calculated as the remainder of `inMinutes` divided by 60.
  /// Useful for extracting the minute component without converting everything to hours.
  int get minutes => inMinutes % 60;

  /// Returns the number of seconds in this `Duration` that do not complete a full minute.
  ///
  /// This is calculated as the remainder of `inSeconds` divided by 60.
  /// Useful for extracting the second component without converting everything to minutes.
  int get seconds => inSeconds % 60;

  /// Returns the number of milliseconds in this `Duration` that do not complete a full second.
  ///
  /// This is calculated as the remainder of `inMilliseconds` divided by 1000.
  /// Useful for extracting the millisecond component without converting everything to seconds.
  int get milliseconds => inMilliseconds % 1000;
}
