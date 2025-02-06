/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/async_tasks.dart' as _i2;
import '../endpoints/authentication.dart' as _i3;
import '../endpoints/basic_types.dart' as _i4;
import '../endpoints/basic_types_streaming.dart' as _i5;
import '../endpoints/cloud_storage.dart' as _i6;
import '../endpoints/cloud_storage_s3.dart' as _i7;
import '../endpoints/custom_class_protocol.dart' as _i8;
import '../endpoints/custom_types.dart' as _i9;
import '../endpoints/database_basic.dart' as _i10;
import '../endpoints/database_transactions.dart' as _i11;
import '../endpoints/deprecation.dart' as _i12;
import '../endpoints/echo_request.dart' as _i13;
import '../endpoints/email_auth_provider.dart' as _i14;
import '../endpoints/exception_test_endpoint.dart' as _i15;
import '../endpoints/failed_calls.dart' as _i16;
import '../endpoints/field_scopes.dart' as _i17;
import '../endpoints/future_calls.dart' as _i18;
import '../endpoints/list_parameters.dart' as _i19;
import '../endpoints/logging.dart' as _i20;
import '../endpoints/logging_disabled.dart' as _i21;
import '../endpoints/map_parameters.dart' as _i22;
import '../endpoints/method_signature_permutations.dart' as _i23;
import '../endpoints/method_streaming.dart' as _i24;
import '../endpoints/module_serialization.dart' as _i25;
import '../endpoints/named_parameters.dart' as _i26;
import '../endpoints/optional_parameters.dart' as _i27;
import '../endpoints/redis.dart' as _i28;
import '../endpoints/server_only_scoped_field_model.dart' as _i29;
import '../endpoints/server_only_scoped_field_model_child.dart' as _i30;
import '../endpoints/signin_required.dart' as _i31;
import '../endpoints/simple.dart' as _i32;
import '../endpoints/streaming.dart' as _i33;
import '../endpoints/streaming_logging.dart' as _i34;
import '../endpoints/subDir/subSubDir/subsubdir_test_endpoint.dart' as _i35;
import '../endpoints/subDir/subdir_test_endpoint.dart' as _i36;
import '../endpoints/test_tools.dart' as _i37;
import '../my_feature/endpoints/my_feature_endpoint.dart' as _i38;
import 'dart:typed_data' as _i39;
import 'package:uuid/uuid_value.dart' as _i40;
import 'package:serverpod_test_shared/src/custom_classes.dart' as _i41;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i42;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i43;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i44;
import 'package:serverpod_test_server/src/generated/types.dart' as _i45;
import 'package:serverpod_test_server/src/generated/object_with_enum.dart'
    as _i46;
import 'package:serverpod_test_server/src/generated/object_with_object.dart'
    as _i47;
