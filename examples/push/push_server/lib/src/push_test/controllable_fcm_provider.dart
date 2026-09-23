import 'dart:async';

import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';

/// One-shot (or N-shot) behaviour the [ControllableFcmProvider] should take
/// instead of calling the real FCM backend.
sealed class FcmTestBehavior {
  const FcmTestBehavior();
}

/// Forward the next [count] sends to the real FCM provider.
class FcmPassthrough extends FcmTestBehavior {
  const FcmPassthrough({this.count = 1});
  final int count;
}

/// Return a fixed [outcome] for the next [count] sends without calling FCM.
class FcmScriptedOutcome extends FcmTestBehavior {
  const FcmScriptedOutcome(
    this.outcome, {
    this.count = 1,
    this.errorCode,
    this.retryAfter,
  });

  final PushDeliveryOutcome outcome;
  final int count;
  final String? errorCode;
  final Duration? retryAfter;
}

/// Hang for [duration] (or forever if null) to exercise send timeouts.
class FcmHang extends FcmTestBehavior {
  const FcmHang({this.duration, this.count = 1});
  final Duration? duration;
  final int count;
}

/// Wraps a real [FcmPushProvider] so device-test scenarios can script
/// provider outcomes without changing device registration (`provider: fcm`).
class ControllableFcmProvider implements PushProvider {
  ControllableFcmProvider(
    this._inner, {
    this.sendTimeout = const Duration(seconds: 2),
  });

  final FcmPushProvider _inner;

  final _queue = <({FcmTestBehavior behavior, int remaining})>[];
  var sendCalls = 0;

  /// Arms [behavior] for the next [behavior]-defined number of sends.
  void arm(final FcmTestBehavior behavior) {
    final count = switch (behavior) {
      FcmPassthrough(:final count) => count,
      FcmScriptedOutcome(:final count) => count,
      FcmHang(:final count) => count,
    };
    _queue.add((behavior: behavior, remaining: count));
  }

  /// Clears any armed behaviours. Subsequent sends go to real FCM.
  void clear() {
    _queue.clear();
  }

  @override
  String get provider => FcmPushProvider.providerId;

  @override
  Set<PushPlatform> get supportedPlatforms => _inner.supportedPlatforms;

  @override
  int get maxTargetsPerRequest => _inner.maxTargetsPerRequest;

  @override
  int get maxConcurrentRequests => _inner.maxConcurrentRequests;

  @override
  final Duration sendTimeout;

  @override
  int get maxPayloadBytes => _inner.maxPayloadBytes;

  @override
  Duration get maxTimeToLive => _inner.maxTimeToLive;

  @override
  String identityKeyFor(final String credential) =>
      _inner.identityKeyFor(credential);

  @override
  int payloadBytesFor(
    final PushMessage message,
    final Map<String, String> additionalData,
  ) => _inner.payloadBytesFor(message, additionalData);

  @override
  Future<List<PushSendResult>> send({
    required final PushMessage message,
    required final List<PushSendRequest> requests,
  }) async {
    sendCalls += 1;
    final armed = _takeNext();
    if (armed == null) {
      return _inner.send(message: message, requests: requests);
    }

    switch (armed) {
      case FcmPassthrough():
        return _inner.send(message: message, requests: requests);
      case FcmScriptedOutcome(
        :final outcome,
        :final errorCode,
        :final retryAfter,
      ):
        return [
          for (final request in requests)
            PushSendResult(
              target: request.target,
              outcome: outcome,
              errorCode: errorCode,
              retryAfter: retryAfter,
            ),
        ];
      case FcmHang(:final duration):
        if (duration != null) {
          await Future<void>.delayed(duration);
        } else {
          await Completer<void>().future;
        }
        return [
          for (final request in requests)
            PushSendResult(
              target: request.target,
              outcome: PushDeliveryOutcome.accepted,
            ),
        ];
    }
  }

  FcmTestBehavior? _takeNext() {
    if (_queue.isEmpty) return null;
    final head = _queue.first;
    final result = head.behavior;
    if (head.remaining <= 1) {
      _queue.removeAt(0);
    } else {
      _queue[0] = (behavior: head.behavior, remaining: head.remaining - 1);
    }
    return result;
  }

  @override
  Future<void> close() => _inner.close();
}
