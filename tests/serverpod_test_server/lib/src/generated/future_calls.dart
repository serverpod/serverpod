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
import 'dart:async' as _ida;
import 'package:clock/clock.dart' as _io0w16m8;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/my_trigger_type.dart'
    as _icum80ls;
import 'package:serverpod_test_server/src/generated/simple_data.dart'
    as _i685tvwm;
import '../futureCalls/test_call.dart' as _i3varv2q;
import '../futureCalls/test_exception_call.dart' as _i6a94ofc;
import '../futureCalls/test_generated_call.dart' as _iwn8y0ww;
import 'future_calls_generated_models/test_generated_call_bye_model.dart'
    as _ip57k4t4;
import 'future_calls_generated_models/test_generated_call_execute_with_trigger_model.dart'
    as _ilmnz413;
import 'future_calls_generated_models/test_generated_call_hello_model.dart'
    as _ifspsmem;
import 'future_calls_generated_models/test_generated_call_invoke_model.dart'
    as _i3yv7lzj;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _is.SerializableModel? object);

extension ServerpodFutureCallsGetter on _is.Serverpod {
  /// Generated future calls.
  FutureCalls get futureCalls => FutureCalls();
}

class FutureCalls extends _is.FutureCallDispatch<_FutureCallRef> {
  FutureCalls._();

  factory FutureCalls() {
    return _instance;
  }

  static final FutureCalls _instance = FutureCalls._();

  _is.FutureCallManager? _futureCallManager;

  String? _serverId;

  String get _effectiveServerId {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _serverId!;
  }

  _is.FutureCallManager get _effectiveFutureCallManager {
    if (_futureCallManager == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _futureCallManager!;
  }

  @override
  void initialize(
    _is.FutureCallManager futureCallManager,
    String serverId,
  ) {
    var registeredFutureCalls = <String, _is.InvokableFutureCall>{
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
  _is.RecurringFutureCallDispatch<_FutureCallRef> callRecurring({
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
    extends _is.RecurringFutureCallDispatch<_FutureCallRef> {
  _RecurringFutureCallDispatchImpl(
    this._futureCallManager,
    this._serverId,
    this._identifier,
  );

  final _is.FutureCallManager _futureCallManager;

  final String _serverId;

  final String? _identifier;

  @override
  _FutureCallRef cron(String cronExpression) {
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          _is.Cron.parse(cronExpression).nextTime(),
          _serverId,
          _identifier,
          scheduling: _is.CronFutureCallScheduling(cron: cronExpression),
        );
      },
    );
  }

  @override
  _FutureCallRef every(
    Duration interval, {
    DateTime? start,
  }) {
    final now = _io0w16m8.clock.now().toUtc();
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          start ?? now.add(interval),
          _serverId,
          _identifier,
          scheduling: _is.IntervalFutureCallScheduling(
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

  Future<void> run(_i685tvwm.SimpleData? data) {
    return _invokeFutureCall(
      'TestCallRunFutureCall',
      data,
    );
  }
}

class _TestExceptionCallFutureCallDispatcher {
  _TestExceptionCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run(_i685tvwm.SimpleData? data) {
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
    var object = _ifspsmem.TestGeneratedCallHelloModel(name: name);
    return _invokeFutureCall(
      'TestGeneratedCallHelloFutureCall',
      object,
    );
  }

  Future<void> bye(
    String name, {
    int code = 0,
  }) {
    var object = _ip57k4t4.TestGeneratedCallByeModel(
      name: name,
      code: code,
    );
    return _invokeFutureCall(
      'TestGeneratedCallByeFutureCall',
      object,
    );
  }

  Future<void> logData(_i685tvwm.SimpleData data) {
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
    var object = _i3yv7lzj.TestGeneratedCallInvokeModel(name: name);
    return _invokeFutureCall(
      'TestGeneratedCallInvokeFutureCall',
      object,
    );
  }

  Future<void> executeWithTrigger(
    String entityId, {
    required _icum80ls.MyTriggerType triggerType,
  }) {
    var object = _ilmnz413.TestGeneratedCallExecuteWithTriggerModel(
      entityId: entityId,
      triggerType: triggerType,
    );
    return _invokeFutureCall(
      'TestGeneratedCallExecuteWithTriggerFutureCall',
      object,
    );
  }
}

class TestCallRunFutureCall extends _is.FutureCall<_i685tvwm.SimpleData>
    implements _is.InvokableFutureCall<_i685tvwm.SimpleData> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _i685tvwm.SimpleData? data,
  ) async {
    await _i3varv2q.TestCall().run(
      session,
      data,
    );
  }
}

class TestExceptionCallRunFutureCall
    extends _is.FutureCall<_i685tvwm.SimpleData>
    implements _is.InvokableFutureCall<_i685tvwm.SimpleData> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _i685tvwm.SimpleData? data,
  ) async {
    await _i6a94ofc.TestExceptionCall().run(
      session,
      data,
    );
  }
}

class TestGeneratedCallHelloFutureCall
    extends _is.FutureCall<_ifspsmem.TestGeneratedCallHelloModel>
    implements _is.InvokableFutureCall<_ifspsmem.TestGeneratedCallHelloModel> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _ifspsmem.TestGeneratedCallHelloModel? object,
  ) async {
    if (object != null) {
      await _iwn8y0ww.TestGeneratedCall().hello(
        session,
        object.name,
      );
    }
  }
}

class TestGeneratedCallByeFutureCall
    extends _is.FutureCall<_ip57k4t4.TestGeneratedCallByeModel>
    implements _is.InvokableFutureCall<_ip57k4t4.TestGeneratedCallByeModel> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _ip57k4t4.TestGeneratedCallByeModel? object,
  ) async {
    if (object != null) {
      await _iwn8y0ww.TestGeneratedCall().bye(
        session,
        object.name,
        code: object.code,
      );
    }
  }
}

/// A sample future call that logs data.
class TestGeneratedCallLogDataFutureCall
    extends _is.FutureCall<_i685tvwm.SimpleData>
    implements _is.InvokableFutureCall<_i685tvwm.SimpleData> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _i685tvwm.SimpleData? data,
  ) async {
    await _iwn8y0ww.TestGeneratedCall().logData(
      session,
      data!,
    );
  }
}

class TestGeneratedCallDoTaskFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _iwn8y0ww.TestGeneratedCall().doTask(session);
  }
}

/// A future call method named `invoke`, which is not reserved and generates
/// a wrapper like any other method.
class TestGeneratedCallInvokeFutureCall
    extends _is.FutureCall<_i3yv7lzj.TestGeneratedCallInvokeModel>
    implements _is.InvokableFutureCall<_i3yv7lzj.TestGeneratedCallInvokeModel> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _i3yv7lzj.TestGeneratedCallInvokeModel? object,
  ) async {
    if (object != null) {
      await _iwn8y0ww.TestGeneratedCall().invoke(
        session,
        object.name,
      );
    }
  }
}

/// Future call with enum parameter.
class TestGeneratedCallExecuteWithTriggerFutureCall
    extends _is.FutureCall<_ilmnz413.TestGeneratedCallExecuteWithTriggerModel>
    implements
        _is.InvokableFutureCall<
          _ilmnz413.TestGeneratedCallExecuteWithTriggerModel
        > {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _ilmnz413.TestGeneratedCallExecuteWithTriggerModel? object,
  ) async {
    if (object != null) {
      await _iwn8y0ww.TestGeneratedCall().executeWithTrigger(
        session,
        object.entityId,
        triggerType: object.triggerType,
      );
    }
  }
}
