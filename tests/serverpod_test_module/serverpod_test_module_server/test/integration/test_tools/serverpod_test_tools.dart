/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_test_module_server/src/generated/module_class.dart'
    as _i4;
import 'package:serverpod_test_module_server/src/generated/protocol.dart';
import 'package:serverpod_test_module_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

@_i1.isTestGroup
withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  String? runMode,
  bool? enableSessionLogging,
  List<String>? testGroupTagsOverride,
  _i1.RollbackDatabase? rollbackDatabase,
  bool? applyMigrations,
}) {
  _i1.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _i1.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      isDatabaseEnabled: true,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
  )(testClosure);
}

class TestEndpoints {
  late final _ModuleEndpoint module;

  late final _StreamingEndpoint streaming;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
  ) {
    module = _ModuleEndpoint(
      endpoints,
      serializationManager,
    );
    streaming = _StreamingEndpoint(
      endpoints,
      serializationManager,
    );
  }
}

class _ModuleEndpoint {
  _ModuleEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> hello(
    _i1.TestSessionBuilder sessionBuilder,
    String name,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'module',
        method: 'hello',
      );
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession,
        endpointPath: 'module',
        methodName: 'hello',
        parameters: _i1.testObjectToJson({'name': name}),
        serializationManager: _serializationManager,
      );
      var _localReturnValue = await (_localCallContext.method.call(
        _localUniqueSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
      await _localUniqueSession.close();
      return _localReturnValue;
    });
  }

  _i3.Future<_i4.ModuleClass> modifyModuleObject(
    _i1.TestSessionBuilder sessionBuilder,
    _i4.ModuleClass object,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'module',
        method: 'modifyModuleObject',
      );
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession,
        endpointPath: 'module',
        methodName: 'modifyModuleObject',
        parameters: _i1.testObjectToJson({'object': object}),
        serializationManager: _serializationManager,
      );
      var _localReturnValue = await (_localCallContext.method.call(
        _localUniqueSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i4.ModuleClass>);
      await _localUniqueSession.close();
      return _localReturnValue;
    });
  }
}

class _StreamingEndpoint {
  _StreamingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> wasStreamOpenCalled(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'streaming',
        method: 'wasStreamOpenCalled',
      );
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession,
        endpointPath: 'streaming',
        methodName: 'wasStreamOpenCalled',
        parameters: _i1.testObjectToJson({}),
        serializationManager: _serializationManager,
      );
      var _localReturnValue = await (_localCallContext.method.call(
        _localUniqueSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
      await _localUniqueSession.close();
      return _localReturnValue;
    });
  }

  _i3.Future<bool> wasStreamClosedCalled(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'streaming',
        method: 'wasStreamClosedCalled',
      );
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession,
        endpointPath: 'streaming',
        methodName: 'wasStreamClosedCalled',
        parameters: _i1.testObjectToJson({}),
        serializationManager: _serializationManager,
      );
      var _localReturnValue = await (_localCallContext.method.call(
        _localUniqueSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
      await _localUniqueSession.close();
      return _localReturnValue;
    });
  }

  _i3.Stream<int> intEchoStream(
    _i1.TestSessionBuilder sessionBuilder,
    _i3.Stream<int> stream,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
          endpoint: 'streaming',
          method: 'intEchoStream',
        );
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'streaming',
          methodName: 'intEchoStream',
          arguments: {},
          requestedInputStreams: ['stream'],
          serializationManager: _serializationManager,
        );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}
