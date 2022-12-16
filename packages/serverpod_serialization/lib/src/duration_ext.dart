/// Extension for decoding [Duration] in the protocol.
extension DurationDec on String {
  /// This next example shows the how decodeDuration() works
  ///
  /// ```dart
  /// Duration duration = Duration(seconds:1);
  /// String encodedDuration = duration.toString();
  /// Duration decodedDuration = encodedDuration.decodeDuration();
  /// print(encodedDuration); // 0:00:01.000000
  /// print(decodedDuration.toString()); // 0:00:01.000000
  /// ```
  ///
  /// ```dart
  /// try{
  ///   Duration decodedDuration = 'not Duration.toString()'.decodeDuration();
  /// }on FormatException (e){
  ///   print(e); // FormatException: Invalid Duration format
  /// }
  /// ```
  ///
  /// Returns [Duration] from an encoded String.
  Duration decodeDuration() {
    var parts = split(':');

    if (parts.length != 3) {
      throw const FormatException('Invalid Duration format');
    }

    int days;
    int hours;
    int minutes;
    int seconds;
    int milliseconds;
    int microseconds;
    bool isNegative = false;
    if (parts.first.codeUnitAt(0) == 45) {
      isNegative = true;
    }

    {
      var p = parts[2].split('.');

      if (p.length != 2) throw const FormatException('Invalid Duration format');

      // If fractional seconds is passed, but less than 6 digits
      // Pad out to the right so we can calculate the ms/us correctly
      var p2 = int.parse(p[1].padRight(6, '0'));
      microseconds = p2 % 1000;
      milliseconds = p2 ~/ 1000;

      seconds = int.parse(p[0]);
    }

    minutes = int.parse(parts[1]);

    {
      int p = int.parse(parts[0]);
      hours = p % 24;
      days = p ~/ 24;
    }

    var duration = Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds);
    if (isNegative) {
      return duration * -1;
    }
    return duration;
  }

  /// This next example shows the how tryDecodeDuration() works
  ///
  /// ```dart
  ///   Duration duration = Duration(seconds:1);
  ///   String encodedDuration = duration.toString();
  ///   Duration decodedDuration = encodedDuration.tryDecodeDuration();
  ///   print(encodedDuration); // 0:00:01.000000
  ///   print(decodedDuration?.toString()); // 0:00:01.000000
  /// ```
  ///
  /// ```dart
  ///   Duration? decodedDuration = 'not Duration.toString()'.tryDecodeDuration();
  ///   print(decodedDuration); // null
  /// ```
  ///
  /// Returns [Duration?] from an encoded String.
  Duration? tryDecodeDuration() {
    try {
      return decodeDuration();
    } catch (e) {
      return null;
    }
  }
}
