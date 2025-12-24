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
import 'test_generated_call_hello_model.dart' as _i3;
import 'test_generated_call_bye_model.dart' as _i4;
import 'dart:async' as _i5;
import '../futureCalls/test_call.dart' as _i6;
import '../futureCalls/test_exception_call.dart' as _i7;
import '../futureCalls/test_generated_call.dart' as _i8;

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
      'TestCallInvokeFutureCall': TestCallInvokeFutureCall(),
      'TestExceptionCallInvokeFutureCall': TestExceptionCallInvokeFutureCall(),
      'TestGeneratedCallHelloFutureCall': TestGeneratedCallHelloFutureCall(),
      'TestGeneratedCallByeFutureCall': TestGeneratedCallByeFutureCall(),
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

  late final testCall = _TestCallFutureCallDispatcher(_invokeFutureCall);

  late final testExceptionCall = _TestExceptionCallFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final testGeneratedCall = _TestGeneratedCallFutureCallDispatcher(
    _invokeFutureCall,
  );
}

class _TestCallFutureCallDispatcher {
  _TestCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i2.SimpleData? object) {
    return _invokeFutureCall(
      'TestCallInvokeFutureCall',
      object,
    );
  }
}

class _TestExceptionCallFutureCallDispatcher {
  _TestExceptionCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i2.SimpleData? object) {
    return _invokeFutureCall(
      'TestExceptionCallInvokeFutureCall',
      object,
    );
  }
}

class _TestGeneratedCallFutureCallDispatcher {
  _TestGeneratedCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> hello(String name) {
    var object = _i3.TestGeneratedCallHelloModel(name: name);
    return _invokeFutureCall(
      'TestGeneratedCallHelloFutureCall',
      object,
    );
  }

  Future<void> bye(
    String name, {
    int code = 0,
  }) {
    var object = _i4.TestGeneratedCallByeModel(
      name: name,
      code: code,
    );
    return _invokeFutureCall(
      'TestGeneratedCallByeFutureCall',
      object,
    );
  }
}

@_i1.doNotGenerate
class TestCallInvokeFutureCall extends _i1.FutureCall<_i2.SimpleData> {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i2.SimpleData? object,
  ) async {
    await _i6.TestCall().invoke(
      session,
      object,
    );
  }
}

@_i1.doNotGenerate
class TestExceptionCallInvokeFutureCall extends _i1.FutureCall<_i2.SimpleData> {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i2.SimpleData? object,
  ) async {
    await _i7.TestExceptionCall().invoke(
      session,
      object,
    );
  }
}

@_i1.doNotGenerate
class TestGeneratedCallHelloFutureCall
    extends _i1.FutureCall<_i3.TestGeneratedCallHelloModel> {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i3.TestGeneratedCallHelloModel? object,
  ) async {
    if (object != null) {
      await _i8.TestGeneratedCall().hello(
        session,
        object.name,
      );
    }
  }
}

@_i1.doNotGenerate
class TestGeneratedCallByeFutureCall
    extends _i1.FutureCall<_i4.TestGeneratedCallByeModel> {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i4.TestGeneratedCallByeModel? object,
  ) async {
    if (object != null) {
      await _i8.TestGeneratedCall().bye(
        session,
        object.name,
        code: object.code,
      );
    }
  }
}
