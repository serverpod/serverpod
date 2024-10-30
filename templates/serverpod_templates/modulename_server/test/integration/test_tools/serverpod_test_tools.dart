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
import 'package:modulename_server/src/generated/protocol.dart';
import 'package:modulename_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

@_i1.isTestGroup
void withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  String? runMode,
  bool? enableSessionLogging,
  _i2.ServerpodLoggingMode? serverpodLoggingMode,
  List<String>? testGroupTagsOverride,
  Duration? serverpodStartTimeout,
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
      serverpodLoggingMode: serverpodLoggingMode,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
  )(testClosure);
}

class TestEndpoints {
  late final _ModuleEndpoint module;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  void initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
  ) {
    module = _ModuleEndpoint(
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
}
