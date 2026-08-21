/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:convert' as _idc;
import 'dart:io' as _idi;
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import 'package:serverpod_test/serverpod_test.dart' as _ist;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _iom2gwyu;
import 'package:serverpod_test_server/src/generated/future_calls.dart'
    as _i3an2vcw;
import 'package:serverpod_test_server/src/generated/future_calls_generated_models/test_generated_call_bye_model.dart'
    as _i4lt3urh;
import 'package:serverpod_test_server/src/generated/future_calls_generated_models/test_generated_call_execute_with_trigger_model.dart'
    as _i1l5bdpk;
import 'package:serverpod_test_server/src/generated/future_calls_generated_models/test_generated_call_hello_model.dart'
    as _irznr7ew;
import 'package:serverpod_test_server/src/generated/future_calls_generated_models/test_generated_call_invoke_model.dart'
    as _i8808sn4;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/container.dart'
    as _ioyh3y7j;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/container_module.dart'
    as _ij2aep0j;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/parent.dart'
    as _ieub4zqi;
import 'package:serverpod_test_server/src/generated/module_datatype.dart'
    as _idarivwd;
import 'package:serverpod_test_server/src/generated/my_feature/models/my_feature_model.dart'
    as _iivg8skz;
import 'package:serverpod_test_server/src/generated/my_trigger_type.dart'
    as _icum80ls;
import 'package:serverpod_test_server/src/generated/object_field_scopes.dart'
    as _io906m8r;
import 'package:serverpod_test_server/src/generated/object_with_dynamic.dart'
    as _i9ckso16;
import 'package:serverpod_test_server/src/generated/object_with_enum.dart'
    as _in2ouh3f;
import 'package:serverpod_test_server/src/generated/object_with_enum_enhanced.dart'
    as _itaf3m7v;
import 'package:serverpod_test_server/src/generated/object_with_object.dart'
    as _i120a7u7;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'package:serverpod_test_server/src/generated/required/model_with_required_field.dart'
    as _iyoxtomg;
import 'package:serverpod_test_server/src/generated/scopes/scope_server_only_field.dart'
    as _iyi8ilhb;
import 'package:serverpod_test_server/src/generated/scopes/scope_server_only_field_child.dart'
    as _i02xdnoq;
import 'package:serverpod_test_server/src/generated/session_auth_info.dart'
    as _i5vgvlyt;
import 'package:serverpod_test_server/src/generated/simple_data.dart'
    as _i685tvwm;
import 'package:serverpod_test_server/src/generated/simple_data_list.dart'
    as _ihs20x3n;
import 'package:serverpod_test_server/src/generated/test_enum.dart'
    as _izdri23a;
import 'package:serverpod_test_server/src/generated/types.dart' as _iuch3ck4;
import 'package:serverpod_test_server/src/generated/types_record.dart'
    as _ix95ig49;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    as _iyx9etqn;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [applyMigrations] Whether pending migrations should be applied when starting Serverpod. Defaults to `true`
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [rollbackDatabase] Options for when to rollback the database during the test lifecycle.
/// By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
/// Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
/// ```dart
/// /// Options for when to rollback the database during the test lifecycle.
/// enum RollbackDatabase {
///   /// After each test. This is the default.
///   afterEach,
///
///   /// After all tests.
///   afterAll,
///
///   /// Disable rolling back the database.
///   disabled,
/// }
/// ```
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 120)`.
///
/// [testServerOutputMode] Options for controlling test server output during test execution. Defaults to `TestServerOutputMode.normal`.
/// ```dart
/// /// Options for controlling test server output during test execution.
/// enum TestServerOutputMode {
///   /// Default mode - only stderr is printed (stdout suppressed).
///   /// This hides normal startup/shutdown logs while preserving error messages.
///   normal,
///
///   /// All logging - both stdout and stderr are printed.
///   /// Useful for debugging when you need to see all server output.
///   verbose,
///
///   /// No logging - both stdout and stderr are suppressed.
///   /// Completely silent mode, useful when you don't want any server output.
///   silent,
/// }
/// ```
///
/// [configOverride] A function to override the server configuration. This function is called with
/// the default server configuration after it is loaded from the config/ directory
/// and before it is used to start the server. Use this to override particular
/// settings in the server configuration.
///
/// [databaseInterceptor] Optional interceptor that replaces the default database for each session.
/// See [Serverpod.databaseInterceptor] for more information.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
///
/// [serverDirectory] The server package directory `config/<runMode>.yaml`, `config/passwords.yaml`,
/// and `migrations/<module>/...` are resolved against. Defaults to
/// [Directory.current] at the time the test boots. Pass this when the test
/// isolate's cwd is not the server package root (e.g. running tests from a
/// workspace parent directory) so config and migrations are still loaded
/// from the right place.
@_ist.isTestGroup
void withServerpod(
  String testGroupName,
  _ist.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  _is.ServerpodConfig Function(_is.ServerpodConfig)? configOverride,
  _is.DatabaseInterceptor? databaseInterceptor,
  bool? enableSessionLogging,
  _is.ExperimentalFeatures? experimentalFeatures,
  _ist.RollbackDatabase? rollbackDatabase,
  String? runMode,
  _is.RuntimeParametersListBuilder? runtimeParametersBuilder,
  _idi.Directory? serverDirectory,
  _is.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
  _ist.TestServerOutputMode? testServerOutputMode,
}) {
  _ist.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _ist.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      testServerOutputMode: testServerOutputMode,
      serverDirectory: serverDirectory,
      experimentalFeatures: experimentalFeatures,
      configOverride: configOverride,
      runtimeParametersBuilder: runtimeParametersBuilder,
      databaseInterceptor: databaseInterceptor,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
    maybeTestServerOutputMode: testServerOutputMode,
  )(testClosure);
}

class TestEndpoints {
  late final futureCalls = _FutureCalls();

  late final _AsyncTasksEndpoint asyncTasks;

  late final _AuthenticationEndpoint authentication;

  late final _BasicTypesEndpoint basicTypes;

  late final _BasicTypesStreamingEndpoint basicTypesStreaming;

  late final _CloudStorageEndpoint cloudStorage;

  late final _S3CloudStorageEndpoint s3CloudStorage;

  late final _CustomClassProtocolEndpoint customClassProtocol;

  late final _CustomTypesEndpoint customTypes;

  late final _BasicDatabase basicDatabase;

  late final _TransactionsDatabaseEndpoint transactionsDatabase;

  late final _DeprecationEndpoint deprecation;

  late final _DiagnosticEventTestEndpoint diagnosticEventTest;

  late final _EchoRequestEndpoint echoRequest;

  late final _EchoRequiredFieldEndpoint echoRequiredField;

  late final _EmailAuthTestMethods emailAuthTestMethods;

  late final _ConcreteBaseEndpoint concreteBase;

  late final _ConcreteSubClassEndpoint concreteSubClass;

  late final _IndependentEndpoint independent;

  late final _ConcreteFromModuleAbstractBaseEndpoint
  concreteFromModuleAbstractBase;

  late final _ConcreteModuleBaseEndpoint concreteModuleBase;

  late final _LoggedInEndpoint loggedIn;

  late final _MyLoggedInEndpoint myLoggedIn;

  late final _AdminEndpoint admin;

  late final _MyAdminEndpoint myAdmin;

  late final _MyConcreteAdminEndpoint myConcreteAdmin;

  late final _ExceptionTestEndpoint exceptionTest;

  late final _FailedCallsEndpoint failedCalls;

  late final _FieldScopesEndpoint fieldScopes;

  late final _TestFutureCallsEndpoint testFutureCalls;

  late final _ListParametersEndpoint listParameters;

  late final _LoggingEndpoint logging;

  late final _LoggingDisabledEndpoint loggingDisabled;

  late final _MapParametersEndpoint mapParameters;

  late final _MethodSignaturePermutationsEndpoint methodSignaturePermutations;

  late final _MethodStreaming methodStreaming;

  late final _AuthenticatedMethodStreaming authenticatedMethodStreaming;

  late final _ModuleEndpointSubclass moduleEndpointSubclass;

  late final _ModuleEndpointAdaptation moduleEndpointAdaptation;

  late final _ModuleEndpointReduction moduleEndpointReduction;

  late final _ModuleEndpointExtension moduleEndpointExtension;

  late final _ModuleSerializationEndpoint moduleSerialization;

  late final _NamedParametersEndpoint namedParameters;

  late final _OptionalParametersEndpoint optionalParameters;

  late final _InheritancePolymorphismTestEndpoint inheritancePolymorphismTest;

  late final _RecordParametersEndpoint recordParameters;

  late final _RedisEndpoint redis;

  late final _ServerOnlyScopedFieldModelEndpoint serverOnlyScopedFieldModel;

  late final _ServerOnlyScopedFieldChildModelEndpoint
  serverOnlyScopedFieldChildModel;

  late final _SessionAuthenticationEndpoint sessionAuthentication;

  late final _SetParametersEndpoint setParameters;

  late final _SignInRequiredEndpoint signInRequired;

  late final _AdminScopeRequiredEndpoint adminScopeRequired;

  late final _SimpleEndpoint simple;

  late final _SubSubDirTestEndpoint subSubDirTest;

  late final _SubDirTestEndpoint subDirTest;

  late final _TestToolsEndpoint testTools;

  late final _AuthenticatedTestToolsEndpoint authenticatedTestTools;

  late final _UnauthenticatedEndpoint unauthenticated;

  late final _PartiallyUnauthenticatedEndpoint partiallyUnauthenticated;

  late final _UnauthenticatedRequireLoginEndpoint unauthenticatedRequireLogin;

  late final _RequireLoginEndpoint requireLogin;

  late final _UploadEndpoint upload;

  late final _MyFeatureEndpoint myFeature;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _ist.InternalTestEndpoints {
  @override
  void initialize(
    _is.SerializationManager serializationManager,
    _is.EndpointDispatch endpoints,
  ) {
    asyncTasks = _AsyncTasksEndpoint(
      endpoints,
      serializationManager,
    );
    authentication = _AuthenticationEndpoint(
      endpoints,
      serializationManager,
    );
    basicTypes = _BasicTypesEndpoint(
      endpoints,
      serializationManager,
    );
    basicTypesStreaming = _BasicTypesStreamingEndpoint(
      endpoints,
      serializationManager,
    );
    cloudStorage = _CloudStorageEndpoint(
      endpoints,
      serializationManager,
    );
    s3CloudStorage = _S3CloudStorageEndpoint(
      endpoints,
      serializationManager,
    );
    customClassProtocol = _CustomClassProtocolEndpoint(
      endpoints,
      serializationManager,
    );
    customTypes = _CustomTypesEndpoint(
      endpoints,
      serializationManager,
    );
    basicDatabase = _BasicDatabase(
      endpoints,
      serializationManager,
    );
    transactionsDatabase = _TransactionsDatabaseEndpoint(
      endpoints,
      serializationManager,
    );
    deprecation = _DeprecationEndpoint(
      endpoints,
      serializationManager,
    );
    diagnosticEventTest = _DiagnosticEventTestEndpoint(
      endpoints,
      serializationManager,
    );
    echoRequest = _EchoRequestEndpoint(
      endpoints,
      serializationManager,
    );
    echoRequiredField = _EchoRequiredFieldEndpoint(
      endpoints,
      serializationManager,
    );
    emailAuthTestMethods = _EmailAuthTestMethods(
      endpoints,
      serializationManager,
    );
    concreteBase = _ConcreteBaseEndpoint(
      endpoints,
      serializationManager,
    );
    concreteSubClass = _ConcreteSubClassEndpoint(
      endpoints,
      serializationManager,
    );
    independent = _IndependentEndpoint(
      endpoints,
      serializationManager,
    );
    concreteFromModuleAbstractBase = _ConcreteFromModuleAbstractBaseEndpoint(
      endpoints,
      serializationManager,
    );
    concreteModuleBase = _ConcreteModuleBaseEndpoint(
      endpoints,
      serializationManager,
    );
    loggedIn = _LoggedInEndpoint(
      endpoints,
      serializationManager,
    );
    myLoggedIn = _MyLoggedInEndpoint(
      endpoints,
      serializationManager,
    );
    admin = _AdminEndpoint(
      endpoints,
      serializationManager,
    );
    myAdmin = _MyAdminEndpoint(
      endpoints,
      serializationManager,
    );
    myConcreteAdmin = _MyConcreteAdminEndpoint(
      endpoints,
      serializationManager,
    );
    exceptionTest = _ExceptionTestEndpoint(
      endpoints,
      serializationManager,
    );
    failedCalls = _FailedCallsEndpoint(
      endpoints,
      serializationManager,
    );
    fieldScopes = _FieldScopesEndpoint(
      endpoints,
      serializationManager,
    );
    testFutureCalls = _TestFutureCallsEndpoint(
      endpoints,
      serializationManager,
    );
    listParameters = _ListParametersEndpoint(
      endpoints,
      serializationManager,
    );
    logging = _LoggingEndpoint(
      endpoints,
      serializationManager,
    );
    loggingDisabled = _LoggingDisabledEndpoint(
      endpoints,
      serializationManager,
    );
    mapParameters = _MapParametersEndpoint(
      endpoints,
      serializationManager,
    );
    methodSignaturePermutations = _MethodSignaturePermutationsEndpoint(
      endpoints,
      serializationManager,
    );
    methodStreaming = _MethodStreaming(
      endpoints,
      serializationManager,
    );
    authenticatedMethodStreaming = _AuthenticatedMethodStreaming(
      endpoints,
      serializationManager,
    );
    moduleEndpointSubclass = _ModuleEndpointSubclass(
      endpoints,
      serializationManager,
    );
    moduleEndpointAdaptation = _ModuleEndpointAdaptation(
      endpoints,
      serializationManager,
    );
    moduleEndpointReduction = _ModuleEndpointReduction(
      endpoints,
      serializationManager,
    );
    moduleEndpointExtension = _ModuleEndpointExtension(
      endpoints,
      serializationManager,
    );
    moduleSerialization = _ModuleSerializationEndpoint(
      endpoints,
      serializationManager,
    );
    namedParameters = _NamedParametersEndpoint(
      endpoints,
      serializationManager,
    );
    optionalParameters = _OptionalParametersEndpoint(
      endpoints,
      serializationManager,
    );
    inheritancePolymorphismTest = _InheritancePolymorphismTestEndpoint(
      endpoints,
      serializationManager,
    );
    recordParameters = _RecordParametersEndpoint(
      endpoints,
      serializationManager,
    );
    redis = _RedisEndpoint(
      endpoints,
      serializationManager,
    );
    serverOnlyScopedFieldModel = _ServerOnlyScopedFieldModelEndpoint(
      endpoints,
      serializationManager,
    );
    serverOnlyScopedFieldChildModel = _ServerOnlyScopedFieldChildModelEndpoint(
      endpoints,
      serializationManager,
    );
    sessionAuthentication = _SessionAuthenticationEndpoint(
      endpoints,
      serializationManager,
    );
    setParameters = _SetParametersEndpoint(
      endpoints,
      serializationManager,
    );
    signInRequired = _SignInRequiredEndpoint(
      endpoints,
      serializationManager,
    );
    adminScopeRequired = _AdminScopeRequiredEndpoint(
      endpoints,
      serializationManager,
    );
    simple = _SimpleEndpoint(
      endpoints,
      serializationManager,
    );
    subSubDirTest = _SubSubDirTestEndpoint(
      endpoints,
      serializationManager,
    );
    subDirTest = _SubDirTestEndpoint(
      endpoints,
      serializationManager,
    );
    testTools = _TestToolsEndpoint(
      endpoints,
      serializationManager,
    );
    authenticatedTestTools = _AuthenticatedTestToolsEndpoint(
      endpoints,
      serializationManager,
    );
    unauthenticated = _UnauthenticatedEndpoint(
      endpoints,
      serializationManager,
    );
    partiallyUnauthenticated = _PartiallyUnauthenticatedEndpoint(
      endpoints,
      serializationManager,
    );
    unauthenticatedRequireLogin = _UnauthenticatedRequireLoginEndpoint(
      endpoints,
      serializationManager,
    );
    requireLogin = _RequireLoginEndpoint(
      endpoints,
      serializationManager,
    );
    upload = _UploadEndpoint(
      endpoints,
      serializationManager,
    );
    myFeature = _MyFeatureEndpoint(
      endpoints,
      serializationManager,
    );
  }
}

class _FutureCalls {
  late final testCall = _TestCallFutureCall();

