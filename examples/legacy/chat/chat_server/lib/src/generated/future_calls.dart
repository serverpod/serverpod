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
import '../future_calls/example_future_call.dart' as _i3;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _i1.SerializableModel? object);

/// Global variable for accessing future calls via a typed interface.
final futureCalls = _FutureCalls();

class _FutureCalls extends _i1.FutureCallInitializer {
  _i1.FutureCallManager? _futureCallManager;

  String? _serverId;

  @override
  void initialize(
    _i1.FutureCallManager futureCallManager,
    String serverId,
  ) {
    registeredFutureCalls['ExampleInvokeFutureCall'] =
        ExampleInvokeFutureCall();
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
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    if (_futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager!.scheduleFutureCall(
          name,
          object,
          time,
          _serverId!,
          identifier,
        );
      },
    );
  }

  _FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    if (_futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager!.scheduleFutureCall(
          name,
          object,
          DateTime.now().toUtc().add(delay),
          _serverId!,
          identifier,
        );
      },
    );
  }
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  _ExampleFutureCallDispatcher get example {
    return _ExampleFutureCallDispatcher(_invokeFutureCall);
  }
}

class _ExampleFutureCallDispatcher {
  _ExampleFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? object) {
    return _invokeFutureCall(
      'ExampleInvokeFutureCall',
      object,
    );
  }
}

@_i1.doNotGenerate
class ExampleInvokeFutureCall extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i3.ExampleFutureCall().invoke(
      session,
      object,
    );
  }
}
