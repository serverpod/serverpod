/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i4;
import 'dart:typed_data' as _i5;
import 'package:uuid/uuid_value.dart' as _i6;
import 'package:serverpod_test_server/src/protocol_custom_classes.dart' as _i7;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i8;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i9;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i10;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i11;
import 'package:serverpod_test_server/src/generated/simple_data_list.dart'
    as _i12;
import 'package:serverpod_test_server/src/generated/types.dart' as _i13;
import 'package:serverpod_test_server/src/generated/object_with_enum.dart'
    as _i14;
import 'package:serverpod_test_server/src/generated/object_with_object.dart'
    as _i15;
import 'package:serverpod_test_server/src/generated/object_field_scopes.dart'
    as _i16;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i17;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i18;
import 'package:serverpod_test_server/src/generated/module_datatype.dart'
    as _i19;
import 'package:serverpod_test_server/src/generated/scopes/scope_server_only_field.dart'
    as _i20;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test.dart'
    show
        TestSession,
        ConnectionClosedException,
        ServerpodUnauthenticatedException,
        ServerpodInsufficientAccessException,
        RollbackDatabase,
        ResetTestSessions,
        flushMicrotasks,
        AuthenticationOverride;

@_i1.isTestGroup
withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  _i1.ResetTestSessions? resetTestSessions,
  _i1.RollbackDatabase? rollbackDatabase,
  String? runMode,
  bool? enableSessionLogging,
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
    ),
    maybeResetTestSessions: resetTestSessions,
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
  )(testClosure);
}

class TestEndpoints {
  late final _AsyncTasksEndpoint asyncTasks;

  late final _AuthenticationEndpoint authentication;

  late final _BasicTypesEndpoint basicTypes;

  late final _CloudStorageEndpoint cloudStorage;

  late final _S3CloudStorageEndpoint s3CloudStorage;

  late final _CustomClassProtocolEndpoint customClassProtocol;

  late final _CustomTypesEndpoint customTypes;

  late final _BasicDatabase basicDatabase;

  late final _TransactionsDatabaseEndpoint transactionsDatabase;

  late final _DeprecationEndpoint deprecation;

  late final _EchoRequestEndpoint echoRequest;

  late final _EmailAuthTestMethods emailAuthTestMethods;

  late final _ExceptionTestEndpoint exceptionTest;

  late final _FailedCallsEndpoint failedCalls;

  late final _FieldScopesEndpoint fieldScopes;

  late final _FutureCallsEndpoint futureCalls;

  late final _ListParametersEndpoint listParameters;

  late final _LoggingEndpoint logging;

  late final _StreamLogging streamLogging;

  late final _StreamQueryLogging streamQueryLogging;

  late final _LoggingDisabledEndpoint loggingDisabled;

  late final _MapParametersEndpoint mapParameters;

  late final _MethodStreaming methodStreaming;

  late final _AuthenticatedMethodStreaming authenticatedMethodStreaming;

  late final _ModuleSerializationEndpoint moduleSerialization;

  late final _NamedParametersEndpoint namedParameters;

  late final _OptionalParametersEndpoint optionalParameters;

  late final _RedisEndpoint redis;

  late final _ServerOnlyScopedFieldModelEndpoint serverOnlyScopedFieldModel;

  late final _SignInRequiredEndpoint signInRequired;

  late final _AdminScopeRequiredEndpoint adminScopeRequired;

  late final _SimpleEndpoint simple;

  late final _StreamingEndpoint streaming;

  late final _StreamingLoggingEndpoint streamingLogging;

  late final _SubSubDirTestEndpoint subSubDirTest;

  late final _SubDirTestEndpoint subDirTest;

  late final _TestToolsEndpoint testTools;

  late final _AuthenticatedTestToolsEndpoint authenticatedTestTools;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
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
    echoRequest = _EchoRequestEndpoint(
      endpoints,
      serializationManager,
    );
    emailAuthTestMethods = _EmailAuthTestMethods(
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
    futureCalls = _FutureCallsEndpoint(
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
    streamLogging = _StreamLogging(
      endpoints,
      serializationManager,
    );
    streamQueryLogging = _StreamQueryLogging(
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
    methodStreaming = _MethodStreaming(
      endpoints,
      serializationManager,
    );
    authenticatedMethodStreaming = _AuthenticatedMethodStreaming(
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
    redis = _RedisEndpoint(
      endpoints,
      serializationManager,
    );
    serverOnlyScopedFieldModel = _ServerOnlyScopedFieldModelEndpoint(
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
    streaming = _StreamingEndpoint(
      endpoints,
      serializationManager,
    );
    streamingLogging = _StreamingLoggingEndpoint(
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
  }
}

class _AsyncTasksEndpoint {
  _AsyncTasksEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> insertRowToSimpleDataAfterDelay(
    _i1.TestSession session,
    int num,
    int seconds,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'asyncTasks',
        method: 'insertRowToSimpleDataAfterDelay',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'asyncTasks',
        methodName: 'insertRowToSimpleDataAfterDelay',
        parameters: {
          'num': num,
          'seconds': seconds,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> throwExceptionAfterDelay(
    _i1.TestSession session,
    int seconds,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'asyncTasks',
        method: 'throwExceptionAfterDelay',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'asyncTasks',
        methodName: 'throwExceptionAfterDelay',
        parameters: {'seconds': seconds},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }
}

class _AuthenticationEndpoint {
  _AuthenticationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> removeAllUsers(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'authentication',
        method: 'removeAllUsers',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authentication',
        methodName: 'removeAllUsers',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<int> countUsers(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'authentication',
        method: 'countUsers',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authentication',
        methodName: 'countUsers',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int>);
    });
  }

  _i3.Future<void> createUser(
    _i1.TestSession session,
    String email,
    String password,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'authentication',
        method: 'createUser',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authentication',
        methodName: 'createUser',
        parameters: {
          'email': email,
          'password': password,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<_i4.AuthenticationResponse> authenticate(
    _i1.TestSession session,
    String email,
    String password,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'authentication',
        method: 'authenticate',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authentication',
        methodName: 'authenticate',
        parameters: {
          'email': email,
          'password': password,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i4.AuthenticationResponse>);
    });
  }

  _i3.Future<void> signOut(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'authentication',
        method: 'signOut',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authentication',
        methodName: 'signOut',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> updateScopes(
    _i1.TestSession session,
    int userId,
    List<String> scopes,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'authentication',
        method: 'updateScopes',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authentication',
        methodName: 'updateScopes',
        parameters: {
          'userId': userId,
          'scopes': scopes,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }
}

class _BasicTypesEndpoint {
  _BasicTypesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<int?> testInt(
    _i1.TestSession session,
    int? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testInt',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testInt',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int?>);
    });
  }

  _i3.Future<double?> testDouble(
    _i1.TestSession session,
    double? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testDouble',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testDouble',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<double?>);
    });
  }

  _i3.Future<bool?> testBool(
    _i1.TestSession session,
    bool? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testBool',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testBool',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool?>);
    });
  }

  _i3.Future<DateTime?> testDateTime(
    _i1.TestSession session,
    DateTime? dateTime,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testDateTime',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testDateTime',
        parameters: {'dateTime': dateTime},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<DateTime?>);
    });
  }

  _i3.Future<String?> testString(
    _i1.TestSession session,
    String? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testString',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testString',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<_i5.ByteData?> testByteData(
    _i1.TestSession session,
    _i5.ByteData? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testByteData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testByteData',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i5.ByteData?>);
    });
  }

  _i3.Future<Duration?> testDuration(
    _i1.TestSession session,
    Duration? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testDuration',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testDuration',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Duration?>);
    });
  }

  _i3.Future<_i6.UuidValue?> testUuid(
    _i1.TestSession session,
    _i6.UuidValue? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicTypes',
        method: 'testUuid',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicTypes',
        methodName: 'testUuid',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i6.UuidValue?>);
    });
  }
}

