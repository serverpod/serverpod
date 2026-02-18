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
import 'future_calls_generated_models/test_generated_call_hello_model.dart'
    as _i2;
import 'future_calls_generated_models/test_generated_call_bye_model.dart'
    as _i3;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i4;
import 'dart:async' as _i5;
import '../futureCalls/test_generated_call.dart' as _i6;

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
      'TestGeneratedCallHelloFutureCall': TestGeneratedCallHelloFutureCall(),
      'TestGeneratedCallByeFutureCall': TestGeneratedCallByeFutureCall(),
      'TestGeneratedCallLogDataFutureCall':
          TestGeneratedCallLogDataFutureCall(),
      'TestGeneratedCallDoTaskFutureCall': TestGeneratedCallDoTaskFutureCall(),
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

  late final testGeneratedCall = _TestGeneratedCallFutureCallDispatcher(
    _invokeFutureCall,
  );
}

class _TestGeneratedCallFutureCallDispatcher {
  _TestGeneratedCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> hello(String name) {
    var object = _i2.TestGeneratedCallHelloModel(name: name);
    return _invokeFutureCall(
      'TestGeneratedCallHelloFutureCall',
      object,
    );
  }

  Future<void> bye(
    String name, {
    int code = 0,
  }) {
    var object = _i3.TestGeneratedCallByeModel(
      name: name,
      code: code,
    );
    return _invokeFutureCall(
      'TestGeneratedCallByeFutureCall',
      object,
    );
  }

  Future<void> logData(_i4.SimpleData data) {
    return _invokeFutureCall(
      'TestGeneratedCallLogDataFutureCall',
      data,
    );
  }

  Future<void> doTask() {
    return _invokeFutureCall(
      'TestGeneratedCallDoTaskFutureCall',
      null,
    );
  }
}

class TestGeneratedCallHelloFutureCall
    extends _i1.FutureCall<_i2.TestGeneratedCallHelloModel> {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i2.TestGeneratedCallHelloModel? object,
  ) async {
    if (object != null) {
      await _i6.TestGeneratedCall().hello(
        session,
        object.name,
      );
    }
  }
}

class TestGeneratedCallByeFutureCall
    extends _i1.FutureCall<_i3.TestGeneratedCallByeModel> {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i3.TestGeneratedCallByeModel? object,
  ) async {
    if (object != null) {
      await _i6.TestGeneratedCall().bye(
        session,
        object.name,
        code: object.code,
      );
    }
  }
}

/// A sample future call that logs data.
class TestGeneratedCallLogDataFutureCall
    extends _i1.FutureCall<_i4.SimpleData> {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i4.SimpleData? data,
  ) async {
    await _i6.TestGeneratedCall().logData(
      session,
      data!,
    );
  }
}

class TestGeneratedCallDoTaskFutureCall extends _i1.FutureCall {
  @override
  _i5.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i6.TestGeneratedCall().doTask(session);
  }
}
