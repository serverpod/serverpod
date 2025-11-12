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
import '../endpoints/diagnostic_event_test_endpoint.dart' as _i13;
import '../endpoints/echo_request.dart' as _i14;
import '../endpoints/echo_required_field.dart' as _i15;
import '../endpoints/email_auth_provider.dart' as _i16;
import '../endpoints/endpoint_inheritance.dart' as _i17;
import '../endpoints/endpoint_login_hierarchy.dart' as _i18;
import '../endpoints/exception_test_endpoint.dart' as _i19;
import '../endpoints/failed_calls.dart' as _i20;
import '../endpoints/field_scopes.dart' as _i21;
import '../endpoints/future_calls.dart' as _i22;
import '../endpoints/list_parameters.dart' as _i23;
import '../endpoints/logging.dart' as _i24;
import '../endpoints/logging_disabled.dart' as _i25;
import '../endpoints/map_parameters.dart' as _i26;
import '../endpoints/method_signature_permutations.dart' as _i27;
import '../endpoints/method_streaming.dart' as _i28;
import '../endpoints/module_endpoint_extension.dart' as _i29;
import '../endpoints/module_serialization.dart' as _i30;
import '../endpoints/named_parameters.dart' as _i31;
import '../endpoints/optional_parameters.dart' as _i32;
import '../endpoints/record_parameters.dart' as _i33;
import '../endpoints/redis.dart' as _i34;
import '../endpoints/server_only_scoped_field_model.dart' as _i35;
import '../endpoints/server_only_scoped_field_model_child.dart' as _i36;
import '../endpoints/session_authentication.dart' as _i37;
import '../endpoints/session_authentication_streaming.dart' as _i38;
import '../endpoints/set_parameters.dart' as _i39;
import '../endpoints/signin_required.dart' as _i40;
import '../endpoints/simple.dart' as _i41;
import '../endpoints/streaming.dart' as _i42;
import '../endpoints/streaming_logging.dart' as _i43;
import '../endpoints/subDir/subSubDir/subsubdir_test_endpoint.dart' as _i44;
import '../endpoints/subDir/subdir_test_endpoint.dart' as _i45;
import '../endpoints/test_tools.dart' as _i46;
import '../endpoints/unauthenticated.dart' as _i47;
import '../endpoints/upload_too_large.dart' as _i48;
import '../my_feature/endpoints/my_feature_endpoint.dart' as _i49;
import 'dart:typed_data' as _i50;
import 'package:serverpod_test_shared/src/custom_classes.dart' as _i51;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i52;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i53;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i54;
import 'package:serverpod_test_server/src/generated/types.dart' as _i55;
import 'package:serverpod_test_server/src/generated/object_with_enum.dart'
    as _i56;
import 'package:serverpod_test_server/src/generated/object_with_object.dart'
    as _i57;
import 'package:serverpod_test_server/src/generated/required/model_with_required_field.dart'
    as _i58;
import 'package:serverpod_test_server/src/generated/object_field_scopes.dart'
    as _i59;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i60;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i61;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i62;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i63;