class _CloudStorageEndpoint {
  _CloudStorageEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> reset(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'reset',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'reset',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> storePublicFile(
    _i1.TestSession session,
    String path,
    _i5.ByteData byteData,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'storePublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'storePublicFile',
        parameters: {
          'path': path,
          'byteData': byteData,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<_i5.ByteData?> retrievePublicFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'retrievePublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'retrievePublicFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i5.ByteData?>);
    });
  }

  _i3.Future<bool?> existsPublicFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'existsPublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'existsPublicFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool?>);
    });
  }

  _i3.Future<void> deletePublicFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'deletePublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'deletePublicFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<String?> getPublicUrlForFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'getPublicUrlForFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'getPublicUrlForFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<String?> getDirectFilePostUrl(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'getDirectFilePostUrl',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'getDirectFilePostUrl',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<bool> verifyDirectFileUpload(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'cloudStorage',
        method: 'verifyDirectFileUpload',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'cloudStorage',
        methodName: 'verifyDirectFileUpload',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _S3CloudStorageEndpoint {
  _S3CloudStorageEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> storePublicFile(
    _i1.TestSession session,
    String path,
    _i5.ByteData byteData,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 's3CloudStorage',
        method: 'storePublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 's3CloudStorage',
        methodName: 'storePublicFile',
        parameters: {
          'path': path,
          'byteData': byteData,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<_i5.ByteData?> retrievePublicFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 's3CloudStorage',
        method: 'retrievePublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 's3CloudStorage',
        methodName: 'retrievePublicFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i5.ByteData?>);
    });
  }

  _i3.Future<bool?> existsPublicFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 's3CloudStorage',
        method: 'existsPublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 's3CloudStorage',
        methodName: 'existsPublicFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool?>);
    });
  }

  _i3.Future<void> deletePublicFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 's3CloudStorage',
        method: 'deletePublicFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 's3CloudStorage',
        methodName: 'deletePublicFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<String?> getPublicUrlForFile(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 's3CloudStorage',
        method: 'getPublicUrlForFile',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 's3CloudStorage',
        methodName: 'getPublicUrlForFile',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<String?> getDirectFilePostUrl(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 's3CloudStorage',
        method: 'getDirectFilePostUrl',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 's3CloudStorage',
        methodName: 'getDirectFilePostUrl',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<bool> verifyDirectFileUpload(
    _i1.TestSession session,
    String path,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 's3CloudStorage',
        method: 'verifyDirectFileUpload',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 's3CloudStorage',
        methodName: 'verifyDirectFileUpload',
        parameters: {'path': path},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _CustomClassProtocolEndpoint {
  _CustomClassProtocolEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i7.ProtocolCustomClass> getProtocolField(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customClassProtocol',
        method: 'getProtocolField',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customClassProtocol',
        methodName: 'getProtocolField',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i7.ProtocolCustomClass>);
    });
  }
}

class _CustomTypesEndpoint {
  _CustomTypesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i8.CustomClass> returnCustomClass(
    _i1.TestSession session,
    _i8.CustomClass data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnCustomClass',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnCustomClass',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i8.CustomClass>);
    });
  }

  _i3.Future<_i8.CustomClass?> returnCustomClassNullable(
    _i1.TestSession session,
    _i8.CustomClass? data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnCustomClassNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnCustomClassNullable',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i8.CustomClass?>);
    });
  }

  _i3.Future<_i8.CustomClass2> returnCustomClass2(
    _i1.TestSession session,
    _i8.CustomClass2 data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnCustomClass2',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnCustomClass2',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i8.CustomClass2>);
    });
  }

  _i3.Future<_i8.CustomClass2?> returnCustomClass2Nullable(
    _i1.TestSession session,
    _i8.CustomClass2? data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnCustomClass2Nullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnCustomClass2Nullable',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i8.CustomClass2?>);
    });
  }

  _i3.Future<_i9.ExternalCustomClass> returnExternalCustomClass(
    _i1.TestSession session,
    _i9.ExternalCustomClass data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnExternalCustomClass',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnExternalCustomClass',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i9.ExternalCustomClass>);
    });
  }

  _i3.Future<_i9.ExternalCustomClass?> returnExternalCustomClassNullable(
    _i1.TestSession session,
    _i9.ExternalCustomClass? data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnExternalCustomClassNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnExternalCustomClassNullable',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i9.ExternalCustomClass?>);
    });
  }

  _i3.Future<_i10.FreezedCustomClass> returnFreezedCustomClass(
    _i1.TestSession session,
    _i10.FreezedCustomClass data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnFreezedCustomClass',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnFreezedCustomClass',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i10.FreezedCustomClass>);
    });
  }

  _i3.Future<_i10.FreezedCustomClass?> returnFreezedCustomClassNullable(
    _i1.TestSession session,
    _i10.FreezedCustomClass? data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'customTypes',
        method: 'returnFreezedCustomClassNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'customTypes',
        methodName: 'returnFreezedCustomClassNullable',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i10.FreezedCustomClass?>);
    });
  }
}

