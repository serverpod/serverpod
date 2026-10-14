import 'dart:math';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'future_call_retry_policy.dart';

bool _hasReachedMaxAttempts(int maxAttempts, FutureCallRetryContext context) {
  return context.retryAttempt >= maxAttempts;
}

void _validateMaxAttempts(int maxAttempts) {
  if (maxAttempts < 1) {
    throw ArgumentError.value(
      maxAttempts,
      'maxAttempts',
      'Must 1 or greater.',
    );
  }
}

void _validateDelay(Duration? delay, String name) {
  if (delay != null && delay.isNegative) {
    throw ArgumentError.value(delay, name, 'Must not be negative.');
  }
}

Duration _capDelay(Duration delay, Duration? maxDelay) {
  if (maxDelay != null && delay > maxDelay) return maxDelay;
  return delay;
}

/// A [FutureCallRetryPolicy] that waits the same [delay] before every retry.
final class FixedDelayRetryPolicy extends FutureCallRetryPolicy {
  /// The maximum number of retries. The first run is not counted.
  final int maxAttempts;

  /// The delay before every retry.
  final Duration delay;

  /// Creates a new [FixedDelayRetryPolicy].
  const FixedDelayRetryPolicy({
    required this.maxAttempts,
    required this.delay,
  });

  /// Creates a [FixedDelayRetryPolicy] from its serialized form.
  factory FixedDelayRetryPolicy.fromJson(Map<String, dynamic> json) {
    return FixedDelayRetryPolicy(
      maxAttempts: json['maxAttempts'] as int,
      delay: DurationJsonExtension.fromJson(json['delay']),
    );
  }

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    if (_hasReachedMaxAttempts(maxAttempts, context)) return null;
    return delay;
  }

  @override
  void validate() {
    _validateMaxAttempts(maxAttempts);
    _validateDelay(delay, 'delay');
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxAttempts': maxAttempts,
    'delay': delay.toJson(),
  };
}

/// A [FutureCallRetryPolicy] that waits [initialDelay] before the first retry,
/// then adds [increment] to the wait for each retry after that.
final class LinearBackoffRetryPolicy extends FutureCallRetryPolicy {
  /// The maximum number of retries. The first run is not counted.
  final int maxAttempts;

  /// The delay before the first retry.
  final Duration initialDelay;

  /// The amount added to the delay for each retry after the first.
  final Duration increment;

  /// The longest delay before a retry. If null, the delay is not capped.
  final Duration? maxDelay;

  /// Creates a new [LinearBackoffRetryPolicy].
  const LinearBackoffRetryPolicy({
    required this.maxAttempts,
    required this.initialDelay,
    required this.increment,
    this.maxDelay,
  });

  /// Creates a [LinearBackoffRetryPolicy] from its serialized form.
  factory LinearBackoffRetryPolicy.fromJson(Map<String, dynamic> json) {
    var maxDelay = json['maxDelay'];
    return LinearBackoffRetryPolicy(
      maxAttempts: json['maxAttempts'] as int,
      initialDelay: DurationJsonExtension.fromJson(json['initialDelay']),
      increment: DurationJsonExtension.fromJson(json['increment']),
      maxDelay: maxDelay == null
          ? null
          : DurationJsonExtension.fromJson(maxDelay),
    );
  }

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    if (_hasReachedMaxAttempts(maxAttempts, context)) return null;
    return _capDelay(initialDelay + increment * context.retryAttempt, maxDelay);
  }

  @override
  void validate() {
    _validateMaxAttempts(maxAttempts);
    _validateDelay(initialDelay, 'initialDelay');
    _validateDelay(increment, 'increment');
    _validateDelay(maxDelay, 'maxDelay');
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxAttempts': maxAttempts,
    'initialDelay': initialDelay.toJson(),
    'increment': increment.toJson(),
    if (maxDelay != null) 'maxDelay': maxDelay!.toJson(),
  };
}

/// A [FutureCallRetryPolicy] that waits [initialDelay] before the first retry,
/// then multiplies the wait by [multiplier] for each retry after that.
final class ExponentialBackoffRetryPolicy extends FutureCallRetryPolicy {
  /// The maximum number of retries. The first run is not counted.
  final int maxAttempts;

  /// The delay before the first retry.
  final Duration initialDelay;

  /// The factor the delay is multiplied by for each retry after the first.
  final double multiplier;

