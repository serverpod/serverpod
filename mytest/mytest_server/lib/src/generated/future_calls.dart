/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:async' as _i2;
import '../reminder.dart' as _i3;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _i1.SerializableModel? object);

extension ServerpodFutureCallsGetter on _i1.Serverpod {
  /// Generated future calls.
  FutureCalls get futureCalls => FutureCalls();
}

class FutureCalls extends _i1.FutureCallDispatch<_FutureCallRef> {
  FutureCalls._();

  factory FutureCalls() {
    return _instance;
  }

  static final FutureCalls _instance = FutureCalls._();

  _i1.FutureCallManager? _futureCallManager;

  String? _serverId;

  String get _effectiveServerId {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _serverId!;
  }

  _i1.FutureCallManager get _effectiveFutureCallManager {
    if (_futureCallManager == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _futureCallManager!;
  }

  @override
  void initialize(
    _i1.FutureCallManager futureCallManager,
    String serverId,
  ) {
    var registeredFutureCalls = <String, _i1.FutureCall>{
      'ReminderHelloFutureCall': ReminderHelloFutureCall(),
      'ReminderDelayedHelloFutureCall': ReminderDelayedHelloFutureCall(),
      'ReminderByeFutureCall': ReminderByeFutureCall(),
      'ReminderDelayedByeFutureCall': ReminderDelayedByeFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  @override
  _FutureCallRef callAtTime(
    DateTime time, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          time,
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          DateTime.now().toUtc().add(delay),
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  Future<void> cancel(String identifier) async {
    await _effectiveFutureCallManager.cancelFutureCall(identifier);
  }
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  late final reminder = _ReminderFutureCallDispatcher(_invokeFutureCall);
}

class _ReminderFutureCallDispatcher {
  _ReminderFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> hello() {
    return _invokeFutureCall(
      'ReminderHelloFutureCall',
      null,
    );
  }

  Future<void> delayedHello() {
    return _invokeFutureCall(
      'ReminderDelayedHelloFutureCall',
      null,
    );
  }

  Future<void> bye() {
    return _invokeFutureCall(
      'ReminderByeFutureCall',
      null,
    );
  }

  Future<void> delayedBye() {
    return _invokeFutureCall(
      'ReminderDelayedByeFutureCall',
      null,
    );
  }
}

class ReminderHelloFutureCall extends _i1.FutureCall {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i3.Reminder().hello(session);
  }
}

class ReminderDelayedHelloFutureCall extends _i1.FutureCall {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i3.Reminder().delayedHello(session);
  }
}

class ReminderByeFutureCall extends _i1.FutureCall {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i3.Reminder().bye(session);
  }
}

class ReminderDelayedByeFutureCall extends _i1.FutureCall {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i3.Reminder().delayedBye(session);
  }
}
