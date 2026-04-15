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

  /// Calls a [FutureCall] at a recurring interval, optionally passing a [String] identifier.
  RecurringFutureCallDispatch<T> callRecurring({String? identifier});

  /// Cancels a [FutureCall] with the specified identifier. If no future call
  /// with the specified identifier is found, this call will have no effect.
  Future<void> cancel(String identifier);
}

/// Provides type-safe access to recurring future calls on the server.
/// Typically, this class is overriden by a generated class.
abstract class RecurringFutureCallDispatch<T> {
  /// Calls a [FutureCall] at a recurring interval defined by [cronExpression].
  T cron(String cronExpression);

  /// Calls a [FutureCall] at a recurring interval defined by [interval],
  /// optionally passing a [start] time.
  ///
  /// [start] defines the exact moment in which the [FutureCall] will run
  /// on every interval. For example, if [interval] is 1 hour and [start] is
  /// 15 minutes past the hour, the [FutureCall] will run at 00:15, 01:15, 02:15, etc.
  ///
  /// If [start] is not provided, the first run occurs after one [interval].
  /// If [start] is in the past, the [FutureCall] will run immediately
  /// and then will subsequently run at the next [interval] in the future.
  T every(Duration interval, {DateTime? start});
}