class _BasicDatabase {
  _BasicDatabase(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> deleteAllSimpleTestData(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'deleteAllSimpleTestData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'deleteAllSimpleTestData',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> deleteSimpleTestDataLessThan(
    _i1.TestSession session,
    int num,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'deleteSimpleTestDataLessThan',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'deleteSimpleTestDataLessThan',
        parameters: {'num': num},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> findAndDeleteSimpleTestData(
    _i1.TestSession session,
    int num,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'findAndDeleteSimpleTestData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'findAndDeleteSimpleTestData',
        parameters: {'num': num},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> createSimpleTestData(
    _i1.TestSession session,
    int numRows,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'createSimpleTestData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'createSimpleTestData',
        parameters: {'numRows': numRows},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<List<_i11.SimpleData>> findSimpleData(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'findSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'findSimpleData',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i11.SimpleData>>);
    });
  }

  _i3.Future<_i11.SimpleData?> findFirstRowSimpleData(
    _i1.TestSession session,
    int num,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'findFirstRowSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'findFirstRowSimpleData',
        parameters: {'num': num},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i11.SimpleData?>);
    });
  }

  _i3.Future<_i11.SimpleData?> findByIdSimpleData(
    _i1.TestSession session,
    int id,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'findByIdSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'findByIdSimpleData',
        parameters: {'id': id},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i11.SimpleData?>);
    });
  }

  _i3.Future<_i12.SimpleDataList?> findSimpleDataRowsLessThan(
    _i1.TestSession session,
    int num,
    int offset,
    int limit,
    bool descending,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'findSimpleDataRowsLessThan',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'findSimpleDataRowsLessThan',
        parameters: {
          'num': num,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i12.SimpleDataList?>);
    });
  }

  _i3.Future<_i11.SimpleData> insertRowSimpleData(
    _i1.TestSession session,
    _i11.SimpleData simpleData,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'insertRowSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'insertRowSimpleData',
        parameters: {'simpleData': simpleData},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i11.SimpleData>);
    });
  }

  _i3.Future<_i11.SimpleData> updateRowSimpleData(
    _i1.TestSession session,
    _i11.SimpleData simpleData,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'updateRowSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'updateRowSimpleData',
        parameters: {'simpleData': simpleData},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i11.SimpleData>);
    });
  }

  _i3.Future<int> deleteRowSimpleData(
    _i1.TestSession session,
    _i11.SimpleData simpleData,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'deleteRowSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'deleteRowSimpleData',
        parameters: {'simpleData': simpleData},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int>);
    });
  }

  _i3.Future<List<int>> deleteWhereSimpleData(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'deleteWhereSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'deleteWhereSimpleData',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<int>>);
    });
  }

  _i3.Future<int> countSimpleData(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'countSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'countSimpleData',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int>);
    });
  }

  _i3.Future<_i13.Types> insertTypes(
    _i1.TestSession session,
    _i13.Types value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'insertTypes',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'insertTypes',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i13.Types>);
    });
  }

  _i3.Future<_i13.Types> updateTypes(
    _i1.TestSession session,
    _i13.Types value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'updateTypes',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'updateTypes',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i13.Types>);
    });
  }

  _i3.Future<int?> countTypesRows(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'countTypesRows',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'countTypesRows',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int?>);
    });
  }

  _i3.Future<List<int>> deleteAllInTypes(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'deleteAllInTypes',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'deleteAllInTypes',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<int>>);
    });
  }

  _i3.Future<_i13.Types?> getTypes(
    _i1.TestSession session,
    int id,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'getTypes',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'getTypes',
        parameters: {'id': id},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i13.Types?>);
    });
  }

  _i3.Future<int?> getTypesRawQuery(
    _i1.TestSession session,
    int id,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'getTypesRawQuery',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'getTypesRawQuery',
        parameters: {'id': id},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int?>);
    });
  }

  _i3.Future<_i14.ObjectWithEnum> storeObjectWithEnum(
    _i1.TestSession session,
    _i14.ObjectWithEnum object,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'storeObjectWithEnum',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'storeObjectWithEnum',
        parameters: {'object': object},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i14.ObjectWithEnum>);
    });
  }

  _i3.Future<_i14.ObjectWithEnum?> getObjectWithEnum(
    _i1.TestSession session,
    int id,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'getObjectWithEnum',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'getObjectWithEnum',
        parameters: {'id': id},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i14.ObjectWithEnum?>);
    });
  }

  _i3.Future<_i15.ObjectWithObject> storeObjectWithObject(
    _i1.TestSession session,
    _i15.ObjectWithObject object,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'storeObjectWithObject',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'storeObjectWithObject',
        parameters: {'object': object},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i15.ObjectWithObject>);
    });
  }

  _i3.Future<_i15.ObjectWithObject?> getObjectWithObject(
    _i1.TestSession session,
    int id,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'getObjectWithObject',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'getObjectWithObject',
        parameters: {'id': id},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i15.ObjectWithObject?>);
    });
  }

  _i3.Future<int> deleteAll(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'deleteAll',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'deleteAll',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int>);
    });
  }

  _i3.Future<bool> testByteDataStore(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'basicDatabase',
        method: 'testByteDataStore',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'basicDatabase',
        methodName: 'testByteDataStore',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _TransactionsDatabaseEndpoint {
  _TransactionsDatabaseEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> removeRow(
    _i1.TestSession session,
    int num,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'transactionsDatabase',
        method: 'removeRow',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'transactionsDatabase',
        methodName: 'removeRow',
        parameters: {'num': num},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<bool> updateInsertDelete(
    _i1.TestSession session,
    int numUpdate,
    int numInsert,
    int numDelete,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'transactionsDatabase',
        method: 'updateInsertDelete',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'transactionsDatabase',
        methodName: 'updateInsertDelete',
        parameters: {
          'numUpdate': numUpdate,
          'numInsert': numInsert,
          'numDelete': numDelete,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _DeprecationEndpoint {
  _DeprecationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> setGlobalDouble(
    _i1.TestSession session,
    double? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'deprecation',
        method: 'setGlobalDouble',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'deprecation',
        methodName: 'setGlobalDouble',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<double> getGlobalDouble(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'deprecation',
        method: 'getGlobalDouble',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'deprecation',
        methodName: 'getGlobalDouble',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<double>);
    });
  }
}

class _EchoRequestEndpoint {
  _EchoRequestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String?> echoAuthenticationKey(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'echoRequest',
        method: 'echoAuthenticationKey',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'echoRequest',
        methodName: 'echoAuthenticationKey',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<List<String>?> echoHttpHeader(
    _i1.TestSession session,
    String headerName,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'echoRequest',
        method: 'echoHttpHeader',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'echoRequest',
        methodName: 'echoHttpHeader',
        parameters: {'headerName': headerName},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<String>?>);
    });
  }
}

class _EmailAuthTestMethods {
  _EmailAuthTestMethods(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String?> findVerificationCode(
    _i1.TestSession session,
    String userName,
    String email,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'emailAuthTestMethods',
        method: 'findVerificationCode',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'emailAuthTestMethods',
        methodName: 'findVerificationCode',
        parameters: {
          'userName': userName,
          'email': email,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<String?> findResetCode(
    _i1.TestSession session,
    String email,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'emailAuthTestMethods',
        method: 'findResetCode',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'emailAuthTestMethods',
        methodName: 'findResetCode',
        parameters: {'email': email},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String?>);
    });
  }

  _i3.Future<void> tearDown(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'emailAuthTestMethods',
        method: 'tearDown',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'emailAuthTestMethods',
        methodName: 'tearDown',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<bool> createUser(
    _i1.TestSession session,
    String userName,
    String email,
    String password,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'emailAuthTestMethods',
        method: 'createUser',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'emailAuthTestMethods',
        methodName: 'createUser',
        parameters: {
          'userName': userName,
          'email': email,
          'password': password,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _ExceptionTestEndpoint {
  _ExceptionTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> throwNormalException(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'exceptionTest',
        method: 'throwNormalException',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'exceptionTest',
        methodName: 'throwNormalException',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }

  _i3.Future<String> throwExceptionWithData(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'exceptionTest',
        method: 'throwExceptionWithData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'exceptionTest',
        methodName: 'throwExceptionWithData',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }

  _i3.Future<String> workingWithoutException(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'exceptionTest',
        method: 'workingWithoutException',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'exceptionTest',
        methodName: 'workingWithoutException',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }
}

class _FailedCallsEndpoint {
  _FailedCallsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> failedCall(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'failedCalls',
        method: 'failedCall',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'failedCalls',
        methodName: 'failedCall',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> failedDatabaseQuery(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'failedCalls',
        method: 'failedDatabaseQuery',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'failedCalls',
        methodName: 'failedDatabaseQuery',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<bool> failedDatabaseQueryCaughtException(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'failedCalls',
        method: 'failedDatabaseQueryCaughtException',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'failedCalls',
        methodName: 'failedDatabaseQueryCaughtException',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }

  _i3.Future<void> slowCall(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'failedCalls',
        method: 'slowCall',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'failedCalls',
        methodName: 'slowCall',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> caughtException(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'failedCalls',
        method: 'caughtException',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'failedCalls',
        methodName: 'caughtException',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }
}

class _FieldScopesEndpoint {
  _FieldScopesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> storeObject(
    _i1.TestSession session,
    _i16.ObjectFieldScopes object,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'fieldScopes',
        method: 'storeObject',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'fieldScopes',
        methodName: 'storeObject',
        parameters: {'object': object},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<_i16.ObjectFieldScopes?> retrieveObject(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'fieldScopes',
        method: 'retrieveObject',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'fieldScopes',
        methodName: 'retrieveObject',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i16.ObjectFieldScopes?>);
    });
  }
}

class _FutureCallsEndpoint {
  _FutureCallsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> makeFutureCall(
    _i1.TestSession session,
    _i11.SimpleData? data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'futureCalls',
        method: 'makeFutureCall',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'futureCalls',
        methodName: 'makeFutureCall',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }
}

class _ListParametersEndpoint {
  _ListParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<int>> returnIntList(
    _i1.TestSession session,
    List<int> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnIntList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnIntList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<int>>);
    });
  }

  _i3.Future<List<List<int>>> returnIntListList(
    _i1.TestSession session,
    List<List<int>> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnIntListList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnIntListList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<List<int>>>);
    });
  }

  _i3.Future<List<int>?> returnIntListNullable(
    _i1.TestSession session,
    List<int>? list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnIntListNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnIntListNullable',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<int>?>);
    });
  }

  _i3.Future<List<List<int>?>> returnIntListNullableList(
    _i1.TestSession session,
    List<List<int>?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnIntListNullableList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnIntListNullableList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<List<int>?>>);
    });
  }

  _i3.Future<List<List<int>>?> returnIntListListNullable(
    _i1.TestSession session,
    List<List<int>>? list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnIntListListNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnIntListListNullable',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<List<int>>?>);
    });
  }

  _i3.Future<List<int?>> returnIntListNullableInts(
    _i1.TestSession session,
    List<int?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnIntListNullableInts',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnIntListNullableInts',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<int?>>);
    });
  }

  _i3.Future<List<int?>?> returnNullableIntListNullableInts(
    _i1.TestSession session,
    List<int?>? list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnNullableIntListNullableInts',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnNullableIntListNullableInts',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<int?>?>);
    });
  }

  _i3.Future<List<double>> returnDoubleList(
    _i1.TestSession session,
    List<double> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnDoubleList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnDoubleList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<double>>);
    });
  }

  _i3.Future<List<double?>> returnDoubleListNullableDoubles(
    _i1.TestSession session,
    List<double?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnDoubleListNullableDoubles',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnDoubleListNullableDoubles',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<double?>>);
    });
  }

  _i3.Future<List<bool>> returnBoolList(
    _i1.TestSession session,
    List<bool> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnBoolList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnBoolList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<bool>>);
    });
  }

  _i3.Future<List<bool?>> returnBoolListNullableBools(
    _i1.TestSession session,
    List<bool?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnBoolListNullableBools',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnBoolListNullableBools',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<bool?>>);
    });
  }

  _i3.Future<List<String>> returnStringList(
    _i1.TestSession session,
    List<String> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnStringList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnStringList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<String>>);
    });
  }

  _i3.Future<List<String?>> returnStringListNullableStrings(
    _i1.TestSession session,
    List<String?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnStringListNullableStrings',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnStringListNullableStrings',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<String?>>);
    });
  }

  _i3.Future<List<DateTime>> returnDateTimeList(
    _i1.TestSession session,
    List<DateTime> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnDateTimeList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnDateTimeList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<DateTime>>);
    });
  }

  _i3.Future<List<DateTime?>> returnDateTimeListNullableDateTimes(
    _i1.TestSession session,
    List<DateTime?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnDateTimeListNullableDateTimes',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnDateTimeListNullableDateTimes',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<DateTime?>>);
    });
  }

  _i3.Future<List<_i5.ByteData>> returnByteDataList(
    _i1.TestSession session,
    List<_i5.ByteData> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnByteDataList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnByteDataList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i5.ByteData>>);
    });
  }

  _i3.Future<List<_i5.ByteData?>> returnByteDataListNullableByteDatas(
    _i1.TestSession session,
    List<_i5.ByteData?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnByteDataListNullableByteDatas',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnByteDataListNullableByteDatas',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i5.ByteData?>>);
    });
  }

  _i3.Future<List<_i11.SimpleData>> returnSimpleDataList(
    _i1.TestSession session,
    List<_i11.SimpleData> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnSimpleDataList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnSimpleDataList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i11.SimpleData>>);
    });
  }

  _i3.Future<List<_i11.SimpleData?>> returnSimpleDataListNullableSimpleData(
    _i1.TestSession session,
    List<_i11.SimpleData?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnSimpleDataListNullableSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnSimpleDataListNullableSimpleData',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i11.SimpleData?>>);
    });
  }

  _i3.Future<List<_i11.SimpleData>?> returnSimpleDataListNullable(
    _i1.TestSession session,
    List<_i11.SimpleData>? list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnSimpleDataListNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnSimpleDataListNullable',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i11.SimpleData>?>);
    });
  }

  _i3.Future<List<_i11.SimpleData?>?>
      returnNullableSimpleDataListNullableSimpleData(
    _i1.TestSession session,
    List<_i11.SimpleData?>? list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnNullableSimpleDataListNullableSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnNullableSimpleDataListNullableSimpleData',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i11.SimpleData?>?>);
    });
  }

  _i3.Future<List<Duration>> returnDurationList(
    _i1.TestSession session,
    List<Duration> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnDurationList',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnDurationList',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<Duration>>);
    });
  }

  _i3.Future<List<Duration?>> returnDurationListNullableDurations(
    _i1.TestSession session,
    List<Duration?> list,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'listParameters',
        method: 'returnDurationListNullableDurations',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'listParameters',
        methodName: 'returnDurationListNullableDurations',
        parameters: {'list': list},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<Duration?>>);
    });
  }
}

