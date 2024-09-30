part of '../headers.dart';

/// A class representing the HTTP Retry-After header.
///
/// This class manages both date-based and delay-based retry values.
/// The Retry-After header can contain either an HTTP date or a delay in seconds
/// indicating when the client should retry the request.
class RetryAfterHeader {
  /// The retry delay in seconds, if present.
  final int? delay;

  /// The retry date, if present.
  final DateTime? date;

  /// Constructs a [RetryAfterHeader] instance with either a delay in seconds or a date.
  const RetryAfterHeader({
    this.delay,
    this.date,
  });

  /// Parses the Retry-After header value and returns a [RetryAfterHeader] instance.
  ///
  /// This method checks if the value is an integer (for delay) or a date string.
  factory RetryAfterHeader.fromHeaderValue(String value) {
    final delay = int.tryParse(value);
    if (delay != null) {
      return RetryAfterHeader(delay: delay);
    } else {
      final date = parseHttpDate(value);
      return RetryAfterHeader(date: date);
    }
  }

  /// Static method that attempts to parse the Retry-After header and returns `null` if the value is `null`.
  static RetryAfterHeader? tryParse(List<String>? value) {
    final first = value?.firstOrNull;
    if (first == null) return null;
    return RetryAfterHeader.fromHeaderValue(first);
  }

  /// Converts the [RetryAfterHeader] instance into a string representation suitable for HTTP headers.
  @override
  String toString() {
    if (delay != null) {
      return delay.toString();
    }
    if (date != null) {
      return formatHttpDate(date!);
    }
    return '';
  }
}
