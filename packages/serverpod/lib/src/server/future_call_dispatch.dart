import 'package:serverpod/serverpod.dart';

/// Provides type-safe access to future calls on the server.
/// Typically, this class is overriden by a FutureCalls class that is generated.
abstract class FutureCallDispatch<T> {
  /// Initializes the future calls.
  void initialize(FutureCallManager futureCallManager, String serverId);

  /// Calls a [FutureCall] at the specified time, optionally passing a [String] identifier.
  T callAtTime(DateTime time, {String? identifier});

  /// Calls a [FutureCall] after the specified [delay], optionally passing a [String] identifier.
  T callWithDelay(Duration delay, {String? identifier});

  /// Cancels a [FutureCall] with the specified identifier. If no future call
  /// with the specified identifier is found, this call will have no effect.
  Future<void> cancel(String identifier);
}
