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
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i2;
import 'dart:async' as _i3;
import '../futureCalls/test_call.dart' as _i4;
import '../futureCalls/test_exception_call.dart' as _i5;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _i1.SerializableModel? object);

/// Global variable for accessing future calls via a typed interface.
final futureCalls = FutureCalls();

class FutureCalls {
  _i1.FutureCallManager? _futureCallManager;

  String? _serverId;

  void initialize(
    _i1.FutureCallManager? futureCallManager,
    String serverId,
  ) {
    var futureCalls = <String, _i1.FutureCall>{
      'TestCallInvokeFutureCall': TestCallInvokeFutureCall(),
      'TestExceptionCallInvokeFutureCall': TestExceptionCallInvokeFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    if (_futureCallManager == null) return;
    for (final entry in futureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  FutureCallRef callAtTime(
    DateTime time, {
    String? identifier,
  }) {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    if (_futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    return FutureCallRef(
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

  FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    if (_futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    return FutureCallRef(
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

class FutureCallRef {
  FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  TestCallFutureCallCaller get testCall {
    return TestCallFutureCallCaller(_invokeFutureCall);
  }

  TestExceptionCallFutureCallCaller get testExceptionCall {
    return TestExceptionCallFutureCallCaller(_invokeFutureCall);
  }
}

class TestCallFutureCallCaller {
  TestCallFutureCallCaller(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i2.SimpleData? object) {
    return _invokeFutureCall(
      'TestCallInvokeFutureCall',
      object,
    );
  }
}

class TestExceptionCallFutureCallCaller {
  TestExceptionCallFutureCallCaller(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i2.SimpleData? object) {
    return _invokeFutureCall(
      'TestExceptionCallInvokeFutureCall',
      object,
    );
  }
}

class TestCallInvokeFutureCall extends _i1.FutureCall<_i2.SimpleData> {
  @_i1.doNotGenerate
  @override
  _i3.Future<void> invoke(
    _i1.Session session,
    _i2.SimpleData? object,
  ) {
    return _i4.TestCall().invoke(
      session,
      object!,
    );
  }
}

class TestExceptionCallInvokeFutureCall extends _i1.FutureCall<_i2.SimpleData> {
  @_i1.doNotGenerate
  @override
  _i3.Future<void> invoke(
    _i1.Session session,
    _i2.SimpleData? object,
  ) {
    return _i5.TestExceptionCall().invoke(
      session,
      object!,
    );
  }
}