import 'package:serverpod_test_server/src/generated/types_record.dart' as _i64;
import 'package:serverpod_test_server/src/generated/module_datatype.dart'
    as _i65;

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
      'diagnosticEventTest': _i13.DiagnosticEventTestEndpoint()
        ..initialize(
          server,
          'diagnosticEventTest',
          null,
        ),
      'echoRequest': _i14.EchoRequestEndpoint()
        ..initialize(
          server,
          'echoRequest',
          null,
        ),
      'echoRequiredField': _i15.EchoRequiredFieldEndpoint()
        ..initialize(
          server,
          'echoRequiredField',
          null,
        ),
      'emailAuthTestMethods': _i16.EmailAuthTestMethods()
        ..initialize(
          server,
          'emailAuthTestMethods',
          null,
        ),
      'concreteBase': _i17.ConcreteBaseEndpoint()
        ..initialize(
          server,
          'concreteBase',
          null,
        ),
      'concreteSubClass': _i17.ConcreteSubClassEndpoint()
        ..initialize(
          server,
          'concreteSubClass',
          null,
        ),
      'independent': _i17.IndependentEndpoint()
        ..initialize(
          server,
          'independent',
          null,
        ),
      'concreteFromModuleAbstractBase':
          _i17.ConcreteFromModuleAbstractBaseEndpoint()
            ..initialize(
              server,
              'concreteFromModuleAbstractBase',
              null,
            ),
      'concreteModuleBase': _i17.ConcreteModuleBaseEndpoint()
        ..initialize(
          server,
          'concreteModuleBase',
          null,
        ),
      'loggedIn': _i18.LoggedInEndpoint()
        ..initialize(
          server,
          'loggedIn',
          null,
        ),
      'myLoggedIn': _i18.MyLoggedInEndpoint()
        ..initialize(
          server,
          'myLoggedIn',
          null,
        ),
      'admin': _i18.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'myAdmin': _i18.MyAdminEndpoint()
        ..initialize(
          server,
          'myAdmin',
          null,
        ),
      'myConcreteAdmin': _i18.MyConcreteAdminEndpoint()
        ..initialize(
          server,
          'myConcreteAdmin',
          null,
        ),
      'exceptionTest': _i19.ExceptionTestEndpoint()
        ..initialize(
          server,
          'exceptionTest',
          null,
        ),
      'failedCalls': _i20.FailedCallsEndpoint()
        ..initialize(
          server,
          'failedCalls',
          null,
        ),
      'fieldScopes': _i21.FieldScopesEndpoint()
        ..initialize(
          server,
          'fieldScopes',
          null,
        ),
      'futureCalls': _i22.FutureCallsEndpoint()
        ..initialize(
          server,
          'futureCalls',
          null,
        ),
      'listParameters': _i23.ListParametersEndpoint()
        ..initialize(
          server,
          'listParameters',
          null,
        ),
      'logging': _i24.LoggingEndpoint()
        ..initialize(
          server,
          'logging',
          null,
        ),
      'streamLogging': _i24.StreamLogging()
        ..initialize(
          server,
          'streamLogging',
          null,
        ),
      'streamQueryLogging': _i24.StreamQueryLogging()
        ..initialize(
          server,
          'streamQueryLogging',
          null,
        ),
      'loggingDisabled': _i25.LoggingDisabledEndpoint()
        ..initialize(
          server,
          'loggingDisabled',
          null,
        ),
      'mapParameters': _i26.MapParametersEndpoint()
        ..initialize(
          server,
          'mapParameters',
          null,
        ),
      'methodSignaturePermutations': _i27.MethodSignaturePermutationsEndpoint()
        ..initialize(
          server,
          'methodSignaturePermutations',
          null,
        ),
      'methodStreaming': _i28.MethodStreaming()
        ..initialize(
          server,
          'methodStreaming',
          null,
        ),
      'authenticatedMethodStreaming': _i28.AuthenticatedMethodStreaming()
        ..initialize(
          server,
          'authenticatedMethodStreaming',
          null,
        ),
      'moduleEndpointSubclass': _i29.ModuleEndpointSubclass()
        ..initialize(
          server,
          'moduleEndpointSubclass',
          null,
        ),
      'moduleEndpointAdaptation': _i29.ModuleEndpointAdaptation()
        ..initialize(
          server,
          'moduleEndpointAdaptation',
          null,
        ),
      'moduleEndpointReduction': _i29.ModuleEndpointReduction()
        ..initialize(
          server,
          'moduleEndpointReduction',
          null,
        ),
      'moduleEndpointExtension': _i29.ModuleEndpointExtension()
        ..initialize(
          server,
          'moduleEndpointExtension',
          null,
        ),
      'moduleSerialization': _i30.ModuleSerializationEndpoint()
        ..initialize(
          server,
          'moduleSerialization',
          null,
        ),
      'namedParameters': _i31.NamedParametersEndpoint()
        ..initialize(
          server,
          'namedParameters',
          null,
        ),
      'optionalParameters': _i32.OptionalParametersEndpoint()
        ..initialize(
          server,
          'optionalParameters',
          null,
        ),
      'recordParameters': _i33.RecordParametersEndpoint()
        ..initialize(
          server,
          'recordParameters',
          null,
        ),
      'redis': _i34.RedisEndpoint()
        ..initialize(
          server,
          'redis',
          null,
        ),
      'serverOnlyScopedFieldModel': _i35.ServerOnlyScopedFieldModelEndpoint()
        ..initialize(
          server,
          'serverOnlyScopedFieldModel',
          null,
        ),
      'serverOnlyScopedFieldChildModel':
          _i36.ServerOnlyScopedFieldChildModelEndpoint()
            ..initialize(
              server,
              'serverOnlyScopedFieldChildModel',
              null,
            ),
      'sessionAuthentication': _i37.SessionAuthenticationEndpoint()
        ..initialize(
          server,
          'sessionAuthentication',
          null,
        ),
      'sessionAuthenticationStreaming':
          _i38.SessionAuthenticationStreamingEndpoint()
            ..initialize(
              server,
              'sessionAuthenticationStreaming',
              null,
            ),
      'setParameters': _i39.SetParametersEndpoint()
        ..initialize(
          server,
          'setParameters',
          null,
        ),
      'signInRequired': _i40.SignInRequiredEndpoint()
        ..initialize(
          server,
          'signInRequired',
          null,
        ),
      'adminScopeRequired': _i40.AdminScopeRequiredEndpoint()
        ..initialize(
          server,
          'adminScopeRequired',
          null,
        ),
      'simple': _i41.SimpleEndpoint()
        ..initialize(
          server,
          'simple',
          null,
        ),
      'streaming': _i42.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          null,
        ),
      'streamingLogging': _i43.StreamingLoggingEndpoint()
        ..initialize(
          server,
          'streamingLogging',
          null,
        ),
      'subSubDirTest': _i44.SubSubDirTestEndpoint()
        ..initialize(
          server,
          'subSubDirTest',
          null,
        ),
      'subDirTest': _i45.SubDirTestEndpoint()
        ..initialize(
          server,
          'subDirTest',
          null,
        ),
      'testTools': _i46.TestToolsEndpoint()
        ..initialize(
          server,
          'testTools',
          null,
        ),
      'authenticatedTestTools': _i46.AuthenticatedTestToolsEndpoint()
        ..initialize(
          server,
          'authenticatedTestTools',
          null,
        ),
      'unauthenticated': _i47.UnauthenticatedEndpoint()
        ..initialize(
          server,
          'unauthenticated',
          null,
        ),
      'partiallyUnauthenticated': _i47.PartiallyUnauthenticatedEndpoint()
        ..initialize(
          server,
          'partiallyUnauthenticated',
          null,
        ),
      'unauthenticatedRequireLogin': _i47.UnauthenticatedRequireLoginEndpoint()
        ..initialize(
          server,
          'unauthenticatedRequireLogin',
          null,
        ),
      'requireLogin': _i47.RequireLoginEndpoint()
        ..initialize(
          server,
          'requireLogin',
          null,
        ),
      'upload': _i48.UploadEndpoint()
        ..initialize(
          server,
          'upload',
          null,
        ),
      'myFeature': _i49.MyFeatureEndpoint()
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
              type: _i1.getType<_i50.ByteData?>(),
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
              type: _i1.getType<_i1.UuidValue?>(),
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
            'value': _i1.StreamParameterDescription<_i50.ByteData?>(
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
            streamParams['value']!.cast<_i50.ByteData?>(),
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
            'value': _i1.StreamParameterDescription<_i1.UuidValue?>(
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
            streamParams['value']!.cast<_i1.UuidValue?>(),
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
              type: _i1.getType<_i50.ByteData>(),
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
              type: _i1.getType<_i50.ByteData>(),
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
              type: _i1.getType<_i51.CustomClass>(),
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
              type: _i1.getType<_i51.CustomClass?>(),
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
              type: _i1.getType<_i51.CustomClass2>(),
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
              type: _i1.getType<_i51.CustomClass2?>(),
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
              type: _i1.getType<_i52.ExternalCustomClass>(),
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
              type: _i1.getType<_i52.ExternalCustomClass?>(),
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
              type: _i1.getType<_i53.FreezedCustomClass>(),
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
              type: _i1.getType<_i53.FreezedCustomClass?>(),
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
              type: _i1.getType<_i51.CustomClassWithoutProtocolSerialization>(),
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
              type: _i1.getType<_i51.CustomClassWithProtocolSerialization>(),
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
                  .getType<_i51.CustomClassWithProtocolSerializationMethod>(),
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
              type: _i1.getType<_i54.SimpleData>(),
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
              type: _i1.getType<_i54.SimpleData>(),
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
              type: _i1.getType<_i54.SimpleData>(),
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
              type: _i1.getType<_i55.Types>(),
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
              type: _i1.getType<_i55.Types>(),
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
              type: _i1.getType<_i56.ObjectWithEnum>(),
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
              type: _i1.getType<_i57.ObjectWithObject>(),
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
    connectors['diagnosticEventTest'] = _i1.EndpointConnector(
      name: 'diagnosticEventTest',
      endpoint: endpoints['diagnosticEventTest']!,
      methodConnectors: {
        'submitExceptionEvent': _i1.MethodConnector(
          name: 'submitExceptionEvent',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['diagnosticEventTest']
                      as _i13.DiagnosticEventTestEndpoint)
                  .submitExceptionEvent(session),
        )
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
              (endpoints['echoRequest'] as _i14.EchoRequestEndpoint)
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
              (endpoints['echoRequest'] as _i14.EchoRequestEndpoint)
                  .echoHttpHeader(
            session,
            params['headerName'],
          ),
        ),
      },
    );
    connectors['echoRequiredField'] = _i1.EndpointConnector(
      name: 'echoRequiredField',
      endpoint: endpoints['echoRequiredField']!,
      methodConnectors: {
        'echoModel': _i1.MethodConnector(
          name: 'echoModel',
          params: {
            'model': _i1.ParameterDescription(
              name: 'model',
              type: _i1.getType<_i58.ModelWithRequiredField>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['echoRequiredField'] as _i15.EchoRequiredFieldEndpoint)
                  .echoModel(
            session,
            params['model'],
          ),
        ),
        'throwException': _i1.MethodConnector(
          name: 'throwException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['echoRequiredField'] as _i15.EchoRequiredFieldEndpoint)
                  .throwException(session),
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
              (endpoints['emailAuthTestMethods'] as _i16.EmailAuthTestMethods)
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
              (endpoints['emailAuthTestMethods'] as _i16.EmailAuthTestMethods)
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
              (endpoints['emailAuthTestMethods'] as _i16.EmailAuthTestMethods)
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
              (endpoints['emailAuthTestMethods'] as _i16.EmailAuthTestMethods)
                  .createUser(
            session,
            params['userName'],
            params['email'],
            params['password'],
          ),
        ),
      },
    );
    connectors['concreteBase'] = _i1.EndpointConnector(
      name: 'concreteBase',
      endpoint: endpoints['concreteBase']!,
      methodConnectors: {
        'virtualMethod': _i1.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteBase'] as _i17.ConcreteBaseEndpoint)
                  .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteBase'] as _i17.ConcreteBaseEndpoint)
                  .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteBase'] as _i17.ConcreteBaseEndpoint)
                  .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _i1.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['concreteBase'] as _i17.ConcreteBaseEndpoint)
                  .abstractBaseStreamMethod(session),
        ),
      },
    );
    connectors['concreteSubClass'] = _i1.EndpointConnector(
      name: 'concreteSubClass',
      endpoint: endpoints['concreteSubClass']!,
      methodConnectors: {
        'subClassVirtualMethod': _i1.MethodConnector(
          name: 'subClassVirtualMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteSubClass'] as _i17.ConcreteSubClassEndpoint)
                  .subClassVirtualMethod(session),
        ),
        'virtualMethod': _i1.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteSubClass'] as _i17.ConcreteSubClassEndpoint)
                  .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteSubClass'] as _i17.ConcreteSubClassEndpoint)
                  .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteSubClass'] as _i17.ConcreteSubClassEndpoint)
                  .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _i1.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['concreteSubClass'] as _i17.ConcreteSubClassEndpoint)
                  .abstractBaseStreamMethod(session),
        ),
      },
    );
    connectors['independent'] = _i1.EndpointConnector(
      name: 'independent',
      endpoint: endpoints['independent']!,
      methodConnectors: {
        'subClassVirtualMethod': _i1.MethodConnector(
          name: 'subClassVirtualMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['independent'] as _i17.IndependentEndpoint)
                  .subClassVirtualMethod(session),
        ),
        'virtualMethod': _i1.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['independent'] as _i17.IndependentEndpoint)
                  .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['independent'] as _i17.IndependentEndpoint)
                  .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['independent'] as _i17.IndependentEndpoint)
                  .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _i1.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['independent'] as _i17.IndependentEndpoint)
                  .abstractBaseStreamMethod(session),
        ),
      },
    );
    connectors['concreteFromModuleAbstractBase'] = _i1.EndpointConnector(
      name: 'concreteFromModuleAbstractBase',
      endpoint: endpoints['concreteFromModuleAbstractBase']!,
      methodConnectors: {
        'virtualMethod': _i1.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteFromModuleAbstractBase']
                      as _i17.ConcreteFromModuleAbstractBaseEndpoint)
                  .virtualMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteFromModuleAbstractBase']
                      as _i17.ConcreteFromModuleAbstractBaseEndpoint)
                  .abstractBaseMethod(session),
        ),
      },
    );
    connectors['concreteModuleBase'] = _i1.EndpointConnector(
      name: 'concreteModuleBase',
      endpoint: endpoints['concreteModuleBase']!,
      methodConnectors: {
        'virtualMethod': _i1.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteModuleBase']
                      as _i17.ConcreteModuleBaseEndpoint)
                  .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteModuleBase']
                      as _i17.ConcreteModuleBaseEndpoint)
                  .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['concreteModuleBase']
                      as _i17.ConcreteModuleBaseEndpoint)
                  .abstractBaseMethod(session),
        ),
      },
    );
    connectors['loggedIn'] = _i1.EndpointConnector(
      name: 'loggedIn',
      endpoint: endpoints['loggedIn']!,
      methodConnectors: {},
    );
    connectors['myLoggedIn'] = _i1.EndpointConnector(
      name: 'myLoggedIn',
      endpoint: endpoints['myLoggedIn']!,
      methodConnectors: {
        'echo': _i1.MethodConnector(
          name: 'echo',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myLoggedIn'] as _i18.MyLoggedInEndpoint).echo(
            session,
            params['value'],
          ),
        )
      },
    );
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {},
    );
    connectors['myAdmin'] = _i1.EndpointConnector(
      name: 'myAdmin',
      endpoint: endpoints['myAdmin']!,
      methodConnectors: {
        'echo': _i1.MethodConnector(
          name: 'echo',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myAdmin'] as _i18.MyAdminEndpoint).echo(
            session,
            params['value'],
          ),
        )
      },
    );
    connectors['myConcreteAdmin'] = _i1.EndpointConnector(
      name: 'myConcreteAdmin',
      endpoint: endpoints['myConcreteAdmin']!,
      methodConnectors: {
        'echo': _i1.MethodConnector(
          name: 'echo',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myConcreteAdmin'] as _i18.MyConcreteAdminEndpoint)
                  .echo(
            session,
            params['value'],
          ),
        )
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
              (endpoints['exceptionTest'] as _i19.ExceptionTestEndpoint)
                  .throwNormalException(session),
        ),
        'throwExceptionWithData': _i1.MethodConnector(
          name: 'throwExceptionWithData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i19.ExceptionTestEndpoint)
                  .throwExceptionWithData(session),
        ),
        'workingWithoutException': _i1.MethodConnector(
          name: 'workingWithoutException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i19.ExceptionTestEndpoint)
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
              (endpoints['failedCalls'] as _i20.FailedCallsEndpoint)
                  .failedCall(session),
        ),
        'failedDatabaseQuery': _i1.MethodConnector(
          name: 'failedDatabaseQuery',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i20.FailedCallsEndpoint)
                  .failedDatabaseQuery(session),
        ),
        'failedDatabaseQueryCaughtException': _i1.MethodConnector(
          name: 'failedDatabaseQueryCaughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i20.FailedCallsEndpoint)
                  .failedDatabaseQueryCaughtException(session),
        ),
        'slowCall': _i1.MethodConnector(
          name: 'slowCall',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i20.FailedCallsEndpoint)
                  .slowCall(session),
        ),
        'caughtException': _i1.MethodConnector(
          name: 'caughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i20.FailedCallsEndpoint)
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
              type: _i1.getType<_i59.ObjectFieldScopes>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['fieldScopes'] as _i21.FieldScopesEndpoint)
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
              (endpoints['fieldScopes'] as _i21.FieldScopesEndpoint)
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
              type: _i1.getType<_i54.SimpleData?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['futureCalls'] as _i22.FutureCallsEndpoint)
                  .makeFutureCall(
            session,
            params['data'],
          ),
        ),
        'makeFutureCallThatThrows': _i1.MethodConnector(
          name: 'makeFutureCallThatThrows',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i54.SimpleData?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['futureCalls'] as _i22.FutureCallsEndpoint)
                  .makeFutureCallThatThrows(
            session,
            params['data'],
          ),
        ),
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              type: _i1.getType<List<_i50.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              type: _i1.getType<List<_i50.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              type: _i1.getType<List<_i54.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              type: _i1.getType<List<_i54.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              type: _i1.getType<List<_i54.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              type: _i1.getType<List<_i54.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i23.ListParametersEndpoint)
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
              (endpoints['logging'] as _i24.LoggingEndpoint).slowQueryMethod(
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
              (endpoints['logging'] as _i24.LoggingEndpoint).queryMethod(
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
              (endpoints['logging'] as _i24.LoggingEndpoint)
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
              (endpoints['logging'] as _i24.LoggingEndpoint).slowMethod(
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
              (endpoints['logging'] as _i24.LoggingEndpoint)
                  .failingMethod(session),
        ),
        'emptyMethod': _i1.MethodConnector(
          name: 'emptyMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i24.LoggingEndpoint)
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
              (endpoints['logging'] as _i24.LoggingEndpoint).log(
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
              (endpoints['logging'] as _i24.LoggingEndpoint).logInfo(
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
              (endpoints['logging'] as _i24.LoggingEndpoint)
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
              (endpoints['logging'] as _i24.LoggingEndpoint)
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
              (endpoints['logging'] as _i24.LoggingEndpoint).streamEmpty(
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
              (endpoints['logging'] as _i24.LoggingEndpoint).streamLogging(
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
              (endpoints['logging'] as _i24.LoggingEndpoint).streamQueryLogging(
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
              (endpoints['logging'] as _i24.LoggingEndpoint)
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
              (endpoints['loggingDisabled'] as _i25.LoggingDisabledEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
                  .returnIntIntMap(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnNestedIntIntMap': _i1.MethodConnector(
          name: 'returnNestedIntIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Map<int, int>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
                  .returnNestedIntIntMap(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnEnumIntMap': _i1.MethodConnector(
          name: 'returnEnumIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<_i61.TestEnum, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
                  .returnEnumIntMap(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnEnumMap': _i1.MethodConnector(
          name: 'returnEnumMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i61.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i50.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i50.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i54.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i54.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i54.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i54.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
                  .returnDurationMapNullableDurations(
            session,
            params['map'],
          ),
        ),
        'returnNestedNonStringKeyedMapInsideRecordInsideMap':
            _i1.MethodConnector(
          name: 'returnNestedNonStringKeyedMapInsideRecordInsideMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<(Map<int, String>, String), String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
                  .returnNestedNonStringKeyedMapInsideRecordInsideMap(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap':
            _i1.MethodConnector(
          name: 'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, (Map<int, int>,)>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i26.MapParametersEndpoint)
                  .returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
                      as _i27.MethodSignaturePermutationsEndpoint)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .methodCallEndpoint(session),
        ),
        'wasBroadcastStreamCanceled': _i1.MethodConnector(
          name: 'wasBroadcastStreamCanceled',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .wasBroadcastStreamCanceled(session),
        ),
        'wasSessionWillCloseListenerCalled': _i1.MethodConnector(
          name: 'wasSessionWillCloseListenerCalled',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .wasSessionWillCloseListenerCalled(session),
        ),
        'simpleEndpoint': _i1.MethodConnector(
          name: 'simpleEndpoint',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleDataStream(
            session,
            params['value'],
          ),
        ),
        'simpleInOutDataStream': _i1.MethodStreamConnector(
          name: 'simpleInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataStream': _i1.StreamParameterDescription<_i54.SimpleData>(
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleInOutDataStream(
            session,
            streamParams['simpleDataStream']!.cast<_i54.SimpleData>(),
          ),
        ),
        'simpleListInOutIntStream': _i1.MethodStreamConnector(
          name: 'simpleListInOutIntStream',
          params: {},
          streamParams: {
            'simpleDataListStream': _i1.StreamParameterDescription<List<int>>(
              name: 'simpleDataListStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleListInOutIntStream(
            session,
            streamParams['simpleDataListStream']!.cast<List<int>>(),
          ),
        ),
        'simpleListInOutDataStream': _i1.MethodStreamConnector(
          name: 'simpleListInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataListStream':
                _i1.StreamParameterDescription<List<_i54.SimpleData>>(
              name: 'simpleDataListStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleListInOutDataStream(
            session,
            streamParams['simpleDataListStream']!.cast<List<_i54.SimpleData>>(),
          ),
        ),
        'simpleListInOutOtherModuleTypeStream': _i1.MethodStreamConnector(
          name: 'simpleListInOutOtherModuleTypeStream',
          params: {},
          streamParams: {
            'userInfoListStream':
                _i1.StreamParameterDescription<List<_i62.UserInfo>>(
              name: 'userInfoListStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleListInOutOtherModuleTypeStream(
            session,
            streamParams['userInfoListStream']!.cast<List<_i62.UserInfo>>(),
          ),
        ),
        'simpleNullableListInOutNullableDataStream': _i1.MethodStreamConnector(
          name: 'simpleNullableListInOutNullableDataStream',
          params: {},
          streamParams: {
            'simpleDataListStream':
                _i1.StreamParameterDescription<List<_i54.SimpleData>?>(
              name: 'simpleDataListStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleNullableListInOutNullableDataStream(
            session,
            streamParams['simpleDataListStream']!
                .cast<List<_i54.SimpleData>?>(),
          ),
        ),
        'simpleListInOutNullableDataStream': _i1.MethodStreamConnector(
          name: 'simpleListInOutNullableDataStream',
          params: {},
          streamParams: {
            'simpleDataListStream':
                _i1.StreamParameterDescription<List<_i54.SimpleData?>>(
              name: 'simpleDataListStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleListInOutNullableDataStream(
            session,
            streamParams['simpleDataListStream']!
                .cast<List<_i54.SimpleData?>>(),
          ),
        ),
        'simpleSetInOutIntStream': _i1.MethodStreamConnector(
          name: 'simpleSetInOutIntStream',
          params: {},
          streamParams: {
            'simpleDataSetStream': _i1.StreamParameterDescription<Set<int>>(
              name: 'simpleDataSetStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleSetInOutIntStream(
            session,
            streamParams['simpleDataSetStream']!.cast<Set<int>>(),
          ),
        ),
        'simpleSetInOutDataStream': _i1.MethodStreamConnector(
          name: 'simpleSetInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataSetStream':
                _i1.StreamParameterDescription<Set<_i54.SimpleData>>(
              name: 'simpleDataSetStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .simpleSetInOutDataStream(
            session,
            streamParams['simpleDataSetStream']!.cast<Set<_i54.SimpleData>>(),
          ),
        ),
        'nestedSetInListInOutDataStream': _i1.MethodStreamConnector(
          name: 'nestedSetInListInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataSetStream':
                _i1.StreamParameterDescription<List<Set<_i54.SimpleData>>>(
              name: 'simpleDataSetStream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
                  .nestedSetInListInOutDataStream(
            session,
            streamParams['simpleDataSetStream']!
                .cast<List<Set<_i54.SimpleData>>>(),
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
              (endpoints['methodStreaming'] as _i28.MethodStreaming)
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
                      as _i28.AuthenticatedMethodStreaming)
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
                      as _i28.AuthenticatedMethodStreaming)
                  .intEchoStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
      },
    );
    connectors['moduleEndpointSubclass'] = _i1.EndpointConnector(
      name: 'moduleEndpointSubclass',
      endpoint: endpoints['moduleEndpointSubclass']!,
      methodConnectors: {
        'echoString': _i1.MethodConnector(
          name: 'echoString',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointSubclass']
                      as _i29.ModuleEndpointSubclass)
                  .echoString(
            session,
            params['value'],
          ),
        ),
        'echoRecord': _i1.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<(int, BigInt)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointSubclass']
                      as _i29.ModuleEndpointSubclass)
                  .echoRecord(
                    session,
                    params['value'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointSubclass']
                      as _i29.ModuleEndpointSubclass)
                  .echoContainer(
            session,
            params['value'],
          ),
        ),
        'echoModel': _i1.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i63.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointSubclass']
                      as _i29.ModuleEndpointSubclass)
                  .echoModel(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['moduleEndpointAdaptation'] = _i1.EndpointConnector(
      name: 'moduleEndpointAdaptation',
      endpoint: endpoints['moduleEndpointAdaptation']!,
      methodConnectors: {
        'echoString': _i1.MethodConnector(
          name: 'echoString',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointAdaptation']
                      as _i29.ModuleEndpointAdaptation)
                  .echoString(
            session,
            params['value'],
          ),
        ),
        'echoRecord': _i1.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<(int, BigInt)>(),
              nullable: false,
            ),
            'multiplier': _i1.ParameterDescription(
              name: 'multiplier',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointAdaptation']
                      as _i29.ModuleEndpointAdaptation)
                  .echoRecord(
                    session,
                    params['value'],
                    params['multiplier'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointAdaptation']
                      as _i29.ModuleEndpointAdaptation)
                  .echoContainer(
            session,
            params['value'],
          ),
        ),
        'echoModel': _i1.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i63.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointAdaptation']
                      as _i29.ModuleEndpointAdaptation)
                  .echoModel(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['moduleEndpointReduction'] = _i1.EndpointConnector(
      name: 'moduleEndpointReduction',
      endpoint: endpoints['moduleEndpointReduction']!,
      methodConnectors: {
        'echoRecord': _i1.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<(int, BigInt)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointReduction']
                      as _i29.ModuleEndpointReduction)
                  .echoRecord(
                    session,
                    params['value'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointReduction']
                      as _i29.ModuleEndpointReduction)
                  .echoContainer(
            session,
            params['value'],
          ),
        ),
        'echoModel': _i1.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i63.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointReduction']
                      as _i29.ModuleEndpointReduction)
                  .echoModel(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['moduleEndpointExtension'] = _i1.EndpointConnector(
      name: 'moduleEndpointExtension',
      endpoint: endpoints['moduleEndpointExtension']!,
      methodConnectors: {
        'greet': _i1.MethodConnector(
          name: 'greet',
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
              (endpoints['moduleEndpointExtension']
                      as _i29.ModuleEndpointExtension)
                  .greet(
            session,
            params['name'],
          ),
        ),
        'ignoredMethod': _i1.MethodConnector(
          name: 'ignoredMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointExtension']
                      as _i29.ModuleEndpointExtension)
                  .ignoredMethod(session),
        ),
        'echoString': _i1.MethodConnector(
          name: 'echoString',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointExtension']
                      as _i29.ModuleEndpointExtension)
                  .echoString(
            session,
            params['value'],
          ),
        ),
        'echoRecord': _i1.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<(int, BigInt)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointExtension']
                      as _i29.ModuleEndpointExtension)
                  .echoRecord(
                    session,
                    params['value'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointExtension']
                      as _i29.ModuleEndpointExtension)
                  .echoContainer(
            session,
            params['value'],
          ),
        ),
        'echoModel': _i1.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i63.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleEndpointExtension']
                      as _i29.ModuleEndpointExtension)
                  .echoModel(
            session,
            params['value'],
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
                      as _i30.ModuleSerializationEndpoint)
                  .serializeModuleObject(session),
        ),
        'modifyModuleObject': _i1.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i63.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleSerialization']
                      as _i30.ModuleSerializationEndpoint)
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
                      as _i30.ModuleSerializationEndpoint)
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
              (endpoints['namedParameters'] as _i31.NamedParametersEndpoint)
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
              (endpoints['namedParameters'] as _i31.NamedParametersEndpoint)
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
                      as _i32.OptionalParametersEndpoint)
                  .returnOptionalInt(
            session,
            params['optionalInt'],
          ),
        )
      },
    );
    connectors['recordParameters'] = _i1.EndpointConnector(
      name: 'recordParameters',
      endpoint: endpoints['recordParameters']!,
      methodConnectors: {
        'returnRecordOfInt': _i1.MethodConnector(
          name: 'returnRecordOfInt',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int,)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnRecordOfInt(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNullableRecordOfInt': _i1.MethodConnector(
          name: 'returnNullableRecordOfInt',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int,)?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNullableRecordOfInt(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnRecordOfNullableInt': _i1.MethodConnector(
          name: 'returnRecordOfNullableInt',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int?,)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnRecordOfNullableInt(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNullableRecordOfNullableInt': _i1.MethodConnector(
          name: 'returnNullableRecordOfNullableInt',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int?,)?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNullableRecordOfNullableInt(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnIntStringRecord': _i1.MethodConnector(
          name: 'returnIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, String)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnIntStringRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNullableIntStringRecord': _i1.MethodConnector(
          name: 'returnNullableIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, String)?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNullableIntStringRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnIntSimpleDataRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, _i54.SimpleData)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnIntSimpleDataRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnNullableIntSimpleDataRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, _i54.SimpleData)?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNullableIntSimpleDataRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnStringKeyedMapRecord': _i1.MethodConnector(
          name: 'returnStringKeyedMapRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(Map<String, int>,)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnStringKeyedMapRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNonStringKeyedMapRecord': _i1.MethodConnector(
          name: 'returnNonStringKeyedMapRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(Map<int, int>,)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNonStringKeyedMapRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnSetWithNestedRecordRecord': _i1.MethodConnector(
          name: 'returnSetWithNestedRecordRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(Set<(int,)>,)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnSetWithNestedRecordRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNamedIntStringRecord': _i1.MethodConnector(
          name: 'returnNamedIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({int number, String text})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNamedIntStringRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNamedNullableIntStringRecord': _i1.MethodConnector(
          name: 'returnNamedNullableIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({int number, String text})?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNamedNullableIntStringRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnRecordOfNamedIntAndObject': _i1.MethodConnector(
          name: 'returnRecordOfNamedIntAndObject',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({_i54.SimpleData data, int number})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnRecordOfNamedIntAndObject(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNullableRecordOfNamedIntAndObject': _i1.MethodConnector(
          name: 'returnNullableRecordOfNamedIntAndObject',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({_i54.SimpleData data, int number})?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNullableRecordOfNamedIntAndObject(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnRecordOfNamedNullableIntAndNullableObject': _i1.MethodConnector(
          name: 'returnRecordOfNamedNullableIntAndNullableObject',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({_i54.SimpleData? data, int? number})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnRecordOfNamedNullableIntAndNullableObject(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNamedNonStringKeyedMapRecord': _i1.MethodConnector(
          name: 'returnNamedNonStringKeyedMapRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({Map<int, int> intIntMap})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNamedNonStringKeyedMapRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNamedSetWithNestedRecordRecord': _i1.MethodConnector(
          name: 'returnNamedSetWithNestedRecordRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({Set<(bool,)> boolSet})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNamedSetWithNestedRecordRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord':
            _i1.MethodConnector(
          name:
              'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<(Map<(Map<int, String>, String), String>,)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord(
                    session,
                    params['map'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnRecordTypedef': _i1.MethodConnector(
          name: 'returnRecordTypedef',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, {_i54.SimpleData data})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnRecordTypedef(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNullableRecordTypedef': _i1.MethodConnector(
          name: 'returnNullableRecordTypedef',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, {_i54.SimpleData data})?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNullableRecordTypedef(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnListOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnListOfIntSimpleDataRecord',
          params: {
            'recordList': _i1.ParameterDescription(
              name: 'recordList',
              type: _i1.getType<List<(int, _i54.SimpleData)>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnListOfIntSimpleDataRecord(
                    session,
                    params['recordList'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnListOfNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnListOfNullableIntSimpleDataRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<List<(int, _i54.SimpleData)?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnListOfNullableIntSimpleDataRecord(
                    session,
                    params['record'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnSetOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnSetOfIntSimpleDataRecord',
          params: {
            'recordSet': _i1.ParameterDescription(
              name: 'recordSet',
              type: _i1.getType<Set<(int, _i54.SimpleData)>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnSetOfIntSimpleDataRecord(
                    session,
                    params['recordSet'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnSetOfNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnSetOfNullableIntSimpleDataRecord',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<(int, _i54.SimpleData)?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnSetOfNullableIntSimpleDataRecord(
                    session,
                    params['set'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnNullableSetOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnNullableSetOfIntSimpleDataRecord',
          params: {
            'recordSet': _i1.ParameterDescription(
              name: 'recordSet',
              type: _i1.getType<Set<(int, _i54.SimpleData)>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNullableSetOfIntSimpleDataRecord(
                    session,
                    params['recordSet'],
                  )
                  .then((container) => container == null
                      ? null
                      : _i60.mapContainerToJson(container)),
        ),
        'returnStringMapOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnStringMapOfIntSimpleDataRecord',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, (int, _i54.SimpleData)>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnStringMapOfIntSimpleDataRecord(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnStringMapOfNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnStringMapOfNullableIntSimpleDataRecord',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, (int, _i54.SimpleData)?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnStringMapOfNullableIntSimpleDataRecord(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnRecordMapOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnRecordMapOfIntSimpleDataRecord',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<(String, int), (int, _i54.SimpleData)>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnRecordMapOfIntSimpleDataRecord(
                    session,
                    params['map'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnStringMapOfListOfRecord': _i1.MethodConnector(
          name: 'returnStringMapOfListOfRecord',
          params: {
            'input': _i1.ParameterDescription(
              name: 'input',
              type: _i1.getType<Set<List<Map<String, (int,)>>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnStringMapOfListOfRecord(
                    session,
                    params['input'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'returnNestedNamedRecord': _i1.MethodConnector(
          name: 'returnNestedNamedRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({(_i54.SimpleData, double) namedSubRecord})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNestedNamedRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNestedNullableNamedRecord': _i1.MethodConnector(
          name: 'returnNestedNullableNamedRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type:
                  _i1.getType<({(_i54.SimpleData, double)? namedSubRecord})>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNestedNullableNamedRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnNestedPositionalAndNamedRecord': _i1.MethodConnector(
          name: 'returnNestedPositionalAndNamedRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<
                  (
                    (int, String), {
                    (_i54.SimpleData, double) namedSubRecord
                  })>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnNestedPositionalAndNamedRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'returnListOfNestedPositionalAndNamedRecord': _i1.MethodConnector(
          name: 'returnListOfNestedPositionalAndNamedRecord',
          params: {
            'recordList': _i1.ParameterDescription(
              name: 'recordList',
              type: _i1.getType<
                  List<
                      (
                        (int, String), {
                        (_i54.SimpleData, double) namedSubRecord
                      })>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .returnListOfNestedPositionalAndNamedRecord(
                    session,
                    params['recordList'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'echoModelClassWithRecordField': _i1.MethodConnector(
          name: 'echoModelClassWithRecordField',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i64.TypesRecord>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .echoModelClassWithRecordField(
            session,
            params['value'],
          ),
        ),
        'echoNullableModelClassWithRecordField': _i1.MethodConnector(
          name: 'echoNullableModelClassWithRecordField',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i64.TypesRecord?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .echoNullableModelClassWithRecordField(
            session,
            params['value'],
          ),
        ),
        'echoNullableModelClassWithRecordFieldFromExternalModule':
            _i1.MethodConnector(
          name: 'echoNullableModelClassWithRecordFieldFromExternalModule',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i63.ModuleClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .echoNullableModelClassWithRecordFieldFromExternalModule(
            session,
            params['value'],
          ),
        ),
        'recordParametersWithCustomNames': _i1.MethodConnector(
          name: 'recordParametersWithCustomNames',
          params: {
            'positionalRecord': _i1.ParameterDescription(
              name: 'positionalRecord',
              type: _i1.getType<(int,)>(),
              nullable: false,
            ),
            'namedRecord': _i1.ParameterDescription(
              name: 'namedRecord',
              type: _i1.getType<(int,)>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .recordParametersWithCustomNames(
            session,
            params['positionalRecord'],
            namedRecord: params['namedRecord'],
          ),
        ),
        'streamNullableRecordOfNullableInt': _i1.MethodStreamConnector(
          name: 'streamNullableRecordOfNullableInt',
          params: {},
          streamParams: {
            'values': _i1.StreamParameterDescription<(int?,)?>(
              name: 'values',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .streamNullableRecordOfNullableInt(
            session,
            streamParams['values']!.cast<(int?,)?>(),
          ),
        ),
        'streamNullableListOfNullableNestedPositionalAndNamedRecord':
            _i1.MethodStreamConnector(
          name: 'streamNullableListOfNullableNestedPositionalAndNamedRecord',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<
                  List<
                      (
                        (int, String), {
                        (_i54.SimpleData, double) namedSubRecord
                      })?>?>(),
              nullable: true,
            )
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<
                List<
                    (
                      (int, String), {
                      (_i54.SimpleData, double) namedSubRecord
                    })?>?>(
              name: 'values',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .streamNullableListOfNullableNestedPositionalAndNamedRecord(
            session,
            params['initialValue'],
            streamParams['values']!.cast<
                List<
                    (
                      (int, String), {
                      (_i54.SimpleData, double) namedSubRecord
                    })?>?>(),
          ),
        ),
        'streamOfModelClassWithRecordField': _i1.MethodStreamConnector(
          name: 'streamOfModelClassWithRecordField',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i64.TypesRecord>(),
              nullable: false,
            )
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i64.TypesRecord>(
              name: 'values',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .streamOfModelClassWithRecordField(
            session,
            params['initialValue'],
            streamParams['values']!.cast<_i64.TypesRecord>(),
          ),
        ),
        'streamOfNullableModelClassWithRecordField': _i1.MethodStreamConnector(
          name: 'streamOfNullableModelClassWithRecordField',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i64.TypesRecord?>(),
              nullable: true,
            )
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i64.TypesRecord?>(
              name: 'values',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .streamOfNullableModelClassWithRecordField(
            session,
            params['initialValue'],
            streamParams['values']!.cast<_i64.TypesRecord?>(),
          ),
        ),
        'streamOfNullableModelClassWithRecordFieldFromExternalModule':
            _i1.MethodStreamConnector(
          name: 'streamOfNullableModelClassWithRecordFieldFromExternalModule',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i63.ModuleClass?>(),
              nullable: true,
            )
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i63.ModuleClass?>(
              name: 'values',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['recordParameters'] as _i33.RecordParametersEndpoint)
                  .streamOfNullableModelClassWithRecordFieldFromExternalModule(
            session,
            params['initialValue'],
            streamParams['values']!.cast<_i63.ModuleClass?>(),
          ),
        ),
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
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i34.RedisEndpoint).setSimpleData(
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
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i34.RedisEndpoint)
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
              (endpoints['redis'] as _i34.RedisEndpoint).getSimpleData(
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
              (endpoints['redis'] as _i34.RedisEndpoint).deleteSimpleData(
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
              (endpoints['redis'] as _i34.RedisEndpoint)
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
              (endpoints['redis'] as _i34.RedisEndpoint).listenToChannel(
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
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i34.RedisEndpoint).postToChannel(
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
              (endpoints['redis'] as _i34.RedisEndpoint)
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
                      as _i35.ServerOnlyScopedFieldModelEndpoint)
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
                      as _i36.ServerOnlyScopedFieldChildModelEndpoint)
                  .getProtocolField(session),
        )
      },
    );
    connectors['sessionAuthentication'] = _i1.EndpointConnector(
      name: 'sessionAuthentication',
      endpoint: endpoints['sessionAuthentication']!,
      methodConnectors: {
        'getAuthenticatedUserId': _i1.MethodConnector(
          name: 'getAuthenticatedUserId',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionAuthentication']
                      as _i37.SessionAuthenticationEndpoint)
                  .getAuthenticatedUserId(session),
        ),
        'getAuthenticatedScopes': _i1.MethodConnector(
          name: 'getAuthenticatedScopes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionAuthentication']
                      as _i37.SessionAuthenticationEndpoint)
                  .getAuthenticatedScopes(session),
        ),
        'getAuthenticatedAuthId': _i1.MethodConnector(
          name: 'getAuthenticatedAuthId',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionAuthentication']
                      as _i37.SessionAuthenticationEndpoint)
                  .getAuthenticatedAuthId(session),
        ),
        'getAuthenticationInfo': _i1.MethodConnector(
          name: 'getAuthenticationInfo',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionAuthentication']
                      as _i37.SessionAuthenticationEndpoint)
                  .getAuthenticationInfo(session),
        ),
        'isAuthenticated': _i1.MethodConnector(
          name: 'isAuthenticated',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionAuthentication']
                      as _i37.SessionAuthenticationEndpoint)
                  .isAuthenticated(session),
        ),
        'streamAuthenticatedUserId': _i1.MethodStreamConnector(
          name: 'streamAuthenticatedUserId',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['sessionAuthentication']
                      as _i37.SessionAuthenticationEndpoint)
                  .streamAuthenticatedUserId(session),
        ),
        'streamIsAuthenticated': _i1.MethodStreamConnector(
          name: 'streamIsAuthenticated',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['sessionAuthentication']
                      as _i37.SessionAuthenticationEndpoint)
                  .streamIsAuthenticated(session),
        ),
      },
    );
    connectors['sessionAuthenticationStreaming'] = _i1.EndpointConnector(
      name: 'sessionAuthenticationStreaming',
      endpoint: endpoints['sessionAuthenticationStreaming']!,
      methodConnectors: {},
    );
    connectors['setParameters'] = _i1.EndpointConnector(
      name: 'setParameters',
      endpoint: endpoints['setParameters']!,
      methodConnectors: {
        'returnIntSet': _i1.MethodConnector(
          name: 'returnIntSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnIntSet(
            session,
            params['set'],
          ),
        ),
        'returnIntSetSet': _i1.MethodConnector(
          name: 'returnIntSetSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<Set<int>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnIntSetSet(
            session,
            params['set'],
          ),
        ),
        'returnIntListSet': _i1.MethodConnector(
          name: 'returnIntListSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<List<int>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnIntListSet(
            session,
            params['set'],
          ),
        ),
        'returnIntSetNullable': _i1.MethodConnector(
          name: 'returnIntSetNullable',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<int>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnIntSetNullable(
            session,
            params['set'],
          ),
        ),
        'returnIntSetNullableSet': _i1.MethodConnector(
          name: 'returnIntSetNullableSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<Set<int>?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnIntSetNullableSet(
            session,
            params['set'],
          ),
        ),
        'returnIntSetSetNullable': _i1.MethodConnector(
          name: 'returnIntSetSetNullable',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<Set<int>>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnIntSetSetNullable(
            session,
            params['set'],
          ),
        ),
        'returnIntSetNullableInts': _i1.MethodConnector(
          name: 'returnIntSetNullableInts',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<int?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnIntSetNullableInts(
            session,
            params['set'],
          ),
        ),
        'returnNullableIntSetNullableInts': _i1.MethodConnector(
          name: 'returnNullableIntSetNullableInts',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<int?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnNullableIntSetNullableInts(
            session,
            params['set'],
          ),
        ),
        'returnDoubleSet': _i1.MethodConnector(
          name: 'returnDoubleSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnDoubleSet(
            session,
            params['set'],
          ),
        ),
        'returnDoubleSetNullableDoubles': _i1.MethodConnector(
          name: 'returnDoubleSetNullableDoubles',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<double?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnDoubleSetNullableDoubles(
            session,
            params['set'],
          ),
        ),
        'returnBoolSet': _i1.MethodConnector(
          name: 'returnBoolSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnBoolSet(
            session,
            params['set'],
          ),
        ),
        'returnBoolSetNullableBools': _i1.MethodConnector(
          name: 'returnBoolSetNullableBools',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<bool?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnBoolSetNullableBools(
            session,
            params['set'],
          ),
        ),
        'returnStringSet': _i1.MethodConnector(
          name: 'returnStringSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnStringSet(
            session,
            params['set'],
          ),
        ),
        'returnStringSetNullableStrings': _i1.MethodConnector(
          name: 'returnStringSetNullableStrings',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<String?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnStringSetNullableStrings(
            session,
            params['set'],
          ),
        ),
        'returnDateTimeSet': _i1.MethodConnector(
          name: 'returnDateTimeSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnDateTimeSet(
            session,
            params['set'],
          ),
        ),
        'returnDateTimeSetNullableDateTimes': _i1.MethodConnector(
          name: 'returnDateTimeSetNullableDateTimes',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<DateTime?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnDateTimeSetNullableDateTimes(
            session,
            params['set'],
          ),
        ),
        'returnByteDataSet': _i1.MethodConnector(
          name: 'returnByteDataSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<_i50.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnByteDataSet(
            session,
            params['set'],
          ),
        ),
        'returnByteDataSetNullableByteDatas': _i1.MethodConnector(
          name: 'returnByteDataSetNullableByteDatas',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<_i50.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnByteDataSetNullableByteDatas(
            session,
            params['set'],
          ),
        ),
        'returnSimpleDataSet': _i1.MethodConnector(
          name: 'returnSimpleDataSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<_i54.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnSimpleDataSet(
            session,
            params['set'],
          ),
        ),
        'returnSimpleDataSetNullableSimpleData': _i1.MethodConnector(
          name: 'returnSimpleDataSetNullableSimpleData',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<_i54.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnSimpleDataSetNullableSimpleData(
            session,
            params['set'],
          ),
        ),
        'returnDurationSet': _i1.MethodConnector(
          name: 'returnDurationSet',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnDurationSet(
            session,
            params['set'],
          ),
        ),
        'returnDurationSetNullableDurations': _i1.MethodConnector(
          name: 'returnDurationSetNullableDurations',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<Duration?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['setParameters'] as _i39.SetParametersEndpoint)
                  .returnDurationSetNullableDurations(
            session,
            params['set'],
          ),
        ),
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
              (endpoints['signInRequired'] as _i40.SignInRequiredEndpoint)
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
                      as _i40.AdminScopeRequiredEndpoint)
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
              (endpoints['simple'] as _i41.SimpleEndpoint).setGlobalInt(
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
              (endpoints['simple'] as _i41.SimpleEndpoint)
                  .addToGlobalInt(session),
        ),
        'getGlobalInt': _i1.MethodConnector(
          name: 'getGlobalInt',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i41.SimpleEndpoint)
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
              (endpoints['simple'] as _i41.SimpleEndpoint).hello(
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
              (endpoints['subSubDirTest'] as _i44.SubSubDirTestEndpoint)
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
              (endpoints['subDirTest'] as _i45.SubDirTestEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .returnsSessionId(session),
        ),
        'returnsSessionEndpointAndMethod': _i1.MethodConnector(
          name: 'returnsSessionEndpointAndMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint).returnsString(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .createSimpleDatasInParallelTransactionCalls(session),
        ),
        'echoSimpleData': _i1.MethodConnector(
          name: 'echoSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint).echoSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'echoSimpleDatas': _i1.MethodConnector(
          name: 'echoSimpleDatas',
          params: {
            'simpleDatas': _i1.ParameterDescription(
              name: 'simpleDatas',
              type: _i1.getType<List<_i54.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .echoSimpleDatas(
            session,
            params['simpleDatas'],
          ),
        ),
        'echoTypes': _i1.MethodConnector(
          name: 'echoTypes',
          params: {
            'typesModel': _i1.ParameterDescription(
              name: 'typesModel',
              type: _i1.getType<_i55.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint).echoTypes(
            session,
            params['typesModel'],
          ),
        ),
        'echoTypesList': _i1.MethodConnector(
          name: 'echoTypesList',
          params: {
            'typesList': _i1.ParameterDescription(
              name: 'typesList',
              type: _i1.getType<List<_i55.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint).echoTypesList(
            session,
            params['typesList'],
          ),
        ),
        'echoModuleDatatype': _i1.MethodConnector(
          name: 'echoModuleDatatype',
          params: {
            'moduleDatatype': _i1.ParameterDescription(
              name: 'moduleDatatype',
              type: _i1.getType<_i65.ModuleDatatype>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .echoModuleDatatype(
            session,
            params['moduleDatatype'],
          ),
        ),
        'echoModuleClass': _i1.MethodConnector(
          name: 'echoModuleClass',
          params: {
            'moduleClass': _i1.ParameterDescription(
              name: 'moduleClass',
              type: _i1.getType<_i63.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .echoModuleClass(
            session,
            params['moduleClass'],
          ),
        ),
        'echoRecord': _i1.MethodConnector(
          name: 'echoRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(String, (int, bool))>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .echoRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i60.mapRecordToJson(record)),
        ),
        'echoRecords': _i1.MethodConnector(
          name: 'echoRecords',
          params: {
            'records': _i1.ParameterDescription(
              name: 'records',
              type: _i1.getType<List<(String, (int, bool))>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .echoRecords(
                    session,
                    params['records'],
                  )
                  .then((container) => _i60.mapContainerToJson(container)),
        ),
        'logMessageWithSession': _i1.MethodConnector(
          name: 'logMessageWithSession',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .logMessageWithSession(session),
        ),
        'addWillCloseListenerToSessionAndThrow': _i1.MethodConnector(
          name: 'addWillCloseListenerToSessionAndThrow',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .addWillCloseListenerToSessionAndThrow(session),
        ),
        'putInLocalCache': _i1.MethodConnector(
          name: 'putInLocalCache',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .putInLocalCache(
            session,
            params['key'],
            params['data'],
          ),
        ),
        'getFromLocalCache': _i1.MethodConnector(
          name: 'getFromLocalCache',
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .getFromLocalCache(
            session,
            params['key'],
          ),
        ),
        'putInLocalPrioCache': _i1.MethodConnector(
          name: 'putInLocalPrioCache',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .putInLocalPrioCache(
            session,
            params['key'],
            params['data'],
          ),
        ),
        'getFromLocalPrioCache': _i1.MethodConnector(
          name: 'getFromLocalPrioCache',
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .getFromLocalPrioCache(
            session,
            params['key'],
          ),
        ),
        'putInQueryCache': _i1.MethodConnector(
          name: 'putInQueryCache',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .putInQueryCache(
            session,
            params['key'],
            params['data'],
          ),
        ),
        'getFromQueryCache': _i1.MethodConnector(
          name: 'getFromQueryCache',
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .getFromQueryCache(
            session,
            params['key'],
          ),
        ),
        'putInLocalCacheWithGroup': _i1.MethodConnector(
          name: 'putInLocalCacheWithGroup',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i54.SimpleData>(),
              nullable: false,
            ),
            'group': _i1.ParameterDescription(
              name: 'group',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .putInLocalCacheWithGroup(
            session,
            params['key'],
            params['data'],
            params['group'],
          ),
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint).returnsStream(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .returnsListFromInputStream(
            session,
            streamParams['numbers']!.cast<int>(),
          ),
        ),
        'returnsSimpleDataListFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsSimpleDataListFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _i1.StreamParameterDescription<_i54.SimpleData>(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .returnsSimpleDataListFromInputStream(
            session,
            streamParams['simpleDatas']!.cast<_i54.SimpleData>(),
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .returnsStreamFromInputStream(
            session,
            streamParams['numbers']!.cast<int>(),
          ),
        ),
        'returnsSimpleDataStreamFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsSimpleDataStreamFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _i1.StreamParameterDescription<_i54.SimpleData>(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .returnsSimpleDataStreamFromInputStream(
            session,
            streamParams['simpleDatas']!.cast<_i54.SimpleData>(),
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .listenForNumbersOnSharedStream(session),
        ),
        'streamModuleDatatype': _i1.MethodStreamConnector(
          name: 'streamModuleDatatype',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i65.ModuleDatatype?>(),
              nullable: true,
            )
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i65.ModuleDatatype?>(
              name: 'values',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .streamModuleDatatype(
            session,
            params['initialValue'],
            streamParams['values']!.cast<_i65.ModuleDatatype?>(),
          ),
        ),
        'streamModuleClass': _i1.MethodStreamConnector(
          name: 'streamModuleClass',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i63.ModuleClass?>(),
              nullable: true,
            )
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i63.ModuleClass?>(
              name: 'values',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .streamModuleClass(
            session,
            params['initialValue'],
            streamParams['values']!.cast<_i63.ModuleClass?>(),
          ),
        ),
        'recordEchoStream': _i1.MethodStreamConnector(
          name: 'recordEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<
                  (
                    String,
                    (Map<String, int>, {bool flag, _i54.SimpleData simpleData})
                  )>(),
              nullable: false,
            )
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<
                (
                  String,
                  (Map<String, int>, {bool flag, _i54.SimpleData simpleData})
                )>(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .recordEchoStream(
            session,
            params['initialValue'],
            streamParams['stream']!.cast<
                (
                  String,
                  (Map<String, int>, {bool flag, _i54.SimpleData simpleData})
                )>(),
          ),
        ),
        'listOfRecordEchoStream': _i1.MethodStreamConnector(
          name: 'listOfRecordEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<List<(String, int)>>(),
              nullable: false,
            )
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<List<(String, int)>>(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .listOfRecordEchoStream(
            session,
            params['initialValue'],
            streamParams['stream']!.cast<List<(String, int)>>(),
          ),
        ),
        'nullableRecordEchoStream': _i1.MethodStreamConnector(
          name: 'nullableRecordEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<
                  (
                    String,
                    (Map<String, int>, {bool flag, _i54.SimpleData simpleData})
                  )?>(),
              nullable: true,
            )
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<
                (
                  String,
                  (Map<String, int>, {bool flag, _i54.SimpleData simpleData})
                )?>(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .nullableRecordEchoStream(
            session,
            params['initialValue'],
            streamParams['stream']!.cast<
                (
                  String,
                  (Map<String, int>, {bool flag, _i54.SimpleData simpleData})
                )?>(),
          ),
        ),
        'nullableListOfRecordEchoStream': _i1.MethodStreamConnector(
          name: 'nullableListOfRecordEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<List<(String, int)>?>(),
              nullable: true,
            )
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<List<(String, int)>?>(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .nullableListOfRecordEchoStream(
            session,
            params['initialValue'],
            streamParams['stream']!.cast<List<(String, int)>?>(),
          ),
        ),
        'modelWithRecordsEchoStream': _i1.MethodStreamConnector(
          name: 'modelWithRecordsEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i64.TypesRecord?>(),
              nullable: true,
            )
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<_i64.TypesRecord?>(
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
                  .modelWithRecordsEchoStream(
            session,
            params['initialValue'],
            streamParams['stream']!.cast<_i64.TypesRecord?>(),
          ),
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
              (endpoints['testTools'] as _i46.TestToolsEndpoint)
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
                      as _i46.AuthenticatedTestToolsEndpoint)
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
                      as _i46.AuthenticatedTestToolsEndpoint)
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
                      as _i46.AuthenticatedTestToolsEndpoint)
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
                      as _i46.AuthenticatedTestToolsEndpoint)
                  .intEchoStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
      },
    );
    connectors['unauthenticated'] = _i1.EndpointConnector(
      name: 'unauthenticated',
      endpoint: endpoints['unauthenticated']!,
      methodConnectors: {
        'unauthenticatedMethod': _i1.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['unauthenticated'] as _i47.UnauthenticatedEndpoint)
                  .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['unauthenticated'] as _i47.UnauthenticatedEndpoint)
                  .unauthenticatedStream(session),
        ),
      },
    );
    connectors['partiallyUnauthenticated'] = _i1.EndpointConnector(
      name: 'partiallyUnauthenticated',
      endpoint: endpoints['partiallyUnauthenticated']!,
      methodConnectors: {
        'unauthenticatedMethod': _i1.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['partiallyUnauthenticated']
                      as _i47.PartiallyUnauthenticatedEndpoint)
                  .unauthenticatedMethod(session),
        ),
        'authenticatedMethod': _i1.MethodConnector(
          name: 'authenticatedMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['partiallyUnauthenticated']
                      as _i47.PartiallyUnauthenticatedEndpoint)
                  .authenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['partiallyUnauthenticated']
                      as _i47.PartiallyUnauthenticatedEndpoint)
                  .unauthenticatedStream(session),
        ),
        'authenticatedStream': _i1.MethodStreamConnector(
          name: 'authenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['partiallyUnauthenticated']
                      as _i47.PartiallyUnauthenticatedEndpoint)
                  .authenticatedStream(session),
        ),
      },
    );
    connectors['unauthenticatedRequireLogin'] = _i1.EndpointConnector(
      name: 'unauthenticatedRequireLogin',
      endpoint: endpoints['unauthenticatedRequireLogin']!,
      methodConnectors: {
        'unauthenticatedMethod': _i1.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['unauthenticatedRequireLogin']
                      as _i47.UnauthenticatedRequireLoginEndpoint)
                  .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['unauthenticatedRequireLogin']
                      as _i47.UnauthenticatedRequireLoginEndpoint)
                  .unauthenticatedStream(session),
        ),
      },
    );
    connectors['requireLogin'] = _i1.EndpointConnector(
      name: 'requireLogin',
      endpoint: endpoints['requireLogin']!,
      methodConnectors: {
        'unauthenticatedMethod': _i1.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['requireLogin'] as _i47.RequireLoginEndpoint)
                  .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['requireLogin'] as _i47.RequireLoginEndpoint)
                  .unauthenticatedStream(session),
        ),
      },
    );
    connectors['upload'] = _i1.EndpointConnector(
      name: 'upload',
      endpoint: endpoints['upload']!,
      methodConnectors: {
        'uploadByteData': _i1.MethodConnector(
          name: 'uploadByteData',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i50.ByteData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['upload'] as _i48.UploadEndpoint).uploadByteData(
            session,
            params['path'],
            params['data'],
          ),
        )
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
              (endpoints['myFeature'] as _i49.MyFeatureEndpoint)
                  .myFeatureMethod(session),
        ),
        'myFeatureModel': _i1.MethodConnector(
          name: 'myFeatureModel',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myFeature'] as _i49.MyFeatureEndpoint)
                  .myFeatureModel(session),
        ),
      },
    );
    modules['serverpod_auth'] = _i62.Endpoints()..initializeEndpoints(server);
    modules['serverpod_test_module'] = _i63.Endpoints()
      ..initializeEndpoints(server);
  }
}