import 'package:serverpod_test_server/src/generated/object_field_scopes.dart'
    as _i48;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i49;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i50;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i51;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'asyncTasks': _i2.AsyncTasksEndpoint()
        ..initialize(
          server,
          'asyncTasks',
          null,
        ),
      'authentication': _i3.AuthenticationEndpoint()
        ..initialize(
          server,
          'authentication',
          null,
        ),
      'basicTypes': _i4.BasicTypesEndpoint()
        ..initialize(
          server,
          'basicTypes',
          null,
        ),
      'basicTypesStreaming': _i5.BasicTypesStreamingEndpoint()
        ..initialize(
          server,
          'basicTypesStreaming',
          null,
        ),
      'cloudStorage': _i6.CloudStorageEndpoint()
        ..initialize(
          server,
          'cloudStorage',
          null,
        ),
      's3CloudStorage': _i7.S3CloudStorageEndpoint()
        ..initialize(
          server,
          's3CloudStorage',
          null,
        ),
      'customClassProtocol': _i8.CustomClassProtocolEndpoint()
        ..initialize(
          server,
          'customClassProtocol',
          null,
        ),
      'customTypes': _i9.CustomTypesEndpoint()
        ..initialize(
          server,
          'customTypes',
          null,
        ),
      'basicDatabase': _i10.BasicDatabase()
        ..initialize(
          server,
          'basicDatabase',
          null,
        ),
      'transactionsDatabase': _i11.TransactionsDatabaseEndpoint()
        ..initialize(
          server,
          'transactionsDatabase',
          null,
        ),
      'deprecation': _i12.DeprecationEndpoint()
        ..initialize(
          server,
          'deprecation',
          null,
        ),
      'echoRequest': _i13.EchoRequestEndpoint()
        ..initialize(
          server,
          'echoRequest',
          null,
        ),
      'emailAuthTestMethods': _i14.EmailAuthTestMethods()
        ..initialize(
          server,
          'emailAuthTestMethods',
          null,
        ),
      'exceptionTest': _i15.ExceptionTestEndpoint()
        ..initialize(
          server,
          'exceptionTest',
          null,
        ),
      'failedCalls': _i16.FailedCallsEndpoint()
        ..initialize(
          server,
          'failedCalls',
          null,
        ),
      'fieldScopes': _i17.FieldScopesEndpoint()
        ..initialize(
          server,
          'fieldScopes',
          null,
        ),
      'futureCalls': _i18.FutureCallsEndpoint()
        ..initialize(
          server,
          'futureCalls',
          null,
        ),
      'listParameters': _i19.ListParametersEndpoint()
        ..initialize(
          server,
          'listParameters',
          null,
        ),
      'logging': _i20.LoggingEndpoint()
        ..initialize(
          server,
          'logging',
          null,
        ),
      'streamLogging': _i20.StreamLogging()
        ..initialize(
          server,
          'streamLogging',
          null,
        ),
      'streamQueryLogging': _i20.StreamQueryLogging()
        ..initialize(
          server,
          'streamQueryLogging',
          null,
        ),
      'loggingDisabled': _i21.LoggingDisabledEndpoint()
        ..initialize(
          server,
          'loggingDisabled',
          null,
        ),
      'mapParameters': _i22.MapParametersEndpoint()
        ..initialize(
          server,
          'mapParameters',
          null,
        ),
      'methodSignaturePermutations': _i23.MethodSignaturePermutationsEndpoint()
        ..initialize(
          server,
          'methodSignaturePermutations',
          null,
        ),
      'methodStreaming': _i24.MethodStreaming()
        ..initialize(
          server,
          'methodStreaming',
          null,
        ),
      'authenticatedMethodStreaming': _i24.AuthenticatedMethodStreaming()
        ..initialize(
          server,
          'authenticatedMethodStreaming',
          null,
        ),
      'moduleSerialization': _i25.ModuleSerializationEndpoint()
        ..initialize(
          server,
          'moduleSerialization',
          null,
        ),
      'namedParameters': _i26.NamedParametersEndpoint()
        ..initialize(
          server,
          'namedParameters',
          null,
        ),
      'optionalParameters': _i27.OptionalParametersEndpoint()
        ..initialize(
          server,
          'optionalParameters',
          null,
        ),
      'redis': _i28.RedisEndpoint()
        ..initialize(
          server,
          'redis',
          null,
        ),
      'serverOnlyScopedFieldModel': _i29.ServerOnlyScopedFieldModelEndpoint()
        ..initialize(
          server,
          'serverOnlyScopedFieldModel',
          null,
        ),
      'serverOnlyScopedFieldChildModel':
          _i30.ServerOnlyScopedFieldChildModelEndpoint()
            ..initialize(
              server,
              'serverOnlyScopedFieldChildModel',
              null,
            ),
      'signInRequired': _i31.SignInRequiredEndpoint()
        ..initialize(
          server,
          'signInRequired',
          null,
        ),
      'adminScopeRequired': _i31.AdminScopeRequiredEndpoint()
        ..initialize(
          server,
          'adminScopeRequired',
          null,
        ),
      'simple': _i32.SimpleEndpoint()
        ..initialize(
          server,
          'simple',
          null,
        ),
      'streaming': _i33.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          null,
        ),
      'streamingLogging': _i34.StreamingLoggingEndpoint()
        ..initialize(
          server,
          'streamingLogging',
          null,
        ),
      'subSubDirTest': _i35.SubSubDirTestEndpoint()
        ..initialize(
          server,
          'subSubDirTest',
          null,
        ),
      'subDirTest': _i36.SubDirTestEndpoint()
        ..initialize(
          server,
          'subDirTest',
          null,
        ),
      'testTools': _i37.TestToolsEndpoint()
        ..initialize(
          server,
          'testTools',
          null,
        ),
      'authenticatedTestTools': _i37.AuthenticatedTestToolsEndpoint()
        ..initialize(
          server,
          'authenticatedTestTools',
          null,
        ),
      'myFeature': _i38.MyFeatureEndpoint()
        ..initialize(
          server,
          'myFeature',
          null,
        ),
    };
    connectors['asyncTasks'] = _i1.EndpointConnector(
      name: 'asyncTasks',
      endpoint: endpoints['asyncTasks']!,
      methodConnectors: {
        'insertRowToSimpleDataAfterDelay': _i1.MethodConnector(
          name: 'insertRowToSimpleDataAfterDelay',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'seconds': _i1.ParameterDescription(
              name: 'seconds',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['asyncTasks'] as _i2.AsyncTasksEndpoint)
                  .insertRowToSimpleDataAfterDelay(
            session,
            params['num'],
            params['seconds'],
          ),
        ),
        'throwExceptionAfterDelay': _i1.MethodConnector(
          name: 'throwExceptionAfterDelay',
          params: {
            'seconds': _i1.ParameterDescription(
              name: 'seconds',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['asyncTasks'] as _i2.AsyncTasksEndpoint)
                  .throwExceptionAfterDelay(
            session,
            params['seconds'],
          ),
        ),
      },
    );
    connectors['authentication'] = _i1.EndpointConnector(
      name: 'authentication',
      endpoint: endpoints['authentication']!,
      methodConnectors: {
        'removeAllUsers': _i1.MethodConnector(
          name: 'removeAllUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .removeAllUsers(session),
        ),
        'countUsers': _i1.MethodConnector(
          name: 'countUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .countUsers(session),
        ),
        'createUser': _i1.MethodConnector(
          name: 'createUser',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .createUser(
            session,
            params['email'],
            params['password'],
          ),
        ),
        'authenticate': _i1.MethodConnector(
          name: 'authenticate',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'scopes': _i1.ParameterDescription(
              name: 'scopes',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .authenticate(
            session,
            params['email'],
            params['password'],
            params['scopes'],
          ),
        ),
        'signOut': _i1.MethodConnector(
          name: 'signOut',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .signOut(session),
        ),
        'updateScopes': _i1.MethodConnector(
          name: 'updateScopes',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'scopes': _i1.ParameterDescription(
              name: 'scopes',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .updateScopes(
            session,
            params['userId'],
            params['scopes'],
          ),
        ),
      },
    );
    connectors['basicTypes'] = _i1.EndpointConnector(
      name: 'basicTypes',
      endpoint: endpoints['basicTypes']!,
      methodConnectors: {
        'testInt': _i1.MethodConnector(
          name: 'testInt',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testInt(
            session,
            params['value'],
          ),
        ),
        'testDouble': _i1.MethodConnector(
          name: 'testDouble',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testDouble(
            session,
            params['value'],
          ),
        ),
        'testBool': _i1.MethodConnector(
          name: 'testBool',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testBool(
            session,
            params['value'],
          ),
        ),
        'testDateTime': _i1.MethodConnector(
          name: 'testDateTime',
          params: {
            'dateTime': _i1.ParameterDescription(
              name: 'dateTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testDateTime(
            session,
            params['dateTime'],
          ),
        ),
        'testString': _i1.MethodConnector(
          name: 'testString',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testString(
            session,
            params['value'],
          ),
        ),
        'testByteData': _i1.MethodConnector(
          name: 'testByteData',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i39.ByteData?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testByteData(
            session,
            params['value'],
          ),
        ),
        'testDuration': _i1.MethodConnector(
          name: 'testDuration',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testDuration(
            session,
            params['value'],
          ),
        ),
        'testUuid': _i1.MethodConnector(
          name: 'testUuid',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i40.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testUuid(
            session,
            params['value'],
          ),
        ),
        'testUri': _i1.MethodConnector(
          name: 'testUri',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Uri?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testUri(
            session,
            params['value'],
          ),
        ),
        'testBigInt': _i1.MethodConnector(
          name: 'testBigInt',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<BigInt?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testBigInt(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['basicTypesStreaming'] = _i1.EndpointConnector(
      name: 'basicTypesStreaming',
      endpoint: endpoints['basicTypesStreaming']!,
      methodConnectors: {
        'testInt': _i1.MethodStreamConnector(
          name: 'testInt',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<int?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testInt(
            session,
            streamParams['value']!.cast<int?>(),
          ),
        ),
        'testDouble': _i1.MethodStreamConnector(
          name: 'testDouble',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<double?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testDouble(
            session,
            streamParams['value']!.cast<double?>(),
          ),
        ),
        'testBool': _i1.MethodStreamConnector(
          name: 'testBool',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<bool?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testBool(
            session,
            streamParams['value']!.cast<bool?>(),
          ),
        ),
        'testDateTime': _i1.MethodStreamConnector(
          name: 'testDateTime',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<DateTime?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testDateTime(
            session,
            streamParams['value']!.cast<DateTime?>(),
          ),
        ),
        'testString': _i1.MethodStreamConnector(
          name: 'testString',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<String?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testString(
            session,
            streamParams['value']!.cast<String?>(),
          ),
        ),
        'testByteData': _i1.MethodStreamConnector(
          name: 'testByteData',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<_i39.ByteData?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testByteData(
            session,
            streamParams['value']!.cast<_i39.ByteData?>(),
          ),
        ),
        'testDuration': _i1.MethodStreamConnector(
          name: 'testDuration',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<Duration?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testDuration(
            session,
            streamParams['value']!.cast<Duration?>(),
          ),
        ),
        'testUuid': _i1.MethodStreamConnector(
          name: 'testUuid',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<_i40.UuidValue?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testUuid(
            session,
            streamParams['value']!.cast<_i40.UuidValue?>(),
          ),
        ),
        'testUri': _i1.MethodStreamConnector(
          name: 'testUri',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<Uri?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testUri(
            session,
            streamParams['value']!.cast<Uri?>(),
          ),
        ),
        'testBigInt': _i1.MethodStreamConnector(
          name: 'testBigInt',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<BigInt?>(
              name: 'value',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['basicTypesStreaming']
                      as _i5.BasicTypesStreamingEndpoint)
                  .testBigInt(
            session,
            streamParams['value']!.cast<BigInt?>(),
          ),
        ),
      },
    );
    connectors['cloudStorage'] = _i1.EndpointConnector(
      name: 'cloudStorage',
      endpoint: endpoints['cloudStorage']!,
      methodConnectors: {
        'reset': _i1.MethodConnector(
          name: 'reset',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .reset(session),
        ),
        'storePublicFile': _i1.MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'byteData': _i1.ParameterDescription(
              name: 'byteData',
              type: _i1.getType<_i39.ByteData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .storePublicFile(
            session,
            params['path'],
            params['byteData'],
          ),
        ),
        'retrievePublicFile': _i1.MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .retrievePublicFile(
            session,
            params['path'],
          ),
        ),
        'existsPublicFile': _i1.MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .existsPublicFile(
            session,
            params['path'],
          ),
        ),
        'deletePublicFile': _i1.MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .deletePublicFile(
            session,
            params['path'],
          ),
        ),
        'getPublicUrlForFile': _i1.MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .getPublicUrlForFile(
            session,
            params['path'],
          ),
        ),
        'getDirectFilePostUrl': _i1.MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .getDirectFilePostUrl(
            session,
            params['path'],
          ),
        ),
        'verifyDirectFileUpload': _i1.MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i6.CloudStorageEndpoint)
                  .verifyDirectFileUpload(
            session,
            params['path'],
          ),
        ),
      },
    );
    connectors['s3CloudStorage'] = _i1.EndpointConnector(
      name: 's3CloudStorage',
      endpoint: endpoints['s3CloudStorage']!,
      methodConnectors: {
        'storePublicFile': _i1.MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'byteData': _i1.ParameterDescription(
              name: 'byteData',
              type: _i1.getType<_i39.ByteData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i7.S3CloudStorageEndpoint)
                  .storePublicFile(
            session,
            params['path'],
            params['byteData'],
          ),
        ),
        'retrievePublicFile': _i1.MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i7.S3CloudStorageEndpoint)
                  .retrievePublicFile(
            session,
            params['path'],
          ),
        ),
        'existsPublicFile': _i1.MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i7.S3CloudStorageEndpoint)
                  .existsPublicFile(
            session,
            params['path'],
          ),
        ),
        'deletePublicFile': _i1.MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i7.S3CloudStorageEndpoint)
                  .deletePublicFile(
            session,
            params['path'],
          ),
        ),
        'getPublicUrlForFile': _i1.MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i7.S3CloudStorageEndpoint)
                  .getPublicUrlForFile(
            session,
            params['path'],
          ),
        ),
        'getDirectFilePostUrl': _i1.MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i7.S3CloudStorageEndpoint)
                  .getDirectFilePostUrl(
            session,
            params['path'],
          ),
        ),
        'verifyDirectFileUpload': _i1.MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i7.S3CloudStorageEndpoint)
                  .verifyDirectFileUpload(
            session,
            params['path'],
          ),
        ),
      },
    );
    connectors['customClassProtocol'] = _i1.EndpointConnector(
      name: 'customClassProtocol',
      endpoint: endpoints['customClassProtocol']!,
      methodConnectors: {
        'getProtocolField': _i1.MethodConnector(
          name: 'getProtocolField',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customClassProtocol']
                      as _i8.CustomClassProtocolEndpoint)
                  .getProtocolField(session),
        )
      },
    );
    connectors['customTypes'] = _i1.EndpointConnector(
      name: 'customTypes',
      endpoint: endpoints['customTypes']!,
      methodConnectors: {
        'returnCustomClass': _i1.MethodConnector(
          name: 'returnCustomClass',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i41.CustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnCustomClass(
            session,
            params['data'],
          ),
        ),
        'returnCustomClassNullable': _i1.MethodConnector(
          name: 'returnCustomClassNullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i41.CustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnCustomClassNullable(
            session,
            params['data'],
          ),
        ),
        'returnCustomClass2': _i1.MethodConnector(
          name: 'returnCustomClass2',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i41.CustomClass2>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnCustomClass2(
            session,
            params['data'],
          ),
        ),
        'returnCustomClass2Nullable': _i1.MethodConnector(
          name: 'returnCustomClass2Nullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i41.CustomClass2?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnCustomClass2Nullable(
            session,
            params['data'],
          ),
        ),
        'returnExternalCustomClass': _i1.MethodConnector(
          name: 'returnExternalCustomClass',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i42.ExternalCustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnExternalCustomClass(
            session,
            params['data'],
          ),
        ),
        'returnExternalCustomClassNullable': _i1.MethodConnector(
          name: 'returnExternalCustomClassNullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i42.ExternalCustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnExternalCustomClassNullable(
            session,
            params['data'],
          ),
        ),
        'returnFreezedCustomClass': _i1.MethodConnector(
          name: 'returnFreezedCustomClass',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i43.FreezedCustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnFreezedCustomClass(
            session,
            params['data'],
          ),
        ),
        'returnFreezedCustomClassNullable': _i1.MethodConnector(
          name: 'returnFreezedCustomClassNullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i43.FreezedCustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnFreezedCustomClassNullable(
            session,
            params['data'],
          ),
        ),
        'returnCustomClassWithoutProtocolSerialization': _i1.MethodConnector(
          name: 'returnCustomClassWithoutProtocolSerialization',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i41.CustomClassWithoutProtocolSerialization>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnCustomClassWithoutProtocolSerialization(
            session,
            params['data'],
          ),
        ),
        'returnCustomClassWithProtocolSerialization': _i1.MethodConnector(
          name: 'returnCustomClassWithProtocolSerialization',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i41.CustomClassWithProtocolSerialization>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnCustomClassWithProtocolSerialization(
            session,
            params['data'],
          ),
        ),
        'returnCustomClassWithProtocolSerializationMethod': _i1.MethodConnector(
          name: 'returnCustomClassWithProtocolSerializationMethod',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1
                  .getType<_i41.CustomClassWithProtocolSerializationMethod>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i9.CustomTypesEndpoint)
                  .returnCustomClassWithProtocolSerializationMethod(
            session,
            params['data'],
          ),
        ),
      },
    );
    connectors['basicDatabase'] = _i1.EndpointConnector(
      name: 'basicDatabase',
      endpoint: endpoints['basicDatabase']!,
      methodConnectors: {
        'deleteAllSimpleTestData': _i1.MethodConnector(
          name: 'deleteAllSimpleTestData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .deleteAllSimpleTestData(session),
        ),
        'deleteSimpleTestDataLessThan': _i1.MethodConnector(
          name: 'deleteSimpleTestDataLessThan',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .deleteSimpleTestDataLessThan(
            session,
            params['num'],
          ),
        ),
        'findAndDeleteSimpleTestData': _i1.MethodConnector(
          name: 'findAndDeleteSimpleTestData',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .findAndDeleteSimpleTestData(
            session,
            params['num'],
          ),
        ),
        'createSimpleTestData': _i1.MethodConnector(
          name: 'createSimpleTestData',
          params: {
            'numRows': _i1.ParameterDescription(
              name: 'numRows',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .createSimpleTestData(
            session,
            params['numRows'],
          ),
        ),
        'findSimpleData': _i1.MethodConnector(
          name: 'findSimpleData',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase).findSimpleData(
            session,
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'findFirstRowSimpleData': _i1.MethodConnector(
          name: 'findFirstRowSimpleData',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .findFirstRowSimpleData(
            session,
            params['num'],
          ),
        ),
        'findByIdSimpleData': _i1.MethodConnector(
          name: 'findByIdSimpleData',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .findByIdSimpleData(
            session,
            params['id'],
          ),
        ),
        'findSimpleDataRowsLessThan': _i1.MethodConnector(
          name: 'findSimpleDataRowsLessThan',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'descending': _i1.ParameterDescription(
              name: 'descending',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .findSimpleDataRowsLessThan(
            session,
            params['num'],
            params['offset'],
            params['limit'],
            params['descending'],
          ),
        ),
        'insertRowSimpleData': _i1.MethodConnector(
          name: 'insertRowSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i44.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .insertRowSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'updateRowSimpleData': _i1.MethodConnector(
          name: 'updateRowSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i44.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .updateRowSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'deleteRowSimpleData': _i1.MethodConnector(
          name: 'deleteRowSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i44.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .deleteRowSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'deleteWhereSimpleData': _i1.MethodConnector(
          name: 'deleteWhereSimpleData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .deleteWhereSimpleData(session),
        ),
        'countSimpleData': _i1.MethodConnector(
          name: 'countSimpleData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .countSimpleData(session),
        ),
        'insertTypes': _i1.MethodConnector(
          name: 'insertTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i45.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase).insertTypes(
            session,
            params['value'],
          ),
        ),
        'updateTypes': _i1.MethodConnector(
          name: 'updateTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i45.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase).updateTypes(
            session,
            params['value'],
          ),
        ),
        'countTypesRows': _i1.MethodConnector(
          name: 'countTypesRows',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .countTypesRows(session),
        ),
        'deleteAllInTypes': _i1.MethodConnector(
          name: 'deleteAllInTypes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .deleteAllInTypes(session),
        ),
        'getTypes': _i1.MethodConnector(
          name: 'getTypes',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase).getTypes(
            session,
            params['id'],
          ),
        ),
        'getTypesRawQuery': _i1.MethodConnector(
          name: 'getTypesRawQuery',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .getTypesRawQuery(
            session,
            params['id'],
          ),
        ),
        'storeObjectWithEnum': _i1.MethodConnector(
          name: 'storeObjectWithEnum',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i46.ObjectWithEnum>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .storeObjectWithEnum(
            session,
            params['object'],
          ),
        ),
        'getObjectWithEnum': _i1.MethodConnector(
          name: 'getObjectWithEnum',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .getObjectWithEnum(
            session,
            params['id'],
          ),
        ),
        'storeObjectWithObject': _i1.MethodConnector(
          name: 'storeObjectWithObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i47.ObjectWithObject>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .storeObjectWithObject(
            session,
            params['object'],
          ),
        ),
        'getObjectWithObject': _i1.MethodConnector(
          name: 'getObjectWithObject',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .getObjectWithObject(
            session,
            params['id'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .deleteAll(session),
        ),
        'testByteDataStore': _i1.MethodConnector(
          name: 'testByteDataStore',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i10.BasicDatabase)
                  .testByteDataStore(session),
        ),
      },
    );
    connectors['transactionsDatabase'] = _i1.EndpointConnector(
      name: 'transactionsDatabase',
      endpoint: endpoints['transactionsDatabase']!,
      methodConnectors: {
        'removeRow': _i1.MethodConnector(
          name: 'removeRow',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transactionsDatabase']
                      as _i11.TransactionsDatabaseEndpoint)
                  .removeRow(
            session,
            params['num'],
          ),
        ),
        'updateInsertDelete': _i1.MethodConnector(
          name: 'updateInsertDelete',
          params: {
            'numUpdate': _i1.ParameterDescription(
              name: 'numUpdate',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'numInsert': _i1.ParameterDescription(
              name: 'numInsert',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'numDelete': _i1.ParameterDescription(
              name: 'numDelete',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transactionsDatabase']
                      as _i11.TransactionsDatabaseEndpoint)
                  .updateInsertDelete(
            session,
            params['numUpdate'],
            params['numInsert'],
            params['numDelete'],
          ),
        ),
      },
    );
    connectors['deprecation'] = _i1.EndpointConnector(
      name: 'deprecation',
      endpoint: endpoints['deprecation']!,
      methodConnectors: {
        'setGlobalDouble': _i1.MethodConnector(
          name: 'setGlobalDouble',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['deprecation'] as _i12.DeprecationEndpoint)
                  .
// ignore: deprecated_member_use_from_same_package
                  setGlobalDouble(
            session,
            params['value'],
          ),
        ),
        'getGlobalDouble': _i1.MethodConnector(
          name: 'getGlobalDouble',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['deprecation'] as _i12.DeprecationEndpoint)
                  .
// ignore: deprecated_member_use_from_same_package
                  getGlobalDouble(session),
        ),
      },
    );
    connectors['echoRequest'] = _i1.EndpointConnector(
      name: 'echoRequest',
      endpoint: endpoints['echoRequest']!,
      methodConnectors: {
        'echoAuthenticationKey': _i1.MethodConnector(
          name: 'echoAuthenticationKey',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['echoRequest'] as _i13.EchoRequestEndpoint)
                  .echoAuthenticationKey(session),
        ),
        'echoHttpHeader': _i1.MethodConnector(
          name: 'echoHttpHeader',
          params: {
            'headerName': _i1.ParameterDescription(
              name: 'headerName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['echoRequest'] as _i13.EchoRequestEndpoint)
                  .echoHttpHeader(
            session,
            params['headerName'],
          ),
        ),
      },
    );
    connectors['emailAuthTestMethods'] = _i1.EndpointConnector(
      name: 'emailAuthTestMethods',
      endpoint: endpoints['emailAuthTestMethods']!,
      methodConnectors: {
        'findVerificationCode': _i1.MethodConnector(
          name: 'findVerificationCode',
          params: {
            'userName': _i1.ParameterDescription(
              name: 'userName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['emailAuthTestMethods'] as _i14.EmailAuthTestMethods)
                  .findVerificationCode(
            session,
            params['userName'],
            params['email'],
          ),
        ),
        'findResetCode': _i1.MethodConnector(
          name: 'findResetCode',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['emailAuthTestMethods'] as _i14.EmailAuthTestMethods)
                  .findResetCode(
            session,
            params['email'],
          ),
        ),
        'tearDown': _i1.MethodConnector(
          name: 'tearDown',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['emailAuthTestMethods'] as _i14.EmailAuthTestMethods)
                  .tearDown(session),
        ),
        'createUser': _i1.MethodConnector(
          name: 'createUser',
          params: {
            'userName': _i1.ParameterDescription(
              name: 'userName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['emailAuthTestMethods'] as _i14.EmailAuthTestMethods)
                  .createUser(
            session,
            params['userName'],
            params['email'],
            params['password'],
          ),
        ),
      },
    );
    connectors['exceptionTest'] = _i1.EndpointConnector(
      name: 'exceptionTest',
      endpoint: endpoints['exceptionTest']!,
      methodConnectors: {
        'throwNormalException': _i1.MethodConnector(
          name: 'throwNormalException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i15.ExceptionTestEndpoint)
                  .throwNormalException(session),
        ),
        'throwExceptionWithData': _i1.MethodConnector(
          name: 'throwExceptionWithData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i15.ExceptionTestEndpoint)
                  .throwExceptionWithData(session),
        ),
        'workingWithoutException': _i1.MethodConnector(
          name: 'workingWithoutException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i15.ExceptionTestEndpoint)
                  .workingWithoutException(session),
        ),
      },
    );
    connectors['failedCalls'] = _i1.EndpointConnector(
      name: 'failedCalls',
      endpoint: endpoints['failedCalls']!,
      methodConnectors: {
        'failedCall': _i1.MethodConnector(
          name: 'failedCall',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i16.FailedCallsEndpoint)
                  .failedCall(session),
        ),
        'failedDatabaseQuery': _i1.MethodConnector(
          name: 'failedDatabaseQuery',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i16.FailedCallsEndpoint)
                  .failedDatabaseQuery(session),
        ),
        'failedDatabaseQueryCaughtException': _i1.MethodConnector(
          name: 'failedDatabaseQueryCaughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i16.FailedCallsEndpoint)
                  .failedDatabaseQueryCaughtException(session),
        ),
        'slowCall': _i1.MethodConnector(
          name: 'slowCall',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i16.FailedCallsEndpoint)
                  .slowCall(session),
        ),
        'caughtException': _i1.MethodConnector(
          name: 'caughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i16.FailedCallsEndpoint)
                  .caughtException(session),
        ),
      },
    );
    connectors['fieldScopes'] = _i1.EndpointConnector(
      name: 'fieldScopes',
      endpoint: endpoints['fieldScopes']!,
      methodConnectors: {
        'storeObject': _i1.MethodConnector(
          name: 'storeObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i48.ObjectFieldScopes>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['fieldScopes'] as _i17.FieldScopesEndpoint)
                  .storeObject(
            session,
            params['object'],
          ),
        ),
        'retrieveObject': _i1.MethodConnector(
          name: 'retrieveObject',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['fieldScopes'] as _i17.FieldScopesEndpoint)
                  .retrieveObject(session),
        ),
      },
    );
    connectors['futureCalls'] = _i1.EndpointConnector(
      name: 'futureCalls',
      endpoint: endpoints['futureCalls']!,
      methodConnectors: {
        'makeFutureCall': _i1.MethodConnector(
          name: 'makeFutureCall',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i44.SimpleData?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['futureCalls'] as _i18.FutureCallsEndpoint)
                  .makeFutureCall(
            session,
            params['data'],
          ),
        )
      },
    );
    connectors['listParameters'] = _i1.EndpointConnector(
      name: 'listParameters',
      endpoint: endpoints['listParameters']!,
      methodConnectors: {
        'returnIntList': _i1.MethodConnector(
          name: 'returnIntList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnIntList(
            session,
            params['list'],
          ),
        ),
        'returnIntListList': _i1.MethodConnector(
          name: 'returnIntListList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<List<int>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnIntListList(
            session,
            params['list'],
          ),
        ),
        'returnIntListNullable': _i1.MethodConnector(
          name: 'returnIntListNullable',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnIntListNullable(
            session,
            params['list'],
          ),
        ),
        'returnIntListNullableList': _i1.MethodConnector(
          name: 'returnIntListNullableList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<List<int>?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnIntListNullableList(
            session,
            params['list'],
          ),
        ),
        'returnIntListListNullable': _i1.MethodConnector(
          name: 'returnIntListListNullable',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<List<int>>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnIntListListNullable(
            session,
            params['list'],
          ),
        ),
        'returnIntListNullableInts': _i1.MethodConnector(
          name: 'returnIntListNullableInts',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnIntListNullableInts(
            session,
            params['list'],
          ),
        ),
        'returnNullableIntListNullableInts': _i1.MethodConnector(
          name: 'returnNullableIntListNullableInts',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnNullableIntListNullableInts(
            session,
            params['list'],
          ),
        ),
        'returnDoubleList': _i1.MethodConnector(
          name: 'returnDoubleList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnDoubleList(
            session,
            params['list'],
          ),
        ),
        'returnDoubleListNullableDoubles': _i1.MethodConnector(
          name: 'returnDoubleListNullableDoubles',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<double?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnDoubleListNullableDoubles(
            session,
            params['list'],
          ),
        ),
        'returnBoolList': _i1.MethodConnector(
          name: 'returnBoolList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnBoolList(
            session,
            params['list'],
          ),
        ),
        'returnBoolListNullableBools': _i1.MethodConnector(
          name: 'returnBoolListNullableBools',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<bool?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnBoolListNullableBools(
            session,
            params['list'],
          ),
        ),
        'returnStringList': _i1.MethodConnector(
          name: 'returnStringList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnStringList(
            session,
            params['list'],
          ),
        ),
        'returnStringListNullableStrings': _i1.MethodConnector(
          name: 'returnStringListNullableStrings',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<String?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnStringListNullableStrings(
            session,
            params['list'],
          ),
        ),
        'returnDateTimeList': _i1.MethodConnector(
          name: 'returnDateTimeList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnDateTimeList(
            session,
            params['list'],
          ),
        ),
        'returnDateTimeListNullableDateTimes': _i1.MethodConnector(
          name: 'returnDateTimeListNullableDateTimes',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<DateTime?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnDateTimeListNullableDateTimes(
            session,
            params['list'],
          ),
        ),
        'returnByteDataList': _i1.MethodConnector(
          name: 'returnByteDataList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i39.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnByteDataList(
            session,
            params['list'],
          ),
        ),
        'returnByteDataListNullableByteDatas': _i1.MethodConnector(
          name: 'returnByteDataListNullableByteDatas',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i39.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnByteDataListNullableByteDatas(
            session,
            params['list'],
          ),
        ),
        'returnSimpleDataList': _i1.MethodConnector(
          name: 'returnSimpleDataList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i44.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnSimpleDataList(
            session,
            params['list'],
          ),
        ),
        'returnSimpleDataListNullableSimpleData': _i1.MethodConnector(
          name: 'returnSimpleDataListNullableSimpleData',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i44.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnSimpleDataListNullableSimpleData(
            session,
            params['list'],
          ),
        ),
        'returnSimpleDataListNullable': _i1.MethodConnector(
          name: 'returnSimpleDataListNullable',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i44.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnSimpleDataListNullable(
            session,
            params['list'],
          ),
        ),
        'returnNullableSimpleDataListNullableSimpleData': _i1.MethodConnector(
          name: 'returnNullableSimpleDataListNullableSimpleData',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i44.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnNullableSimpleDataListNullableSimpleData(
            session,
            params['list'],
          ),
        ),
        'returnDurationList': _i1.MethodConnector(
          name: 'returnDurationList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnDurationList(
            session,
            params['list'],
          ),
        ),
        'returnDurationListNullableDurations': _i1.MethodConnector(
          name: 'returnDurationListNullableDurations',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<Duration?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i19.ListParametersEndpoint)
                  .returnDurationListNullableDurations(
            session,
            params['list'],
          ),
        ),
      },
    );
    connectors['logging'] = _i1.EndpointConnector(
      name: 'logging',
      endpoint: endpoints['logging']!,
      methodConnectors: {
        'slowQueryMethod': _i1.MethodConnector(
          name: 'slowQueryMethod',
          params: {
            'seconds': _i1.ParameterDescription(
              name: 'seconds',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint).slowQueryMethod(
            session,
            params['seconds'],
          ),
        ),
        'queryMethod': _i1.MethodConnector(
          name: 'queryMethod',
          params: {
            'queries': _i1.ParameterDescription(
              name: 'queries',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint).queryMethod(
            session,
            params['queries'],
          ),
        ),
        'failedQueryMethod': _i1.MethodConnector(
          name: 'failedQueryMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint)
                  .failedQueryMethod(session),
        ),
        'slowMethod': _i1.MethodConnector(
          name: 'slowMethod',
          params: {
            'delayMillis': _i1.ParameterDescription(
              name: 'delayMillis',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint).slowMethod(
            session,
            params['delayMillis'],
          ),
        ),
        'failingMethod': _i1.MethodConnector(
          name: 'failingMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint)
                  .failingMethod(session),
        ),
        'emptyMethod': _i1.MethodConnector(
          name: 'emptyMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint)
                  .emptyMethod(session),
        ),
        'log': _i1.MethodConnector(
          name: 'log',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'logLevels': _i1.ParameterDescription(
              name: 'logLevels',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint).log(
            session,
            params['message'],
            params['logLevels'],
          ),
        ),
        'logInfo': _i1.MethodConnector(
          name: 'logInfo',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint).logInfo(
            session,
            params['message'],
          ),
        ),
        'logDebugAndInfoAndError': _i1.MethodConnector(
          name: 'logDebugAndInfoAndError',
          params: {
            'debug': _i1.ParameterDescription(
              name: 'debug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'info': _i1.ParameterDescription(
              name: 'info',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'error': _i1.ParameterDescription(
              name: 'error',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint)
                  .logDebugAndInfoAndError(
            session,
            params['debug'],
            params['info'],
            params['error'],
          ),
        ),
        'twoQueries': _i1.MethodConnector(
          name: 'twoQueries',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i20.LoggingEndpoint)
                  .twoQueries(session),
        ),
        'streamEmpty': _i1.MethodStreamConnector(
          name: 'streamEmpty',
          params: {},
          streamParams: {
            'input': _i1.StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['logging'] as _i20.LoggingEndpoint).streamEmpty(
            session,
            streamParams['input']!.cast<int>(),
          ),
        ),
        'streamLogging': _i1.MethodStreamConnector(
          name: 'streamLogging',
          params: {},
          streamParams: {
            'input': _i1.StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['logging'] as _i20.LoggingEndpoint).streamLogging(
            session,
            streamParams['input']!.cast<int>(),
          ),
        ),
        'streamQueryLogging': _i1.MethodStreamConnector(
          name: 'streamQueryLogging',
          params: {},
          streamParams: {
            'input': _i1.StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['logging'] as _i20.LoggingEndpoint).streamQueryLogging(
            session,
            streamParams['input']!.cast<int>(),
          ),
        ),
        'streamException': _i1.MethodStreamConnector(
          name: 'streamException',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['logging'] as _i20.LoggingEndpoint)
                  .streamException(session),
        ),
      },
    );
    connectors['streamLogging'] = _i1.EndpointConnector(
      name: 'streamLogging',
      endpoint: endpoints['streamLogging']!,
      methodConnectors: {},
    );
    connectors['streamQueryLogging'] = _i1.EndpointConnector(
      name: 'streamQueryLogging',
      endpoint: endpoints['streamQueryLogging']!,
      methodConnectors: {},
    );
    connectors['loggingDisabled'] = _i1.EndpointConnector(
      name: 'loggingDisabled',
      endpoint: endpoints['loggingDisabled']!,
      methodConnectors: {
        'logInfo': _i1.MethodConnector(
          name: 'logInfo',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['loggingDisabled'] as _i21.LoggingDisabledEndpoint)
                  .logInfo(
            session,
            params['message'],
          ),
        )
      },
    );
    connectors['mapParameters'] = _i1.EndpointConnector(
      name: 'mapParameters',
      endpoint: endpoints['mapParameters']!,
      methodConnectors: {
        'returnIntMap': _i1.MethodConnector(
          name: 'returnIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnIntMap(
            session,
            params['map'],
          ),
        ),
        'returnIntMapNullable': _i1.MethodConnector(
          name: 'returnIntMapNullable',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnIntMapNullable(
            session,
            params['map'],
          ),
        ),
        'returnNestedIntMap': _i1.MethodConnector(
          name: 'returnNestedIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Map<String, int>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnNestedIntMap(
            session,
            params['map'],
          ),
        ),
        'returnIntMapNullableInts': _i1.MethodConnector(
          name: 'returnIntMapNullableInts',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnIntMapNullableInts(
            session,
            params['map'],
          ),
        ),
        'returnNullableIntMapNullableInts': _i1.MethodConnector(
          name: 'returnNullableIntMapNullableInts',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnNullableIntMapNullableInts(
            session,
            params['map'],
          ),
        ),
        'returnIntIntMap': _i1.MethodConnector(
          name: 'returnIntIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<int, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnIntIntMap(
            session,
            params['map'],
          ),
        ),
        'returnEnumIntMap': _i1.MethodConnector(
          name: 'returnEnumIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<_i49.TestEnum, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnEnumIntMap(
            session,
            params['map'],
          ),
        ),
        'returnEnumMap': _i1.MethodConnector(
          name: 'returnEnumMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i49.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnEnumMap(
            session,
            params['map'],
          ),
        ),
        'returnDoubleMap': _i1.MethodConnector(
          name: 'returnDoubleMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnDoubleMap(
            session,
            params['map'],
          ),
        ),
        'returnDoubleMapNullableDoubles': _i1.MethodConnector(
          name: 'returnDoubleMapNullableDoubles',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, double?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnDoubleMapNullableDoubles(
            session,
            params['map'],
          ),
        ),
        'returnBoolMap': _i1.MethodConnector(
          name: 'returnBoolMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnBoolMap(
            session,
            params['map'],
          ),
        ),
        'returnBoolMapNullableBools': _i1.MethodConnector(
          name: 'returnBoolMapNullableBools',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, bool?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnBoolMapNullableBools(
            session,
            params['map'],
          ),
        ),
        'returnStringMap': _i1.MethodConnector(
          name: 'returnStringMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnStringMap(
            session,
            params['map'],
          ),
        ),
        'returnStringMapNullableStrings': _i1.MethodConnector(
          name: 'returnStringMapNullableStrings',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, String?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnStringMapNullableStrings(
            session,
            params['map'],
          ),
        ),
        'returnDateTimeMap': _i1.MethodConnector(
          name: 'returnDateTimeMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnDateTimeMap(
            session,
            params['map'],
          ),
        ),
        'returnDateTimeMapNullableDateTimes': _i1.MethodConnector(
          name: 'returnDateTimeMapNullableDateTimes',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, DateTime?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnDateTimeMapNullableDateTimes(
            session,
            params['map'],
          ),
        ),
        'returnByteDataMap': _i1.MethodConnector(
          name: 'returnByteDataMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i39.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnByteDataMap(
            session,
            params['map'],
          ),
        ),
        'returnByteDataMapNullableByteDatas': _i1.MethodConnector(
          name: 'returnByteDataMapNullableByteDatas',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i39.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnByteDataMapNullableByteDatas(
            session,
            params['map'],
          ),
        ),
        'returnSimpleDataMap': _i1.MethodConnector(
          name: 'returnSimpleDataMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i44.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnSimpleDataMap(
            session,
            params['map'],
          ),
        ),
        'returnSimpleDataMapNullableSimpleData': _i1.MethodConnector(
          name: 'returnSimpleDataMapNullableSimpleData',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i44.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnSimpleDataMapNullableSimpleData(
            session,
            params['map'],
          ),
        ),
        'returnSimpleDataMapNullable': _i1.MethodConnector(
          name: 'returnSimpleDataMapNullable',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i44.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnSimpleDataMapNullable(
            session,
            params['map'],
          ),
        ),
        'returnNullableSimpleDataMapNullableSimpleData': _i1.MethodConnector(
          name: 'returnNullableSimpleDataMapNullableSimpleData',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i44.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnNullableSimpleDataMapNullableSimpleData(
            session,
            params['map'],
          ),
        ),
        'returnDurationMap': _i1.MethodConnector(
          name: 'returnDurationMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnDurationMap(
            session,
            params['map'],
          ),
        ),
        'returnDurationMapNullableDurations': _i1.MethodConnector(
          name: 'returnDurationMapNullableDurations',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Duration?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i22.MapParametersEndpoint)
                  .returnDurationMapNullableDurations(
            session,
            params['map'],
          ),
        ),
      },
    );
    connectors['methodSignaturePermutations'] = _i1.EndpointConnector(
      name: 'methodSignaturePermutations',
      endpoint: endpoints['methodSignaturePermutations']!,
      methodConnectors: {
        'echoPositionalArg': _i1.MethodConnector(
          name: 'echoPositionalArg',
          params: {
            'string': _i1.ParameterDescription(
              name: 'string',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoPositionalArg(
            session,
            params['string'],
          ),
        ),
        'echoNamedArg': _i1.MethodConnector(
          name: 'echoNamedArg',
          params: {
            'string': _i1.ParameterDescription(
              name: 'string',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoNamedArg(
            session,
            string: params['string'],
          ),
        ),
        'echoNullableNamedArg': _i1.MethodConnector(
          name: 'echoNullableNamedArg',
          params: {
            'string': _i1.ParameterDescription(
              name: 'string',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoNullableNamedArg(
            session,
            string: params['string'],
          ),
        ),
        'echoOptionalArg': _i1.MethodConnector(
          name: 'echoOptionalArg',
          params: {
            'string': _i1.ParameterDescription(
              name: 'string',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoOptionalArg(
            session,
            params['string'],
          ),
        ),
        'echoPositionalAndNamedArgs': _i1.MethodConnector(
          name: 'echoPositionalAndNamedArgs',
          params: {
            'string1': _i1.ParameterDescription(
              name: 'string1',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'string2': _i1.ParameterDescription(
              name: 'string2',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoPositionalAndNamedArgs(
            session,
            params['string1'],
            string2: params['string2'],
          ),
        ),
        'echoPositionalAndNullableNamedArgs': _i1.MethodConnector(
          name: 'echoPositionalAndNullableNamedArgs',
          params: {
            'string1': _i1.ParameterDescription(
              name: 'string1',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'string2': _i1.ParameterDescription(
              name: 'string2',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoPositionalAndNullableNamedArgs(
            session,
            params['string1'],
            string2: params['string2'],
          ),
        ),
        'echoPositionalAndOptionalArgs': _i1.MethodConnector(
          name: 'echoPositionalAndOptionalArgs',
          params: {
            'string1': _i1.ParameterDescription(
              name: 'string1',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'string2': _i1.ParameterDescription(
              name: 'string2',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoPositionalAndOptionalArgs(
            session,
            params['string1'],
            params['string2'],
          ),
        ),
        'echoNamedArgStream': _i1.MethodStreamConnector(
          name: 'echoNamedArgStream',
          params: {},
          streamParams: {
            'strings': _i1.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoNamedArgStream(
            session,
            strings: streamParams['strings']!.cast<String>(),
          ),
        ),
        'echoNamedArgStreamAsFuture': _i1.MethodStreamConnector(
          name: 'echoNamedArgStreamAsFuture',
          params: {},
          streamParams: {
            'strings': _i1.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoNamedArgStreamAsFuture(
            session,
            strings: streamParams['strings']!.cast<String>(),
          ),
        ),
        'echoPositionalArgStream': _i1.MethodStreamConnector(
          name: 'echoPositionalArgStream',
          params: {},
          streamParams: {
            'strings': _i1.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoPositionalArgStream(
            session,
            streamParams['strings']!.cast<String>(),
          ),
        ),
        'echoPositionalArgStreamAsFuture': _i1.MethodStreamConnector(
          name: 'echoPositionalArgStreamAsFuture',
          params: {},
          streamParams: {
            'strings': _i1.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodSignaturePermutations']
                      as _i23.MethodSignaturePermutationsEndpoint)
                  .echoPositionalArgStreamAsFuture(
            session,
            streamParams['strings']!.cast<String>(),
          ),
        ),
      },
    );
    connectors['methodStreaming'] = _i1.EndpointConnector(
      name: 'methodStreaming',
      endpoint: endpoints['methodStreaming']!,
      methodConnectors: {
        'methodCallEndpoint': _i1.MethodConnector(
          name: 'methodCallEndpoint',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .methodCallEndpoint(session),
        ),
        'wasBroadcastStreamCanceled': _i1.MethodConnector(
          name: 'wasBroadcastStreamCanceled',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .wasBroadcastStreamCanceled(session),
        ),
        'wasSessionWillCloseListenerCalled': _i1.MethodConnector(
          name: 'wasSessionWillCloseListenerCalled',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .wasSessionWillCloseListenerCalled(session),
        ),
        'simpleEndpoint': _i1.MethodConnector(
          name: 'simpleEndpoint',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .simpleEndpoint(session),
        ),
        'intParameter': _i1.MethodConnector(
          name: 'intParameter',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .intParameter(
            session,
            params['value'],
          ),
        ),
        'doubleInputValue': _i1.MethodConnector(
          name: 'doubleInputValue',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .doubleInputValue(
            session,
            params['value'],
          ),
        ),
        'delayedResponse': _i1.MethodConnector(
          name: 'delayedResponse',
          params: {
            'delay': _i1.ParameterDescription(
              name: 'delay',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .delayedResponse(
            session,
            params['delay'],
          ),
        ),
        'completeAllDelayedResponses': _i1.MethodConnector(
          name: 'completeAllDelayedResponses',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .completeAllDelayedResponses(session),
        ),
        'simpleStream': _i1.MethodStreamConnector(
          name: 'simpleStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .simpleStream(session),
        ),
        'neverEndingStreamWithDelay': _i1.MethodStreamConnector(
          name: 'neverEndingStreamWithDelay',
          params: {
            'millisecondsDelay': _i1.ParameterDescription(
              name: 'millisecondsDelay',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .neverEndingStreamWithDelay(
            session,
            params['millisecondsDelay'],
          ),
        ),
        'intReturnFromStream': _i1.MethodStreamConnector(
          name: 'intReturnFromStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .intReturnFromStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'nullableIntReturnFromStream': _i1.MethodStreamConnector(
          name: 'nullableIntReturnFromStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int?>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .nullableIntReturnFromStream(
            session,
            streamParams['stream']!.cast<int?>(),
          ),
        ),
        'getBroadcastStream': _i1.MethodStreamConnector(
          name: 'getBroadcastStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .getBroadcastStream(session),
        ),
        'intStreamFromValue': _i1.MethodStreamConnector(
          name: 'intStreamFromValue',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .intStreamFromValue(
            session,
            params['value'],
          ),
        ),
        'intEchoStream': _i1.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .intEchoStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'dynamicEchoStream': _i1.MethodStreamConnector(
          name: 'dynamicEchoStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<dynamic>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .dynamicEchoStream(
            session,
            streamParams['stream']!.cast<dynamic>(),
          ),
        ),
        'nullableIntEchoStream': _i1.MethodStreamConnector(
          name: 'nullableIntEchoStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int?>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .nullableIntEchoStream(
            session,
            streamParams['stream']!.cast<int?>(),
          ),
        ),
        'voidReturnAfterStream': _i1.MethodStreamConnector(
          name: 'voidReturnAfterStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .voidReturnAfterStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'multipleIntEchoStreams': _i1.MethodStreamConnector(
          name: 'multipleIntEchoStreams',
          params: {},
          streamParams: {
            'stream1': _i1.StreamParameterDescription<int>(
              name: 'stream1',
              nullable: false,
            ),
            'stream2': _i1.StreamParameterDescription<int>(
              name: 'stream2',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .multipleIntEchoStreams(
            session,
            streamParams['stream1']!.cast<int>(),
            streamParams['stream2']!.cast<int>(),
          ),
        ),
        'directVoidReturnWithStreamInput': _i1.MethodStreamConnector(
          name: 'directVoidReturnWithStreamInput',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .directVoidReturnWithStreamInput(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'directOneIntReturnWithStreamInput': _i1.MethodStreamConnector(
          name: 'directOneIntReturnWithStreamInput',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .directOneIntReturnWithStreamInput(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'simpleInputReturnStream': _i1.MethodStreamConnector(
          name: 'simpleInputReturnStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .simpleInputReturnStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'simpleStreamWithParameter': _i1.MethodStreamConnector(
          name: 'simpleStreamWithParameter',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .simpleStreamWithParameter(
            session,
            params['value'],
          ),
        ),
        'simpleDataStream': _i1.MethodStreamConnector(
          name: 'simpleDataStream',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .simpleDataStream(
            session,
            params['value'],
          ),
        ),
        'simpleInOutDataStream': _i1.MethodStreamConnector(
          name: 'simpleInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataStream': _i1.StreamParameterDescription<_i44.SimpleData>(
              name: 'simpleDataStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .simpleInOutDataStream(
            session,
            streamParams['simpleDataStream']!.cast<_i44.SimpleData>(),
          ),
        ),
        'delayedStreamResponse': _i1.MethodStreamConnector(
          name: 'delayedStreamResponse',
          params: {
            'delay': _i1.ParameterDescription(
              name: 'delay',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .delayedStreamResponse(
            session,
            params['delay'],
          ),
        ),
        'delayedNeverListenedInputStream': _i1.MethodStreamConnector(
          name: 'delayedNeverListenedInputStream',
          params: {
            'delay': _i1.ParameterDescription(
              name: 'delay',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .delayedNeverListenedInputStream(
            session,
            params['delay'],
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'delayedPausedInputStream': _i1.MethodStreamConnector(
          name: 'delayedPausedInputStream',
          params: {
            'delay': _i1.ParameterDescription(
              name: 'delay',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .delayedPausedInputStream(
            session,
            params['delay'],
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'inStreamThrowsException': _i1.MethodStreamConnector(
          name: 'inStreamThrowsException',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .inStreamThrowsException(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'inStreamThrowsSerializableException': _i1.MethodStreamConnector(
          name: 'inStreamThrowsSerializableException',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .inStreamThrowsSerializableException(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'outStreamThrowsException': _i1.MethodStreamConnector(
          name: 'outStreamThrowsException',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .outStreamThrowsException(session),
        ),
        'outStreamThrowsSerializableException': _i1.MethodStreamConnector(
          name: 'outStreamThrowsSerializableException',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .outStreamThrowsSerializableException(session),
        ),
        'throwsExceptionVoid': _i1.MethodStreamConnector(
          name: 'throwsExceptionVoid',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .throwsExceptionVoid(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'throwsSerializableExceptionVoid': _i1.MethodStreamConnector(
          name: 'throwsSerializableExceptionVoid',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.voidType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .throwsSerializableExceptionVoid(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'throwsException': _i1.MethodStreamConnector(
          name: 'throwsException',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .throwsException(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'throwsSerializableException': _i1.MethodStreamConnector(
          name: 'throwsSerializableException',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .throwsSerializableException(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'throwsExceptionStream': _i1.MethodStreamConnector(
          name: 'throwsExceptionStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .throwsExceptionStream(session),
        ),
        'exceptionThrownBeforeStreamReturn': _i1.MethodStreamConnector(
          name: 'exceptionThrownBeforeStreamReturn',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .exceptionThrownBeforeStreamReturn(session),
        ),
        'exceptionThrownInStreamReturn': _i1.MethodStreamConnector(
          name: 'exceptionThrownInStreamReturn',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .exceptionThrownInStreamReturn(session),
        ),
        'throwsSerializableExceptionStream': _i1.MethodStreamConnector(
          name: 'throwsSerializableExceptionStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .throwsSerializableExceptionStream(session),
        ),
        'didInputStreamHaveError': _i1.MethodStreamConnector(
          name: 'didInputStreamHaveError',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .didInputStreamHaveError(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'didInputStreamHaveSerializableExceptionError':
            _i1.MethodStreamConnector(
          name: 'didInputStreamHaveSerializableExceptionError',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i24.MethodStreaming)
                  .didInputStreamHaveSerializableExceptionError(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
      },
    );
    connectors['authenticatedMethodStreaming'] = _i1.EndpointConnector(
      name: 'authenticatedMethodStreaming',
      endpoint: endpoints['authenticatedMethodStreaming']!,
      methodConnectors: {
        'simpleStream': _i1.MethodStreamConnector(
          name: 'simpleStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['authenticatedMethodStreaming']
                      as _i24.AuthenticatedMethodStreaming)
                  .simpleStream(session),
        ),
        'intEchoStream': _i1.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['authenticatedMethodStreaming']
                      as _i24.AuthenticatedMethodStreaming)
                  .intEchoStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
      },
    );
    connectors['moduleSerialization'] = _i1.EndpointConnector(
      name: 'moduleSerialization',
      endpoint: endpoints['moduleSerialization']!,
      methodConnectors: {
        'serializeModuleObject': _i1.MethodConnector(
          name: 'serializeModuleObject',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleSerialization']
                      as _i25.ModuleSerializationEndpoint)
                  .serializeModuleObject(session),
        ),
        'modifyModuleObject': _i1.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i50.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleSerialization']
                      as _i25.ModuleSerializationEndpoint)
                  .modifyModuleObject(
            session,
            params['object'],
          ),
        ),
        'serializeNestedModuleObject': _i1.MethodConnector(
          name: 'serializeNestedModuleObject',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleSerialization']
                      as _i25.ModuleSerializationEndpoint)
                  .serializeNestedModuleObject(session),
        ),
      },
    );
    connectors['namedParameters'] = _i1.EndpointConnector(
      name: 'namedParameters',
      endpoint: endpoints['namedParameters']!,
      methodConnectors: {
        'namedParametersMethod': _i1.MethodConnector(
          name: 'namedParametersMethod',
          params: {
            'namedInt': _i1.ParameterDescription(
              name: 'namedInt',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'intWithDefaultValue': _i1.ParameterDescription(
              name: 'intWithDefaultValue',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'nullableInt': _i1.ParameterDescription(
              name: 'nullableInt',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'nullableIntWithDefaultValue': _i1.ParameterDescription(
              name: 'nullableIntWithDefaultValue',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['namedParameters'] as _i26.NamedParametersEndpoint)
                  .namedParametersMethod(
            session,
            namedInt: params['namedInt'],
            intWithDefaultValue: params['intWithDefaultValue'],
            nullableInt: params['nullableInt'],
            nullableIntWithDefaultValue: params['nullableIntWithDefaultValue'],
          ),
        ),
        'namedParametersMethodEqualInts': _i1.MethodConnector(
          name: 'namedParametersMethodEqualInts',
          params: {
            'namedInt': _i1.ParameterDescription(
              name: 'namedInt',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'nullableInt': _i1.ParameterDescription(
              name: 'nullableInt',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['namedParameters'] as _i26.NamedParametersEndpoint)
                  .namedParametersMethodEqualInts(
            session,
            namedInt: params['namedInt'],
            nullableInt: params['nullableInt'],
          ),
        ),
      },
    );
    connectors['optionalParameters'] = _i1.EndpointConnector(
      name: 'optionalParameters',
      endpoint: endpoints['optionalParameters']!,
      methodConnectors: {
        'returnOptionalInt': _i1.MethodConnector(
          name: 'returnOptionalInt',
          params: {
            'optionalInt': _i1.ParameterDescription(
              name: 'optionalInt',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['optionalParameters']
                      as _i27.OptionalParametersEndpoint)
                  .returnOptionalInt(
            session,
            params['optionalInt'],
          ),
        )
      },
    );
    connectors['redis'] = _i1.EndpointConnector(
      name: 'redis',
      endpoint: endpoints['redis']!,
      methodConnectors: {
        'setSimpleData': _i1.MethodConnector(
          name: 'setSimpleData',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i44.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint).setSimpleData(
            session,
            params['key'],
            params['data'],
          ),
        ),
        'setSimpleDataWithLifetime': _i1.MethodConnector(
          name: 'setSimpleDataWithLifetime',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i44.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint)
                  .setSimpleDataWithLifetime(
            session,
            params['key'],
            params['data'],
          ),
        ),
        'getSimpleData': _i1.MethodConnector(
          name: 'getSimpleData',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint).getSimpleData(
            session,
            params['key'],
          ),
        ),
        'deleteSimpleData': _i1.MethodConnector(
          name: 'deleteSimpleData',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint).deleteSimpleData(
            session,
            params['key'],
          ),
        ),
        'resetMessageCentralTest': _i1.MethodConnector(
          name: 'resetMessageCentralTest',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint)
                  .resetMessageCentralTest(session),
        ),
        'listenToChannel': _i1.MethodConnector(
          name: 'listenToChannel',
          params: {
            'channel': _i1.ParameterDescription(
              name: 'channel',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint).listenToChannel(
            session,
            params['channel'],
          ),
        ),
        'postToChannel': _i1.MethodConnector(
          name: 'postToChannel',
          params: {
            'channel': _i1.ParameterDescription(
              name: 'channel',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i44.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint).postToChannel(
            session,
            params['channel'],
            params['data'],
          ),
        ),
        'countSubscribedChannels': _i1.MethodConnector(
          name: 'countSubscribedChannels',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i28.RedisEndpoint)
                  .countSubscribedChannels(session),
        ),
      },
    );
    connectors['serverOnlyScopedFieldModel'] = _i1.EndpointConnector(
      name: 'serverOnlyScopedFieldModel',
      endpoint: endpoints['serverOnlyScopedFieldModel']!,
      methodConnectors: {
        'getScopeServerOnlyField': _i1.MethodConnector(
          name: 'getScopeServerOnlyField',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['serverOnlyScopedFieldModel']
                      as _i29.ServerOnlyScopedFieldModelEndpoint)
                  .getScopeServerOnlyField(session),
        )
      },
    );
    connectors['serverOnlyScopedFieldChildModel'] = _i1.EndpointConnector(
      name: 'serverOnlyScopedFieldChildModel',
      endpoint: endpoints['serverOnlyScopedFieldChildModel']!,
      methodConnectors: {
        'getProtocolField': _i1.MethodConnector(
          name: 'getProtocolField',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['serverOnlyScopedFieldChildModel']
                      as _i30.ServerOnlyScopedFieldChildModelEndpoint)
                  .getProtocolField(session),
        )
      },
    );
    connectors['signInRequired'] = _i1.EndpointConnector(
      name: 'signInRequired',
      endpoint: endpoints['signInRequired']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['signInRequired'] as _i31.SignInRequiredEndpoint)
                  .testMethod(session),
        )
      },
    );
    connectors['adminScopeRequired'] = _i1.EndpointConnector(
      name: 'adminScopeRequired',
      endpoint: endpoints['adminScopeRequired']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['adminScopeRequired']
                      as _i31.AdminScopeRequiredEndpoint)
                  .testMethod(session),
        )
      },
    );
    connectors['simple'] = _i1.EndpointConnector(
      name: 'simple',
      endpoint: endpoints['simple']!,
      methodConnectors: {
        'setGlobalInt': _i1.MethodConnector(
          name: 'setGlobalInt',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'secondValue': _i1.ParameterDescription(
              name: 'secondValue',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i32.SimpleEndpoint).setGlobalInt(
            session,
            params['value'],
            params['secondValue'],
          ),
        ),
        'addToGlobalInt': _i1.MethodConnector(
          name: 'addToGlobalInt',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i32.SimpleEndpoint)
                  .addToGlobalInt(session),
        ),
        'getGlobalInt': _i1.MethodConnector(
          name: 'getGlobalInt',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i32.SimpleEndpoint)
                  .getGlobalInt(session),
        ),
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i32.SimpleEndpoint).hello(
            session,
            params['name'],
          ),
        ),
      },
    );
    connectors['streaming'] = _i1.EndpointConnector(
      name: 'streaming',
      endpoint: endpoints['streaming']!,
      methodConnectors: {},
    );
    connectors['streamingLogging'] = _i1.EndpointConnector(
      name: 'streamingLogging',
      endpoint: endpoints['streamingLogging']!,
      methodConnectors: {},
    );
    connectors['subSubDirTest'] = _i1.EndpointConnector(
      name: 'subSubDirTest',
      endpoint: endpoints['subSubDirTest']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subSubDirTest'] as _i35.SubSubDirTestEndpoint)
                  .testMethod(session),
        )
      },
    );
    connectors['subDirTest'] = _i1.EndpointConnector(
      name: 'subDirTest',
      endpoint: endpoints['subDirTest']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subDirTest'] as _i36.SubDirTestEndpoint)
                  .testMethod(session),
        )
      },
    );
    connectors['testTools'] = _i1.EndpointConnector(
      name: 'testTools',
      endpoint: endpoints['testTools']!,
      methodConnectors: {
        'returnsSessionId': _i1.MethodConnector(
          name: 'returnsSessionId',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsSessionId(session),
        ),
        'returnsSessionEndpointAndMethod': _i1.MethodConnector(
          name: 'returnsSessionEndpointAndMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsSessionEndpointAndMethod(session),
        ),
        'returnsString': _i1.MethodConnector(
          name: 'returnsString',
          params: {
            'string': _i1.ParameterDescription(
              name: 'string',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint).returnsString(
            session,
            params['string'],
          ),
        ),
        'postNumberToSharedStream': _i1.MethodConnector(
          name: 'postNumberToSharedStream',
          params: {
            'number': _i1.ParameterDescription(
              name: 'number',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .postNumberToSharedStream(
            session,
            params['number'],
          ),
        ),
        'createSimpleData': _i1.MethodConnector(
          name: 'createSimpleData',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .createSimpleData(
            session,
            params['data'],
          ),
        ),
        'getAllSimpleData': _i1.MethodConnector(
          name: 'getAllSimpleData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .getAllSimpleData(session),
        ),
        'createSimpleDatasInsideTransactions': _i1.MethodConnector(
          name: 'createSimpleDatasInsideTransactions',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .createSimpleDatasInsideTransactions(
            session,
            params['data'],
          ),
        ),
        'createSimpleDataAndThrowInsideTransaction': _i1.MethodConnector(
          name: 'createSimpleDataAndThrowInsideTransaction',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .createSimpleDataAndThrowInsideTransaction(
            session,
            params['data'],
          ),
        ),
        'createSimpleDatasInParallelTransactionCalls': _i1.MethodConnector(
          name: 'createSimpleDatasInParallelTransactionCalls',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .createSimpleDatasInParallelTransactionCalls(session),
        ),
        'echoSimpleData': _i1.MethodConnector(
          name: 'echoSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i44.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint).echoSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'echoSimpleDatas': _i1.MethodConnector(
          name: 'echoSimpleDatas',
          params: {
            'simpleDatas': _i1.ParameterDescription(
              name: 'simpleDatas',
              type: _i1.getType<List<_i44.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .echoSimpleDatas(
            session,
            params['simpleDatas'],
          ),
        ),
        'logMessageWithSession': _i1.MethodConnector(
          name: 'logMessageWithSession',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .logMessageWithSession(session),
        ),
        'addWillCloseListenerToSessionAndThrow': _i1.MethodConnector(
          name: 'addWillCloseListenerToSessionAndThrow',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .addWillCloseListenerToSessionAndThrow(session),
        ),
        'returnsSessionIdFromStream': _i1.MethodStreamConnector(
          name: 'returnsSessionIdFromStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsSessionIdFromStream(session),
        ),
        'returnsSessionEndpointAndMethodFromStream': _i1.MethodStreamConnector(
          name: 'returnsSessionEndpointAndMethodFromStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsSessionEndpointAndMethodFromStream(session),
        ),
        'returnsStream': _i1.MethodStreamConnector(
          name: 'returnsStream',
          params: {
            'n': _i1.ParameterDescription(
              name: 'n',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint).returnsStream(
            session,
            params['n'],
          ),
        ),
        'returnsListFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsListFromInputStream',
          params: {},
          streamParams: {
            'numbers': _i1.StreamParameterDescription<int>(
              name: 'numbers',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsListFromInputStream(
            session,
            streamParams['numbers']!.cast<int>(),
          ),
        ),
        'returnsSimpleDataListFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsSimpleDataListFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _i1.StreamParameterDescription<_i44.SimpleData>(
              name: 'simpleDatas',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsSimpleDataListFromInputStream(
            session,
            streamParams['simpleDatas']!.cast<_i44.SimpleData>(),
          ),
        ),
        'returnsStreamFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsStreamFromInputStream',
          params: {},
          streamParams: {
            'numbers': _i1.StreamParameterDescription<int>(
              name: 'numbers',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsStreamFromInputStream(
            session,
            streamParams['numbers']!.cast<int>(),
          ),
        ),
        'returnsSimpleDataStreamFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsSimpleDataStreamFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _i1.StreamParameterDescription<_i44.SimpleData>(
              name: 'simpleDatas',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .returnsSimpleDataStreamFromInputStream(
            session,
            streamParams['simpleDatas']!.cast<_i44.SimpleData>(),
          ),
        ),
        'postNumberToSharedStreamAndReturnStream': _i1.MethodStreamConnector(
          name: 'postNumberToSharedStreamAndReturnStream',
          params: {
            'number': _i1.ParameterDescription(
              name: 'number',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .postNumberToSharedStreamAndReturnStream(
            session,
            params['number'],
          ),
        ),
        'listenForNumbersOnSharedStream': _i1.MethodStreamConnector(
          name: 'listenForNumbersOnSharedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .listenForNumbersOnSharedStream(session),
        ),
        'addWillCloseListenerToSessionIntStreamMethodAndThrow':
            _i1.MethodStreamConnector(
          name: 'addWillCloseListenerToSessionIntStreamMethodAndThrow',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i37.TestToolsEndpoint)
                  .addWillCloseListenerToSessionIntStreamMethodAndThrow(
                      session),
        ),
      },
    );
    connectors['authenticatedTestTools'] = _i1.EndpointConnector(
      name: 'authenticatedTestTools',
      endpoint: endpoints['authenticatedTestTools']!,
      methodConnectors: {
        'returnsString': _i1.MethodConnector(
          name: 'returnsString',
          params: {
            'string': _i1.ParameterDescription(
              name: 'string',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authenticatedTestTools']
                      as _i37.AuthenticatedTestToolsEndpoint)
                  .returnsString(
            session,
            params['string'],
          ),
        ),
        'returnsStream': _i1.MethodStreamConnector(
          name: 'returnsStream',
          params: {
            'n': _i1.ParameterDescription(
              name: 'n',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['authenticatedTestTools']
                      as _i37.AuthenticatedTestToolsEndpoint)
                  .returnsStream(
            session,
            params['n'],
          ),
        ),
        'returnsListFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsListFromInputStream',
          params: {},
          streamParams: {
            'numbers': _i1.StreamParameterDescription<int>(
              name: 'numbers',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['authenticatedTestTools']
                      as _i37.AuthenticatedTestToolsEndpoint)
                  .returnsListFromInputStream(
            session,
            streamParams['numbers']!.cast<int>(),
          ),
        ),
        'intEchoStream': _i1.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['authenticatedTestTools']
                      as _i37.AuthenticatedTestToolsEndpoint)
                  .intEchoStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
      },
    );
    connectors['myFeature'] = _i1.EndpointConnector(
      name: 'myFeature',
      endpoint: endpoints['myFeature']!,
      methodConnectors: {
        'myFeatureMethod': _i1.MethodConnector(
          name: 'myFeatureMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myFeature'] as _i38.MyFeatureEndpoint)
                  .myFeatureMethod(session),
        ),
        'myFeatureModel': _i1.MethodConnector(
          name: 'myFeatureModel',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myFeature'] as _i38.MyFeatureEndpoint)
                  .myFeatureModel(session),
        ),
      },
    );
    modules['serverpod_auth'] = _i51.Endpoints()..initializeEndpoints(server);
    modules['serverpod_test_module'] = _i50.Endpoints()
      ..initializeEndpoints(server);
  }
}
