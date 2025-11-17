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
import '../endpoints/basic_types.dart' as _i3;
import '../endpoints/basic_types_streaming.dart' as _i4;
import '../endpoints/cloud_storage.dart' as _i5;
import '../endpoints/cloud_storage_s3.dart' as _i6;
import '../endpoints/custom_class_protocol.dart' as _i7;
import '../endpoints/custom_types.dart' as _i8;
import '../endpoints/database_basic.dart' as _i9;
import '../endpoints/database_transactions.dart' as _i10;
import '../endpoints/deprecation.dart' as _i11;
import '../endpoints/diagnostic_event_test_endpoint.dart' as _i12;
import '../endpoints/echo_request.dart' as _i13;
import '../endpoints/echo_required_field.dart' as _i14;
import '../endpoints/endpoint_inheritance.dart' as _i15;
import '../endpoints/endpoint_login_hierarchy.dart' as _i16;
import '../endpoints/exception_test_endpoint.dart' as _i17;
import '../endpoints/failed_calls.dart' as _i18;
import '../endpoints/field_scopes.dart' as _i19;
import '../endpoints/future_calls.dart' as _i20;
import '../endpoints/list_parameters.dart' as _i21;
import '../endpoints/logging.dart' as _i22;
import '../endpoints/logging_disabled.dart' as _i23;
import '../endpoints/map_parameters.dart' as _i24;
import '../endpoints/method_signature_permutations.dart' as _i25;
import '../endpoints/module_endpoint_extension.dart' as _i26;
import '../endpoints/module_serialization.dart' as _i27;
import '../endpoints/named_parameters.dart' as _i28;
import '../endpoints/optional_parameters.dart' as _i29;
import '../endpoints/polymorphism.dart' as _i30;
import '../endpoints/record_parameters.dart' as _i31;
import '../endpoints/redis.dart' as _i32;
import '../endpoints/server_only_scoped_field_model.dart' as _i33;
import '../endpoints/server_only_scoped_field_model_child.dart' as _i34;
import '../endpoints/session_authentication.dart' as _i35;
import '../endpoints/session_authentication_streaming.dart' as _i36;
import '../endpoints/set_parameters.dart' as _i37;
import '../endpoints/signin_required.dart' as _i38;
import '../endpoints/simple.dart' as _i39;
import '../endpoints/streaming.dart' as _i40;
import '../endpoints/streaming_logging.dart' as _i41;
import '../endpoints/subDir/subSubDir/subsubdir_test_endpoint.dart' as _i42;
import '../endpoints/subDir/subdir_test_endpoint.dart' as _i43;
import '../endpoints/test_tools.dart' as _i44;
import '../endpoints/unauthenticated.dart' as _i45;
import '../endpoints/upload_too_large.dart' as _i46;
import '../my_feature/endpoints/my_feature_endpoint.dart' as _i47;
import 'dart:typed_data' as _i48;
import 'package:serverpod_test_shared/src/custom_classes.dart' as _i49;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i50;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i51;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i52;
import 'package:serverpod_test_server/src/generated/types.dart' as _i53;
import 'package:serverpod_test_server/src/generated/object_with_enum.dart'
    as _i54;
import 'package:serverpod_test_server/src/generated/object_with_object.dart'
    as _i55;
import 'package:serverpod_test_server/src/generated/required/model_with_required_field.dart'
    as _i56;
