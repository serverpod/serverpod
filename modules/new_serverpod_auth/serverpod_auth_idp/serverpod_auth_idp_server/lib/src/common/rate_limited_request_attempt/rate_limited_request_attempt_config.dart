import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'rate_limited_request_attempt_util.dart';

/// Configuration for rate limiting request attempts.
///
/// This class provides configuration for the [RateLimitedRequestAttemptUtil]
/// to track and limit attempts based on domain, source, and nonce.
///
/// The rate limiting can be configured in two ways:
/// - By attempt count: Limits the total number of attempts (requires [maxAttempts])
/// - By timeframe: Limits attempts within a rolling window (requires [timeframe])
///
/// Both mechanisms can be used together, but at least one of [maxAttempts] or
/// [timeframe] must be provided.
///
/// At least one of [maxAttempts] or [timeframe] must be provided.
///
/// Type parameter [T] represents the type of the nonce.
class RateLimitedRequestAttemptConfig<T> {
  /// The domain of the attempt.
  ///
  /// Example: "email", "sms", etc.
  final String domain;

  /// The source of the attempt.
  ///
  /// Example: "password_reset", "login_attempt", etc.
  final String source;

  /// Default extra data to be logged for the attempt.
  ///
  /// This data will be logged for every attempt along with the extra data
  /// provided to the [RateLimitedRequestAttemptUtil.hasTooManyAttempts] method.
  final Map<String, String>? defaultExtraData;

  /// The maximum number of attempts allowed.
  ///
  /// If provided, limits the total number of attempts for a given nonce.
  /// If [timeframe] is also provided, this limit applies within that timeframe.
  final int? maxAttempts;

  /// The timeframe within which attempts are counted.
  ///
  /// If provided, only attempts within this rolling window are counted.
  /// If [maxAttempts] is also provided, the limit applies within this timeframe.
  final Duration? timeframe;

  /// Optional callback called when rate limit is exceeded.
  ///
  /// Can be used to cleanup unverified requests outside of the transaction.
  final Future<void> Function(Session session, T nonce)? onRateLimitExceeded;

  /// Converts the nonce to a string.
  ///
  /// Default implementation uses [SerializationManager.encode] to convert most
  /// known basic types to strings.
  late final String Function(T nonce) nonceToString;

  /// Converts the nonce from a string.
  ///
  /// Default implementation uses [Protocol().deserialize<T>] to convert strings
  /// to basic known types.
  late final T Function(String nonce) nonceFromString;

  /// Creates a new [RateLimitedRequestAttemptUtil] instance.
  ///
  /// At least one of [maxAttempts] or [timeframe] must be provided.
  ///
  /// Throws [ArgumentError] if both [maxAttempts] and [timeframe] are null.
  RateLimitedRequestAttemptConfig({
    required this.domain,
    required this.source,
    this.defaultExtraData,
    this.maxAttempts,
    this.timeframe,
    this.onRateLimitExceeded,
    final String Function(T nonce)? nonceToString,
    final T Function(String nonce)? nonceFromString,
  }) : assert(
         maxAttempts != null || timeframe != null,
         'At least one of maxAttempts or timeframe must be provided',
       ) {
    this.nonceToString = nonceToString ?? _nonceToString;
    this.nonceFromString = nonceFromString ?? _nonceFromString;
  }

  /// Converts nonce of type [T] to a string.
  ///
  /// If [T] is [String], the nonce is returned as is.
  static String _nonceToString<T>(final T nonce) =>
      nonce is String ? nonce : SerializationManager.encode(nonce);

  /// Converts nonce of type [String] to a type [T].
  ///
  /// If [T] is [String], the nonce is returned as is.
  static T _nonceFromString<T>(final String nonce) =>
      T == String ? nonce as T : Protocol().deserialize<T>(nonce);
}
