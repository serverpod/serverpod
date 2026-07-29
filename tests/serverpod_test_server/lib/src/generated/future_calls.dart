/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:clock/clock.dart' as _i2;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i3;
import 'future_calls_generated_models/test_generated_call_hello_model.dart'
    as _i4;
import 'future_calls_generated_models/test_generated_call_bye_model.dart'
    as _i5;
import 'future_calls_generated_models/test_generated_call_invoke_model.dart'
    as _i6;
import 'package:serverpod_test_server/src/generated/my_trigger_type.dart'
    as _i7;
import 'future_calls_generated_models/test_generated_call_execute_with_trigger_model.dart'
    as _i8;
import 'dart:async' as _i9;
import '../futureCalls/test_call.dart' as _i10;
import '../futureCalls/test_exception_call.dart' as _i11;
import '../futureCalls/test_generated_call.dart' as _i12;

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
    var registeredFutureCalls = <String, _i1.InvokableFutureCall>{
      'TestCallRunFutureCall': TestCallRunFutureCall(),
      'TestExceptionCallRunFutureCall': TestExceptionCallRunFutureCall(),
      'TestGeneratedCallHelloFutureCall': TestGeneratedCallHelloFutureCall(),
      'TestGeneratedCallByeFutureCall': TestGeneratedCallByeFutureCall(),
      'TestGeneratedCallLogDataFutureCall':
          TestGeneratedCallLogDataFutureCall(),
      'TestGeneratedCallDoTaskFutureCall': TestGeneratedCallDoTaskFutureCall(),
      'TestGeneratedCallInvokeFutureCall': TestGeneratedCallInvokeFutureCall(),
      'TestGeneratedCallExecuteWithTriggerFutureCall':
          TestGeneratedCallExecuteWithTriggerFutureCall(),
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
  _i1.RecurringFutureCallDispatch<_FutureCallRef> callRecurring({
    String? identifier,
  }) {
    return _RecurringFutureCallDispatchImpl(
      _effectiveFutureCallManager,
      _effectiveServerId,
      identifier,
    );
  }

  @override
  Future<void> cancel(String identifier) async {
    await _effectiveFutureCallManager.cancelFutureCall(identifier);
  }
}

class _RecurringFutureCallDispatchImpl
    extends _i1.RecurringFutureCallDispatch<_FutureCallRef> {
  _RecurringFutureCallDispatchImpl(
    this._futureCallManager,
    this._serverId,
    this._identifier,
  );

  final _i1.FutureCallManager _futureCallManager;

  final String _serverId;

  final String? _identifier;

  @override
  _FutureCallRef cron(String cronExpression) {
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          _i1.Cron.parse(cronExpression).nextTime(),
          _serverId,
          _identifier,
          scheduling: _i1.CronFutureCallScheduling(cron: cronExpression),
        );
      },
    );
  }

  @override
  _FutureCallRef every(
    Duration interval, {
    DateTime? start,
  }) {
    final now = _i2.clock.now().toUtc();
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          start ?? now.add(interval),
          _serverId,
          _identifier,
          scheduling: _i1.IntervalFutureCallScheduling(
            interval: interval,
            start: start,
          ),
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

  Future<void> run(_i3.SimpleData? data) {
    return _invokeFutureCall(
      'TestCallRunFutureCall',
      data,
    );
  }
}

class _TestExceptionCallFutureCallDispatcher {
  _TestExceptionCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run(_i3.SimpleData? data) {
    return _invokeFutureCall(
      'TestExceptionCallRunFutureCall',
      data,
    );
  }
}

class _TestGeneratedCallFutureCallDispatcher {
  _TestGeneratedCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> hello(String name) {
    var object = _i4.TestGeneratedCallHelloModel(name: name);
    return _invokeFutureCall(
      'TestGeneratedCallHelloFutureCall',
      object,
    );
  }