import 'package:serverpod_test_server/src/generated/object_field_scopes.dart'
    as _i57;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i58;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i59;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i60;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/parent.dart'
    as _i61;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/container.dart'
    as _i62;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/container_module.dart'
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
      'basicTypes': _i3.BasicTypesEndpoint()
        ..initialize(
          server,
          'basicTypes',
          null,
        ),
      'basicTypesStreaming': _i4.BasicTypesStreamingEndpoint()
        ..initialize(
          server,
          'basicTypesStreaming',
          null,
        ),
      'cloudStorage': _i5.CloudStorageEndpoint()
        ..initialize(
          server,
          'cloudStorage',
          null,
        ),
      's3CloudStorage': _i6.S3CloudStorageEndpoint()
        ..initialize(
          server,
          's3CloudStorage',
          null,
        ),
      'customClassProtocol': _i7.CustomClassProtocolEndpoint()
        ..initialize(
          server,
          'customClassProtocol',
          null,
        ),
      'customTypes': _i8.CustomTypesEndpoint()
        ..initialize(
          server,
          'customTypes',
          null,
        ),
      'basicDatabase': _i9.BasicDatabase()
        ..initialize(
          server,
          'basicDatabase',
          null,
        ),
      'transactionsDatabase': _i10.TransactionsDatabaseEndpoint()
        ..initialize(
          server,
          'transactionsDatabase',
          null,
        ),
      'deprecation': _i11.DeprecationEndpoint()
        ..initialize(
          server,
          'deprecation',
          null,
        ),
      'diagnosticEventTest': _i12.DiagnosticEventTestEndpoint()
        ..initialize(
          server,
          'diagnosticEventTest',
          null,
        ),
      'echoRequest': _i13.EchoRequestEndpoint()
        ..initialize(
          server,
          'echoRequest',
          null,
        ),
      'echoRequiredField': _i14.EchoRequiredFieldEndpoint()
        ..initialize(
          server,
          'echoRequiredField',
          null,
        ),
      'concreteBase': _i15.ConcreteBaseEndpoint()
        ..initialize(
          server,
          'concreteBase',
          null,
        ),
      'concreteSubClass': _i15.ConcreteSubClassEndpoint()
        ..initialize(
          server,
          'concreteSubClass',
          null,
        ),
      'independent': _i15.IndependentEndpoint()
        ..initialize(
          server,
          'independent',
          null,
        ),
      'concreteFromModuleAbstractBase':
          _i15.ConcreteFromModuleAbstractBaseEndpoint()..initialize(
            server,
            'concreteFromModuleAbstractBase',
            null,
          ),
      'concreteModuleBase': _i15.ConcreteModuleBaseEndpoint()
        ..initialize(
          server,
          'concreteModuleBase',
          null,
        ),
      'loggedIn': _i16.LoggedInEndpoint()
        ..initialize(
          server,
          'loggedIn',
          null,
        ),
      'myLoggedIn': _i16.MyLoggedInEndpoint()
        ..initialize(
          server,
          'myLoggedIn',
          null,
        ),
      'admin': _i16.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'myAdmin': _i16.MyAdminEndpoint()
        ..initialize(
          server,
          'myAdmin',
          null,
        ),
      'myConcreteAdmin': _i16.MyConcreteAdminEndpoint()
        ..initialize(
          server,
          'myConcreteAdmin',
          null,
        ),
      'exceptionTest': _i17.ExceptionTestEndpoint()
        ..initialize(
          server,
          'exceptionTest',
          null,
        ),
      'failedCalls': _i18.FailedCallsEndpoint()
        ..initialize(
          server,
          'failedCalls',
          null,
        ),
      'fieldScopes': _i19.FieldScopesEndpoint()
        ..initialize(
          server,
          'fieldScopes',
          null,
        ),
      'futureCalls': _i20.FutureCallsEndpoint()
        ..initialize(
          server,
          'futureCalls',
          null,
        ),
      'listParameters': _i21.ListParametersEndpoint()
        ..initialize(
          server,
          'listParameters',
          null,
        ),
      'logging': _i22.LoggingEndpoint()
        ..initialize(
          server,
          'logging',
          null,
        ),
      'streamLogging': _i22.StreamLogging()
        ..initialize(
          server,
          'streamLogging',
          null,
        ),
      'streamQueryLogging': _i22.StreamQueryLogging()
        ..initialize(
          server,
          'streamQueryLogging',
          null,
        ),
      'loggingDisabled': _i23.LoggingDisabledEndpoint()
        ..initialize(
          server,
          'loggingDisabled',
          null,
        ),
      'mapParameters': _i24.MapParametersEndpoint()
        ..initialize(
          server,
          'mapParameters',
          null,
        ),
      'methodSignaturePermutations': _i25.MethodSignaturePermutationsEndpoint()
        ..initialize(
          server,
          'methodSignaturePermutations',
          null,
        ),
      'moduleEndpointSubclass': _i26.ModuleEndpointSubclass()
        ..initialize(
          server,
          'moduleEndpointSubclass',
          null,
        ),
      'moduleEndpointAdaptation': _i26.ModuleEndpointAdaptation()
        ..initialize(
          server,
          'moduleEndpointAdaptation',
          null,
        ),
      'moduleEndpointReduction': _i26.ModuleEndpointReduction()
        ..initialize(
          server,
          'moduleEndpointReduction',
          null,
        ),
      'moduleEndpointExtension': _i26.ModuleEndpointExtension()
        ..initialize(
          server,
          'moduleEndpointExtension',
          null,
        ),
      'moduleSerialization': _i27.ModuleSerializationEndpoint()
        ..initialize(
          server,
          'moduleSerialization',
          null,
        ),
      'namedParameters': _i28.NamedParametersEndpoint()
        ..initialize(
          server,
          'namedParameters',
          null,
        ),
      'optionalParameters': _i29.OptionalParametersEndpoint()
        ..initialize(
          server,
          'optionalParameters',
          null,
        ),
      'inheritancePolymorphismTest': _i30.InheritancePolymorphismTestEndpoint()
        ..initialize(
          server,
          'inheritancePolymorphismTest',
          null,
        ),
      'recordParameters': _i31.RecordParametersEndpoint()
        ..initialize(
          server,
          'recordParameters',
          null,
        ),
      'redis': _i32.RedisEndpoint()
        ..initialize(
          server,
          'redis',
          null,
        ),
      'serverOnlyScopedFieldModel': _i33.ServerOnlyScopedFieldModelEndpoint()
        ..initialize(
          server,
          'serverOnlyScopedFieldModel',
          null,
        ),
      'serverOnlyScopedFieldChildModel':
          _i34.ServerOnlyScopedFieldChildModelEndpoint()..initialize(
            server,
            'serverOnlyScopedFieldChildModel',
            null,
          ),
      'sessionAuthentication': _i35.SessionAuthenticationEndpoint()
        ..initialize(
          server,
          'sessionAuthentication',
          null,
        ),
      'sessionAuthenticationStreaming':
          _i36.SessionAuthenticationStreamingEndpoint()..initialize(
            server,
            'sessionAuthenticationStreaming',
            null,
          ),
      'setParameters': _i37.SetParametersEndpoint()
        ..initialize(
          server,
          'setParameters',
          null,
        ),
      'signInRequired': _i38.SignInRequiredEndpoint()
        ..initialize(
          server,
          'signInRequired',
          null,
        ),
      'adminScopeRequired': _i38.AdminScopeRequiredEndpoint()
        ..initialize(
          server,
          'adminScopeRequired',
          null,
        ),
      'simple': _i39.SimpleEndpoint()
        ..initialize(
          server,
          'simple',
          null,
        ),
      'streaming': _i40.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          null,
        ),
      'streamingLogging': _i41.StreamingLoggingEndpoint()
        ..initialize(
          server,
          'streamingLogging',
          null,
        ),
      'subSubDirTest': _i42.SubSubDirTestEndpoint()
        ..initialize(
          server,
          'subSubDirTest',
          null,
        ),
      'subDirTest': _i43.SubDirTestEndpoint()
        ..initialize(
          server,
          'subDirTest',
          null,
        ),
      'testTools': _i44.TestToolsEndpoint()
        ..initialize(
          server,
          'testTools',
          null,
        ),
      'authenticatedTestTools': _i44.AuthenticatedTestToolsEndpoint()
        ..initialize(
          server,
          'authenticatedTestTools',
          null,
        ),
      'unauthenticated': _i45.UnauthenticatedEndpoint()
        ..initialize(
          server,
          'unauthenticated',
          null,
        ),
      'partiallyUnauthenticated': _i45.PartiallyUnauthenticatedEndpoint()
        ..initialize(
          server,
          'partiallyUnauthenticated',
          null,
        ),
      'unauthenticatedRequireLogin': _i45.UnauthenticatedRequireLoginEndpoint()
        ..initialize(
          server,
          'unauthenticatedRequireLogin',
          null,
        ),
      'requireLogin': _i45.RequireLoginEndpoint()
        ..initialize(
          server,
          'requireLogin',
          null,
        ),
      'upload': _i46.UploadEndpoint()
        ..initialize(
          server,
          'upload',
          null,
        ),
      'myFeature': _i47.MyFeatureEndpoint()
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['asyncTasks'] as _i2.AsyncTasksEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['asyncTasks'] as _i2.AsyncTasksEndpoint)
                  .throwExceptionAfterDelay(
                    session,
                    params['seconds'],
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i3.BasicTypesEndpoint).testInt(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicTypes'] as _i3.BasicTypesEndpoint)
                  .testDouble(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i3.BasicTypesEndpoint).testBool(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicTypes'] as _i3.BasicTypesEndpoint)
                  .testDateTime(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicTypes'] as _i3.BasicTypesEndpoint)
                  .testString(
                    session,
                    params['value'],
                  ),
        ),
        'testByteData': _i1.MethodConnector(
          name: 'testByteData',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i48.ByteData?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicTypes'] as _i3.BasicTypesEndpoint)
                  .testByteData(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicTypes'] as _i3.BasicTypesEndpoint)
                  .testDuration(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i3.BasicTypesEndpoint).testUuid(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i3.BasicTypesEndpoint).testUri(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicTypes'] as _i3.BasicTypesEndpoint)
                  .testBigInt(
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
                      .testString(
                        session,
                        streamParams['value']!.cast<String?>(),
                      ),
        ),
        'testByteData': _i1.MethodStreamConnector(
          name: 'testByteData',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<_i48.ByteData?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
                      .testByteData(
                        session,
                        streamParams['value']!.cast<_i48.ByteData?>(),
                      ),
        ),
        'testDuration': _i1.MethodStreamConnector(
          name: 'testDuration',
          params: {},
          streamParams: {
            'value': _i1.StreamParameterDescription<Duration?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _i4.BasicTypesStreamingEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
              type: _i1.getType<_i48.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
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
              type: _i1.getType<_i48.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customClassProtocol']
                          as _i7.CustomClassProtocolEndpoint)
                      .getProtocolField(session),
        ),
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
              type: _i1.getType<_i49.CustomClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i49.CustomClass?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i49.CustomClass2>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i49.CustomClass2?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i50.ExternalCustomClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i50.ExternalCustomClass?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i51.FreezedCustomClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i51.FreezedCustomClass?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i49.CustomClassWithoutProtocolSerialization>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
              type: _i1.getType<_i49.CustomClassWithProtocolSerialization>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
                  .getType<_i49.CustomClassWithProtocolSerializationMethod>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customTypes'] as _i8.CustomTypesEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .deleteAllSimpleTestData(session),
        ),
        'deleteSimpleTestDataLessThan': _i1.MethodConnector(
          name: 'deleteSimpleTestDataLessThan',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .findSimpleData(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .deleteRowSimpleData(
                    session,
                    params['simpleData'],
                  ),
        ),
        'deleteWhereSimpleData': _i1.MethodConnector(
          name: 'deleteWhereSimpleData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .deleteWhereSimpleData(session),
        ),
        'countSimpleData': _i1.MethodConnector(
          name: 'countSimpleData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .countSimpleData(session),
        ),
        'insertTypes': _i1.MethodConnector(
          name: 'insertTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i53.Types>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicDatabase'] as _i9.BasicDatabase).insertTypes(
                    session,
                    params['value'],
                  ),
        ),
        'updateTypes': _i1.MethodConnector(
          name: 'updateTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i53.Types>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicDatabase'] as _i9.BasicDatabase).updateTypes(
                    session,
                    params['value'],
                  ),
        ),
        'countTypesRows': _i1.MethodConnector(
          name: 'countTypesRows',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .countTypesRows(session),
        ),
        'deleteAllInTypes': _i1.MethodConnector(
          name: 'deleteAllInTypes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .deleteAllInTypes(session),
        ),
        'getTypes': _i1.MethodConnector(
          name: 'getTypes',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicDatabase'] as _i9.BasicDatabase).getTypes(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
              type: _i1.getType<_i54.ObjectWithEnum>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
              type: _i1.getType<_i55.ObjectWithObject>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .getObjectWithObject(
                    session,
                    params['id'],
                  ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
                  .deleteAll(session),
        ),
        'testByteDataStore': _i1.MethodConnector(
          name: 'testByteDataStore',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i9.BasicDatabase)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transactionsDatabase']
                          as _i10.TransactionsDatabaseEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transactionsDatabase']
                          as _i10.TransactionsDatabaseEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _i11.DeprecationEndpoint).
                  // ignore: deprecated_member_use_from_same_package
                  setGlobalDouble(
                    session,
                    params['value'],
                  ),
        ),
        'getGlobalDouble': _i1.MethodConnector(
          name: 'getGlobalDouble',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _i11.DeprecationEndpoint).
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['diagnosticEventTest']
                          as _i12.DiagnosticEventTestEndpoint)
                      .submitExceptionEvent(session),
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['echoRequest'] as _i13.EchoRequestEndpoint)
                  .echoAuthenticationKey(session),
        ),
        'echoHttpHeader': _i1.MethodConnector(
          name: 'echoHttpHeader',
          params: {
            'headerName': _i1.ParameterDescription(
              name: 'headerName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['echoRequest'] as _i13.EchoRequestEndpoint)
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
              type: _i1.getType<_i56.ModelWithRequiredField>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['echoRequiredField']
                          as _i14.EchoRequiredFieldEndpoint)
                      .echoModel(
                        session,
                        params['model'],
                      ),
        ),
        'throwException': _i1.MethodConnector(
          name: 'throwException',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['echoRequiredField']
                          as _i14.EchoRequiredFieldEndpoint)
                      .throwException(session),
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _i15.ConcreteBaseEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _i15.ConcreteBaseEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _i15.ConcreteBaseEndpoint)
                      .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _i1.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['concreteBase'] as _i15.ConcreteBaseEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i15.ConcreteSubClassEndpoint)
                      .subClassVirtualMethod(session),
        ),
        'virtualMethod': _i1.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i15.ConcreteSubClassEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i15.ConcreteSubClassEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i15.ConcreteSubClassEndpoint)
                      .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _i1.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['concreteSubClass']
                          as _i15.ConcreteSubClassEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['independent'] as _i15.IndependentEndpoint)
                  .subClassVirtualMethod(session),
        ),
        'virtualMethod': _i1.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['independent'] as _i15.IndependentEndpoint)
                  .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['independent'] as _i15.IndependentEndpoint)
                  .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['independent'] as _i15.IndependentEndpoint)
                  .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _i1.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['independent'] as _i15.IndependentEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteFromModuleAbstractBase']
                          as _i15.ConcreteFromModuleAbstractBaseEndpoint)
                      .virtualMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteFromModuleAbstractBase']
                          as _i15.ConcreteFromModuleAbstractBaseEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteModuleBase']
                          as _i15.ConcreteModuleBaseEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _i1.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteModuleBase']
                          as _i15.ConcreteModuleBaseEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _i1.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteModuleBase']
                          as _i15.ConcreteModuleBaseEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['myLoggedIn'] as _i16.MyLoggedInEndpoint).echo(
                    session,
                    params['value'],
                  ),
        ),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['myAdmin'] as _i16.MyAdminEndpoint).echo(
                session,
                params['value'],
              ),
        ),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['myConcreteAdmin'] as _i16.MyConcreteAdminEndpoint)
                      .echo(
                        session,
                        params['value'],
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exceptionTest'] as _i17.ExceptionTestEndpoint)
                      .throwNormalException(session),
        ),
        'throwExceptionWithData': _i1.MethodConnector(
          name: 'throwExceptionWithData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exceptionTest'] as _i17.ExceptionTestEndpoint)
                      .throwExceptionWithData(session),
        ),
        'workingWithoutException': _i1.MethodConnector(
          name: 'workingWithoutException',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exceptionTest'] as _i17.ExceptionTestEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['failedCalls'] as _i18.FailedCallsEndpoint)
                  .failedCall(session),
        ),
        'failedDatabaseQuery': _i1.MethodConnector(
          name: 'failedDatabaseQuery',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['failedCalls'] as _i18.FailedCallsEndpoint)
                  .failedDatabaseQuery(session),
        ),
        'failedDatabaseQueryCaughtException': _i1.MethodConnector(
          name: 'failedDatabaseQueryCaughtException',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['failedCalls'] as _i18.FailedCallsEndpoint)
                  .failedDatabaseQueryCaughtException(session),
        ),
        'slowCall': _i1.MethodConnector(
          name: 'slowCall',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['failedCalls'] as _i18.FailedCallsEndpoint)
                  .slowCall(session),
        ),
        'caughtException': _i1.MethodConnector(
          name: 'caughtException',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['failedCalls'] as _i18.FailedCallsEndpoint)
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
              type: _i1.getType<_i57.ObjectFieldScopes>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fieldScopes'] as _i19.FieldScopesEndpoint)
                  .storeObject(
                    session,
                    params['object'],
                  ),
        ),
        'retrieveObject': _i1.MethodConnector(
          name: 'retrieveObject',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fieldScopes'] as _i19.FieldScopesEndpoint)
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
              type: _i1.getType<_i52.SimpleData?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['futureCalls'] as _i20.FutureCallsEndpoint)
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
              type: _i1.getType<_i52.SimpleData?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['futureCalls'] as _i20.FutureCallsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
              type: _i1.getType<List<_i48.ByteData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
              type: _i1.getType<List<_i48.ByteData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
              type: _i1.getType<List<_i52.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
              type: _i1.getType<List<_i52.SimpleData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
              type: _i1.getType<List<_i52.SimpleData>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
              type: _i1.getType<List<_i52.SimpleData?>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters'] as _i21.ListParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint)
                  .slowQueryMethod(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['logging'] as _i22.LoggingEndpoint).queryMethod(
                    session,
                    params['queries'],
                  ),
        ),
        'failedQueryMethod': _i1.MethodConnector(
          name: 'failedQueryMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint)
                  .failedQueryMethod(session),
        ),
        'slowMethod': _i1.MethodConnector(
          name: 'slowMethod',
          params: {
            'delayMillis': _i1.ParameterDescription(
              name: 'delayMillis',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['logging'] as _i22.LoggingEndpoint).slowMethod(
                    session,
                    params['delayMillis'],
                  ),
        ),
        'failingMethod': _i1.MethodConnector(
          name: 'failingMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint)
                  .failingMethod(session),
        ),
        'emptyMethod': _i1.MethodConnector(
          name: 'emptyMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint).log(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint).logInfo(
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _i22.LoggingEndpoint)
                  .twoQueries(session),
        ),
        'streamEmpty': _i1.MethodStreamConnector(
          name: 'streamEmpty',
          params: {},
          streamParams: {
            'input': _i1.StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _i22.LoggingEndpoint).streamEmpty(
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _i22.LoggingEndpoint).streamLogging(
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _i22.LoggingEndpoint)
                  .streamQueryLogging(
                    session,
                    streamParams['input']!.cast<int>(),
                  ),
        ),
        'streamException': _i1.MethodStreamConnector(
          name: 'streamException',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _i22.LoggingEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loggingDisabled'] as _i23.LoggingDisabledEndpoint)
                      .logInfo(
                        session,
                        params['message'],
                      ),
        ),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                      .returnIntIntMap(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnNestedIntIntMap': _i1.MethodConnector(
          name: 'returnNestedIntIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Map<int, int>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                      .returnNestedIntIntMap(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnEnumIntMap': _i1.MethodConnector(
          name: 'returnEnumIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<_i59.TestEnum, int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                      .returnEnumIntMap(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnEnumMap': _i1.MethodConnector(
          name: 'returnEnumMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i59.TestEnum>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i48.ByteData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i48.ByteData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i52.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i52.SimpleData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i52.SimpleData>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i52.SimpleData?>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
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
                ),
              },
              call:
                  (
                    _i1.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                          .returnNestedNonStringKeyedMapInsideRecordInsideMap(
                            session,
                            params['map'],
                          )
                          .then(
                            (container) => _i58.mapContainerToJson(container),
                          ),
            ),
        'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap':
            _i1.MethodConnector(
              name: 'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap',
              params: {
                'map': _i1.ParameterDescription(
                  name: 'map',
                  type: _i1.getType<Map<String, (Map<int, int>,)>>(),
                  nullable: false,
                ),
              },
              call:
                  (
                    _i1.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                          .returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap(
                            session,
                            params['map'],
                          )
                          .then(
                            (container) => _i58.mapContainerToJson(container),
                          ),
            ),
        'returnDateTimeBoolMap': _i1.MethodConnector(
          name: 'returnDateTimeBoolMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<DateTime, bool>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                      .returnDateTimeBoolMap(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnDateTimeBoolMapNullable': _i1.MethodConnector(
          name: 'returnDateTimeBoolMapNullable',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<DateTime, bool>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                      .returnDateTimeBoolMapNullable(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) => container == null
                            ? null
                            : _i58.mapContainerToJson(container),
                      ),
        ),
        'returnIntStringMap': _i1.MethodConnector(
          name: 'returnIntStringMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<int, String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                      .returnIntStringMap(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnIntStringMapNullable': _i1.MethodConnector(
          name: 'returnIntStringMapNullable',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<int, String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters'] as _i24.MapParametersEndpoint)
                      .returnIntStringMapNullable(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) => container == null
                            ? null
                            : _i58.mapContainerToJson(container),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _i25.MethodSignaturePermutationsEndpoint)
                      .echoPositionalArgStreamAsFuture(
                        session,
                        streamParams['strings']!.cast<String>(),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _i26.ModuleEndpointSubclass)
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _i26.ModuleEndpointSubclass)
                      .echoRecord(
                        session,
                        params['value'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _i26.ModuleEndpointSubclass)
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
              type: _i1.getType<_i60.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _i26.ModuleEndpointSubclass)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _i26.ModuleEndpointAdaptation)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _i26.ModuleEndpointAdaptation)
                      .echoRecord(
                        session,
                        params['value'],
                        params['multiplier'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _i26.ModuleEndpointAdaptation)
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
              type: _i1.getType<_i60.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _i26.ModuleEndpointAdaptation)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointReduction']
                          as _i26.ModuleEndpointReduction)
                      .echoRecord(
                        session,
                        params['value'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointReduction']
                          as _i26.ModuleEndpointReduction)
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
              type: _i1.getType<_i60.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointReduction']
                          as _i26.ModuleEndpointReduction)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _i26.ModuleEndpointExtension)
                      .greet(
                        session,
                        params['name'],
                      ),
        ),
        'ignoredMethod': _i1.MethodConnector(
          name: 'ignoredMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _i26.ModuleEndpointExtension)
                      .ignoredMethod(session),
        ),
        'echoString': _i1.MethodConnector(
          name: 'echoString',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _i26.ModuleEndpointExtension)
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _i26.ModuleEndpointExtension)
                      .echoRecord(
                        session,
                        params['value'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _i26.ModuleEndpointExtension)
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
              type: _i1.getType<_i60.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _i26.ModuleEndpointExtension)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleSerialization']
                          as _i27.ModuleSerializationEndpoint)
                      .serializeModuleObject(session),
        ),
        'modifyModuleObject': _i1.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i60.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleSerialization']
                          as _i27.ModuleSerializationEndpoint)
                      .modifyModuleObject(
                        session,
                        params['object'],
                      ),
        ),
        'serializeNestedModuleObject': _i1.MethodConnector(
          name: 'serializeNestedModuleObject',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleSerialization']
                          as _i27.ModuleSerializationEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['namedParameters'] as _i28.NamedParametersEndpoint)
                      .namedParametersMethod(
                        session,
                        namedInt: params['namedInt'],
                        intWithDefaultValue: params['intWithDefaultValue'],
                        nullableInt: params['nullableInt'],
                        nullableIntWithDefaultValue:
                            params['nullableIntWithDefaultValue'],
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['namedParameters'] as _i28.NamedParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['optionalParameters']
                          as _i29.OptionalParametersEndpoint)
                      .returnOptionalInt(
                        session,
                        params['optionalInt'],
                      ),
        ),
      },
    );
    connectors['inheritancePolymorphismTest'] = _i1.EndpointConnector(
      name: 'inheritancePolymorphismTest',
      endpoint: endpoints['inheritancePolymorphismTest']!,
      methodConnectors: {
        'polymorphicRoundtrip': _i1.MethodConnector(
          name: 'polymorphicRoundtrip',
          params: {
            'parent': _i1.ParameterDescription(
              name: 'parent',
              type: _i1.getType<_i61.PolymorphicParent>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['inheritancePolymorphismTest']
                          as _i30.InheritancePolymorphismTestEndpoint)
                      .polymorphicRoundtrip(
                        session,
                        params['parent'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'polymorphicContainerRoundtrip': _i1.MethodConnector(
          name: 'polymorphicContainerRoundtrip',
          params: {
            'container': _i1.ParameterDescription(
              name: 'container',
              type: _i1.getType<_i62.PolymorphicChildContainer>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['inheritancePolymorphismTest']
                          as _i30.InheritancePolymorphismTestEndpoint)
                      .polymorphicContainerRoundtrip(
                        session,
                        params['container'],
                      ),
        ),
        'polymorphicModuleContainerRoundtrip': _i1.MethodConnector(
          name: 'polymorphicModuleContainerRoundtrip',
          params: {
            'container': _i1.ParameterDescription(
              name: 'container',
              type: _i1.getType<_i63.ModulePolymorphicChildContainer>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['inheritancePolymorphismTest']
                          as _i30.InheritancePolymorphismTestEndpoint)
                      .polymorphicModuleContainerRoundtrip(
                        session,
                        params['container'],
                      ),
        ),
        'polymorphicStreamingRoundtrip': _i1.MethodStreamConnector(
          name: 'polymorphicStreamingRoundtrip',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<_i61.PolymorphicParent>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['inheritancePolymorphismTest']
                          as _i30.InheritancePolymorphismTestEndpoint)
                      .polymorphicStreamingRoundtrip(
                        session,
                        streamParams['stream']!.cast<_i61.PolymorphicParent>(),
                      ),
        ),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnRecordOfInt(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNullableRecordOfInt': _i1.MethodConnector(
          name: 'returnNullableRecordOfInt',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int,)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNullableRecordOfInt(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnRecordOfNullableInt': _i1.MethodConnector(
          name: 'returnRecordOfNullableInt',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int?,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnRecordOfNullableInt(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNullableRecordOfNullableInt': _i1.MethodConnector(
          name: 'returnNullableRecordOfNullableInt',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int?,)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNullableRecordOfNullableInt(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnIntStringRecord': _i1.MethodConnector(
          name: 'returnIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, String)>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNullableIntStringRecord': _i1.MethodConnector(
          name: 'returnNullableIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, String)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNullableIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnIntSimpleDataRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, _i52.SimpleData)>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnIntSimpleDataRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnNullableIntSimpleDataRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, _i52.SimpleData)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNullableIntSimpleDataRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnStringKeyedMapRecord': _i1.MethodConnector(
          name: 'returnStringKeyedMapRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(Map<String, int>,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnStringKeyedMapRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNonStringKeyedMapRecord': _i1.MethodConnector(
          name: 'returnNonStringKeyedMapRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(Map<int, int>,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNonStringKeyedMapRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnSetWithNestedRecordRecord': _i1.MethodConnector(
          name: 'returnSetWithNestedRecordRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(Set<(int,)>,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnSetWithNestedRecordRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNamedIntStringRecord': _i1.MethodConnector(
          name: 'returnNamedIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({int number, String text})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNamedIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNamedNullableIntStringRecord': _i1.MethodConnector(
          name: 'returnNamedNullableIntStringRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({int number, String text})?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNamedNullableIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnRecordOfNamedIntAndObject': _i1.MethodConnector(
          name: 'returnRecordOfNamedIntAndObject',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({_i52.SimpleData data, int number})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnRecordOfNamedIntAndObject(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNullableRecordOfNamedIntAndObject': _i1.MethodConnector(
          name: 'returnNullableRecordOfNamedIntAndObject',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({_i52.SimpleData data, int number})?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNullableRecordOfNamedIntAndObject(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnRecordOfNamedNullableIntAndNullableObject': _i1.MethodConnector(
          name: 'returnRecordOfNamedNullableIntAndNullableObject',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({_i52.SimpleData? data, int? number})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnRecordOfNamedNullableIntAndNullableObject(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNamedNonStringKeyedMapRecord': _i1.MethodConnector(
          name: 'returnNamedNonStringKeyedMapRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({Map<int, int> intIntMap})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNamedNonStringKeyedMapRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNamedSetWithNestedRecordRecord': _i1.MethodConnector(
          name: 'returnNamedSetWithNestedRecordRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({Set<(bool,)> boolSet})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNamedSetWithNestedRecordRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord':
            _i1.MethodConnector(
              name:
                  'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord',
              params: {
                'map': _i1.ParameterDescription(
                  name: 'map',
                  type: _i1
                      .getType<(Map<(Map<int, String>, String), String>,)>(),
                  nullable: false,
                ),
              },
              call:
                  (
                    _i1.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['recordParameters']
                              as _i31.RecordParametersEndpoint)
                          .returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord(
                            session,
                            params['map'],
                          )
                          .then((record) => _i58.mapRecordToJson(record)),
            ),
        'returnRecordTypedef': _i1.MethodConnector(
          name: 'returnRecordTypedef',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, {_i52.SimpleData data})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnRecordTypedef(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNullableRecordTypedef': _i1.MethodConnector(
          name: 'returnNullableRecordTypedef',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<(int, {_i52.SimpleData data})?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNullableRecordTypedef(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnListOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnListOfIntSimpleDataRecord',
          params: {
            'recordList': _i1.ParameterDescription(
              name: 'recordList',
              type: _i1.getType<List<(int, _i52.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnListOfIntSimpleDataRecord(
                        session,
                        params['recordList'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnListOfNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnListOfNullableIntSimpleDataRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<List<(int, _i52.SimpleData)?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnListOfNullableIntSimpleDataRecord(
                        session,
                        params['record'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnSetOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnSetOfIntSimpleDataRecord',
          params: {
            'recordSet': _i1.ParameterDescription(
              name: 'recordSet',
              type: _i1.getType<Set<(int, _i52.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnSetOfIntSimpleDataRecord(
                        session,
                        params['recordSet'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnSetOfNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnSetOfNullableIntSimpleDataRecord',
          params: {
            'set': _i1.ParameterDescription(
              name: 'set',
              type: _i1.getType<Set<(int, _i52.SimpleData)?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnSetOfNullableIntSimpleDataRecord(
                        session,
                        params['set'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnNullableSetOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnNullableSetOfIntSimpleDataRecord',
          params: {
            'recordSet': _i1.ParameterDescription(
              name: 'recordSet',
              type: _i1.getType<Set<(int, _i52.SimpleData)>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNullableSetOfIntSimpleDataRecord(
                        session,
                        params['recordSet'],
                      )
                      .then(
                        (container) => container == null
                            ? null
                            : _i58.mapContainerToJson(container),
                      ),
        ),
        'returnStringMapOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnStringMapOfIntSimpleDataRecord',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, (int, _i52.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnStringMapOfIntSimpleDataRecord(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnStringMapOfNullableIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnStringMapOfNullableIntSimpleDataRecord',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, (int, _i52.SimpleData)?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnStringMapOfNullableIntSimpleDataRecord(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnRecordMapOfIntSimpleDataRecord': _i1.MethodConnector(
          name: 'returnRecordMapOfIntSimpleDataRecord',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<(String, int), (int, _i52.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnRecordMapOfIntSimpleDataRecord(
                        session,
                        params['map'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnStringMapOfListOfRecord': _i1.MethodConnector(
          name: 'returnStringMapOfListOfRecord',
          params: {
            'input': _i1.ParameterDescription(
              name: 'input',
              type: _i1.getType<Set<List<Map<String, (int,)>>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnStringMapOfListOfRecord(
                        session,
                        params['input'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnNestedNamedRecord': _i1.MethodConnector(
          name: 'returnNestedNamedRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<({(_i52.SimpleData, double) namedSubRecord})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNestedNamedRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNestedNullableNamedRecord': _i1.MethodConnector(
          name: 'returnNestedNullableNamedRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1
                  .getType<({(_i52.SimpleData, double)? namedSubRecord})>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNestedNullableNamedRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnNestedPositionalAndNamedRecord': _i1.MethodConnector(
          name: 'returnNestedPositionalAndNamedRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1
                  .getType<
                    ((int, String), {(_i52.SimpleData, double) namedSubRecord})
                  >(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnNestedPositionalAndNamedRecord(
                        session,
                        params['record'],
                      )
                      .then((record) => _i58.mapRecordToJson(record)),
        ),
        'returnListOfNestedPositionalAndNamedRecord': _i1.MethodConnector(
          name: 'returnListOfNestedPositionalAndNamedRecord',
          params: {
            'recordList': _i1.ParameterDescription(
              name: 'recordList',
              type: _i1
                  .getType<
                    List<
                      (
                        (int, String), {
                        (_i52.SimpleData, double) namedSubRecord,
                      })
                    >
                  >(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .returnListOfNestedPositionalAndNamedRecord(
                        session,
                        params['recordList'],
                      )
                      .then((container) => _i58.mapContainerToJson(container)),
        ),
        'echoModelClassWithRecordField': _i1.MethodConnector(
          name: 'echoModelClassWithRecordField',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i64.TypesRecord>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
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
                  type: _i1.getType<_i60.ModuleClass?>(),
                  nullable: true,
                ),
              },
              call:
                  (
                    _i1.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['recordParameters']
                              as _i31.RecordParametersEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .streamNullableRecordOfNullableInt(
                        session,
                        streamParams['values']!.cast<(int?,)?>(),
                      ),
        ),
        'streamNullableListOfNullableNestedPositionalAndNamedRecord':
            _i1.MethodStreamConnector(
              name:
                  'streamNullableListOfNullableNestedPositionalAndNamedRecord',
              params: {
                'initialValue': _i1.ParameterDescription(
                  name: 'initialValue',
                  type: _i1
                      .getType<
                        List<
                          (
                            (int, String), {
                            (_i52.SimpleData, double) namedSubRecord,
                          })?
                        >?
                      >(),
                  nullable: true,
                ),
              },
              streamParams: {
                'values':
                    _i1.StreamParameterDescription<
                      List<
                        (
                          (int, String), {
                          (_i52.SimpleData, double) namedSubRecord,
                        })?
                      >?
                    >(
                      name: 'values',
                      nullable: false,
                    ),
              },
              returnType: _i1.MethodStreamReturnType.streamType,
              call:
                  (
                    _i1.Session session,
                    Map<String, dynamic> params,
                    Map<String, Stream> streamParams,
                  ) =>
                      (endpoints['recordParameters']
                              as _i31.RecordParametersEndpoint)
                          .streamNullableListOfNullableNestedPositionalAndNamedRecord(
                            session,
                            params['initialValue'],
                            streamParams['values']!
                                .cast<
                                  List<
                                    (
                                      (int, String), {
                                      (_i52.SimpleData, double) namedSubRecord,
                                    })?
                                  >?
                                >(),
                          ),
            ),
        'streamOfModelClassWithRecordField': _i1.MethodStreamConnector(
          name: 'streamOfModelClassWithRecordField',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i64.TypesRecord>(),
              nullable: false,
            ),
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i64.TypesRecord>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
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
            ),
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i64.TypesRecord?>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordParameters']
                          as _i31.RecordParametersEndpoint)
                      .streamOfNullableModelClassWithRecordField(
                        session,
                        params['initialValue'],
                        streamParams['values']!.cast<_i64.TypesRecord?>(),
                      ),
        ),
        'streamOfNullableModelClassWithRecordFieldFromExternalModule':
            _i1.MethodStreamConnector(
              name:
                  'streamOfNullableModelClassWithRecordFieldFromExternalModule',
              params: {
                'initialValue': _i1.ParameterDescription(
                  name: 'initialValue',
                  type: _i1.getType<_i60.ModuleClass?>(),
                  nullable: true,
                ),
              },
              streamParams: {
                'values': _i1.StreamParameterDescription<_i60.ModuleClass?>(
                  name: 'values',
                  nullable: false,
                ),
              },
              returnType: _i1.MethodStreamReturnType.streamType,
              call:
                  (
                    _i1.Session session,
                    Map<String, dynamic> params,
                    Map<String, Stream> streamParams,
                  ) =>
                      (endpoints['recordParameters']
                              as _i31.RecordParametersEndpoint)
                          .streamOfNullableModelClassWithRecordFieldFromExternalModule(
                            session,
                            params['initialValue'],
                            streamParams['values']!.cast<_i60.ModuleClass?>(),
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i32.RedisEndpoint).setSimpleData(
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i32.RedisEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i32.RedisEndpoint).getSimpleData(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i32.RedisEndpoint).deleteSimpleData(
                    session,
                    params['key'],
                  ),
        ),
        'resetMessageCentralTest': _i1.MethodConnector(
          name: 'resetMessageCentralTest',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i32.RedisEndpoint)
                  .resetMessageCentralTest(session),
        ),
        'listenToChannel': _i1.MethodConnector(
          name: 'listenToChannel',
          params: {
            'channel': _i1.ParameterDescription(
              name: 'channel',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i32.RedisEndpoint).listenToChannel(
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i32.RedisEndpoint).postToChannel(
                    session,
                    params['channel'],
                    params['data'],
                  ),
        ),
        'countSubscribedChannels': _i1.MethodConnector(
          name: 'countSubscribedChannels',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i32.RedisEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['serverOnlyScopedFieldModel']
                          as _i33.ServerOnlyScopedFieldModelEndpoint)
                      .getScopeServerOnlyField(session),
        ),
      },
    );
    connectors['serverOnlyScopedFieldChildModel'] = _i1.EndpointConnector(
      name: 'serverOnlyScopedFieldChildModel',
      endpoint: endpoints['serverOnlyScopedFieldChildModel']!,
      methodConnectors: {
        'getProtocolField': _i1.MethodConnector(
          name: 'getProtocolField',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['serverOnlyScopedFieldChildModel']
                          as _i34.ServerOnlyScopedFieldChildModelEndpoint)
                      .getProtocolField(session),
        ),
      },
    );
    connectors['sessionAuthentication'] = _i1.EndpointConnector(
      name: 'sessionAuthentication',
      endpoint: endpoints['sessionAuthentication']!,
      methodConnectors: {
        'getAuthenticatedUserId': _i1.MethodConnector(
          name: 'getAuthenticatedUserId',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _i35.SessionAuthenticationEndpoint)
                      .getAuthenticatedUserId(session),
        ),
        'getAuthenticatedScopes': _i1.MethodConnector(
          name: 'getAuthenticatedScopes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _i35.SessionAuthenticationEndpoint)
                      .getAuthenticatedScopes(session),
        ),
        'getAuthenticatedAuthId': _i1.MethodConnector(
          name: 'getAuthenticatedAuthId',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _i35.SessionAuthenticationEndpoint)
                      .getAuthenticatedAuthId(session),
        ),
        'getAuthenticationInfo': _i1.MethodConnector(
          name: 'getAuthenticationInfo',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _i35.SessionAuthenticationEndpoint)
                      .getAuthenticationInfo(session),
        ),
        'isAuthenticated': _i1.MethodConnector(
          name: 'isAuthenticated',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _i35.SessionAuthenticationEndpoint)
                      .isAuthenticated(session),
        ),
        'streamAuthenticatedUserId': _i1.MethodStreamConnector(
          name: 'streamAuthenticatedUserId',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['sessionAuthentication']
                          as _i35.SessionAuthenticationEndpoint)
                      .streamAuthenticatedUserId(session),
        ),
        'streamIsAuthenticated': _i1.MethodStreamConnector(
          name: 'streamIsAuthenticated',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['sessionAuthentication']
                          as _i35.SessionAuthenticationEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
              type: _i1.getType<Set<_i48.ByteData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
              type: _i1.getType<Set<_i48.ByteData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
              type: _i1.getType<Set<_i52.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
              type: _i1.getType<Set<_i52.SimpleData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters'] as _i37.SetParametersEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['signInRequired'] as _i38.SignInRequiredEndpoint)
                      .testMethod(session),
        ),
      },
    );
    connectors['adminScopeRequired'] = _i1.EndpointConnector(
      name: 'adminScopeRequired',
      endpoint: endpoints['adminScopeRequired']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminScopeRequired']
                          as _i38.AdminScopeRequiredEndpoint)
                      .testMethod(session),
        ),
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simple'] as _i39.SimpleEndpoint).setGlobalInt(
                    session,
                    params['value'],
                    params['secondValue'],
                  ),
        ),
        'addToGlobalInt': _i1.MethodConnector(
          name: 'addToGlobalInt',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['simple'] as _i39.SimpleEndpoint)
                  .addToGlobalInt(session),
        ),
        'getGlobalInt': _i1.MethodConnector(
          name: 'getGlobalInt',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['simple'] as _i39.SimpleEndpoint)
                  .getGlobalInt(session),
        ),
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['simple'] as _i39.SimpleEndpoint).hello(
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['subSubDirTest'] as _i42.SubSubDirTestEndpoint)
                      .testMethod(session),
        ),
      },
    );
    connectors['subDirTest'] = _i1.EndpointConnector(
      name: 'subDirTest',
      endpoint: endpoints['subDirTest']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['subDirTest'] as _i43.SubDirTestEndpoint)
                  .testMethod(session),
        ),
      },
    );
    connectors['testTools'] = _i1.EndpointConnector(
      name: 'testTools',
      endpoint: endpoints['testTools']!,
      methodConnectors: {
        'returnsSessionId': _i1.MethodConnector(
          name: 'returnsSessionId',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsSessionId(session),
        ),
        'returnsSessionEndpointAndMethod': _i1.MethodConnector(
          name: 'returnsSessionEndpointAndMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsSessionEndpointAndMethod(session),
        ),
        'returnsString': _i1.MethodConnector(
          name: 'returnsString',
          params: {
            'string': _i1.ParameterDescription(
              name: 'string',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsString(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .createSimpleData(
                    session,
                    params['data'],
                  ),
        ),
        'getAllSimpleData': _i1.MethodConnector(
          name: 'getAllSimpleData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .getAllSimpleData(session),
        ),
        'createSimpleDatasInsideTransactions': _i1.MethodConnector(
          name: 'createSimpleDatasInsideTransactions',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .createSimpleDataAndThrowInsideTransaction(
                    session,
                    params['data'],
                  ),
        ),
        'createSimpleDatasInParallelTransactionCalls': _i1.MethodConnector(
          name: 'createSimpleDatasInParallelTransactionCalls',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .createSimpleDatasInParallelTransactionCalls(session),
        ),
        'echoSimpleData': _i1.MethodConnector(
          name: 'echoSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .echoSimpleData(
                    session,
                    params['simpleData'],
                  ),
        ),
        'echoSimpleDatas': _i1.MethodConnector(
          name: 'echoSimpleDatas',
          params: {
            'simpleDatas': _i1.ParameterDescription(
              name: 'simpleDatas',
              type: _i1.getType<List<_i52.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1.getType<_i53.Types>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['testTools'] as _i44.TestToolsEndpoint).echoTypes(
                    session,
                    params['typesModel'],
                  ),
        ),
        'echoTypesList': _i1.MethodConnector(
          name: 'echoTypesList',
          params: {
            'typesList': _i1.ParameterDescription(
              name: 'typesList',
              type: _i1.getType<List<_i53.Types>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .echoTypesList(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1.getType<_i60.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .echoRecord(
                    session,
                    params['record'],
                  )
                  .then((record) => _i58.mapRecordToJson(record)),
        ),
        'echoRecords': _i1.MethodConnector(
          name: 'echoRecords',
          params: {
            'records': _i1.ParameterDescription(
              name: 'records',
              type: _i1.getType<List<(String, (int, bool))>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .echoRecords(
                    session,
                    params['records'],
                  )
                  .then((container) => _i58.mapContainerToJson(container)),
        ),
        'returnRecordWithSerializableObject': _i1.MethodConnector(
          name: 'returnRecordWithSerializableObject',
          params: {
            'number': _i1.ParameterDescription(
              name: 'number',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnRecordWithSerializableObject(
                    session,
                    params['number'],
                    params['data'],
                  )
                  .then((record) => _i58.mapRecordToJson(record)),
        ),
        'logMessageWithSession': _i1.MethodConnector(
          name: 'logMessageWithSession',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .logMessageWithSession(session),
        ),
        'addWillCloseListenerToSessionAndThrow': _i1.MethodConnector(
          name: 'addWillCloseListenerToSessionAndThrow',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1.getType<_i52.SimpleData>(),
              nullable: false,
            ),
            'group': _i1.ParameterDescription(
              name: 'group',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsSessionIdFromStream(session),
        ),
        'returnsSessionEndpointAndMethodFromStream': _i1.MethodStreamConnector(
          name: 'returnsSessionEndpointAndMethodFromStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsSessionEndpointAndMethodFromStream(session),
        ),
        'returnsStream': _i1.MethodStreamConnector(
          name: 'returnsStream',
          params: {
            'n': _i1.ParameterDescription(
              name: 'n',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsListFromInputStream(
                    session,
                    streamParams['numbers']!.cast<int>(),
                  ),
        ),
        'returnsSimpleDataListFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsSimpleDataListFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _i1.StreamParameterDescription<_i52.SimpleData>(
              name: 'simpleDatas',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsSimpleDataListFromInputStream(
                    session,
                    streamParams['simpleDatas']!.cast<_i52.SimpleData>(),
                  ),
        ),
        'returnsStreamFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsStreamFromInputStream',
          params: {},
          streamParams: {
            'numbers': _i1.StreamParameterDescription<int>(
              name: 'numbers',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsStreamFromInputStream(
                    session,
                    streamParams['numbers']!.cast<int>(),
                  ),
        ),
        'returnsSimpleDataStreamFromInputStream': _i1.MethodStreamConnector(
          name: 'returnsSimpleDataStreamFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _i1.StreamParameterDescription<_i52.SimpleData>(
              name: 'simpleDatas',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .returnsSimpleDataStreamFromInputStream(
                    session,
                    streamParams['simpleDatas']!.cast<_i52.SimpleData>(),
                  ),
        ),
        'postNumberToSharedStreamAndReturnStream': _i1.MethodStreamConnector(
          name: 'postNumberToSharedStreamAndReturnStream',
          params: {
            'number': _i1.ParameterDescription(
              name: 'number',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .listenForNumbersOnSharedStream(session),
        ),
        'streamModuleDatatype': _i1.MethodStreamConnector(
          name: 'streamModuleDatatype',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<_i65.ModuleDatatype?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i65.ModuleDatatype?>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1.getType<_i60.ModuleClass?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'values': _i1.StreamParameterDescription<_i60.ModuleClass?>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .streamModuleClass(
                    session,
                    params['initialValue'],
                    streamParams['values']!.cast<_i60.ModuleClass?>(),
                  ),
        ),
        'recordEchoStream': _i1.MethodStreamConnector(
          name: 'recordEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1
                  .getType<
                    (
                      String,
                      (
                        Map<String, int>, {
                        bool flag,
                        _i52.SimpleData simpleData,
                      }),
                    )
                  >(),
              nullable: false,
            ),
          },
          streamParams: {
            'stream':
                _i1.StreamParameterDescription<
                  (
                    String,
                    (Map<String, int>, {bool flag, _i52.SimpleData simpleData}),
                  )
                >(
                  name: 'stream',
                  nullable: false,
                ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .recordEchoStream(
                    session,
                    params['initialValue'],
                    streamParams['stream']!
                        .cast<
                          (
                            String,
                            (
                              Map<String, int>, {
                              bool flag,
                              _i52.SimpleData simpleData,
                            }),
                          )
                        >(),
                  ),
        ),
        'listOfRecordEchoStream': _i1.MethodStreamConnector(
          name: 'listOfRecordEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<List<(String, int)>>(),
              nullable: false,
            ),
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<List<(String, int)>>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              type: _i1
                  .getType<
                    (
                      String,
                      (
                        Map<String, int>, {
                        bool flag,
                        _i52.SimpleData simpleData,
                      }),
                    )?
                  >(),
              nullable: true,
            ),
          },
          streamParams: {
            'stream':
                _i1.StreamParameterDescription<
                  (
                    String,
                    (Map<String, int>, {bool flag, _i52.SimpleData simpleData}),
                  )?
                >(
                  name: 'stream',
                  nullable: false,
                ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                  .nullableRecordEchoStream(
                    session,
                    params['initialValue'],
                    streamParams['stream']!
                        .cast<
                          (
                            String,
                            (
                              Map<String, int>, {
                              bool flag,
                              _i52.SimpleData simpleData,
                            }),
                          )?
                        >(),
                  ),
        ),
        'nullableListOfRecordEchoStream': _i1.MethodStreamConnector(
          name: 'nullableListOfRecordEchoStream',
          params: {
            'initialValue': _i1.ParameterDescription(
              name: 'initialValue',
              type: _i1.getType<List<(String, int)>?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<List<(String, int)>?>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
            ),
          },
          streamParams: {
            'stream': _i1.StreamParameterDescription<_i64.TypesRecord?>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
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
              call:
                  (
                    _i1.Session session,
                    Map<String, dynamic> params,
                    Map<String, Stream> streamParams,
                  ) => (endpoints['testTools'] as _i44.TestToolsEndpoint)
                      .addWillCloseListenerToSessionIntStreamMethodAndThrow(
                        session,
                      ),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authenticatedTestTools']
                          as _i44.AuthenticatedTestToolsEndpoint)
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
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedTestTools']
                          as _i44.AuthenticatedTestToolsEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedTestTools']
                          as _i44.AuthenticatedTestToolsEndpoint)
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
            ),
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedTestTools']
                          as _i44.AuthenticatedTestToolsEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['unauthenticated'] as _i45.UnauthenticatedEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['unauthenticated'] as _i45.UnauthenticatedEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['partiallyUnauthenticated']
                          as _i45.PartiallyUnauthenticatedEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'authenticatedMethod': _i1.MethodConnector(
          name: 'authenticatedMethod',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['partiallyUnauthenticated']
                          as _i45.PartiallyUnauthenticatedEndpoint)
                      .authenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['partiallyUnauthenticated']
                          as _i45.PartiallyUnauthenticatedEndpoint)
                      .unauthenticatedStream(session),
        ),
        'authenticatedStream': _i1.MethodStreamConnector(
          name: 'authenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['partiallyUnauthenticated']
                          as _i45.PartiallyUnauthenticatedEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['unauthenticatedRequireLogin']
                          as _i45.UnauthenticatedRequireLoginEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['unauthenticatedRequireLogin']
                          as _i45.UnauthenticatedRequireLoginEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['requireLogin'] as _i45.RequireLoginEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _i1.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['requireLogin'] as _i45.RequireLoginEndpoint)
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
              type: _i1.getType<_i48.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['upload'] as _i46.UploadEndpoint).uploadByteData(
                    session,
                    params['path'],
                    params['data'],
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['myFeature'] as _i47.MyFeatureEndpoint)
                  .myFeatureMethod(session),
        ),
        'myFeatureModel': _i1.MethodConnector(
          name: 'myFeatureModel',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['myFeature'] as _i47.MyFeatureEndpoint)
                  .myFeatureModel(session),
        ),
      },
    );
    modules['serverpod_test_module'] = _i60.Endpoints()
      ..initializeEndpoints(server);
  }
}
