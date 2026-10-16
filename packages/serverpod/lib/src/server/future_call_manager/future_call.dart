import 'dart:async';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import '../server.dart';
import '../session.dart';
import 'future_call_retry_policy.dart';

/// Superclass for future calls. Extend this class and declare public
/// `Future<void>` methods that take a [Session] as their first parameter to
/// create custom future calls. Type-safe methods for scheduling the calls are
/// generated when running `serverpod generate`.
abstract class FutureCall<T extends SerializableModel> {
  late String _name;

  /// The name of the call.
  String get name => _name;

  /// The type of the data provided when the call is invoked.
  Type get dataType => T;

  late Server _server;

  /// The [Server] where the call is registered.
  Server get server => _server;

  /// Initializes the [FutureCall]. This is typically called from the [Server]
  /// when the call is being registered and should not be called directly.
  void initialize(Server server, String name) {
    _server = server;
    _name = name;
  }

  /// Decides whether a failed run of this future call may be retried.
  ///
  /// Only called for calls scheduled with a [FutureCallRetryPolicy], before
  /// the policy is asked for a delay. Return `false` for errors that will
  /// never go away, so the call is not retried whatever the policy says.
  ///
  /// [session] is the session of the run that failed. [context] describes the
  /// failure. Returns `true` by default.
  FutureOr<bool> shouldRetry(Session session, FutureCallRetryContext context) {
    return true;
  }
}

/// A [FutureCall] that can be invoked by the server when its scheduled time
/// arrives. Implemented by the future call wrappers generated when running
/// `serverpod generate`; not intended to be implemented directly by users.
abstract interface class InvokableFutureCall<T extends SerializableModel>
    implements FutureCall<T> {
  /// Called by the server when the scheduled time of the call arrives.
  Future<void> invoke(Session session, T? object);
}