  Future<void> bye(
    String name, {
    int code = 0,
  }) {
    var object = _i5.TestGeneratedCallByeModel(
      name: name,
      code: code,
    );
    return _invokeFutureCall(
      'TestGeneratedCallByeFutureCall',
      object,
    );
  }

  Future<void> logData(_i3.SimpleData data) {
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

  Future<void> invoke(String name) {
    var object = _i6.TestGeneratedCallInvokeModel(name: name);
    return _invokeFutureCall(
      'TestGeneratedCallInvokeFutureCall',
      object,
    );
  }

  Future<void> executeWithTrigger(
    String entityId, {
    required _i7.MyTriggerType triggerType,
  }) {
    var object = _i8.TestGeneratedCallExecuteWithTriggerModel(
      entityId: entityId,
      triggerType: triggerType,
    );
    return _invokeFutureCall(
      'TestGeneratedCallExecuteWithTriggerFutureCall',
      object,
    );
  }
}

class TestCallRunFutureCall extends _i1.FutureCall<_i3.SimpleData>
    implements _i1.InvokableFutureCall<_i3.SimpleData> {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i3.SimpleData? data,
  ) async {
    await _i10.TestCall().run(
      session,
      data,
    );
  }
}

class TestExceptionCallRunFutureCall extends _i1.FutureCall<_i3.SimpleData>
    implements _i1.InvokableFutureCall<_i3.SimpleData> {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i3.SimpleData? data,
  ) async {
    await _i11.TestExceptionCall().run(
      session,
      data,
    );
  }
}

class TestGeneratedCallHelloFutureCall
    extends _i1.FutureCall<_i4.TestGeneratedCallHelloModel>
    implements _i1.InvokableFutureCall<_i4.TestGeneratedCallHelloModel> {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i4.TestGeneratedCallHelloModel? object,
  ) async {
    if (object != null) {
      await _i12.TestGeneratedCall().hello(
        session,
        object.name,
      );
    }
  }
}

class TestGeneratedCallByeFutureCall
    extends _i1.FutureCall<_i5.TestGeneratedCallByeModel>
    implements _i1.InvokableFutureCall<_i5.TestGeneratedCallByeModel> {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i5.TestGeneratedCallByeModel? object,
  ) async {
    if (object != null) {
      await _i12.TestGeneratedCall().bye(
        session,
        object.name,
        code: object.code,
      );
    }
  }
}

/// A sample future call that logs data.
class TestGeneratedCallLogDataFutureCall extends _i1.FutureCall<_i3.SimpleData>
    implements _i1.InvokableFutureCall<_i3.SimpleData> {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i3.SimpleData? data,
  ) async {
    await _i12.TestGeneratedCall().logData(
      session,
      data!,
    );
  }
}

class TestGeneratedCallDoTaskFutureCall extends _i1.FutureCall
    implements _i1.InvokableFutureCall {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i12.TestGeneratedCall().doTask(session);
  }
}

/// A future call method named `invoke`, which is not reserved and generates
/// a wrapper like any other method.
class TestGeneratedCallInvokeFutureCall
    extends _i1.FutureCall<_i6.TestGeneratedCallInvokeModel>
    implements _i1.InvokableFutureCall<_i6.TestGeneratedCallInvokeModel> {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i6.TestGeneratedCallInvokeModel? object,
  ) async {
    if (object != null) {
      await _i12.TestGeneratedCall().invoke(
        session,
        object.name,
      );
    }
  }
}

/// Future call with enum parameter.
class TestGeneratedCallExecuteWithTriggerFutureCall
    extends _i1.FutureCall<_i8.TestGeneratedCallExecuteWithTriggerModel>
    implements
        _i1.InvokableFutureCall<_i8.TestGeneratedCallExecuteWithTriggerModel> {
  @override
  _i9.Future<void> invoke(
    _i1.Session session,
    _i8.TestGeneratedCallExecuteWithTriggerModel? object,
  ) async {
    if (object != null) {
      await _i12.TestGeneratedCall().executeWithTrigger(
        session,
        object.entityId,
        triggerType: object.triggerType,
      );
    }
  }
}
