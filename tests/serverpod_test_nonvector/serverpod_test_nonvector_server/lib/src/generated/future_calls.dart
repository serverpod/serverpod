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
import 'package:serverpod_test_nonvector_server/src/generated/greeting.dart'
    as _i2;
import 'dart:async' as _i3;
import '../birthday_reminder.dart' as _i4;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _i1.SerializableModel? object);

/// Global variable for accessing future calls via a typed interface.
final futureCalls = _FutureCalls();

class _FutureCalls extends _i1.FutureCallInitializer {
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
      'BirthdayReminderInvokeFutureCall': BirthdayReminderInvokeFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

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
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  late final birthdayReminder = _BirthdayReminderFutureCallDispatcher(
    _invokeFutureCall,
  );
}

class _BirthdayReminderFutureCallDispatcher {
  _BirthdayReminderFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i2.Greeting? object) {
    return _invokeFutureCall(
      'BirthdayReminderInvokeFutureCall',
      object,
    );
  }
}

@_i1.doNotGenerate
class BirthdayReminderInvokeFutureCall extends _i1.FutureCall<_i2.Greeting> {
  @override
  _i3.Future<void> invoke(
    _i1.Session session,
    _i2.Greeting? object,
  ) async {
    await _i4.BirthdayReminder().invoke(
      session,
      object,
    );
  }
}