  late final testExceptionCall = _TestExceptionCallFutureCall();

  late final testGeneratedCall = _TestGeneratedCallFutureCall();
}

class _AsyncTasksEndpoint {
  _AsyncTasksEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> insertRowToSimpleDataAfterDelay(
    _ist.TestSessionBuilder sessionBuilder,
    int num,
    int seconds,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'asyncTasks',
            method: 'insertRowToSimpleDataAfterDelay',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'asyncTasks',
          methodName: 'insertRowToSimpleDataAfterDelay',
          parameters: _ist.testObjectToJson({
            'num': num,
            'seconds': seconds,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> throwExceptionAfterDelay(
    _ist.TestSessionBuilder sessionBuilder,
    int seconds,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'asyncTasks',
            method: 'throwExceptionAfterDelay',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'asyncTasks',
          methodName: 'throwExceptionAfterDelay',
          parameters: _ist.testObjectToJson({'seconds': seconds}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AuthenticationEndpoint {
  _AuthenticationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> removeAllUsers(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'authentication',
            method: 'removeAllUsers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'authentication',
          methodName: 'removeAllUsers',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> countUsers(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'authentication',
            method: 'countUsers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'authentication',
          methodName: 'countUsers',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> createUser(
    _ist.TestSessionBuilder sessionBuilder,
    String email,
    String password,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'authentication',
            method: 'createUser',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'authentication',
          methodName: 'createUser',
          parameters: _ist.testObjectToJson({
            'email': email,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i1n3uhu0.AuthenticationResponse> authenticate(
    _ist.TestSessionBuilder sessionBuilder,
    String email,
    String password, [
    List<String>? scopes,
  ]) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'authentication',
            method: 'authenticate',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'authentication',
          methodName: 'authenticate',
          parameters: _ist.testObjectToJson({
            'email': email,
            'password': password,
            'scopes': scopes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i1n3uhu0.AuthenticationResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> signOut(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'authentication',
            method: 'signOut',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'authentication',
          methodName: 'signOut',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> updateScopes(
    _ist.TestSessionBuilder sessionBuilder,
    int userId,
    List<String> scopes,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'authentication',
            method: 'updateScopes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'authentication',
          methodName: 'updateScopes',
          parameters: _ist.testObjectToJson({
            'userId': userId,
            'scopes': scopes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _BasicTypesEndpoint {
  _BasicTypesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<int?> testInt(
    _ist.TestSessionBuilder sessionBuilder,
    int? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testInt',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<double?> testDouble(
    _ist.TestSessionBuilder sessionBuilder,
    double? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testDouble',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testDouble',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<double?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool?> testBool(
    _ist.TestSessionBuilder sessionBuilder,
    bool? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testBool',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testBool',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<DateTime?> testDateTime(
    _ist.TestSessionBuilder sessionBuilder,
    DateTime? dateTime,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testDateTime',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testDateTime',
          parameters: _ist.testObjectToJson({'dateTime': dateTime}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<DateTime?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> testString(
    _ist.TestSessionBuilder sessionBuilder,
    String? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testString',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testString',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idt.ByteData?> testByteData(
    _ist.TestSessionBuilder sessionBuilder,
    _idt.ByteData? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testByteData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testByteData',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idt.ByteData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Duration?> testDuration(
    _ist.TestSessionBuilder sessionBuilder,
    Duration? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testDuration',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testDuration',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Duration?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_is.UuidValue?> testUuid(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testUuid',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testUuid',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_is.UuidValue?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Uri?> testUri(
    _ist.TestSessionBuilder sessionBuilder,
    Uri? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testUri',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testUri',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Uri?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<BigInt?> testBigInt(
    _ist.TestSessionBuilder sessionBuilder,
    BigInt? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicTypes',
            method: 'testBigInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicTypes',
          methodName: 'testBigInt',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<BigInt?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _BasicTypesStreamingEndpoint {
  _BasicTypesStreamingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Stream<int?> testInt(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testInt',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testInt',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<double?> testDouble(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<double?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<double?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testDouble',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testDouble',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<bool?> testBool(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<bool?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<bool?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testBool',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testBool',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<DateTime?> testDateTime(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<DateTime?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<DateTime?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testDateTime',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testDateTime',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<String?> testString(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<String?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<String?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testString',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testString',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<_idt.ByteData?> testByteData(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<_idt.ByteData?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<_idt.ByteData?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testByteData',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testByteData',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<Duration?> testDuration(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<Duration?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<Duration?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testDuration',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testDuration',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<_is.UuidValue?> testUuid(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<_is.UuidValue?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<_is.UuidValue?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testUuid',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testUuid',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<Uri?> testUri(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<Uri?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<Uri?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testUri',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testUri',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<BigInt?> testBigInt(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<BigInt?> value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<BigInt?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'basicTypesStreaming',
              method: 'testBigInt',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'basicTypesStreaming',
              methodName: 'testBigInt',
              arguments: {},
              requestedInputStreams: ['value'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'value': value},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _CloudStorageEndpoint {
  _CloudStorageEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> reset(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'reset',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'reset',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> storePublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
    _idt.ByteData byteData,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'storePublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'storePublicFile',
          parameters: _ist.testObjectToJson({
            'path': path,
            'byteData': byteData,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idt.ByteData?> retrievePublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'retrievePublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'retrievePublicFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idt.ByteData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool?> existsPublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'existsPublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'existsPublicFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> deletePublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'deletePublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'deletePublicFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> getPublicUrlForFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'getPublicUrlForFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'getPublicUrlForFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> getDirectFilePostUrl(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'getDirectFilePostUrl',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'getDirectFilePostUrl',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> verifyDirectFileUpload(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'cloudStorage',
            method: 'verifyDirectFileUpload',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'cloudStorage',
          methodName: 'verifyDirectFileUpload',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _S3CloudStorageEndpoint {
  _S3CloudStorageEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> storePublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
    _idt.ByteData byteData,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 's3CloudStorage',
            method: 'storePublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 's3CloudStorage',
          methodName: 'storePublicFile',
          parameters: _ist.testObjectToJson({
            'path': path,
            'byteData': byteData,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idt.ByteData?> retrievePublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 's3CloudStorage',
            method: 'retrievePublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 's3CloudStorage',
          methodName: 'retrievePublicFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idt.ByteData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool?> existsPublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 's3CloudStorage',
            method: 'existsPublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 's3CloudStorage',
          methodName: 'existsPublicFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> deletePublicFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 's3CloudStorage',
            method: 'deletePublicFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 's3CloudStorage',
          methodName: 'deletePublicFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> getPublicUrlForFile(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 's3CloudStorage',
            method: 'getPublicUrlForFile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 's3CloudStorage',
          methodName: 'getPublicUrlForFile',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> getDirectFilePostUrl(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 's3CloudStorage',
            method: 'getDirectFilePostUrl',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 's3CloudStorage',
          methodName: 'getDirectFilePostUrl',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> verifyDirectFileUpload(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 's3CloudStorage',
            method: 'verifyDirectFileUpload',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 's3CloudStorage',
          methodName: 'verifyDirectFileUpload',
          parameters: _ist.testObjectToJson({'path': path}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CustomClassProtocolEndpoint {
  _CustomClassProtocolEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_ilwf0zl1.ProtocolCustomClass> getProtocolField(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customClassProtocol',
            method: 'getProtocolField',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customClassProtocol',
          methodName: 'getProtocolField',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.ProtocolCustomClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CustomTypesEndpoint {
  _CustomTypesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_ilwf0zl1.CustomClass> returnCustomClass(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.CustomClass data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnCustomClass',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnCustomClass',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.CustomClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.CustomClass?> returnCustomClassNullable(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.CustomClass? data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnCustomClassNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnCustomClassNullable',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.CustomClass?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.CustomClass2> returnCustomClass2(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.CustomClass2 data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnCustomClass2',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnCustomClass2',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.CustomClass2>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.CustomClass2?> returnCustomClass2Nullable(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.CustomClass2? data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnCustomClass2Nullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnCustomClass2Nullable',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.CustomClass2?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.ExternalCustomClass> returnExternalCustomClass(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.ExternalCustomClass data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnExternalCustomClass',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnExternalCustomClass',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.ExternalCustomClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.ExternalCustomClass?> returnExternalCustomClassNullable(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.ExternalCustomClass? data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnExternalCustomClassNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnExternalCustomClassNullable',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.ExternalCustomClass?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.FreezedCustomClass> returnFreezedCustomClass(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.FreezedCustomClass data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnFreezedCustomClass',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnFreezedCustomClass',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.FreezedCustomClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.FreezedCustomClass?> returnFreezedCustomClassNullable(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.FreezedCustomClass? data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnFreezedCustomClassNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnFreezedCustomClassNullable',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.FreezedCustomClass?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.CustomClassWithoutProtocolSerialization>
  returnCustomClassWithoutProtocolSerialization(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.CustomClassWithoutProtocolSerialization data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnCustomClassWithoutProtocolSerialization',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnCustomClassWithoutProtocolSerialization',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<
                  _ilwf0zl1.CustomClassWithoutProtocolSerialization
                >);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.CustomClassWithProtocolSerialization>
  returnCustomClassWithProtocolSerialization(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.CustomClassWithProtocolSerialization data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnCustomClassWithProtocolSerialization',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnCustomClassWithProtocolSerialization',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ilwf0zl1.CustomClassWithProtocolSerialization>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ilwf0zl1.CustomClassWithProtocolSerializationMethod>
  returnCustomClassWithProtocolSerializationMethod(
    _ist.TestSessionBuilder sessionBuilder,
    _ilwf0zl1.CustomClassWithProtocolSerializationMethod data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'customTypes',
            method: 'returnCustomClassWithProtocolSerializationMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customTypes',
          methodName: 'returnCustomClassWithProtocolSerializationMethod',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<
                  _ilwf0zl1.CustomClassWithProtocolSerializationMethod
                >);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _BasicDatabase {
  _BasicDatabase(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> deleteAllSimpleTestData(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'deleteAllSimpleTestData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'deleteAllSimpleTestData',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> deleteSimpleTestDataLessThan(
    _ist.TestSessionBuilder sessionBuilder,
    int num,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'deleteSimpleTestDataLessThan',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'deleteSimpleTestDataLessThan',
          parameters: _ist.testObjectToJson({'num': num}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> findAndDeleteSimpleTestData(
    _ist.TestSessionBuilder sessionBuilder,
    int num,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'findAndDeleteSimpleTestData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'findAndDeleteSimpleTestData',
          parameters: _ist.testObjectToJson({'num': num}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> createSimpleTestData(
    _ist.TestSessionBuilder sessionBuilder,
    int numRows,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'createSimpleTestData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'createSimpleTestData',
          parameters: _ist.testObjectToJson({'numRows': numRows}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i685tvwm.SimpleData>> findSimpleData(
    _ist.TestSessionBuilder sessionBuilder, {
    required int limit,
    required int offset,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'findSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'findSimpleData',
          parameters: _ist.testObjectToJson({
            'limit': limit,
            'offset': offset,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i685tvwm.SimpleData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData?> findFirstRowSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    int num,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'findFirstRowSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'findFirstRowSimpleData',
          parameters: _ist.testObjectToJson({'num': num}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData?> findByIdSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    int id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'findByIdSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'findByIdSimpleData',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ihs20x3n.SimpleDataList?> findSimpleDataRowsLessThan(
    _ist.TestSessionBuilder sessionBuilder,
    int num,
    int offset,
    int limit,
    bool descending,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'findSimpleDataRowsLessThan',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'findSimpleDataRowsLessThan',
          parameters: _ist.testObjectToJson({
            'num': num,
            'offset': offset,
            'limit': limit,
            'descending': descending,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ihs20x3n.SimpleDataList?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData> insertRowSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData simpleData,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'insertRowSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'insertRowSimpleData',
          parameters: _ist.testObjectToJson({'simpleData': simpleData}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData> updateRowSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData simpleData,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'updateRowSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'updateRowSimpleData',
          parameters: _ist.testObjectToJson({'simpleData': simpleData}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> deleteRowSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData simpleData,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'deleteRowSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'deleteRowSimpleData',
          parameters: _ist.testObjectToJson({'simpleData': simpleData}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<int>> deleteWhereSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'deleteWhereSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'deleteWhereSimpleData',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> countSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'countSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'countSimpleData',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iuch3ck4.Types> insertTypes(
    _ist.TestSessionBuilder sessionBuilder,
    _iuch3ck4.Types value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'insertTypes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'insertTypes',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iuch3ck4.Types>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iuch3ck4.Types> updateTypes(
    _ist.TestSessionBuilder sessionBuilder,
    _iuch3ck4.Types value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'updateTypes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'updateTypes',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iuch3ck4.Types>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int?> countTypesRows(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'countTypesRows',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'countTypesRows',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<int>> deleteAllInTypes(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'deleteAllInTypes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'deleteAllInTypes',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iuch3ck4.Types?> getTypes(
    _ist.TestSessionBuilder sessionBuilder,
    int id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'getTypes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'getTypes',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iuch3ck4.Types?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int?> getTypesRawQuery(
    _ist.TestSessionBuilder sessionBuilder,
    int id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'getTypesRawQuery',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'getTypesRawQuery',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_in2ouh3f.ObjectWithEnum> storeObjectWithEnum(
    _ist.TestSessionBuilder sessionBuilder,
    _in2ouh3f.ObjectWithEnum object,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'storeObjectWithEnum',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'storeObjectWithEnum',
          parameters: _ist.testObjectToJson({'object': object}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_in2ouh3f.ObjectWithEnum>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_in2ouh3f.ObjectWithEnum?> getObjectWithEnum(
    _ist.TestSessionBuilder sessionBuilder,
    int id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'getObjectWithEnum',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'getObjectWithEnum',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_in2ouh3f.ObjectWithEnum?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_itaf3m7v.ObjectWithEnumEnhanced> storeObjectWithEnumEnhanced(
    _ist.TestSessionBuilder sessionBuilder,
    _itaf3m7v.ObjectWithEnumEnhanced object,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'storeObjectWithEnumEnhanced',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'storeObjectWithEnumEnhanced',
          parameters: _ist.testObjectToJson({'object': object}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_itaf3m7v.ObjectWithEnumEnhanced>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_itaf3m7v.ObjectWithEnumEnhanced?> getObjectWithEnumEnhanced(
    _ist.TestSessionBuilder sessionBuilder,
    int id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'getObjectWithEnumEnhanced',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'getObjectWithEnumEnhanced',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_itaf3m7v.ObjectWithEnumEnhanced?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i120a7u7.ObjectWithObject> storeObjectWithObject(
    _ist.TestSessionBuilder sessionBuilder,
    _i120a7u7.ObjectWithObject object,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'storeObjectWithObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'storeObjectWithObject',
          parameters: _ist.testObjectToJson({'object': object}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i120a7u7.ObjectWithObject>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i120a7u7.ObjectWithObject?> getObjectWithObject(
    _ist.TestSessionBuilder sessionBuilder,
    int id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'getObjectWithObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'getObjectWithObject',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i120a7u7.ObjectWithObject?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> deleteAll(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'deleteAll',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'deleteAll',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> testByteDataStore(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'basicDatabase',
            method: 'testByteDataStore',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'basicDatabase',
          methodName: 'testByteDataStore',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _TransactionsDatabaseEndpoint {
  _TransactionsDatabaseEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> removeRow(
    _ist.TestSessionBuilder sessionBuilder,
    int num,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'transactionsDatabase',
            method: 'removeRow',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'transactionsDatabase',
          methodName: 'removeRow',
          parameters: _ist.testObjectToJson({'num': num}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> updateInsertDelete(
    _ist.TestSessionBuilder sessionBuilder,
    int numUpdate,
    int numInsert,
    int numDelete,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'transactionsDatabase',
            method: 'updateInsertDelete',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'transactionsDatabase',
          methodName: 'updateInsertDelete',
          parameters: _ist.testObjectToJson({
            'numUpdate': numUpdate,
            'numInsert': numInsert,
            'numDelete': numDelete,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _DeprecationEndpoint {
  _DeprecationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  @deprecated
  _ida.Future<void> setGlobalDouble(
    _ist.TestSessionBuilder sessionBuilder,
    double? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'deprecation',
            method: 'setGlobalDouble',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deprecation',
          methodName: 'setGlobalDouble',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  @Deprecated('Marking endpoint method as deprecated')
  _ida.Future<double> getGlobalDouble(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'deprecation',
            method: 'getGlobalDouble',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deprecation',
          methodName: 'getGlobalDouble',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<double>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> methodWithDeprecatedParam(
    _ist.TestSessionBuilder sessionBuilder,
    @deprecated String deprecatedParam,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'deprecation',
            method: 'methodWithDeprecatedParam',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deprecation',
          methodName: 'methodWithDeprecatedParam',
          parameters: _ist.testObjectToJson({
            'deprecatedParam': deprecatedParam,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> methodWithDeprecatedParamMessage(
    _ist.TestSessionBuilder sessionBuilder,
    @Deprecated('This parameter is deprecated') String deprecatedParam,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'deprecation',
            method: 'methodWithDeprecatedParamMessage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deprecation',
          methodName: 'methodWithDeprecatedParamMessage',
          parameters: _ist.testObjectToJson({
            'deprecatedParam': deprecatedParam,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> methodWithMixedParams(
    _ist.TestSessionBuilder sessionBuilder,
    String normalParam,
    @deprecated String deprecatedParam,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'deprecation',
            method: 'methodWithMixedParams',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deprecation',
          methodName: 'methodWithMixedParams',
          parameters: _ist.testObjectToJson({
            'normalParam': normalParam,
            'deprecatedParam': deprecatedParam,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> methodWithOptionalDeprecatedParam(
    _ist.TestSessionBuilder sessionBuilder, [
    @deprecated String? deprecatedParam,
  ]) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'deprecation',
            method: 'methodWithOptionalDeprecatedParam',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deprecation',
          methodName: 'methodWithOptionalDeprecatedParam',
          parameters: _ist.testObjectToJson({
            'deprecatedParam': deprecatedParam,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> methodWithNamedDeprecatedParam(
    _ist.TestSessionBuilder sessionBuilder, {
    required String normalParam,
    @deprecated String? deprecatedParam,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'deprecation',
            method: 'methodWithNamedDeprecatedParam',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deprecation',
          methodName: 'methodWithNamedDeprecatedParam',
          parameters: _ist.testObjectToJson({
            'normalParam': normalParam,
            'deprecatedParam': deprecatedParam,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _DiagnosticEventTestEndpoint {
  _DiagnosticEventTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> submitExceptionEvent(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'diagnosticEventTest',
            method: 'submitExceptionEvent',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'diagnosticEventTest',
          methodName: 'submitExceptionEvent',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _EchoRequestEndpoint {
  _EchoRequestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String?> echoAuthenticationKey(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'echoRequest',
            method: 'echoAuthenticationKey',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'echoRequest',
          methodName: 'echoAuthenticationKey',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String>?> echoHttpHeader(
    _ist.TestSessionBuilder sessionBuilder,
    String headerName,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'echoRequest',
            method: 'echoHttpHeader',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'echoRequest',
          methodName: 'echoHttpHeader',
          parameters: _ist.testObjectToJson({'headerName': headerName}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _EchoRequiredFieldEndpoint {
  _EchoRequiredFieldEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iyoxtomg.ModelWithRequiredField> echoModel(
    _ist.TestSessionBuilder sessionBuilder,
    _iyoxtomg.ModelWithRequiredField model,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'echoRequiredField',
            method: 'echoModel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'echoRequiredField',
          methodName: 'echoModel',
          parameters: _ist.testObjectToJson({'model': model}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iyoxtomg.ModelWithRequiredField>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> throwException(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'echoRequiredField',
            method: 'throwException',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'echoRequiredField',
          methodName: 'throwException',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _EmailAuthTestMethods {
  _EmailAuthTestMethods(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String?> findVerificationCode(
    _ist.TestSessionBuilder sessionBuilder,
    String userName,
    String email,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailAuthTestMethods',
            method: 'findVerificationCode',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailAuthTestMethods',
          methodName: 'findVerificationCode',
          parameters: _ist.testObjectToJson({
            'userName': userName,
            'email': email,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> findResetCode(
    _ist.TestSessionBuilder sessionBuilder,
    String email,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailAuthTestMethods',
            method: 'findResetCode',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailAuthTestMethods',
          methodName: 'findResetCode',
          parameters: _ist.testObjectToJson({'email': email}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> tearDown(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailAuthTestMethods',
            method: 'tearDown',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailAuthTestMethods',
          methodName: 'tearDown',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> createUser(
    _ist.TestSessionBuilder sessionBuilder,
    String userName,
    String email,
    String password,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailAuthTestMethods',
            method: 'createUser',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailAuthTestMethods',
          methodName: 'createUser',
          parameters: _ist.testObjectToJson({
            'userName': userName,
            'email': email,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ConcreteBaseEndpoint {
  _ConcreteBaseEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> virtualMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteBase',
            method: 'virtualMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteBase',
          methodName: 'virtualMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> concreteMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteBase',
            method: 'concreteMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteBase',
          methodName: 'concreteMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> abstractBaseMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteBase',
            method: 'abstractBaseMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteBase',
          methodName: 'abstractBaseMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<String> abstractBaseStreamMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<String>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'concreteBase',
              method: 'abstractBaseStreamMethod',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'concreteBase',
              methodName: 'abstractBaseStreamMethod',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _ConcreteSubClassEndpoint {
  _ConcreteSubClassEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> subClassVirtualMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteSubClass',
            method: 'subClassVirtualMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteSubClass',
          methodName: 'subClassVirtualMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> virtualMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteSubClass',
            method: 'virtualMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteSubClass',
          methodName: 'virtualMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> concreteMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteSubClass',
            method: 'concreteMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteSubClass',
          methodName: 'concreteMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> abstractBaseMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteSubClass',
            method: 'abstractBaseMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteSubClass',
          methodName: 'abstractBaseMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<String> abstractBaseStreamMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<String>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'concreteSubClass',
              method: 'abstractBaseStreamMethod',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'concreteSubClass',
              methodName: 'abstractBaseStreamMethod',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _IndependentEndpoint {
  _IndependentEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> subClassVirtualMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'independent',
            method: 'subClassVirtualMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'independent',
          methodName: 'subClassVirtualMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> virtualMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'independent',
            method: 'virtualMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'independent',
          methodName: 'virtualMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> concreteMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'independent',
            method: 'concreteMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'independent',
          methodName: 'concreteMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> abstractBaseMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'independent',
            method: 'abstractBaseMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'independent',
          methodName: 'abstractBaseMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<String> abstractBaseStreamMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<String>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'independent',
              method: 'abstractBaseStreamMethod',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'independent',
              methodName: 'abstractBaseStreamMethod',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _ConcreteFromModuleAbstractBaseEndpoint {
  _ConcreteFromModuleAbstractBaseEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> virtualMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteFromModuleAbstractBase',
            method: 'virtualMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteFromModuleAbstractBase',
          methodName: 'virtualMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> abstractBaseMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteFromModuleAbstractBase',
            method: 'abstractBaseMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteFromModuleAbstractBase',
          methodName: 'abstractBaseMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ConcreteModuleBaseEndpoint {
  _ConcreteModuleBaseEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> virtualMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteModuleBase',
            method: 'virtualMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteModuleBase',
          methodName: 'virtualMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> concreteMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteModuleBase',
            method: 'concreteMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteModuleBase',
          methodName: 'concreteMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> abstractBaseMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'concreteModuleBase',
            method: 'abstractBaseMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'concreteModuleBase',
          methodName: 'abstractBaseMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _LoggedInEndpoint {
  _LoggedInEndpoint(
    _endpointDispatch,
    _serializationManager,
  );
}

class _MyLoggedInEndpoint {
  _MyLoggedInEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> echo(
    _ist.TestSessionBuilder sessionBuilder,
    String value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'myLoggedIn',
            method: 'echo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'myLoggedIn',
          methodName: 'echo',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AdminEndpoint {
  _AdminEndpoint(
    _endpointDispatch,
    _serializationManager,
  );
}

class _MyAdminEndpoint {
  _MyAdminEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> echo(
    _ist.TestSessionBuilder sessionBuilder,
    String value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'myAdmin',
            method: 'echo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'myAdmin',
          methodName: 'echo',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _MyConcreteAdminEndpoint {
  _MyConcreteAdminEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> echo(
    _ist.TestSessionBuilder sessionBuilder,
    String value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'myConcreteAdmin',
            method: 'echo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'myConcreteAdmin',
          methodName: 'echo',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ExceptionTestEndpoint {
  _ExceptionTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> throwNormalException(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'exceptionTest',
            method: 'throwNormalException',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'exceptionTest',
          methodName: 'throwNormalException',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> throwExceptionWithData(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'exceptionTest',
            method: 'throwExceptionWithData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'exceptionTest',
          methodName: 'throwExceptionWithData',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> workingWithoutException(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'exceptionTest',
            method: 'workingWithoutException',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'exceptionTest',
          methodName: 'workingWithoutException',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _FailedCallsEndpoint {
  _FailedCallsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> failedCall(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'failedCalls',
            method: 'failedCall',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'failedCalls',
          methodName: 'failedCall',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> failedDatabaseQuery(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'failedCalls',
            method: 'failedDatabaseQuery',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'failedCalls',
          methodName: 'failedDatabaseQuery',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> failedDatabaseQueryCaughtException(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'failedCalls',
            method: 'failedDatabaseQueryCaughtException',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'failedCalls',
          methodName: 'failedDatabaseQueryCaughtException',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> slowCall(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'failedCalls',
            method: 'slowCall',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'failedCalls',
          methodName: 'slowCall',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> caughtException(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'failedCalls',
            method: 'caughtException',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'failedCalls',
          methodName: 'caughtException',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _FieldScopesEndpoint {
  _FieldScopesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> storeObject(
    _ist.TestSessionBuilder sessionBuilder,
    _io906m8r.ObjectFieldScopes object,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'fieldScopes',
            method: 'storeObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'fieldScopes',
          methodName: 'storeObject',
          parameters: _ist.testObjectToJson({'object': object}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_io906m8r.ObjectFieldScopes?> retrieveObject(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'fieldScopes',
            method: 'retrieveObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'fieldScopes',
          methodName: 'retrieveObject',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_io906m8r.ObjectFieldScopes?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _TestFutureCallsEndpoint {
  _TestFutureCallsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> makeFutureCall(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData? data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testFutureCalls',
            method: 'makeFutureCall',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testFutureCalls',
          methodName: 'makeFutureCall',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> makeFutureCallThatThrows(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData? data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testFutureCalls',
            method: 'makeFutureCallThatThrows',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testFutureCalls',
          methodName: 'makeFutureCallThatThrows',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ListParametersEndpoint {
  _ListParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<int>> returnIntList(
    _ist.TestSessionBuilder sessionBuilder,
    List<int> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnIntList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnIntList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<List<int>>> returnIntListList(
    _ist.TestSessionBuilder sessionBuilder,
    List<List<int>> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnIntListList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnIntListList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<List<int>>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<int>?> returnIntListNullable(
    _ist.TestSessionBuilder sessionBuilder,
    List<int>? list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnIntListNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnIntListNullable',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<int>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<List<int>?>> returnIntListNullableList(
    _ist.TestSessionBuilder sessionBuilder,
    List<List<int>?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnIntListNullableList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnIntListNullableList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<List<int>?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<List<int>>?> returnIntListListNullable(
    _ist.TestSessionBuilder sessionBuilder,
    List<List<int>>? list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnIntListListNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnIntListListNullable',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<List<int>>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<int?>> returnIntListNullableInts(
    _ist.TestSessionBuilder sessionBuilder,
    List<int?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnIntListNullableInts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnIntListNullableInts',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<int?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<int?>?> returnNullableIntListNullableInts(
    _ist.TestSessionBuilder sessionBuilder,
    List<int?>? list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnNullableIntListNullableInts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnNullableIntListNullableInts',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<int?>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<double>> returnDoubleList(
    _ist.TestSessionBuilder sessionBuilder,
    List<double> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnDoubleList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnDoubleList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<double>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<double?>> returnDoubleListNullableDoubles(
    _ist.TestSessionBuilder sessionBuilder,
    List<double?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnDoubleListNullableDoubles',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnDoubleListNullableDoubles',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<double?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<bool>> returnBoolList(
    _ist.TestSessionBuilder sessionBuilder,
    List<bool> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnBoolList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnBoolList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<bool>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<bool?>> returnBoolListNullableBools(
    _ist.TestSessionBuilder sessionBuilder,
    List<bool?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnBoolListNullableBools',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnBoolListNullableBools',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<bool?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String>> returnStringList(
    _ist.TestSessionBuilder sessionBuilder,
    List<String> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnStringList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnStringList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String?>> returnStringListNullableStrings(
    _ist.TestSessionBuilder sessionBuilder,
    List<String?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnStringListNullableStrings',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnStringListNullableStrings',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<DateTime>> returnDateTimeList(
    _ist.TestSessionBuilder sessionBuilder,
    List<DateTime> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnDateTimeList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnDateTimeList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<DateTime>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<DateTime?>> returnDateTimeListNullableDateTimes(
    _ist.TestSessionBuilder sessionBuilder,
    List<DateTime?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnDateTimeListNullableDateTimes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnDateTimeListNullableDateTimes',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<DateTime?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_idt.ByteData>> returnByteDataList(
    _ist.TestSessionBuilder sessionBuilder,
    List<_idt.ByteData> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnByteDataList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnByteDataList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_idt.ByteData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_idt.ByteData?>> returnByteDataListNullableByteDatas(
    _ist.TestSessionBuilder sessionBuilder,
    List<_idt.ByteData?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnByteDataListNullableByteDatas',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnByteDataListNullableByteDatas',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_idt.ByteData?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i685tvwm.SimpleData>> returnSimpleDataList(
    _ist.TestSessionBuilder sessionBuilder,
    List<_i685tvwm.SimpleData> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnSimpleDataList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnSimpleDataList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i685tvwm.SimpleData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i685tvwm.SimpleData?>>
  returnSimpleDataListNullableSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    List<_i685tvwm.SimpleData?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnSimpleDataListNullableSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnSimpleDataListNullableSimpleData',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i685tvwm.SimpleData?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i685tvwm.SimpleData>?> returnSimpleDataListNullable(
    _ist.TestSessionBuilder sessionBuilder,
    List<_i685tvwm.SimpleData>? list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnSimpleDataListNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnSimpleDataListNullable',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i685tvwm.SimpleData>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i685tvwm.SimpleData?>?>
  returnNullableSimpleDataListNullableSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    List<_i685tvwm.SimpleData?>? list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnNullableSimpleDataListNullableSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnNullableSimpleDataListNullableSimpleData',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i685tvwm.SimpleData?>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<Duration>> returnDurationList(
    _ist.TestSessionBuilder sessionBuilder,
    List<Duration> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnDurationList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnDurationList',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<Duration>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<Duration?>> returnDurationListNullableDurations(
    _ist.TestSessionBuilder sessionBuilder,
    List<Duration?> list,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'listParameters',
            method: 'returnDurationListNullableDurations',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'listParameters',
          methodName: 'returnDurationListNullableDurations',
          parameters: _ist.testObjectToJson({'list': list}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<Duration?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _LoggingEndpoint {
  _LoggingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> slowQueryMethod(
    _ist.TestSessionBuilder sessionBuilder,
    int seconds,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'slowQueryMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'slowQueryMethod',
          parameters: _ist.testObjectToJson({'seconds': seconds}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> queryMethod(
    _ist.TestSessionBuilder sessionBuilder,
    int queries,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'queryMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'queryMethod',
          parameters: _ist.testObjectToJson({'queries': queries}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> failedQueryMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'failedQueryMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'failedQueryMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> slowMethod(
    _ist.TestSessionBuilder sessionBuilder,
    int delayMillis,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'slowMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'slowMethod',
          parameters: _ist.testObjectToJson({'delayMillis': delayMillis}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> failingMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'failingMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'failingMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> emptyMethod(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'emptyMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'emptyMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> log(
    _ist.TestSessionBuilder sessionBuilder,
    String message,
    List<int> logLevels,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'log',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'log',
          parameters: _ist.testObjectToJson({
            'message': message,
            'logLevels': logLevels,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> logInfo(
    _ist.TestSessionBuilder sessionBuilder,
    String message,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'logInfo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'logInfo',
          parameters: _ist.testObjectToJson({'message': message}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> logDebugAndInfoAndError(
    _ist.TestSessionBuilder sessionBuilder,
    String debug,
    String info,
    String error,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'logDebugAndInfoAndError',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'logDebugAndInfoAndError',
          parameters: _ist.testObjectToJson({
            'debug': debug,
            'info': info,
            'error': error,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> twoQueries(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'logging',
            method: 'twoQueries',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'logging',
          methodName: 'twoQueries',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<int> streamEmpty(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> input,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'logging',
              method: 'streamEmpty',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'logging',
              methodName: 'streamEmpty',
              arguments: {},
              requestedInputStreams: ['input'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'input': input},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> streamLogging(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> input,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'logging',
              method: 'streamLogging',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'logging',
              methodName: 'streamLogging',
              arguments: {},
              requestedInputStreams: ['input'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'input': input},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> streamQueryLogging(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> input,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'logging',
              method: 'streamQueryLogging',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'logging',
              methodName: 'streamQueryLogging',
              arguments: {},
              requestedInputStreams: ['input'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'input': input},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> streamException(_ist.TestSessionBuilder sessionBuilder) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'logging',
              method: 'streamException',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'logging',
              methodName: 'streamException',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _LoggingDisabledEndpoint {
  _LoggingDisabledEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> logInfo(
    _ist.TestSessionBuilder sessionBuilder,
    String message,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'loggingDisabled',
            method: 'logInfo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'loggingDisabled',
          methodName: 'logInfo',
          parameters: _ist.testObjectToJson({'message': message}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _MapParametersEndpoint {
  _MapParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<Map<String, int>> returnIntMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, int> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnIntMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnIntMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, int>?> returnIntMapNullable(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, int>? map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnIntMapNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnIntMapNullable',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, int>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, Map<String, int>>> returnNestedIntMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, Map<String, int>> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnNestedIntMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnNestedIntMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, Map<String, int>>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, int?>> returnIntMapNullableInts(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, int?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnIntMapNullableInts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnIntMapNullableInts',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, int?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, int?>?> returnNullableIntMapNullableInts(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, int?>? map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnNullableIntMapNullableInts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnNullableIntMapNullableInts',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, int?>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<int, int>> returnIntIntMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<int, int> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnIntIntMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnIntIntMap',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (map) => _igqrxdcj.Protocol().deserialize<Map<int, int>>(map),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, Map<int, int>>> returnNestedIntIntMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, Map<int, int>> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnNestedIntIntMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnNestedIntIntMap',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, Map<int, int>>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<_izdri23a.TestEnum, int>> returnEnumIntMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<_izdri23a.TestEnum, int> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnEnumIntMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnEnumIntMap',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (map) => _igqrxdcj.Protocol()
                  .deserialize<Map<_izdri23a.TestEnum, int>>(map),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, _izdri23a.TestEnum>> returnEnumMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, _izdri23a.TestEnum> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnEnumMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnEnumMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, _izdri23a.TestEnum>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, double>> returnDoubleMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, double> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDoubleMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDoubleMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, double>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, double?>> returnDoubleMapNullableDoubles(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, double?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDoubleMapNullableDoubles',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDoubleMapNullableDoubles',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, double?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, bool>> returnBoolMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, bool> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnBoolMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnBoolMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, bool>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, bool?>> returnBoolMapNullableBools(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, bool?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnBoolMapNullableBools',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnBoolMapNullableBools',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, bool?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, String>> returnStringMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, String> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnStringMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnStringMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, String>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, String?>> returnStringMapNullableStrings(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, String?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnStringMapNullableStrings',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnStringMapNullableStrings',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, String?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, DateTime>> returnDateTimeMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, DateTime> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDateTimeMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDateTimeMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, DateTime>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, DateTime?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDateTimeMapNullableDateTimes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDateTimeMapNullableDateTimes',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, DateTime?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, _idt.ByteData>> returnByteDataMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, _idt.ByteData> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnByteDataMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnByteDataMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, _idt.ByteData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, _idt.ByteData?>> returnByteDataMapNullableByteDatas(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, _idt.ByteData?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnByteDataMapNullableByteDatas',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnByteDataMapNullableByteDatas',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, _idt.ByteData?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, _i685tvwm.SimpleData>> returnSimpleDataMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, _i685tvwm.SimpleData> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnSimpleDataMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnSimpleDataMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, _i685tvwm.SimpleData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, _i685tvwm.SimpleData?>>
  returnSimpleDataMapNullableSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, _i685tvwm.SimpleData?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnSimpleDataMapNullableSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnSimpleDataMapNullableSimpleData',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, _i685tvwm.SimpleData?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, _i685tvwm.SimpleData>?> returnSimpleDataMapNullable(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, _i685tvwm.SimpleData>? map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnSimpleDataMapNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnSimpleDataMapNullable',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, _i685tvwm.SimpleData>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, _i685tvwm.SimpleData?>?>
  returnNullableSimpleDataMapNullableSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, _i685tvwm.SimpleData?>? map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnNullableSimpleDataMapNullableSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnNullableSimpleDataMapNullableSimpleData',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, _i685tvwm.SimpleData?>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, Duration>> returnDurationMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, Duration> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDurationMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDurationMap',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, Duration>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, Duration?>> returnDurationMapNullableDurations(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, Duration?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDurationMapNullableDurations',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDurationMapNullableDurations',
          parameters: _ist.testObjectToJson({'map': map}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Map<String, Duration?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<(Map<int, String>, String), String>>
  returnNestedNonStringKeyedMapInsideRecordInsideMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<(Map<int, String>, String), String> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnNestedNonStringKeyedMapInsideRecordInsideMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnNestedNonStringKeyedMapInsideRecordInsideMap',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Map<(Map<int, String>, String), String>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, (Map<int, int>,)>>
  returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, (Map<int, int>,)> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName:
              'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Map<String, (Map<int, int>,)>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<DateTime, bool>> returnDateTimeBoolMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<DateTime, bool> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDateTimeBoolMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDateTimeBoolMap',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (map) =>
                  _igqrxdcj.Protocol().deserialize<Map<DateTime, bool>>(map),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<DateTime, bool>?> returnDateTimeBoolMapNullable(
    _ist.TestSessionBuilder sessionBuilder,
    Map<DateTime, bool>? map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnDateTimeBoolMapNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnDateTimeBoolMapNullable',
          parameters: _ist.testObjectToJson({
            'map': map == null
                ? null
                : _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (map) =>
                  _igqrxdcj.Protocol().deserialize<Map<DateTime, bool>?>(map),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<int, String>> returnIntStringMap(
    _ist.TestSessionBuilder sessionBuilder,
    Map<int, String> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnIntStringMap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnIntStringMap',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (map) => _igqrxdcj.Protocol().deserialize<Map<int, String>>(map),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<int, String>?> returnIntStringMapNullable(
    _ist.TestSessionBuilder sessionBuilder,
    Map<int, String>? map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'mapParameters',
            method: 'returnIntStringMapNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'mapParameters',
          methodName: 'returnIntStringMapNullable',
          parameters: _ist.testObjectToJson({
            'map': map == null
                ? null
                : _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (map) => _igqrxdcj.Protocol().deserialize<Map<int, String>?>(map),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _MethodSignaturePermutationsEndpoint {
  _MethodSignaturePermutationsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> echoPositionalArg(
    _ist.TestSessionBuilder sessionBuilder,
    String string,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodSignaturePermutations',
            method: 'echoPositionalArg',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodSignaturePermutations',
          methodName: 'echoPositionalArg',
          parameters: _ist.testObjectToJson({'string': string}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> echoNamedArg(
    _ist.TestSessionBuilder sessionBuilder, {
    required String string,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodSignaturePermutations',
            method: 'echoNamedArg',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodSignaturePermutations',
          methodName: 'echoNamedArg',
          parameters: _ist.testObjectToJson({'string': string}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> echoNullableNamedArg(
    _ist.TestSessionBuilder sessionBuilder, {
    String? string,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodSignaturePermutations',
            method: 'echoNullableNamedArg',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodSignaturePermutations',
          methodName: 'echoNullableNamedArg',
          parameters: _ist.testObjectToJson({'string': string}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> echoOptionalArg(
    _ist.TestSessionBuilder sessionBuilder, [
    String? string,
  ]) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodSignaturePermutations',
            method: 'echoOptionalArg',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodSignaturePermutations',
          methodName: 'echoOptionalArg',
          parameters: _ist.testObjectToJson({'string': string}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String?>> echoPositionalAndNamedArgs(
    _ist.TestSessionBuilder sessionBuilder,
    String string1, {
    required String string2,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodSignaturePermutations',
            method: 'echoPositionalAndNamedArgs',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodSignaturePermutations',
          methodName: 'echoPositionalAndNamedArgs',
          parameters: _ist.testObjectToJson({
            'string1': string1,
            'string2': string2,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String?>> echoPositionalAndNullableNamedArgs(
    _ist.TestSessionBuilder sessionBuilder,
    String string1, {
    String? string2,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodSignaturePermutations',
            method: 'echoPositionalAndNullableNamedArgs',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodSignaturePermutations',
          methodName: 'echoPositionalAndNullableNamedArgs',
          parameters: _ist.testObjectToJson({
            'string1': string1,
            'string2': string2,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String?>> echoPositionalAndOptionalArgs(
    _ist.TestSessionBuilder sessionBuilder,
    String string1, [
    String? string2,
  ]) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodSignaturePermutations',
            method: 'echoPositionalAndOptionalArgs',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodSignaturePermutations',
          methodName: 'echoPositionalAndOptionalArgs',
          parameters: _ist.testObjectToJson({
            'string1': string1,
            'string2': string2,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<String> echoNamedArgStream(
    _ist.TestSessionBuilder sessionBuilder, {
    required _ida.Stream<String> strings,
  }) {
    var _localTestStreamManager = _ist.TestStreamManager<String>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodSignaturePermutations',
              method: 'echoNamedArgStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodSignaturePermutations',
              methodName: 'echoNamedArgStream',
              arguments: {},
              requestedInputStreams: ['strings'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'strings': strings},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<String> echoNamedArgStreamAsFuture(
    _ist.TestSessionBuilder sessionBuilder, {
    required _ida.Stream<String> strings,
  }) async {
    var _localTestStreamManager = _ist.TestStreamManager<String>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodSignaturePermutations',
              method: 'echoNamedArgStreamAsFuture',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodSignaturePermutations',
              methodName: 'echoNamedArgStreamAsFuture',
              arguments: {},
              requestedInputStreams: ['strings'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'strings': strings},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<String> echoPositionalArgStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<String> strings,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<String>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodSignaturePermutations',
              method: 'echoPositionalArgStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodSignaturePermutations',
              methodName: 'echoPositionalArgStream',
              arguments: {},
              requestedInputStreams: ['strings'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'strings': strings},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<String> echoPositionalArgStreamAsFuture(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<String> strings,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<String>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodSignaturePermutations',
              method: 'echoPositionalArgStreamAsFuture',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodSignaturePermutations',
              methodName: 'echoPositionalArgStreamAsFuture',
              arguments: {},
              requestedInputStreams: ['strings'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'strings': strings},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }
}

class _MethodStreaming {
  _MethodStreaming(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Stream<int> simpleStream(_ist.TestSessionBuilder sessionBuilder) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> neverEndingStreamWithDelay(
    _ist.TestSessionBuilder sessionBuilder,
    int millisecondsDelay,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'neverEndingStreamWithDelay',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'neverEndingStreamWithDelay',
              arguments: {'millisecondsDelay': millisecondsDelay},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> methodCallEndpoint(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'methodCallEndpoint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'methodCallEndpoint',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> intReturnFromStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'intReturnFromStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'intReturnFromStream',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<int?> nullableIntReturnFromStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int?> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<int?>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'nullableIntReturnFromStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'nullableIntReturnFromStream',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<int?> getBroadcastStream(_ist.TestSessionBuilder sessionBuilder) {
    var _localTestStreamManager = _ist.TestStreamManager<int?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'getBroadcastStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'getBroadcastStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<bool> wasBroadcastStreamCanceled(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'wasBroadcastStreamCanceled',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'wasBroadcastStreamCanceled',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> wasSessionWillCloseListenerCalled(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'wasSessionWillCloseListenerCalled',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'wasSessionWillCloseListenerCalled',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<int> intStreamFromValue(
    _ist.TestSessionBuilder sessionBuilder,
    int value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'intStreamFromValue',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'intStreamFromValue',
              arguments: {'value': value},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> intEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'intEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
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

  _ida.Stream<dynamic> dynamicEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<dynamic> stream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<dynamic>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'dynamicEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'dynamicEchoStream',
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

  _ida.Stream<int?> nullableIntEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int?> stream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'nullableIntEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'nullableIntEchoStream',
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

  _ida.Future<void> voidReturnAfterStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'voidReturnAfterStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'voidReturnAfterStream',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<int> multipleIntEchoStreams(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream1,
    _ida.Stream<int> stream2,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'multipleIntEchoStreams',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'multipleIntEchoStreams',
              arguments: {},
              requestedInputStreams: [
                'stream1',
                'stream2',
              ],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {
            'stream1': stream1,
            'stream2': stream2,
          },
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> directVoidReturnWithStreamInput(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'directVoidReturnWithStreamInput',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'directVoidReturnWithStreamInput',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<int> directOneIntReturnWithStreamInput(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'directOneIntReturnWithStreamInput',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'directOneIntReturnWithStreamInput',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<int> simpleInputReturnStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleInputReturnStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleInputReturnStream',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<int> simpleStreamWithParameter(
    _ist.TestSessionBuilder sessionBuilder,
    int value,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleStreamWithParameter',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleStreamWithParameter',
              arguments: {'value': value},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<_i685tvwm.SimpleData> simpleDataStream(
    _ist.TestSessionBuilder sessionBuilder,
    int value,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_i685tvwm.SimpleData>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleDataStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleDataStream',
              arguments: {'value': value},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<_i685tvwm.SimpleData> simpleInOutDataStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<_i685tvwm.SimpleData> simpleDataStream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_i685tvwm.SimpleData>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleInOutDataStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleInOutDataStream',
              arguments: {},
              requestedInputStreams: ['simpleDataStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataStream': simpleDataStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<List<int>> simpleListInOutIntStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<List<int>> simpleDataListStream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<List<int>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleListInOutIntStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleListInOutIntStream',
              arguments: {},
              requestedInputStreams: ['simpleDataListStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataListStream': simpleDataListStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<List<_i685tvwm.SimpleData>> simpleListInOutDataStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<List<_i685tvwm.SimpleData>> simpleDataListStream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<List<_i685tvwm.SimpleData>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleListInOutDataStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleListInOutDataStream',
              arguments: {},
              requestedInputStreams: ['simpleDataListStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataListStream': simpleDataListStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<List<_i1n3uhu0.UserInfo>> simpleListInOutOtherModuleTypeStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<List<_i1n3uhu0.UserInfo>> userInfoListStream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<List<_i1n3uhu0.UserInfo>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleListInOutOtherModuleTypeStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleListInOutOtherModuleTypeStream',
              arguments: {},
              requestedInputStreams: ['userInfoListStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'userInfoListStream': userInfoListStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<List<_i685tvwm.SimpleData>?>
  simpleNullableListInOutNullableDataStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<List<_i685tvwm.SimpleData>?> simpleDataListStream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<List<_i685tvwm.SimpleData>?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleNullableListInOutNullableDataStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleNullableListInOutNullableDataStream',
              arguments: {},
              requestedInputStreams: ['simpleDataListStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataListStream': simpleDataListStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<List<_i685tvwm.SimpleData?>> simpleListInOutNullableDataStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<List<_i685tvwm.SimpleData?>> simpleDataListStream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<List<_i685tvwm.SimpleData?>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleListInOutNullableDataStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleListInOutNullableDataStream',
              arguments: {},
              requestedInputStreams: ['simpleDataListStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataListStream': simpleDataListStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<Set<int>> simpleSetInOutIntStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<Set<int>> simpleDataSetStream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<Set<int>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleSetInOutIntStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleSetInOutIntStream',
              arguments: {},
              requestedInputStreams: ['simpleDataSetStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataSetStream': simpleDataSetStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<Set<_i685tvwm.SimpleData>> simpleSetInOutDataStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<Set<_i685tvwm.SimpleData>> simpleDataSetStream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<Set<_i685tvwm.SimpleData>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'simpleSetInOutDataStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'simpleSetInOutDataStream',
              arguments: {},
              requestedInputStreams: ['simpleDataSetStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataSetStream': simpleDataSetStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<Set<_i685tvwm.SimpleData>> nestedSetInListInOutDataStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<List<Set<_i685tvwm.SimpleData>>> simpleDataSetStream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<Set<_i685tvwm.SimpleData>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'nestedSetInListInOutDataStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'nestedSetInListInOutDataStream',
              arguments: {},
              requestedInputStreams: ['simpleDataSetStream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDataSetStream': simpleDataSetStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> simpleEndpoint(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'simpleEndpoint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'simpleEndpoint',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> intParameter(
    _ist.TestSessionBuilder sessionBuilder,
    int value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'intParameter',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'intParameter',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> doubleInputValue(
    _ist.TestSessionBuilder sessionBuilder,
    int value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'doubleInputValue',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'doubleInputValue',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> delayedResponse(
    _ist.TestSessionBuilder sessionBuilder,
    int delay,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'delayedResponse',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'delayedResponse',
          parameters: _ist.testObjectToJson({'delay': delay}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<int> delayedStreamResponse(
    _ist.TestSessionBuilder sessionBuilder,
    int delay,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'delayedStreamResponse',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'delayedStreamResponse',
              arguments: {'delay': delay},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> delayedNeverListenedInputStream(
    _ist.TestSessionBuilder sessionBuilder,
    int delay,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'delayedNeverListenedInputStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'delayedNeverListenedInputStream',
              arguments: {'delay': delay},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<void> delayedPausedInputStream(
    _ist.TestSessionBuilder sessionBuilder,
    int delay,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'delayedPausedInputStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'delayedPausedInputStream',
              arguments: {'delay': delay},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<void> completeAllDelayedResponses(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'methodStreaming',
            method: 'completeAllDelayedResponses',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'methodStreaming',
          methodName: 'completeAllDelayedResponses',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> inStreamThrowsException(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'inStreamThrowsException',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'inStreamThrowsException',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<void> inStreamThrowsSerializableException(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'inStreamThrowsSerializableException',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'inStreamThrowsSerializableException',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<int> outStreamThrowsException(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'outStreamThrowsException',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'outStreamThrowsException',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> outStreamThrowsSerializableException(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'outStreamThrowsSerializableException',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'outStreamThrowsSerializableException',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> throwsExceptionVoid(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'throwsExceptionVoid',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'throwsExceptionVoid',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<void> throwsSerializableExceptionVoid(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<void>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'throwsSerializableExceptionVoid',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'throwsSerializableExceptionVoid',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<int> throwsException(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'throwsException',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'throwsException',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<int> throwsSerializableException(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'throwsSerializableException',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'throwsSerializableException',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<int> throwsExceptionStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'throwsExceptionStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'throwsExceptionStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> exceptionThrownBeforeStreamReturn(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'exceptionThrownBeforeStreamReturn',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'exceptionThrownBeforeStreamReturn',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> exceptionThrownInStreamReturn(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'exceptionThrownInStreamReturn',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'exceptionThrownInStreamReturn',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> throwsSerializableExceptionStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'throwsSerializableExceptionStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'throwsSerializableExceptionStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<bool> didInputStreamHaveError(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'didInputStreamHaveError',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'didInputStreamHaveError',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<bool> didInputStreamHaveSerializableExceptionError(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'methodStreaming',
              method: 'didInputStreamHaveSerializableExceptionError',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'methodStreaming',
              methodName: 'didInputStreamHaveSerializableExceptionError',
              arguments: {},
              requestedInputStreams: ['stream'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'stream': stream},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }
}

class _AuthenticatedMethodStreaming {
  _AuthenticatedMethodStreaming(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Stream<int> simpleStream(_ist.TestSessionBuilder sessionBuilder) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'authenticatedMethodStreaming',
              method: 'simpleStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'authenticatedMethodStreaming',
              methodName: 'simpleStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> intEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'authenticatedMethodStreaming',
              method: 'intEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'authenticatedMethodStreaming',
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

class _ModuleEndpointSubclass {
  _ModuleEndpointSubclass(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> echoString(
    _ist.TestSessionBuilder sessionBuilder,
    String value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointSubclass',
            method: 'echoString',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointSubclass',
          methodName: 'echoString',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, BigInt)> echoRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, BigInt) value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointSubclass',
            method: 'echoRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointSubclass',
          methodName: 'echoRecord',
          parameters: _ist.testObjectToJson({
            'value': _igqrxdcj.Protocol().mapRecordToJson(value),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(int, BigInt)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<int>> echoContainer(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int> value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointSubclass',
            method: 'echoContainer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointSubclass',
          methodName: 'echoContainer',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iom2gwyu.ModuleClass> echoModel(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointSubclass',
            method: 'echoModel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointSubclass',
          methodName: 'echoModel',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iom2gwyu.ModuleClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ModuleEndpointAdaptation {
  _ModuleEndpointAdaptation(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> echoString(
    _ist.TestSessionBuilder sessionBuilder,
    String value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointAdaptation',
            method: 'echoString',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointAdaptation',
          methodName: 'echoString',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, BigInt)> echoRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, BigInt) value, [
    int? multiplier,
  ]) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointAdaptation',
            method: 'echoRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointAdaptation',
          methodName: 'echoRecord',
          parameters: _ist.testObjectToJson({
            'value': _igqrxdcj.Protocol().mapRecordToJson(value),
            'multiplier': multiplier,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(int, BigInt)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<int>> echoContainer(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int> value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointAdaptation',
            method: 'echoContainer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointAdaptation',
          methodName: 'echoContainer',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iom2gwyu.ModuleClass> echoModel(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointAdaptation',
            method: 'echoModel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointAdaptation',
          methodName: 'echoModel',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iom2gwyu.ModuleClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ModuleEndpointReduction {
  _ModuleEndpointReduction(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<(int, BigInt)> echoRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, BigInt) value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointReduction',
            method: 'echoRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointReduction',
          methodName: 'echoRecord',
          parameters: _ist.testObjectToJson({
            'value': _igqrxdcj.Protocol().mapRecordToJson(value),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(int, BigInt)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<int>> echoContainer(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int> value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointReduction',
            method: 'echoContainer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointReduction',
          methodName: 'echoContainer',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iom2gwyu.ModuleClass> echoModel(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointReduction',
            method: 'echoModel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointReduction',
          methodName: 'echoModel',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iom2gwyu.ModuleClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ModuleEndpointExtension {
  _ModuleEndpointExtension(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> greet(
    _ist.TestSessionBuilder sessionBuilder,
    String name,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointExtension',
            method: 'greet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointExtension',
          methodName: 'greet',
          parameters: _ist.testObjectToJson({'name': name}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> ignoredMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointExtension',
            method: 'ignoredMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointExtension',
          methodName: 'ignoredMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> echoString(
    _ist.TestSessionBuilder sessionBuilder,
    String value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointExtension',
            method: 'echoString',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointExtension',
          methodName: 'echoString',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, BigInt)> echoRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, BigInt) value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointExtension',
            method: 'echoRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointExtension',
          methodName: 'echoRecord',
          parameters: _ist.testObjectToJson({
            'value': _igqrxdcj.Protocol().mapRecordToJson(value),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(int, BigInt)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<int>> echoContainer(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int> value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointExtension',
            method: 'echoContainer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointExtension',
          methodName: 'echoContainer',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iom2gwyu.ModuleClass> echoModel(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleEndpointExtension',
            method: 'echoModel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleEndpointExtension',
          methodName: 'echoModel',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iom2gwyu.ModuleClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ModuleSerializationEndpoint {
  _ModuleSerializationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> serializeModuleObject(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleSerialization',
            method: 'serializeModuleObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleSerialization',
          methodName: 'serializeModuleObject',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iom2gwyu.ModuleClass> modifyModuleObject(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass object,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleSerialization',
            method: 'modifyModuleObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleSerialization',
          methodName: 'modifyModuleObject',
          parameters: _ist.testObjectToJson({'object': object}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iom2gwyu.ModuleClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iyx9etqn.SharedModuleTable> modifySharedModuleTable(
    _ist.TestSessionBuilder sessionBuilder,
    _iyx9etqn.SharedModuleTable object,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleSerialization',
            method: 'modifySharedModuleTable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleSerialization',
          methodName: 'modifySharedModuleTable',
          parameters: _ist.testObjectToJson({'object': object}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iyx9etqn.SharedModuleTable>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idarivwd.ModuleDatatype> serializeNestedModuleObject(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'moduleSerialization',
            method: 'serializeNestedModuleObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'moduleSerialization',
          methodName: 'serializeNestedModuleObject',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idarivwd.ModuleDatatype>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _NamedParametersEndpoint {
  _NamedParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> namedParametersMethod(
    _ist.TestSessionBuilder sessionBuilder, {
    required int namedInt,
    required int intWithDefaultValue,
    int? nullableInt,
    int? nullableIntWithDefaultValue,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'namedParameters',
            method: 'namedParametersMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'namedParameters',
          methodName: 'namedParametersMethod',
          parameters: _ist.testObjectToJson({
            'namedInt': namedInt,
            'intWithDefaultValue': intWithDefaultValue,
            'nullableInt': nullableInt,
            'nullableIntWithDefaultValue': nullableIntWithDefaultValue,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> namedParametersMethodEqualInts(
    _ist.TestSessionBuilder sessionBuilder, {
    required int namedInt,
    int? nullableInt,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'namedParameters',
            method: 'namedParametersMethodEqualInts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'namedParameters',
          methodName: 'namedParametersMethodEqualInts',
          parameters: _ist.testObjectToJson({
            'namedInt': namedInt,
            'nullableInt': nullableInt,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _OptionalParametersEndpoint {
  _OptionalParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<int?> returnOptionalInt(
    _ist.TestSessionBuilder sessionBuilder, [
    int? optionalInt,
  ]) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'optionalParameters',
            method: 'returnOptionalInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'optionalParameters',
          methodName: 'returnOptionalInt',
          parameters: _ist.testObjectToJson({'optionalInt': optionalInt}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _InheritancePolymorphismTestEndpoint {
  _InheritancePolymorphismTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<(String, _ieub4zqi.PolymorphicParent)> polymorphicRoundtrip(
    _ist.TestSessionBuilder sessionBuilder,
    _ieub4zqi.PolymorphicParent parent,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'inheritancePolymorphismTest',
            method: 'polymorphicRoundtrip',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'inheritancePolymorphismTest',
          methodName: 'polymorphicRoundtrip',
          parameters: _ist.testObjectToJson({'parent': parent}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(String, _ieub4zqi.PolymorphicParent)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<(String, _ieub4zqi.PolymorphicParent)>
  polymorphicStreamingRoundtrip(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<_ieub4zqi.PolymorphicParent> stream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<(String, _ieub4zqi.PolymorphicParent)>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'inheritancePolymorphismTest',
              method: 'polymorphicStreamingRoundtrip',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'inheritancePolymorphismTest',
              methodName: 'polymorphicStreamingRoundtrip',
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

  _ida.Future<_ioyh3y7j.PolymorphicChildContainer>
  polymorphicContainerRoundtrip(
    _ist.TestSessionBuilder sessionBuilder,
    _ioyh3y7j.PolymorphicChildContainer container,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'inheritancePolymorphismTest',
            method: 'polymorphicContainerRoundtrip',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'inheritancePolymorphismTest',
          methodName: 'polymorphicContainerRoundtrip',
          parameters: _ist.testObjectToJson({'container': container}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ioyh3y7j.PolymorphicChildContainer>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ij2aep0j.ModulePolymorphicChildContainer>
  polymorphicModuleContainerRoundtrip(
    _ist.TestSessionBuilder sessionBuilder,
    _ij2aep0j.ModulePolymorphicChildContainer container,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'inheritancePolymorphismTest',
            method: 'polymorphicModuleContainerRoundtrip',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'inheritancePolymorphismTest',
          methodName: 'polymorphicModuleContainerRoundtrip',
          parameters: _ist.testObjectToJson({'container': container}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ij2aep0j.ModulePolymorphicChildContainer>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _RecordParametersEndpoint {
  _RecordParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<(int,)> returnRecordOfInt(
    _ist.TestSessionBuilder sessionBuilder,
    (int,) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnRecordOfInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnRecordOfInt',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then((record) => _igqrxdcj.Protocol().deserialize<(int,)>(record));
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int,)?> returnNullableRecordOfInt(
    _ist.TestSessionBuilder sessionBuilder,
    (int,)? record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNullableRecordOfInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNullableRecordOfInt',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol().deserialize<(int,)?>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int?,)> returnRecordOfNullableInt(
    _ist.TestSessionBuilder sessionBuilder,
    (int?,) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnRecordOfNullableInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnRecordOfNullableInt',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol().deserialize<(int?,)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int?,)?> returnNullableRecordOfNullableInt(
    _ist.TestSessionBuilder sessionBuilder,
    (int?,)? record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNullableRecordOfNullableInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNullableRecordOfNullableInt',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol().deserialize<(int?,)?>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<(int?,)?> streamNullableRecordOfNullableInt(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<(int?,)?> values,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<(int?,)?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'recordParameters',
              method: 'streamNullableRecordOfNullableInt',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'recordParameters',
              methodName: 'streamNullableRecordOfNullableInt',
              arguments: {},
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<(int, String)> returnIntStringRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, String) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnIntStringRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnIntStringRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(int, String)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, String)?> returnNullableIntStringRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, String)? record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNullableIntStringRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNullableIntStringRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(int, String)?>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, _i685tvwm.SimpleData)> returnIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, _i685tvwm.SimpleData) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(int, _i685tvwm.SimpleData)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, _i685tvwm.SimpleData)?> returnNullableIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (int, _i685tvwm.SimpleData)? record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNullableIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNullableIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(int, _i685tvwm.SimpleData)?>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(Map<String, int>,)> returnStringKeyedMapRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (Map<String, int>,) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnStringKeyedMapRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnStringKeyedMapRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(Map<String, int>,)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(Map<int, int>,)> returnNonStringKeyedMapRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (Map<int, int>,) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNonStringKeyedMapRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNonStringKeyedMapRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(Map<int, int>,)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(Set<(int,)>,)> returnSetWithNestedRecordRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (Set<(int,)>,) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnSetWithNestedRecordRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnSetWithNestedRecordRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<(Set<(int,)>,)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({int number, String text})> returnNamedIntStringRecord(
    _ist.TestSessionBuilder sessionBuilder,
    ({int number, String text}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNamedIntStringRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNamedIntStringRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<({int number, String text})>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({int number, String text})?> returnNamedNullableIntStringRecord(
    _ist.TestSessionBuilder sessionBuilder,
    ({int number, String text})? record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNamedNullableIntStringRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNamedNullableIntStringRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<({int number, String text})?>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({_i685tvwm.SimpleData data, int number})>
  returnRecordOfNamedIntAndObject(
    _ist.TestSessionBuilder sessionBuilder,
    ({_i685tvwm.SimpleData data, int number}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnRecordOfNamedIntAndObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnRecordOfNamedIntAndObject',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<({_i685tvwm.SimpleData data, int number})>(
                    record,
                  ),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({_i685tvwm.SimpleData data, int number})?>
  returnNullableRecordOfNamedIntAndObject(
    _ist.TestSessionBuilder sessionBuilder,
    ({_i685tvwm.SimpleData data, int number})? record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNullableRecordOfNamedIntAndObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNullableRecordOfNamedIntAndObject',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<({_i685tvwm.SimpleData data, int number})?>(
                    record,
                  ),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({_i685tvwm.SimpleData? data, int? number})>
  returnRecordOfNamedNullableIntAndNullableObject(
    _ist.TestSessionBuilder sessionBuilder,
    ({_i685tvwm.SimpleData? data, int? number}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnRecordOfNamedNullableIntAndNullableObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnRecordOfNamedNullableIntAndNullableObject',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<({_i685tvwm.SimpleData? data, int? number})>(
                    record,
                  ),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({Map<int, int> intIntMap})> returnNamedNonStringKeyedMapRecord(
    _ist.TestSessionBuilder sessionBuilder,
    ({Map<int, int> intIntMap}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNamedNonStringKeyedMapRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNamedNonStringKeyedMapRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<({Map<int, int> intIntMap})>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({Set<(bool,)> boolSet})> returnNamedSetWithNestedRecordRecord(
    _ist.TestSessionBuilder sessionBuilder,
    ({Set<(bool,)> boolSet}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNamedSetWithNestedRecordRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNamedSetWithNestedRecordRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<({Set<(bool,)> boolSet})>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(Map<(Map<int, String>, String), String>,)>
  returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (Map<(Map<int, String>, String), String>,) map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method:
                'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName:
              'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapRecordToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(Map<(Map<int, String>, String), String>,)>(
                    record,
                  ),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, {_i685tvwm.SimpleData data})> returnRecordTypedef(
    _ist.TestSessionBuilder sessionBuilder,
    (int, {_i685tvwm.SimpleData data}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnRecordTypedef',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnRecordTypedef',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(int, {_i685tvwm.SimpleData data})>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, {_i685tvwm.SimpleData data})?> returnNullableRecordTypedef(
    _ist.TestSessionBuilder sessionBuilder,
    (int, {_i685tvwm.SimpleData data})? record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNullableRecordTypedef',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNullableRecordTypedef',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(int, {_i685tvwm.SimpleData data})?>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<(int, _i685tvwm.SimpleData)>>
  returnListOfIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    List<(int, _i685tvwm.SimpleData)> recordList,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnListOfIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnListOfIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'recordList': _igqrxdcj.Protocol().mapContainerToJson(recordList),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<List<(int, _i685tvwm.SimpleData)>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<(int, _i685tvwm.SimpleData)?>>
  returnListOfNullableIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    List<(int, _i685tvwm.SimpleData)?> record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnListOfNullableIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnListOfNullableIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapContainerToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<List<(int, _i685tvwm.SimpleData)?>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<(int, _i685tvwm.SimpleData)>> returnSetOfIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    Set<(int, _i685tvwm.SimpleData)> recordSet,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnSetOfIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnSetOfIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'recordSet': _igqrxdcj.Protocol().mapContainerToJson(recordSet),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Set<(int, _i685tvwm.SimpleData)>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<(int, _i685tvwm.SimpleData)?>>
  returnSetOfNullableIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    Set<(int, _i685tvwm.SimpleData)?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnSetOfNullableIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnSetOfNullableIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'set': _igqrxdcj.Protocol().mapContainerToJson(set),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Set<(int, _i685tvwm.SimpleData)?>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<(int, _i685tvwm.SimpleData)>?>
  returnNullableSetOfIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    Set<(int, _i685tvwm.SimpleData)>? recordSet,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNullableSetOfIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNullableSetOfIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'recordSet': recordSet == null
                ? null
                : _igqrxdcj.Protocol().mapContainerToJson(recordSet),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Set<(int, _i685tvwm.SimpleData)>?>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, (int, _i685tvwm.SimpleData)>>
  returnStringMapOfIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, (int, _i685tvwm.SimpleData)> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnStringMapOfIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnStringMapOfIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Map<String, (int, _i685tvwm.SimpleData)>>(
                    record,
                  ),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, (int, _i685tvwm.SimpleData)?>>
  returnStringMapOfNullableIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    Map<String, (int, _i685tvwm.SimpleData)?> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnStringMapOfNullableIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnStringMapOfNullableIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Map<String, (int, _i685tvwm.SimpleData)?>>(
                    record,
                  ),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<(String, int), (int, _i685tvwm.SimpleData)>>
  returnRecordMapOfIntSimpleDataRecord(
    _ist.TestSessionBuilder sessionBuilder,
    Map<(String, int), (int, _i685tvwm.SimpleData)> map,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnRecordMapOfIntSimpleDataRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnRecordMapOfIntSimpleDataRecord',
          parameters: _ist.testObjectToJson({
            'map': _igqrxdcj.Protocol().mapContainerToJson(map),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Map<(String, int), (int, _i685tvwm.SimpleData)>>(
                    record,
                  ),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Map<String, List<Set<(int,)>>>> returnStringMapOfListOfRecord(
    _ist.TestSessionBuilder sessionBuilder,
    Set<List<Map<String, (int,)>>> input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnStringMapOfListOfRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnStringMapOfListOfRecord',
          parameters: _ist.testObjectToJson({
            'input': _igqrxdcj.Protocol().mapContainerToJson(input),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<Map<String, List<Set<(int,)>>>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({(_i685tvwm.SimpleData, double) namedSubRecord})>
  returnNestedNamedRecord(
    _ist.TestSessionBuilder sessionBuilder,
    ({(_i685tvwm.SimpleData, double) namedSubRecord}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNestedNamedRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNestedNamedRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<
                    ({(_i685tvwm.SimpleData, double) namedSubRecord})
                  >(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<({(_i685tvwm.SimpleData, double)? namedSubRecord})>
  returnNestedNullableNamedRecord(
    _ist.TestSessionBuilder sessionBuilder,
    ({(_i685tvwm.SimpleData, double)? namedSubRecord}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNestedNullableNamedRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNestedNullableNamedRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<
                    ({(_i685tvwm.SimpleData, double)? namedSubRecord})
                  >(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})>
  returnNestedPositionalAndNamedRecord(
    _ist.TestSessionBuilder sessionBuilder,
    ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord}) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnNestedPositionalAndNamedRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnNestedPositionalAndNamedRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<
                    (
                      (int, String), {
                      (_i685tvwm.SimpleData, double) namedSubRecord,
                    })
                  >(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<
    List<((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})>
  >
  returnListOfNestedPositionalAndNamedRecord(
    _ist.TestSessionBuilder sessionBuilder,
    List<((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})>
    recordList,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'returnListOfNestedPositionalAndNamedRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'returnListOfNestedPositionalAndNamedRecord',
          parameters: _ist.testObjectToJson({
            'recordList': _igqrxdcj.Protocol().mapContainerToJson(recordList),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) =>
                  _igqrxdcj.Protocol().deserialize<
                    List<
                      (
                        (int, String), {
                        (_i685tvwm.SimpleData, double) namedSubRecord,
                      })
                    >
                  >(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<
    List<((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?>?
  >
  streamNullableListOfNullableNestedPositionalAndNamedRecord(
    _ist.TestSessionBuilder sessionBuilder,
    List<((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?>?
    initialValue,
    _ida.Stream<
      List<((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?>?
    >
    values,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<
          List<
            ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
          >?
        >();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'recordParameters',
              method:
                  'streamNullableListOfNullableNestedPositionalAndNamedRecord',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'recordParameters',
              methodName:
                  'streamNullableListOfNullableNestedPositionalAndNamedRecord',
              arguments: {
                'initialValue': initialValue == null
                    ? null
                    : _idc.jsonDecode(
                        _is.SerializationManager.encode(
                          _igqrxdcj.Protocol().mapContainerToJson(initialValue),
                        ),
                      ),
              },
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<_ix95ig49.TypesRecord> echoModelClassWithRecordField(
    _ist.TestSessionBuilder sessionBuilder,
    _ix95ig49.TypesRecord value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'echoModelClassWithRecordField',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'echoModelClassWithRecordField',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ix95ig49.TypesRecord>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ix95ig49.TypesRecord?> echoNullableModelClassWithRecordField(
    _ist.TestSessionBuilder sessionBuilder,
    _ix95ig49.TypesRecord? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'echoNullableModelClassWithRecordField',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'echoNullableModelClassWithRecordField',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ix95ig49.TypesRecord?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iom2gwyu.ModuleClass?>
  echoNullableModelClassWithRecordFieldFromExternalModule(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass? value,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'echoNullableModelClassWithRecordFieldFromExternalModule',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'echoNullableModelClassWithRecordFieldFromExternalModule',
          parameters: _ist.testObjectToJson({'value': value}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iom2gwyu.ModuleClass?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<_ix95ig49.TypesRecord> streamOfModelClassWithRecordField(
    _ist.TestSessionBuilder sessionBuilder,
    _ix95ig49.TypesRecord initialValue,
    _ida.Stream<_ix95ig49.TypesRecord> values,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_ix95ig49.TypesRecord>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'recordParameters',
              method: 'streamOfModelClassWithRecordField',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'recordParameters',
              methodName: 'streamOfModelClassWithRecordField',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(initialValue),
                ),
              },
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<_ix95ig49.TypesRecord?> streamOfNullableModelClassWithRecordField(
    _ist.TestSessionBuilder sessionBuilder,
    _ix95ig49.TypesRecord? initialValue,
    _ida.Stream<_ix95ig49.TypesRecord?> values,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_ix95ig49.TypesRecord?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'recordParameters',
              method: 'streamOfNullableModelClassWithRecordField',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'recordParameters',
              methodName: 'streamOfNullableModelClassWithRecordField',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(initialValue),
                ),
              },
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<_iom2gwyu.ModuleClass?>
  streamOfNullableModelClassWithRecordFieldFromExternalModule(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass? initialValue,
    _ida.Stream<_iom2gwyu.ModuleClass?> values,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_iom2gwyu.ModuleClass?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'recordParameters',
              method:
                  'streamOfNullableModelClassWithRecordFieldFromExternalModule',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'recordParameters',
              methodName:
                  'streamOfNullableModelClassWithRecordFieldFromExternalModule',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(initialValue),
                ),
              },
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<(int?, _iom2gwyu.ProjectStreamingClass?)>
  streamOfNullableIntAndModuleClass(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<(int?, _iom2gwyu.ProjectStreamingClass?)> values,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<(int?, _iom2gwyu.ProjectStreamingClass?)>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'recordParameters',
              method: 'streamOfNullableIntAndModuleClass',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'recordParameters',
              methodName: 'streamOfNullableIntAndModuleClass',
              arguments: {},
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<int> recordParametersWithCustomNames(
    _ist.TestSessionBuilder sessionBuilder,
    (int,) positionalRecord, {
    required (int,) namedRecord,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recordParameters',
            method: 'recordParametersWithCustomNames',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recordParameters',
          methodName: 'recordParametersWithCustomNames',
          parameters: _ist.testObjectToJson({
            'positionalRecord': _igqrxdcj.Protocol().mapRecordToJson(
              positionalRecord,
            ),
            'namedRecord': _igqrxdcj.Protocol().mapRecordToJson(namedRecord),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _RedisEndpoint {
  _RedisEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> setSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
    _i685tvwm.SimpleData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'setSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'setSimpleData',
          parameters: _ist.testObjectToJson({
            'key': key,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> setSimpleDataWithLifetime(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
    _i685tvwm.SimpleData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'setSimpleDataWithLifetime',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'setSimpleDataWithLifetime',
          parameters: _ist.testObjectToJson({
            'key': key,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData?> getSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'getSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'getSimpleData',
          parameters: _ist.testObjectToJson({'key': key}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> deleteSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'deleteSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'deleteSimpleData',
          parameters: _ist.testObjectToJson({'key': key}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> resetMessageCentralTest(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'resetMessageCentralTest',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'resetMessageCentralTest',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData?> listenToChannel(
    _ist.TestSessionBuilder sessionBuilder,
    String channel,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'listenToChannel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'listenToChannel',
          parameters: _ist.testObjectToJson({'channel': channel}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> postToChannel(
    _ist.TestSessionBuilder sessionBuilder,
    String channel,
    _i685tvwm.SimpleData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'postToChannel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'postToChannel',
          parameters: _ist.testObjectToJson({
            'channel': channel,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> countSubscribedChannels(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'redis',
            method: 'countSubscribedChannels',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'redis',
          methodName: 'countSubscribedChannels',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ServerOnlyScopedFieldModelEndpoint {
  _ServerOnlyScopedFieldModelEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iyi8ilhb.ScopeServerOnlyField> getScopeServerOnlyField(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'serverOnlyScopedFieldModel',
            method: 'getScopeServerOnlyField',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'serverOnlyScopedFieldModel',
          methodName: 'getScopeServerOnlyField',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iyi8ilhb.ScopeServerOnlyField>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ServerOnlyScopedFieldChildModelEndpoint {
  _ServerOnlyScopedFieldChildModelEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_i02xdnoq.ScopeServerOnlyFieldChild> getProtocolField(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'serverOnlyScopedFieldChildModel',
            method: 'getProtocolField',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'serverOnlyScopedFieldChildModel',
          methodName: 'getProtocolField',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i02xdnoq.ScopeServerOnlyFieldChild>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SessionAuthenticationEndpoint {
  _SessionAuthenticationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String?> getAuthenticatedUserId(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'sessionAuthentication',
            method: 'getAuthenticatedUserId',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'sessionAuthentication',
          methodName: 'getAuthenticatedUserId',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String>> getAuthenticatedScopes(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'sessionAuthentication',
            method: 'getAuthenticatedScopes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'sessionAuthentication',
          methodName: 'getAuthenticatedScopes',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String?> getAuthenticatedAuthId(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'sessionAuthentication',
            method: 'getAuthenticatedAuthId',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'sessionAuthentication',
          methodName: 'getAuthenticatedAuthId',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i5vgvlyt.SessionAuthInfo> getAuthenticationInfo(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'sessionAuthentication',
            method: 'getAuthenticationInfo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'sessionAuthentication',
          methodName: 'getAuthenticationInfo',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i5vgvlyt.SessionAuthInfo>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> isAuthenticated(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'sessionAuthentication',
            method: 'isAuthenticated',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'sessionAuthentication',
          methodName: 'isAuthenticated',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<String?> streamAuthenticatedUserId(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<String?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'sessionAuthentication',
              method: 'streamAuthenticatedUserId',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'sessionAuthentication',
              methodName: 'streamAuthenticatedUserId',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<bool> streamIsAuthenticated(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'sessionAuthentication',
              method: 'streamIsAuthenticated',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'sessionAuthentication',
              methodName: 'streamIsAuthenticated',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _SetParametersEndpoint {
  _SetParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<Set<int>> returnIntSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnIntSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnIntSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<Set<int>>> returnIntSetSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<Set<int>> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnIntSetSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnIntSetSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<Set<int>>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<List<int>>> returnIntListSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<List<int>> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnIntListSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnIntListSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<List<int>>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<int>?> returnIntSetNullable(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int>? set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnIntSetNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnIntSetNullable',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<Set<int>?>> returnIntSetNullableSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<Set<int>?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnIntSetNullableSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnIntSetNullableSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<Set<int>?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<Set<int>>?> returnIntSetSetNullable(
    _ist.TestSessionBuilder sessionBuilder,
    Set<Set<int>>? set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnIntSetSetNullable',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnIntSetSetNullable',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<Set<int>>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<int?>> returnIntSetNullableInts(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnIntSetNullableInts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnIntSetNullableInts',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<int?>?> returnNullableIntSetNullableInts(
    _ist.TestSessionBuilder sessionBuilder,
    Set<int?>? set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnNullableIntSetNullableInts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnNullableIntSetNullableInts',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<int?>?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<double>> returnDoubleSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<double> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnDoubleSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnDoubleSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<double>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<double?>> returnDoubleSetNullableDoubles(
    _ist.TestSessionBuilder sessionBuilder,
    Set<double?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnDoubleSetNullableDoubles',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnDoubleSetNullableDoubles',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<double?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<bool>> returnBoolSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<bool> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnBoolSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnBoolSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<bool>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<bool?>> returnBoolSetNullableBools(
    _ist.TestSessionBuilder sessionBuilder,
    Set<bool?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnBoolSetNullableBools',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnBoolSetNullableBools',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<bool?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<String>> returnStringSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<String> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnStringSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnStringSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<String>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<String?>> returnStringSetNullableStrings(
    _ist.TestSessionBuilder sessionBuilder,
    Set<String?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnStringSetNullableStrings',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnStringSetNullableStrings',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<String?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<DateTime>> returnDateTimeSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<DateTime> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnDateTimeSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnDateTimeSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<DateTime>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<DateTime?>> returnDateTimeSetNullableDateTimes(
    _ist.TestSessionBuilder sessionBuilder,
    Set<DateTime?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnDateTimeSetNullableDateTimes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnDateTimeSetNullableDateTimes',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<DateTime?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<_idt.ByteData>> returnByteDataSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<_idt.ByteData> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnByteDataSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnByteDataSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<_idt.ByteData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<_idt.ByteData?>> returnByteDataSetNullableByteDatas(
    _ist.TestSessionBuilder sessionBuilder,
    Set<_idt.ByteData?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnByteDataSetNullableByteDatas',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnByteDataSetNullableByteDatas',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<_idt.ByteData?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<_i685tvwm.SimpleData>> returnSimpleDataSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<_i685tvwm.SimpleData> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnSimpleDataSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnSimpleDataSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<_i685tvwm.SimpleData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<_i685tvwm.SimpleData?>> returnSimpleDataSetNullableSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    Set<_i685tvwm.SimpleData?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnSimpleDataSetNullableSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnSimpleDataSetNullableSimpleData',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<_i685tvwm.SimpleData?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<Duration>> returnDurationSet(
    _ist.TestSessionBuilder sessionBuilder,
    Set<Duration> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnDurationSet',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnDurationSet',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<Duration>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<Set<Duration?>> returnDurationSetNullableDurations(
    _ist.TestSessionBuilder sessionBuilder,
    Set<Duration?> set,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'setParameters',
            method: 'returnDurationSetNullableDurations',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'setParameters',
          methodName: 'returnDurationSetNullableDurations',
          parameters: _ist.testObjectToJson({'set': set}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<Set<Duration?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SignInRequiredEndpoint {
  _SignInRequiredEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> testMethod(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'signInRequired',
            method: 'testMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'signInRequired',
          methodName: 'testMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AdminScopeRequiredEndpoint {
  _AdminScopeRequiredEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> testMethod(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'adminScopeRequired',
            method: 'testMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'adminScopeRequired',
          methodName: 'testMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SimpleEndpoint {
  _SimpleEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> setGlobalInt(
    _ist.TestSessionBuilder sessionBuilder,
    int? value, [
    int? secondValue,
  ]) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simple',
            method: 'setGlobalInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simple',
          methodName: 'setGlobalInt',
          parameters: _ist.testObjectToJson({
            'value': value,
            'secondValue': secondValue,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> addToGlobalInt(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simple',
            method: 'addToGlobalInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simple',
          methodName: 'addToGlobalInt',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> getGlobalInt(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simple',
            method: 'getGlobalInt',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simple',
          methodName: 'getGlobalInt',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> hello(
    _ist.TestSessionBuilder sessionBuilder,
    String name,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simple',
            method: 'hello',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simple',
          methodName: 'hello',
          parameters: _ist.testObjectToJson({'name': name}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SubSubDirTestEndpoint {
  _SubSubDirTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> testMethod(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'subSubDirTest',
            method: 'testMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subSubDirTest',
          methodName: 'testMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SubDirTestEndpoint {
  _SubDirTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> testMethod(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'subDirTest',
            method: 'testMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subDirTest',
          methodName: 'testMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _TestToolsEndpoint {
  _TestToolsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_is.UuidValue> returnsSessionId(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'returnsSessionId',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'returnsSessionId',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_is.UuidValue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<String?>> returnsSessionEndpointAndMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'returnsSessionEndpointAndMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'returnsSessionEndpointAndMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<String?>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<_is.UuidValue> returnsSessionIdFromStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<_is.UuidValue>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'returnsSessionIdFromStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'returnsSessionIdFromStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<String?> returnsSessionEndpointAndMethodFromStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<String?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'returnsSessionEndpointAndMethodFromStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'returnsSessionEndpointAndMethodFromStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<String> returnsString(
    _ist.TestSessionBuilder sessionBuilder,
    String string,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'returnsString',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'returnsString',
          parameters: _ist.testObjectToJson({'string': string}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<int> returnsStream(
    _ist.TestSessionBuilder sessionBuilder,
    int n,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'returnsStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'returnsStream',
              arguments: {'n': n},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<List<int>> returnsListFromInputStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> numbers,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<List<int>>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'returnsListFromInputStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'returnsListFromInputStream',
              arguments: {},
              requestedInputStreams: ['numbers'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'numbers': numbers},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Future<List<_i685tvwm.SimpleData>> returnsSimpleDataListFromInputStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<_i685tvwm.SimpleData> simpleDatas,
  ) async {
    var _localTestStreamManager =
        _ist.TestStreamManager<List<_i685tvwm.SimpleData>>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'returnsSimpleDataListFromInputStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'returnsSimpleDataListFromInputStream',
              arguments: {},
              requestedInputStreams: ['simpleDatas'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDatas': simpleDatas},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<int> returnsStreamFromInputStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> numbers,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'returnsStreamFromInputStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'returnsStreamFromInputStream',
              arguments: {},
              requestedInputStreams: ['numbers'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'numbers': numbers},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<_i685tvwm.SimpleData> returnsSimpleDataStreamFromInputStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<_i685tvwm.SimpleData> simpleDatas,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_i685tvwm.SimpleData>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'returnsSimpleDataStreamFromInputStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'returnsSimpleDataStreamFromInputStream',
              arguments: {},
              requestedInputStreams: ['simpleDatas'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'simpleDatas': simpleDatas},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> postNumberToSharedStream(
    _ist.TestSessionBuilder sessionBuilder,
    int number,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'postNumberToSharedStream',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'postNumberToSharedStream',
          parameters: _ist.testObjectToJson({'number': number}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<int> postNumberToSharedStreamAndReturnStream(
    _ist.TestSessionBuilder sessionBuilder,
    int number,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'postNumberToSharedStreamAndReturnStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'postNumberToSharedStreamAndReturnStream',
              arguments: {'number': number},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Stream<int> listenForNumbersOnSharedStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'listenForNumbersOnSharedStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'listenForNumbersOnSharedStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> createSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    int data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'createSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'createSimpleData',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i685tvwm.SimpleData>> getAllSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'getAllSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'getAllSimpleData',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i685tvwm.SimpleData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> createSimpleDatasInsideTransactions(
    _ist.TestSessionBuilder sessionBuilder,
    int data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'createSimpleDatasInsideTransactions',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'createSimpleDatasInsideTransactions',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> createSimpleDataAndThrowInsideTransaction(
    _ist.TestSessionBuilder sessionBuilder,
    int data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'createSimpleDataAndThrowInsideTransaction',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'createSimpleDataAndThrowInsideTransaction',
          parameters: _ist.testObjectToJson({'data': data}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> createSimpleDatasInParallelTransactionCalls(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'createSimpleDatasInParallelTransactionCalls',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'createSimpleDatasInParallelTransactionCalls',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<dynamic> echoDynamic(
    _ist.TestSessionBuilder sessionBuilder,
    dynamic anything,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoDynamic',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoDynamic',
          parameters: _ist.testObjectToJson({'anything': anything}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData> echoSimpleData(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData simpleData,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoSimpleData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoSimpleData',
          parameters: _ist.testObjectToJson({'simpleData': simpleData}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i685tvwm.SimpleData>> echoSimpleDatas(
    _ist.TestSessionBuilder sessionBuilder,
    List<_i685tvwm.SimpleData> simpleDatas,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoSimpleDatas',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoSimpleDatas',
          parameters: _ist.testObjectToJson({'simpleDatas': simpleDatas}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i685tvwm.SimpleData>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i9ckso16.ObjectWithDynamic> echoObjectWithDynamic(
    _ist.TestSessionBuilder sessionBuilder,
    _i9ckso16.ObjectWithDynamic objectWithDynamic,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoObjectWithDynamic',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoObjectWithDynamic',
          parameters: _ist.testObjectToJson({
            'objectWithDynamic': objectWithDynamic,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i9ckso16.ObjectWithDynamic>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iuch3ck4.Types> echoTypes(
    _ist.TestSessionBuilder sessionBuilder,
    _iuch3ck4.Types typesModel,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoTypes',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoTypes',
          parameters: _ist.testObjectToJson({'typesModel': typesModel}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iuch3ck4.Types>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iuch3ck4.Types>> echoTypesList(
    _ist.TestSessionBuilder sessionBuilder,
    List<_iuch3ck4.Types> typesList,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoTypesList',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoTypesList',
          parameters: _ist.testObjectToJson({'typesList': typesList}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iuch3ck4.Types>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idarivwd.ModuleDatatype> echoModuleDatatype(
    _ist.TestSessionBuilder sessionBuilder,
    _idarivwd.ModuleDatatype moduleDatatype,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoModuleDatatype',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoModuleDatatype',
          parameters: _ist.testObjectToJson({'moduleDatatype': moduleDatatype}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idarivwd.ModuleDatatype>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<_idarivwd.ModuleDatatype?> streamModuleDatatype(
    _ist.TestSessionBuilder sessionBuilder,
    _idarivwd.ModuleDatatype? initialValue,
    _ida.Stream<_idarivwd.ModuleDatatype?> values,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_idarivwd.ModuleDatatype?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'streamModuleDatatype',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'streamModuleDatatype',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(initialValue),
                ),
              },
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<_iom2gwyu.ModuleClass> echoModuleClass(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass moduleClass,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoModuleClass',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoModuleClass',
          parameters: _ist.testObjectToJson({'moduleClass': moduleClass}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iom2gwyu.ModuleClass>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<_iom2gwyu.ModuleClass?> streamModuleClass(
    _ist.TestSessionBuilder sessionBuilder,
    _iom2gwyu.ModuleClass? initialValue,
    _ida.Stream<_iom2gwyu.ModuleClass?> values,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_iom2gwyu.ModuleClass?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'streamModuleClass',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'streamModuleClass',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(initialValue),
                ),
              },
              requestedInputStreams: ['values'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'values': values},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<(String, (int, bool))> echoRecord(
    _ist.TestSessionBuilder sessionBuilder,
    (String, (int, bool)) record,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoRecord',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoRecord',
          parameters: _ist.testObjectToJson({
            'record': _igqrxdcj.Protocol().mapRecordToJson(record),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(String, (int, bool))>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<(String, (int, bool))>> echoRecords(
    _ist.TestSessionBuilder sessionBuilder,
    List<(String, (int, bool))> records,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'echoRecords',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'echoRecords',
          parameters: _ist.testObjectToJson({
            'records': _igqrxdcj.Protocol().mapContainerToJson(records),
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<List<(String, (int, bool))>>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<(int, _i685tvwm.SimpleData)> returnRecordWithSerializableObject(
    _ist.TestSessionBuilder sessionBuilder,
    int number,
    _i685tvwm.SimpleData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'returnRecordWithSerializableObject',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'returnRecordWithSerializableObject',
          parameters: _ist.testObjectToJson({
            'number': number,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then(
              (record) => _igqrxdcj.Protocol()
                  .deserialize<(int, _i685tvwm.SimpleData)>(record),
            );
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<
    (String, (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}))
  >
  recordEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    (String, (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}))
    initialValue,
    _ida.Stream<
      (String, (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}))
    >
    stream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<
          (
            String,
            (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
          )
        >();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'recordEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'recordEchoStream',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(
                    _igqrxdcj.Protocol().mapRecordToJson(initialValue),
                  ),
                ),
              },
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

  _ida.Stream<List<(String, int)>> listOfRecordEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    List<(String, int)> initialValue,
    _ida.Stream<List<(String, int)>> stream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<List<(String, int)>>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'listOfRecordEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'listOfRecordEchoStream',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(
                    _igqrxdcj.Protocol().mapContainerToJson(initialValue),
                  ),
                ),
              },
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

  _ida.Stream<
    (String, (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}))?
  >
  nullableRecordEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    (String, (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}))?
    initialValue,
    _ida.Stream<
      (
        String,
        (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
      )?
    >
    stream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<
          (
            String,
            (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
          )?
        >();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'nullableRecordEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'nullableRecordEchoStream',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(
                    _igqrxdcj.Protocol().mapRecordToJson(initialValue),
                  ),
                ),
              },
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

  _ida.Stream<List<(String, int)>?> nullableListOfRecordEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    List<(String, int)>? initialValue,
    _ida.Stream<List<(String, int)>?> stream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<List<(String, int)>?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'nullableListOfRecordEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'nullableListOfRecordEchoStream',
              arguments: {
                'initialValue': initialValue == null
                    ? null
                    : _idc.jsonDecode(
                        _is.SerializationManager.encode(
                          _igqrxdcj.Protocol().mapContainerToJson(initialValue),
                        ),
                      ),
              },
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

  _ida.Stream<_ix95ig49.TypesRecord?> modelWithRecordsEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ix95ig49.TypesRecord? initialValue,
    _ida.Stream<_ix95ig49.TypesRecord?> stream,
  ) {
    var _localTestStreamManager =
        _ist.TestStreamManager<_ix95ig49.TypesRecord?>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'modelWithRecordsEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName: 'modelWithRecordsEchoStream',
              arguments: {
                'initialValue': _idc.jsonDecode(
                  _is.SerializationManager.encode(initialValue),
                ),
              },
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

  _ida.Future<void> logMessageWithSession(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'logMessageWithSession',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'logMessageWithSession',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> addWillCloseListenerToSessionAndThrow(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'addWillCloseListenerToSessionAndThrow',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'addWillCloseListenerToSessionAndThrow',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<int> addWillCloseListenerToSessionIntStreamMethodAndThrow(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'testTools',
              method: 'addWillCloseListenerToSessionIntStreamMethodAndThrow',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'testTools',
              methodName:
                  'addWillCloseListenerToSessionIntStreamMethodAndThrow',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<void> putInLocalCache(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
    _i685tvwm.SimpleData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'putInLocalCache',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'putInLocalCache',
          parameters: _ist.testObjectToJson({
            'key': key,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData?> getFromLocalCache(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'getFromLocalCache',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'getFromLocalCache',
          parameters: _ist.testObjectToJson({'key': key}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> putInLocalPrioCache(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
    _i685tvwm.SimpleData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'putInLocalPrioCache',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'putInLocalPrioCache',
          parameters: _ist.testObjectToJson({
            'key': key,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData?> getFromLocalPrioCache(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'getFromLocalPrioCache',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'getFromLocalPrioCache',
          parameters: _ist.testObjectToJson({'key': key}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> putInQueryCache(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
    _i685tvwm.SimpleData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'putInQueryCache',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'putInQueryCache',
          parameters: _ist.testObjectToJson({
            'key': key,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i685tvwm.SimpleData?> getFromQueryCache(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'getFromQueryCache',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'getFromQueryCache',
          parameters: _ist.testObjectToJson({'key': key}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i685tvwm.SimpleData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> putInLocalCacheWithGroup(
    _ist.TestSessionBuilder sessionBuilder,
    String key,
    _i685tvwm.SimpleData data,
    String group,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'testTools',
            method: 'putInLocalCacheWithGroup',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'testTools',
          methodName: 'putInLocalCacheWithGroup',
          parameters: _ist.testObjectToJson({
            'key': key,
            'data': data,
            'group': group,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AuthenticatedTestToolsEndpoint {
  _AuthenticatedTestToolsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> returnsString(
    _ist.TestSessionBuilder sessionBuilder,
    String string,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'authenticatedTestTools',
            method: 'returnsString',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'authenticatedTestTools',
          methodName: 'returnsString',
          parameters: _ist.testObjectToJson({'string': string}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<int> returnsStream(
    _ist.TestSessionBuilder sessionBuilder,
    int n,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'authenticatedTestTools',
              method: 'returnsStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'authenticatedTestTools',
              methodName: 'returnsStream',
              arguments: {'n': n},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<List<int>> returnsListFromInputStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> numbers,
  ) async {
    var _localTestStreamManager = _ist.TestStreamManager<List<int>>();
    return _ist.callAwaitableFunctionWithStreamInputAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'authenticatedTestTools',
              method: 'returnsListFromInputStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'authenticatedTestTools',
              methodName: 'returnsListFromInputStream',
              arguments: {},
              requestedInputStreams: ['numbers'],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {'numbers': numbers},
        );
        return _localTestStreamManager.outputStreamController.stream;
      },
    );
  }

  _ida.Stream<int> intEchoStream(
    _ist.TestSessionBuilder sessionBuilder,
    _ida.Stream<int> stream,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<int>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'authenticatedTestTools',
              method: 'intEchoStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'authenticatedTestTools',
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

class _UnauthenticatedEndpoint {
  _UnauthenticatedEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> unauthenticatedMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'unauthenticated',
            method: 'unauthenticatedMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'unauthenticated',
          methodName: 'unauthenticatedMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<bool> unauthenticatedStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'unauthenticated',
              method: 'unauthenticatedStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'unauthenticated',
              methodName: 'unauthenticatedStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _PartiallyUnauthenticatedEndpoint {
  _PartiallyUnauthenticatedEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> unauthenticatedMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'partiallyUnauthenticated',
            method: 'unauthenticatedMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'partiallyUnauthenticated',
          methodName: 'unauthenticatedMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<bool> unauthenticatedStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'partiallyUnauthenticated',
              method: 'unauthenticatedStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'partiallyUnauthenticated',
              methodName: 'unauthenticatedStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _ida.Future<bool> authenticatedMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'partiallyUnauthenticated',
            method: 'authenticatedMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'partiallyUnauthenticated',
          methodName: 'authenticatedMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<bool> authenticatedStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'partiallyUnauthenticated',
              method: 'authenticatedStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'partiallyUnauthenticated',
              methodName: 'authenticatedStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _UnauthenticatedRequireLoginEndpoint {
  _UnauthenticatedRequireLoginEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> unauthenticatedMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'unauthenticatedRequireLogin',
            method: 'unauthenticatedMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'unauthenticatedRequireLogin',
          methodName: 'unauthenticatedMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<bool> unauthenticatedStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'unauthenticatedRequireLogin',
              method: 'unauthenticatedStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'unauthenticatedRequireLogin',
              methodName: 'unauthenticatedStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _RequireLoginEndpoint {
  _RequireLoginEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> unauthenticatedMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'requireLogin',
            method: 'unauthenticatedMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'requireLogin',
          methodName: 'unauthenticatedMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<bool> unauthenticatedStream(
    _ist.TestSessionBuilder sessionBuilder,
  ) {
    var _localTestStreamManager = _ist.TestStreamManager<bool>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'requireLogin',
              method: 'unauthenticatedStream',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'requireLogin',
              methodName: 'unauthenticatedStream',
              arguments: {},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _UploadEndpoint {
  _UploadEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<bool> uploadByteData(
    _ist.TestSessionBuilder sessionBuilder,
    String path,
    _idt.ByteData data,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'upload',
            method: 'uploadByteData',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'upload',
          methodName: 'uploadByteData',
          parameters: _ist.testObjectToJson({
            'path': path,
            'data': data,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _MyFeatureEndpoint {
  _MyFeatureEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<String> myFeatureMethod(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'myFeature',
            method: 'myFeatureMethod',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'myFeature',
          methodName: 'myFeatureMethod',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iivg8skz.MyFeatureModel> myFeatureModel(
    _ist.TestSessionBuilder sessionBuilder,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'myFeature',
            method: 'myFeatureModel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'myFeature',
          methodName: 'myFeatureModel',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iivg8skz.MyFeatureModel>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _TestCallFutureCall {
  Future<void> run(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData? data,
  ) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestCallRunFutureCall().invoke(
        _localUniqueSession,
        data,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _TestExceptionCallFutureCall {
  Future<void> run(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData? data,
  ) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestExceptionCallRunFutureCall().invoke(
        _localUniqueSession,
        data,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _TestGeneratedCallFutureCall {
  Future<void> hello(
    _ist.TestSessionBuilder sessionBuilder,
    String name,
  ) async {
    var object = _irznr7ew.TestGeneratedCallHelloModel(name: name);
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestGeneratedCallHelloFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }

  Future<void> bye(
    _ist.TestSessionBuilder sessionBuilder,
    String name, {
    int code = 0,
  }) async {
    var object = _i4lt3urh.TestGeneratedCallByeModel(
      name: name,
      code: code,
    );
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestGeneratedCallByeFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }

  Future<void> logData(
    _ist.TestSessionBuilder sessionBuilder,
    _i685tvwm.SimpleData data,
  ) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestGeneratedCallLogDataFutureCall().invoke(
        _localUniqueSession,
        data,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }

  Future<void> doTask(_ist.TestSessionBuilder sessionBuilder) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestGeneratedCallDoTaskFutureCall().invoke(
        _localUniqueSession,
        null,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }

  Future<void> invoke(
    _ist.TestSessionBuilder sessionBuilder,
    String name,
  ) async {
    var object = _i8808sn4.TestGeneratedCallInvokeModel(name: name);
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestGeneratedCallInvokeFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }

  Future<void> executeWithTrigger(
    _ist.TestSessionBuilder sessionBuilder,
    String entityId, {
    required _icum80ls.MyTriggerType triggerType,
  }) async {
    var object = _i1l5bdpk.TestGeneratedCallExecuteWithTriggerModel(
      entityId: entityId,
      triggerType: triggerType,
    );
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i3an2vcw.TestGeneratedCallExecuteWithTriggerFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}
