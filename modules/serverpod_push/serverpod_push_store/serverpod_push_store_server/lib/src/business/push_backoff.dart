import 'dart:math';

import 'push_store_config.dart';

/// Exponential backoff driven by [exponent], jittered by [config.backoffJitter].
Duration pushBackoff(
  final int exponent,
  final PushStoreConfig config, {
  final Random? random,
}) {
  final rng = random ?? Random();
  final shift = exponent.clamp(0, 30);
  var milliseconds = config.baseBackoff.inMilliseconds * (1 << shift);
  final maxMs = config.maxBackoff.inMilliseconds;
  if (milliseconds > maxMs) milliseconds = maxMs;
  final factor = 1 + ((rng.nextDouble() * 2) - 1) * config.backoffJitter;
  return Duration(
    milliseconds: (milliseconds * factor).round().clamp(0, maxMs),
  );
}