class _LoggingEndpoint {
  _LoggingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> slowQueryMethod(
    _i1.TestSession session,
    int seconds,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'slowQueryMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'slowQueryMethod',
        parameters: {'seconds': seconds},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> queryMethod(
    _i1.TestSession session,
    int queries,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'queryMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'queryMethod',
        parameters: {'queries': queries},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> failedQueryMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'failedQueryMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'failedQueryMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> slowMethod(
    _i1.TestSession session,
    int delayMillis,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'slowMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'slowMethod',
        parameters: {'delayMillis': delayMillis},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> failingMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'failingMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'failingMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> emptyMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'emptyMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'emptyMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> log(
    _i1.TestSession session,
    String message,
    List<int> logLevels,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'log',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'log',
        parameters: {
          'message': message,
          'logLevels': logLevels,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> logInfo(
    _i1.TestSession session,
    String message,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'logInfo',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'logInfo',
        parameters: {'message': message},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> logDebugAndInfoAndError(
    _i1.TestSession session,
    String debug,
    String info,
    String error,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'logDebugAndInfoAndError',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'logDebugAndInfoAndError',
        parameters: {
          'debug': debug,
          'info': info,
          'error': error,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> twoQueries(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'logging',
        method: 'twoQueries',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'logging',
        methodName: 'twoQueries',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Stream<int> streamEmpty(
    _i1.TestSession session,
    _i3.Stream<int> input,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'logging',
          method: 'streamEmpty',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'logging',
          methodName: 'streamEmpty',
          arguments: {},
          requestedInputStreams: ['input'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'input': input},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> streamLogging(
    _i1.TestSession session,
    _i3.Stream<int> input,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'logging',
          method: 'streamLogging',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'logging',
          methodName: 'streamLogging',
          arguments: {},
          requestedInputStreams: ['input'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'input': input},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> streamQueryLogging(
    _i1.TestSession session,
    _i3.Stream<int> input,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'logging',
          method: 'streamQueryLogging',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'logging',
          methodName: 'streamQueryLogging',
          arguments: {},
          requestedInputStreams: ['input'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'input': input},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _StreamLogging {
  _StreamLogging(
    _endpointDispatch,
    _serializationManager,
  );
}

class _StreamQueryLogging {
  _StreamQueryLogging(
    _endpointDispatch,
    _serializationManager,
  );
}

class _LoggingDisabledEndpoint {
  _LoggingDisabledEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> logInfo(
    _i1.TestSession session,
    String message,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'loggingDisabled',
        method: 'logInfo',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'loggingDisabled',
        methodName: 'logInfo',
        parameters: {'message': message},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }
}

class _MapParametersEndpoint {
  _MapParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<Map<String, int>> returnIntMap(
    _i1.TestSession session,
    Map<String, int> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnIntMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnIntMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, int>>);
    });
  }

  _i3.Future<Map<String, int>?> returnIntMapNullable(
    _i1.TestSession session,
    Map<String, int>? map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnIntMapNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnIntMapNullable',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, int>?>);
    });
  }

  _i3.Future<Map<String, Map<String, int>>> returnNestedIntMap(
    _i1.TestSession session,
    Map<String, Map<String, int>> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnNestedIntMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnNestedIntMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, Map<String, int>>>);
    });
  }

  _i3.Future<Map<String, int?>> returnIntMapNullableInts(
    _i1.TestSession session,
    Map<String, int?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnIntMapNullableInts',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnIntMapNullableInts',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, int?>>);
    });
  }

  _i3.Future<Map<String, int?>?> returnNullableIntMapNullableInts(
    _i1.TestSession session,
    Map<String, int?>? map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnNullableIntMapNullableInts',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnNullableIntMapNullableInts',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, int?>?>);
    });
  }

  _i3.Future<Map<int, int>> returnIntIntMap(
    _i1.TestSession session,
    Map<int, int> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnIntIntMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnIntIntMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<int, int>>);
    });
  }

  _i3.Future<Map<_i17.TestEnum, int>> returnEnumIntMap(
    _i1.TestSession session,
    Map<_i17.TestEnum, int> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnEnumIntMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnEnumIntMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<_i17.TestEnum, int>>);
    });
  }

  _i3.Future<Map<String, _i17.TestEnum>> returnEnumMap(
    _i1.TestSession session,
    Map<String, _i17.TestEnum> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnEnumMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnEnumMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, _i17.TestEnum>>);
    });
  }

  _i3.Future<Map<String, double>> returnDoubleMap(
    _i1.TestSession session,
    Map<String, double> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnDoubleMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnDoubleMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, double>>);
    });
  }

  _i3.Future<Map<String, double?>> returnDoubleMapNullableDoubles(
    _i1.TestSession session,
    Map<String, double?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnDoubleMapNullableDoubles',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnDoubleMapNullableDoubles',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, double?>>);
    });
  }

  _i3.Future<Map<String, bool>> returnBoolMap(
    _i1.TestSession session,
    Map<String, bool> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnBoolMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnBoolMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, bool>>);
    });
  }

  _i3.Future<Map<String, bool?>> returnBoolMapNullableBools(
    _i1.TestSession session,
    Map<String, bool?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnBoolMapNullableBools',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnBoolMapNullableBools',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, bool?>>);
    });
  }

  _i3.Future<Map<String, String>> returnStringMap(
    _i1.TestSession session,
    Map<String, String> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnStringMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnStringMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, String>>);
    });
  }

  _i3.Future<Map<String, String?>> returnStringMapNullableStrings(
    _i1.TestSession session,
    Map<String, String?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnStringMapNullableStrings',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnStringMapNullableStrings',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, String?>>);
    });
  }

  _i3.Future<Map<String, DateTime>> returnDateTimeMap(
    _i1.TestSession session,
    Map<String, DateTime> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnDateTimeMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnDateTimeMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, DateTime>>);
    });
  }

  _i3.Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
    _i1.TestSession session,
    Map<String, DateTime?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnDateTimeMapNullableDateTimes',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnDateTimeMapNullableDateTimes',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, DateTime?>>);
    });
  }

  _i3.Future<Map<String, _i5.ByteData>> returnByteDataMap(
    _i1.TestSession session,
    Map<String, _i5.ByteData> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnByteDataMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnByteDataMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, _i5.ByteData>>);
    });
  }

  _i3.Future<Map<String, _i5.ByteData?>> returnByteDataMapNullableByteDatas(
    _i1.TestSession session,
    Map<String, _i5.ByteData?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnByteDataMapNullableByteDatas',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnByteDataMapNullableByteDatas',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, _i5.ByteData?>>);
    });
  }

  _i3.Future<Map<String, _i11.SimpleData>> returnSimpleDataMap(
    _i1.TestSession session,
    Map<String, _i11.SimpleData> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnSimpleDataMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnSimpleDataMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, _i11.SimpleData>>);
    });
  }

  _i3.Future<Map<String, _i11.SimpleData?>>
      returnSimpleDataMapNullableSimpleData(
    _i1.TestSession session,
    Map<String, _i11.SimpleData?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnSimpleDataMapNullableSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnSimpleDataMapNullableSimpleData',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, _i11.SimpleData?>>);
    });
  }

  _i3.Future<Map<String, _i11.SimpleData>?> returnSimpleDataMapNullable(
    _i1.TestSession session,
    Map<String, _i11.SimpleData>? map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnSimpleDataMapNullable',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnSimpleDataMapNullable',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, _i11.SimpleData>?>);
    });
  }

  _i3.Future<Map<String, _i11.SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
    _i1.TestSession session,
    Map<String, _i11.SimpleData?>? map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnNullableSimpleDataMapNullableSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnNullableSimpleDataMapNullableSimpleData',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, _i11.SimpleData?>?>);
    });
  }

  _i3.Future<Map<String, Duration>> returnDurationMap(
    _i1.TestSession session,
    Map<String, Duration> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnDurationMap',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnDurationMap',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, Duration>>);
    });
  }

  _i3.Future<Map<String, Duration?>> returnDurationMapNullableDurations(
    _i1.TestSession session,
    Map<String, Duration?> map,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'mapParameters',
        method: 'returnDurationMapNullableDurations',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'mapParameters',
        methodName: 'returnDurationMapNullableDurations',
        parameters: {'map': map},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<Map<String, Duration?>>);
    });
  }
}