  /// The longest delay before a retry. If null, the delay is not capped.
  final Duration? maxDelay;

  /// Creates a new [ExponentialBackoffRetryPolicy].
  const ExponentialBackoffRetryPolicy({
    required this.maxAttempts,
    required this.initialDelay,
    this.multiplier = 2.0,
    this.maxDelay,
  });

  /// Creates an [ExponentialBackoffRetryPolicy] from its serialized form.
  factory ExponentialBackoffRetryPolicy.fromJson(Map<String, dynamic> json) {
    var maxDelay = json['maxDelay'];
    return ExponentialBackoffRetryPolicy(
      maxAttempts: json['maxAttempts'] as int,
      initialDelay: DurationJsonExtension.fromJson(json['initialDelay']),
      multiplier: (json['multiplier'] as num).toDouble(),
      maxDelay: maxDelay == null
          ? null
          : DurationJsonExtension.fromJson(maxDelay),
    );
  }

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    if (_hasReachedMaxAttempts(maxAttempts, context)) return null;

    var microseconds =
        initialDelay.inMicroseconds * pow(multiplier, context.retryAttempt);
    return _capDelay(Duration(microseconds: microseconds.round()), maxDelay);
  }

  @override
  void validate() {
    _validateMaxAttempts(maxAttempts);
    _validateDelay(initialDelay, 'initialDelay');
    _validateDelay(maxDelay, 'maxDelay');
    if (multiplier.isNaN || multiplier < 0) {
      throw ArgumentError.value(
        multiplier,
        'multiplier',
        'Must not be negative.',
      );
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxAttempts': maxAttempts,
    'initialDelay': initialDelay.toJson(),
    'multiplier': multiplier,
    if (maxDelay != null) 'maxDelay': maxDelay!.toJson(),
  };
}

/// A [FutureCallRetryPolicy] that waits a random time between [min] and [max]
/// before every retry.
final class RandomDelayRetryPolicy extends FutureCallRetryPolicy {
  static final _random = Random();

  /// The maximum number of retries. The first run is not counted.
  final int maxAttempts;

  /// The shortest delay before a retry.
  final Duration min;

  /// The longest delay before a retry.
  final Duration max;

  /// Creates a new [RandomDelayRetryPolicy].
  const RandomDelayRetryPolicy({
    required this.maxAttempts,
    required this.min,
    required this.max,
  });

  /// Creates a [RandomDelayRetryPolicy] from its serialized form.
  factory RandomDelayRetryPolicy.fromJson(Map<String, dynamic> json) {
    return RandomDelayRetryPolicy(
      maxAttempts: json['maxAttempts'] as int,
      min: DurationJsonExtension.fromJson(json['min']),
      max: DurationJsonExtension.fromJson(json['max']),
    );
  }

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    if (_hasReachedMaxAttempts(maxAttempts, context)) return null;
    return min + (max - min) * _random.nextDouble();
  }

  @override
  void validate() {
    _validateMaxAttempts(maxAttempts);
    _validateDelay(min, 'min');
    _validateDelay(max, 'max');
    if (min > max) {
      throw ArgumentError.value(min, 'min', 'Must not be greater than max.');
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxAttempts': maxAttempts,
    'min': min.toJson(),
    'max': max.toJson(),
  };
}

/// A [FutureCallRetryPolicy] that uses a list of [delays] in order, one for
/// each retry. After the last one, it stops retrying.
final class CustomDelaysRetryPolicy extends FutureCallRetryPolicy {
  /// The delays before each retry, in order.
  final List<Duration> delays;

  /// Creates a new [CustomDelaysRetryPolicy].
  const CustomDelaysRetryPolicy(this.delays);

  /// Creates a [CustomDelaysRetryPolicy] from its serialized form.
  factory CustomDelaysRetryPolicy.fromJson(Map<String, dynamic> json) {
    return CustomDelaysRetryPolicy([
      for (var delay in json['delays'] as List)
        DurationJsonExtension.fromJson(delay),
    ]);
  }

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    if (context.retryAttempt >= delays.length) return null;
    return delays[context.retryAttempt];
  }

  @override
  void validate() {
    if (delays.isEmpty) {
      throw ArgumentError.value(delays, 'delays', 'Must not be empty.');
    }
    for (var delay in delays) {
      _validateDelay(delay, 'delays');
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    'delays': [for (var delay in delays) delay.toJson()],
  };
}