class _MethodStreaming {
  _MethodStreaming(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Stream<int> simpleStream(_i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'simpleStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'simpleStream',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> neverEndingStreamWithDelay(
    _i1.TestSession session,
    int millisecondsDelay,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'neverEndingStreamWithDelay',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'neverEndingStreamWithDelay',
          arguments: {'millisecondsDelay': millisecondsDelay},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> methodCallEndpoint(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'methodCallEndpoint',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'methodCallEndpoint',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<int> intReturnFromStream(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'intReturnFromStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'intReturnFromStream',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<int?> nullableIntReturnFromStream(
    _i1.TestSession session,
    _i3.Stream<int?> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<int?>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'nullableIntReturnFromStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'nullableIntReturnFromStream',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Stream<int> intStreamFromValue(
    _i1.TestSession session,
    int value,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'intStreamFromValue',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'intStreamFromValue',
          arguments: {'value': value},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> intEchoStream(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'intEchoStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'intEchoStream',
          arguments: {},
          requestedInputStreams: ['stream'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'stream': stream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<dynamic> dynamicEchoStream(
    _i1.TestSession session,
    _i3.Stream<dynamic> stream,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<dynamic>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'dynamicEchoStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'dynamicEchoStream',
          arguments: {},
          requestedInputStreams: ['stream'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'stream': stream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int?> nullableIntEchoStream(
    _i1.TestSession session,
    _i3.Stream<int?> stream,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int?>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'nullableIntEchoStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'nullableIntEchoStream',
          arguments: {},
          requestedInputStreams: ['stream'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'stream': stream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> voidReturnAfterStream(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'voidReturnAfterStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'voidReturnAfterStream',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Stream<int> multipleIntEchoStreams(
    _i1.TestSession session,
    _i3.Stream<int> stream1,
    _i3.Stream<int> stream2,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'multipleIntEchoStreams',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'multipleIntEchoStreams',
          arguments: {},
          requestedInputStreams: [
            'stream1',
            'stream2',
          ],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
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

  _i3.Future<void> directVoidReturnWithStreamInput(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'directVoidReturnWithStreamInput',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'directVoidReturnWithStreamInput',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<int> directOneIntReturnWithStreamInput(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'directOneIntReturnWithStreamInput',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'directOneIntReturnWithStreamInput',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<int> simpleInputReturnStream(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'simpleInputReturnStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'simpleInputReturnStream',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Stream<int> simpleStreamWithParameter(
    _i1.TestSession session,
    int value,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'simpleStreamWithParameter',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'simpleStreamWithParameter',
          arguments: {'value': value},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<_i11.SimpleData> simpleDataStream(
    _i1.TestSession session,
    int value,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<_i11.SimpleData>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'simpleDataStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'simpleDataStream',
          arguments: {'value': value},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<_i11.SimpleData> simpleInOutDataStream(
    _i1.TestSession session,
    _i3.Stream<_i11.SimpleData> simpleDataStream,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<_i11.SimpleData>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'simpleInOutDataStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'simpleInOutDataStream',
          arguments: {},
          requestedInputStreams: ['simpleDataStream'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'simpleDataStream': simpleDataStream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> simpleEndpoint(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'simpleEndpoint',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'simpleEndpoint',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> intParameter(
    _i1.TestSession session,
    int value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'intParameter',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'intParameter',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<int> doubleInputValue(
    _i1.TestSession session,
    int value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'doubleInputValue',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'doubleInputValue',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int>);
    });
  }

  _i3.Future<void> delayedResponse(
    _i1.TestSession session,
    int delay,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'delayedResponse',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'delayedResponse',
        parameters: {'delay': delay},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Stream<int> delayedStreamResponse(
    _i1.TestSession session,
    int delay,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'delayedStreamResponse',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'delayedStreamResponse',
          arguments: {'delay': delay},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> delayedNeverListenedInputStream(
    _i1.TestSession session,
    int delay,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'delayedNeverListenedInputStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'delayedNeverListenedInputStream',
        arguments: {'delay': delay},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<void> delayedPausedInputStream(
    _i1.TestSession session,
    int delay,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'delayedPausedInputStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'delayedPausedInputStream',
        arguments: {'delay': delay},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<void> completeAllDelayedResponses(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'completeAllDelayedResponses',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'completeAllDelayedResponses',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> inStreamThrowsException(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'inStreamThrowsException',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'inStreamThrowsException',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<void> inStreamThrowsSerializableException(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'inStreamThrowsSerializableException',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'inStreamThrowsSerializableException',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Stream<int> outStreamThrowsException(_i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'outStreamThrowsException',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'outStreamThrowsException',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> outStreamThrowsSerializableException(
      _i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'outStreamThrowsSerializableException',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'outStreamThrowsSerializableException',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> throwsExceptionVoid(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'throwsExceptionVoid',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'throwsExceptionVoid',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<void> throwsSerializableExceptionVoid(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<void>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'throwsSerializableExceptionVoid',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'throwsSerializableExceptionVoid',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<int> throwsException(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'throwsException',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'throwsException',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<int> throwsSerializableException(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'throwsSerializableException',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'throwsSerializableException',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Stream<int> throwsExceptionStream(_i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'throwsExceptionStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'throwsExceptionStream',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> throwsSerializableExceptionStream(_i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'methodStreaming',
          method: 'throwsSerializableExceptionStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'methodStreaming',
          methodName: 'throwsSerializableExceptionStream',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<bool> didInputStreamHaveError(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<bool>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'didInputStreamHaveError',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'didInputStreamHaveError',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Future<bool> didInputStreamHaveSerializableExceptionError(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<bool>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'methodStreaming',
        method: 'didInputStreamHaveSerializableExceptionError',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'methodStreaming',
        methodName: 'didInputStreamHaveSerializableExceptionError',
        arguments: {},
        requestedInputStreams: ['stream'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'stream': stream},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }
}

class _AuthenticatedMethodStreaming {
  _AuthenticatedMethodStreaming(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Stream<int> simpleStream(_i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'authenticatedMethodStreaming',
          method: 'simpleStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'authenticatedMethodStreaming',
          methodName: 'simpleStream',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> intEchoStream(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'authenticatedMethodStreaming',
          method: 'intEchoStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'authenticatedMethodStreaming',
          methodName: 'intEchoStream',
          arguments: {},
          requestedInputStreams: ['stream'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'stream': stream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _ModuleSerializationEndpoint {
  _ModuleSerializationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> serializeModuleObject(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'moduleSerialization',
        method: 'serializeModuleObject',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'moduleSerialization',
        methodName: 'serializeModuleObject',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }

  _i3.Future<_i18.ModuleClass> modifyModuleObject(
    _i1.TestSession session,
    _i18.ModuleClass object,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'moduleSerialization',
        method: 'modifyModuleObject',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'moduleSerialization',
        methodName: 'modifyModuleObject',
        parameters: {'object': object},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i18.ModuleClass>);
    });
  }

  _i3.Future<_i19.ModuleDatatype> serializeNestedModuleObject(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'moduleSerialization',
        method: 'serializeNestedModuleObject',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'moduleSerialization',
        methodName: 'serializeNestedModuleObject',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i19.ModuleDatatype>);
    });
  }
}

class _NamedParametersEndpoint {
  _NamedParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> namedParametersMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'namedParameters',
        method: 'namedParametersMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'namedParameters',
        methodName: 'namedParametersMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }

  _i3.Future<bool> namedParametersMethodEqualInts(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'namedParameters',
        method: 'namedParametersMethodEqualInts',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'namedParameters',
        methodName: 'namedParametersMethodEqualInts',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _OptionalParametersEndpoint {
  _OptionalParametersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<int?> returnOptionalInt(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'optionalParameters',
        method: 'returnOptionalInt',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'optionalParameters',
        methodName: 'returnOptionalInt',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int?>);
    });
  }
}

class _RedisEndpoint {
  _RedisEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> setSimpleData(
    _i1.TestSession session,
    String key,
    _i11.SimpleData data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'setSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'setSimpleData',
        parameters: {
          'key': key,
          'data': data,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> setSimpleDataWithLifetime(
    _i1.TestSession session,
    String key,
    _i11.SimpleData data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'setSimpleDataWithLifetime',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'setSimpleDataWithLifetime',
        parameters: {
          'key': key,
          'data': data,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<_i11.SimpleData?> getSimpleData(
    _i1.TestSession session,
    String key,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'getSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'getSimpleData',
        parameters: {'key': key},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i11.SimpleData?>);
    });
  }

  _i3.Future<void> deleteSimpleData(
    _i1.TestSession session,
    String key,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'deleteSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'deleteSimpleData',
        parameters: {'key': key},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> resetMessageCentralTest(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'resetMessageCentralTest',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'resetMessageCentralTest',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<_i11.SimpleData?> listenToChannel(
    _i1.TestSession session,
    String channel,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'listenToChannel',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'listenToChannel',
        parameters: {'channel': channel},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i11.SimpleData?>);
    });
  }

  _i3.Future<void> postToChannel(
    _i1.TestSession session,
    String channel,
    _i11.SimpleData data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'postToChannel',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'postToChannel',
        parameters: {
          'channel': channel,
          'data': data,
        },
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<int> countSubscribedChannels(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'redis',
        method: 'countSubscribedChannels',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'redis',
        methodName: 'countSubscribedChannels',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int>);
    });
  }
}

class _ServerOnlyScopedFieldModelEndpoint {
  _ServerOnlyScopedFieldModelEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i20.ScopeServerOnlyField> getScopeServerOnlyField(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'serverOnlyScopedFieldModel',
        method: 'getScopeServerOnlyField',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'serverOnlyScopedFieldModel',
        methodName: 'getScopeServerOnlyField',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i20.ScopeServerOnlyField>);
    });
  }
}

class _SignInRequiredEndpoint {
  _SignInRequiredEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> testMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'signInRequired',
        method: 'testMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'signInRequired',
        methodName: 'testMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _AdminScopeRequiredEndpoint {
  _AdminScopeRequiredEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> testMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'adminScopeRequired',
        method: 'testMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'adminScopeRequired',
        methodName: 'testMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<bool>);
    });
  }
}

class _SimpleEndpoint {
  _SimpleEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> setGlobalInt(
    _i1.TestSession session,
    int? value,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'simple',
        method: 'setGlobalInt',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'simple',
        methodName: 'setGlobalInt',
        parameters: {'value': value},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<void> addToGlobalInt(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'simple',
        method: 'addToGlobalInt',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'simple',
        methodName: 'addToGlobalInt',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<int> getGlobalInt(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'simple',
        method: 'getGlobalInt',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'simple',
        methodName: 'getGlobalInt',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<int>);
    });
  }

  _i3.Future<String> hello(
    _i1.TestSession session,
    String name,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'simple',
        method: 'hello',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'simple',
        methodName: 'hello',
        parameters: {'name': name},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }
}

class _StreamingEndpoint {
  _StreamingEndpoint(
    _endpointDispatch,
    _serializationManager,
  );
}

class _StreamingLoggingEndpoint {
  _StreamingLoggingEndpoint(
    _endpointDispatch,
    _serializationManager,
  );
}

class _SubSubDirTestEndpoint {
  _SubSubDirTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> testMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'subSubDirTest',
        method: 'testMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'subSubDirTest',
        methodName: 'testMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }
}

class _SubDirTestEndpoint {
  _SubDirTestEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> testMethod(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'subDirTest',
        method: 'testMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'subDirTest',
        methodName: 'testMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }
}

class _TestToolsEndpoint {
  _TestToolsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i6.UuidValue> returnsSessionId(_i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'testTools',
        method: 'returnsSessionId',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'testTools',
        methodName: 'returnsSessionId',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<_i6.UuidValue>);
    });
  }

  _i3.Future<List<String?>> returnsSessionEndpointAndMethod(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'testTools',
        method: 'returnsSessionEndpointAndMethod',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'testTools',
        methodName: 'returnsSessionEndpointAndMethod',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<String?>>);
    });
  }

  _i3.Stream<_i6.UuidValue> returnsSessionIdFromStream(
      _i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<_i6.UuidValue>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'testTools',
          method: 'returnsSessionIdFromStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'testTools',
          methodName: 'returnsSessionIdFromStream',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<String?> returnsSessionEndpointAndMethodFromStream(
      _i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<String?>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'testTools',
          method: 'returnsSessionEndpointAndMethodFromStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'testTools',
          methodName: 'returnsSessionEndpointAndMethodFromStream',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<String> returnsString(
    _i1.TestSession session,
    String string,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'testTools',
        method: 'returnsString',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'testTools',
        methodName: 'returnsString',
        parameters: {'string': string},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }

  _i3.Stream<int> returnsStream(
    _i1.TestSession session,
    int n,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'testTools',
          method: 'returnsStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'testTools',
          methodName: 'returnsStream',
          arguments: {'n': n},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<List<int>> returnsListFromInputStream(
    _i1.TestSession session,
    _i3.Stream<int> numbers,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<List<int>>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'testTools',
        method: 'returnsListFromInputStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'testTools',
        methodName: 'returnsListFromInputStream',
        arguments: {},
        requestedInputStreams: ['numbers'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'numbers': numbers},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Stream<int> returnsStreamFromInputStream(
    _i1.TestSession session,
    _i3.Stream<int> numbers,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'testTools',
          method: 'returnsStreamFromInputStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'testTools',
          methodName: 'returnsStreamFromInputStream',
          arguments: {},
          requestedInputStreams: ['numbers'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'numbers': numbers},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> postNumberToSharedStream(
    _i1.TestSession session,
    int number,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'testTools',
        method: 'postNumberToSharedStream',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'testTools',
        methodName: 'postNumberToSharedStream',
        parameters: {'number': number},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Stream<int> postNumberToSharedStreamAndReturnStream(
    _i1.TestSession session,
    int number,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'testTools',
          method: 'postNumberToSharedStreamAndReturnStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'testTools',
          methodName: 'postNumberToSharedStreamAndReturnStream',
          arguments: {'number': number},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<int> listenForNumbersOnSharedStream(_i1.TestSession session) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'testTools',
          method: 'listenForNumbersOnSharedStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'testTools',
          methodName: 'listenForNumbersOnSharedStream',
          arguments: {},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> createSimpleData(
    _i1.TestSession session,
    int data,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'testTools',
        method: 'createSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'testTools',
        methodName: 'createSimpleData',
        parameters: {'data': data},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<void>);
    });
  }

  _i3.Future<List<_i11.SimpleData>> getAllSimpleData(
      _i1.TestSession session) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'testTools',
        method: 'getAllSimpleData',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'testTools',
        methodName: 'getAllSimpleData',
        parameters: {},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<List<_i11.SimpleData>>);
    });
  }
}

class _AuthenticatedTestToolsEndpoint {
  _AuthenticatedTestToolsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> returnsString(
    _i1.TestSession session,
    String string,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = ((session as _i1.InternalTestSession).copyWith(
        endpoint: 'authenticatedTestTools',
        method: 'returnsString',
      ) as _i1.InternalTestSession);
      var _localCallContext = await _endpointDispatch.getMethodCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authenticatedTestTools',
        methodName: 'returnsString',
        parameters: {'string': string},
        serializationManager: _serializationManager,
      );
      return (_localCallContext.method.call(
        _localUniqueSession.serverpodSession,
        _localCallContext.arguments,
      ) as _i3.Future<String>);
    });
  }

  _i3.Stream<int> returnsStream(
    _i1.TestSession session,
    int n,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'authenticatedTestTools',
          method: 'returnsStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'authenticatedTestTools',
          methodName: 'returnsStream',
          arguments: {'n': n},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<List<int>> returnsListFromInputStream(
    _i1.TestSession session,
    _i3.Stream<int> numbers,
  ) async {
    var _localTestStreamManager = _i1.TestStreamManager<List<int>>();
    return _i1
        .callAwaitableFunctionWithStreamInputAndHandleExceptions(() async {
      var _localUniqueSession =
          (await (session as _i1.InternalTestSession).copyWith(
        endpoint: 'authenticatedTestTools',
        method: 'returnsListFromInputStream',
      ) as _i1.InternalTestSession);
      var _localCallContext =
          await _endpointDispatch.getMethodStreamCallContext(
        createSessionCallback: (_) => _localUniqueSession.serverpodSession,
        endpointPath: 'authenticatedTestTools',
        methodName: 'returnsListFromInputStream',
        arguments: {},
        requestedInputStreams: ['numbers'],
        serializationManager: _serializationManager,
      );
      _localTestStreamManager.callStreamMethod(
        _localCallContext,
        _localUniqueSession.serverpodSession,
        {'numbers': numbers},
      );
      return _localTestStreamManager.outputStreamController.stream;
    });
  }

  _i3.Stream<int> intEchoStream(
    _i1.TestSession session,
    _i3.Stream<int> stream,
  ) {
    var _localTestStreamManager = _i1.TestStreamManager<int>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (await (session as _i1.InternalTestSession).copyWith(
          endpoint: 'authenticatedTestTools',
          method: 'intEchoStream',
        ) as _i1.InternalTestSession);
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession.serverpodSession,
          endpointPath: 'authenticatedTestTools',
          methodName: 'intEchoStream',
          arguments: {},
          requestedInputStreams: ['stream'],
          serializationManager: _serializationManager,
        );
        _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession.serverpodSession,
          {'stream': stream},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}
