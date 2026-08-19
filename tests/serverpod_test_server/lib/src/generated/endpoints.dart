/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _iom2gwyu;
import 'package:serverpod_test_server/src/generated/future_calls.dart'
    as _i3an2vcw;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/container.dart'
    as _ioyh3y7j;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/container_module.dart'
    as _ij2aep0j;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/parent.dart'
    as _ieub4zqi;
import 'package:serverpod_test_server/src/generated/module_datatype.dart'
    as _idarivwd;
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
import 'package:serverpod_test_server/src/generated/simple_data.dart'
    as _i685tvwm;
import 'package:serverpod_test_server/src/generated/test_enum.dart'
    as _izdri23a;
import 'package:serverpod_test_server/src/generated/types.dart' as _iuch3ck4;
import 'package:serverpod_test_server/src/generated/types_record.dart'
    as _ix95ig49;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    as _iyx9etqn;
import '../endpoints/async_tasks.dart' as _iyams8ur;
import '../endpoints/authentication.dart' as _iqzgn7n3;
import '../endpoints/basic_types.dart' as _i795tvcb;
import '../endpoints/basic_types_streaming.dart' as _ioq23vds;
import '../endpoints/cloud_storage.dart' as _i539zsf6;
import '../endpoints/cloud_storage_s3.dart' as _iez7ug2d;
import '../endpoints/custom_class_protocol.dart' as _iwz8g6i5;
import '../endpoints/custom_types.dart' as _i7bcbcdf;
import '../endpoints/database_basic.dart' as _i72l4yiw;
import '../endpoints/database_transactions.dart' as _iitlqru7;
import '../endpoints/deprecation.dart' as _idq2fszg;
import '../endpoints/diagnostic_event_test_endpoint.dart' as _i80k5lij;
import '../endpoints/echo_request.dart' as _ivddvur7;
import '../endpoints/echo_required_field.dart' as _ik6eczg2;
import '../endpoints/email_auth_provider.dart' as _ijlsxep6;
import '../endpoints/endpoint_inheritance.dart' as _i0zjahsw;
import '../endpoints/endpoint_login_hierarchy.dart' as _inx00omf;
import '../endpoints/exception_test_endpoint.dart' as _igyldlid;
import '../endpoints/failed_calls.dart' as _ik2ddfcb;
import '../endpoints/field_scopes.dart' as _iwb8t23v;
import '../endpoints/future_calls.dart' as _i86flpi8;
import '../endpoints/list_parameters.dart' as _ijuqq02d;
import '../endpoints/logging.dart' as _ihsjb7qe;
import '../endpoints/logging_disabled.dart' as _iqn8602i;
import '../endpoints/map_parameters.dart' as _i7zzrcbk;
import '../endpoints/method_signature_permutations.dart' as _ixhdyiji;
import '../endpoints/method_streaming.dart' as _icmw7mkg;
import '../endpoints/module_endpoint_extension.dart' as _ioqbbgad;
import '../endpoints/module_serialization.dart' as _iwv9sobp;
import '../endpoints/named_parameters.dart' as _ims5wkpy;
import '../endpoints/optional_parameters.dart' as _ifkxt35t;
import '../endpoints/polymorphism.dart' as _iiarbij8;
import '../endpoints/record_parameters.dart' as _ib1glaoo;
import '../endpoints/redis.dart' as _i5ia1kr7;
import '../endpoints/server_only_scoped_field_model.dart' as _ix3s2g81;
import '../endpoints/server_only_scoped_field_model_child.dart' as _iv5t2nu0;
import '../endpoints/session_authentication.dart' as _ieivi1oj;
import '../endpoints/set_parameters.dart' as _i80ils9z;
import '../endpoints/signin_required.dart' as _idzjag2f;
import '../endpoints/simple.dart' as _il4e9ez0;
import '../endpoints/subDir/subdir_test_endpoint.dart' as _i7nbpkw0;
import '../endpoints/subDir/subSubDir/subsubdir_test_endpoint.dart'
    as _ig647puh;
import '../endpoints/test_tools.dart' as _itdztv0y;
import '../endpoints/unauthenticated.dart' as _ius7wovq;
import '../endpoints/upload_too_large.dart' as _ia6lpdch;
import '../my_feature/endpoints/my_feature_endpoint.dart' as _ij2anjje;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'asyncTasks': _iyams8ur.AsyncTasksEndpoint()
        ..initialize(
          server,
          'asyncTasks',
          null,
        ),
      'authentication': _iqzgn7n3.AuthenticationEndpoint()
        ..initialize(
          server,
          'authentication',
          null,
        ),
      'basicTypes': _i795tvcb.BasicTypesEndpoint()
        ..initialize(
          server,
          'basicTypes',
          null,
        ),
      'basicTypesStreaming': _ioq23vds.BasicTypesStreamingEndpoint()
        ..initialize(
          server,
          'basicTypesStreaming',
          null,
        ),
      'cloudStorage': _i539zsf6.CloudStorageEndpoint()
        ..initialize(
          server,
          'cloudStorage',
          null,
        ),
      's3CloudStorage': _iez7ug2d.S3CloudStorageEndpoint()
        ..initialize(
          server,
          's3CloudStorage',
          null,
        ),
      'customClassProtocol': _iwz8g6i5.CustomClassProtocolEndpoint()
        ..initialize(
          server,
          'customClassProtocol',
          null,
        ),
      'customTypes': _i7bcbcdf.CustomTypesEndpoint()
        ..initialize(
          server,
          'customTypes',
          null,
        ),
      'basicDatabase': _i72l4yiw.BasicDatabase()
        ..initialize(
          server,
          'basicDatabase',
          null,
        ),
      'transactionsDatabase': _iitlqru7.TransactionsDatabaseEndpoint()
        ..initialize(
          server,
          'transactionsDatabase',
          null,
        ),
      'deprecation': _idq2fszg.DeprecationEndpoint()
        ..initialize(
          server,
          'deprecation',
          null,
        ),
      'diagnosticEventTest': _i80k5lij.DiagnosticEventTestEndpoint()
        ..initialize(
          server,
          'diagnosticEventTest',
          null,
        ),
      'echoRequest': _ivddvur7.EchoRequestEndpoint()
        ..initialize(
          server,
          'echoRequest',
          null,
        ),
      'echoRequiredField': _ik6eczg2.EchoRequiredFieldEndpoint()
        ..initialize(
          server,
          'echoRequiredField',
          null,
        ),
      'emailAuthTestMethods': _ijlsxep6.EmailAuthTestMethods()
        ..initialize(
          server,
          'emailAuthTestMethods',
          null,
        ),
      'concreteBase': _i0zjahsw.ConcreteBaseEndpoint()
        ..initialize(
          server,
          'concreteBase',
          null,
        ),
      'concreteSubClass': _i0zjahsw.ConcreteSubClassEndpoint()
        ..initialize(
          server,
          'concreteSubClass',
          null,
        ),
      'independent': _i0zjahsw.IndependentEndpoint()
        ..initialize(
          server,
          'independent',
          null,
        ),
      'concreteFromModuleAbstractBase':
          _i0zjahsw.ConcreteFromModuleAbstractBaseEndpoint()..initialize(
            server,
            'concreteFromModuleAbstractBase',
            null,
          ),
      'concreteModuleBase': _i0zjahsw.ConcreteModuleBaseEndpoint()
        ..initialize(
          server,
          'concreteModuleBase',
          null,
        ),
      'loggedIn': _inx00omf.LoggedInEndpoint()
        ..initialize(
          server,
          'loggedIn',
          null,
        ),
      'myLoggedIn': _inx00omf.MyLoggedInEndpoint()
        ..initialize(
          server,
          'myLoggedIn',
          null,
        ),
      'admin': _inx00omf.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'myAdmin': _inx00omf.MyAdminEndpoint()
        ..initialize(
          server,
          'myAdmin',
          null,
        ),
      'myConcreteAdmin': _inx00omf.MyConcreteAdminEndpoint()
        ..initialize(
          server,
          'myConcreteAdmin',
          null,
        ),
      'exceptionTest': _igyldlid.ExceptionTestEndpoint()
        ..initialize(
          server,
          'exceptionTest',
          null,
        ),
      'failedCalls': _ik2ddfcb.FailedCallsEndpoint()
        ..initialize(
          server,
          'failedCalls',
          null,
        ),
      'fieldScopes': _iwb8t23v.FieldScopesEndpoint()
        ..initialize(
          server,
          'fieldScopes',
          null,
        ),
      'testFutureCalls': _i86flpi8.TestFutureCallsEndpoint()
        ..initialize(
          server,
          'testFutureCalls',
          null,
        ),
      'listParameters': _ijuqq02d.ListParametersEndpoint()
        ..initialize(
          server,
          'listParameters',
          null,
        ),
      'logging': _ihsjb7qe.LoggingEndpoint()
        ..initialize(
          server,
          'logging',
          null,
        ),
      'loggingDisabled': _iqn8602i.LoggingDisabledEndpoint()
        ..initialize(
          server,
          'loggingDisabled',
          null,
        ),
      'mapParameters': _i7zzrcbk.MapParametersEndpoint()
        ..initialize(
          server,
          'mapParameters',
          null,
        ),
      'methodSignaturePermutations':
          _ixhdyiji.MethodSignaturePermutationsEndpoint()..initialize(
            server,
            'methodSignaturePermutations',
            null,
          ),
      'methodStreaming': _icmw7mkg.MethodStreaming()
        ..initialize(
          server,
          'methodStreaming',
          null,
        ),
      'authenticatedMethodStreaming': _icmw7mkg.AuthenticatedMethodStreaming()
        ..initialize(
          server,
          'authenticatedMethodStreaming',
          null,
        ),
      'moduleEndpointSubclass': _ioqbbgad.ModuleEndpointSubclass()
        ..initialize(
          server,
          'moduleEndpointSubclass',
          null,
        ),
      'moduleEndpointAdaptation': _ioqbbgad.ModuleEndpointAdaptation()
        ..initialize(
          server,
          'moduleEndpointAdaptation',
          null,
        ),
      'moduleEndpointReduction': _ioqbbgad.ModuleEndpointReduction()
        ..initialize(
          server,
          'moduleEndpointReduction',
          null,
        ),
      'moduleEndpointExtension': _ioqbbgad.ModuleEndpointExtension()
        ..initialize(
          server,
          'moduleEndpointExtension',
          null,
        ),
      'moduleSerialization': _iwv9sobp.ModuleSerializationEndpoint()
        ..initialize(
          server,
          'moduleSerialization',
          null,
        ),
      'namedParameters': _ims5wkpy.NamedParametersEndpoint()
        ..initialize(
          server,
          'namedParameters',
          null,
        ),
      'optionalParameters': _ifkxt35t.OptionalParametersEndpoint()
        ..initialize(
          server,
          'optionalParameters',
          null,
        ),
      'inheritancePolymorphismTest':
          _iiarbij8.InheritancePolymorphismTestEndpoint()..initialize(
            server,
            'inheritancePolymorphismTest',
            null,
          ),
      'recordParameters': _ib1glaoo.RecordParametersEndpoint()
        ..initialize(
          server,
          'recordParameters',
          null,
        ),
      'redis': _i5ia1kr7.RedisEndpoint()
        ..initialize(
          server,
          'redis',
          null,
        ),
      'serverOnlyScopedFieldModel':
          _ix3s2g81.ServerOnlyScopedFieldModelEndpoint()..initialize(
            server,
            'serverOnlyScopedFieldModel',
            null,
          ),
      'serverOnlyScopedFieldChildModel':
          _iv5t2nu0.ServerOnlyScopedFieldChildModelEndpoint()..initialize(
            server,
            'serverOnlyScopedFieldChildModel',
            null,
          ),
      'sessionAuthentication': _ieivi1oj.SessionAuthenticationEndpoint()
        ..initialize(
          server,
          'sessionAuthentication',
          null,
        ),
      'setParameters': _i80ils9z.SetParametersEndpoint()
        ..initialize(
          server,
          'setParameters',
          null,
        ),
      'signInRequired': _idzjag2f.SignInRequiredEndpoint()
        ..initialize(
          server,
          'signInRequired',
          null,
        ),
      'adminScopeRequired': _idzjag2f.AdminScopeRequiredEndpoint()
        ..initialize(
          server,
          'adminScopeRequired',
          null,
        ),
      'simple': _il4e9ez0.SimpleEndpoint()
        ..initialize(
          server,
          'simple',
          null,
        ),
      'subSubDirTest': _ig647puh.SubSubDirTestEndpoint()
        ..initialize(
          server,
          'subSubDirTest',
          null,
        ),
      'subDirTest': _i7nbpkw0.SubDirTestEndpoint()
        ..initialize(
          server,
          'subDirTest',
          null,
        ),
      'testTools': _itdztv0y.TestToolsEndpoint()
        ..initialize(
          server,
          'testTools',
          null,
        ),
      'authenticatedTestTools': _itdztv0y.AuthenticatedTestToolsEndpoint()
        ..initialize(
          server,
          'authenticatedTestTools',
          null,
        ),
      'unauthenticated': _ius7wovq.UnauthenticatedEndpoint()
        ..initialize(
          server,
          'unauthenticated',
          null,
        ),
      'partiallyUnauthenticated': _ius7wovq.PartiallyUnauthenticatedEndpoint()
        ..initialize(
          server,
          'partiallyUnauthenticated',
          null,
        ),
      'unauthenticatedRequireLogin':
          _ius7wovq.UnauthenticatedRequireLoginEndpoint()..initialize(
            server,
            'unauthenticatedRequireLogin',
            null,
          ),
      'requireLogin': _ius7wovq.RequireLoginEndpoint()
        ..initialize(
          server,
          'requireLogin',
          null,
        ),
      'upload': _ia6lpdch.UploadEndpoint()
        ..initialize(
          server,
          'upload',
          null,
        ),
      'myFeature': _ij2anjje.MyFeatureEndpoint()
        ..initialize(
          server,
          'myFeature',
          null,
        ),
    };
    connectors['asyncTasks'] = _is.EndpointConnector(
      name: 'asyncTasks',
      endpoint: endpoints['asyncTasks']!,
      methodConnectors: {
        'insertRowToSimpleDataAfterDelay': _is.MethodConnector(
          name: 'insertRowToSimpleDataAfterDelay',
          params: {
            'num': _is.ParameterDescription(
              name: 'num',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'seconds': _is.ParameterDescription(
              name: 'seconds',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['asyncTasks'] as _iyams8ur.AsyncTasksEndpoint)
                      .insertRowToSimpleDataAfterDelay(
                        session,
                        params['num'],
                        params['seconds'],
                      ),
        ),
        'throwExceptionAfterDelay': _is.MethodConnector(
          name: 'throwExceptionAfterDelay',
          params: {
            'seconds': _is.ParameterDescription(
              name: 'seconds',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['asyncTasks'] as _iyams8ur.AsyncTasksEndpoint)
                      .throwExceptionAfterDelay(
                        session,
                        params['seconds'],
                      ),
        ),
      },
    );
    connectors['authentication'] = _is.EndpointConnector(
      name: 'authentication',
      endpoint: endpoints['authentication']!,
      methodConnectors: {
        'removeAllUsers': _is.MethodConnector(
          name: 'removeAllUsers',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authentication']
                          as _iqzgn7n3.AuthenticationEndpoint)
                      .removeAllUsers(session),
        ),
        'countUsers': _is.MethodConnector(
          name: 'countUsers',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authentication']
                          as _iqzgn7n3.AuthenticationEndpoint)
                      .countUsers(session),
        ),
        'createUser': _is.MethodConnector(
          name: 'createUser',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authentication']
                          as _iqzgn7n3.AuthenticationEndpoint)
                      .createUser(
                        session,
                        params['email'],
                        params['password'],
                      ),
        ),
        'authenticate': _is.MethodConnector(
          name: 'authenticate',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'scopes': _is.ParameterDescription(
              name: 'scopes',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authentication']
                          as _iqzgn7n3.AuthenticationEndpoint)
                      .authenticate(
                        session,
                        params['email'],
                        params['password'],
                        params['scopes'],
                      ),
        ),
        'signOut': _is.MethodConnector(
          name: 'signOut',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authentication']
                          as _iqzgn7n3.AuthenticationEndpoint)
                      .signOut(session),
        ),
        'updateScopes': _is.MethodConnector(
          name: 'updateScopes',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'scopes': _is.ParameterDescription(
              name: 'scopes',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authentication']
                          as _iqzgn7n3.AuthenticationEndpoint)
                      .updateScopes(
                        session,
                        params['userId'],
                        params['scopes'],
                      ),
        ),
      },
    );
    connectors['basicTypes'] = _is.EndpointConnector(
      name: 'basicTypes',
      endpoint: endpoints['basicTypes']!,
      methodConnectors: {
        'testInt': _is.MethodConnector(
          name: 'testInt',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testInt(
                        session,
                        params['value'],
                      ),
        ),
        'testDouble': _is.MethodConnector(
          name: 'testDouble',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testDouble(
                        session,
                        params['value'],
                      ),
        ),
        'testBool': _is.MethodConnector(
          name: 'testBool',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testBool(
                        session,
                        params['value'],
                      ),
        ),
        'testDateTime': _is.MethodConnector(
          name: 'testDateTime',
          params: {
            'dateTime': _is.ParameterDescription(
              name: 'dateTime',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testDateTime(
                        session,
                        params['dateTime'],
                      ),
        ),
        'testString': _is.MethodConnector(
          name: 'testString',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testString(
                        session,
                        params['value'],
                      ),
        ),
        'testByteData': _is.MethodConnector(
          name: 'testByteData',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_idt.ByteData?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testByteData(
                        session,
                        params['value'],
                      ),
        ),
        'testDuration': _is.MethodConnector(
          name: 'testDuration',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<Duration?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testDuration(
                        session,
                        params['value'],
                      ),
        ),
        'testUuid': _is.MethodConnector(
          name: 'testUuid',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testUuid(
                        session,
                        params['value'],
                      ),
        ),
        'testUri': _is.MethodConnector(
          name: 'testUri',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<Uri?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testUri(
                        session,
                        params['value'],
                      ),
        ),
        'testBigInt': _is.MethodConnector(
          name: 'testBigInt',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<BigInt?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['basicTypes'] as _i795tvcb.BasicTypesEndpoint)
                      .testBigInt(
                        session,
                        params['value'],
                      ),
        ),
      },
    );
    connectors['basicTypesStreaming'] = _is.EndpointConnector(
      name: 'basicTypesStreaming',
      endpoint: endpoints['basicTypesStreaming']!,
      methodConnectors: {
        'testInt': _is.MethodStreamConnector(
          name: 'testInt',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<int?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testInt(
                        session,
                        streamParams['value']!.cast<int?>(),
                      ),
        ),
        'testDouble': _is.MethodStreamConnector(
          name: 'testDouble',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<double?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testDouble(
                        session,
                        streamParams['value']!.cast<double?>(),
                      ),
        ),
        'testBool': _is.MethodStreamConnector(
          name: 'testBool',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<bool?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testBool(
                        session,
                        streamParams['value']!.cast<bool?>(),
                      ),
        ),
        'testDateTime': _is.MethodStreamConnector(
          name: 'testDateTime',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<DateTime?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testDateTime(
                        session,
                        streamParams['value']!.cast<DateTime?>(),
                      ),
        ),
        'testString': _is.MethodStreamConnector(
          name: 'testString',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<String?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testString(
                        session,
                        streamParams['value']!.cast<String?>(),
                      ),
        ),
        'testByteData': _is.MethodStreamConnector(
          name: 'testByteData',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<_idt.ByteData?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testByteData(
                        session,
                        streamParams['value']!.cast<_idt.ByteData?>(),
                      ),
        ),
        'testDuration': _is.MethodStreamConnector(
          name: 'testDuration',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<Duration?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testDuration(
                        session,
                        streamParams['value']!.cast<Duration?>(),
                      ),
        ),
        'testUuid': _is.MethodStreamConnector(
          name: 'testUuid',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<_is.UuidValue?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testUuid(
                        session,
                        streamParams['value']!.cast<_is.UuidValue?>(),
                      ),
        ),
        'testUri': _is.MethodStreamConnector(
          name: 'testUri',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<Uri?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testUri(
                        session,
                        streamParams['value']!.cast<Uri?>(),
                      ),
        ),
        'testBigInt': _is.MethodStreamConnector(
          name: 'testBigInt',
          params: {},
          streamParams: {
            'value': _is.StreamParameterDescription<BigInt?>(
              name: 'value',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['basicTypesStreaming']
                          as _ioq23vds.BasicTypesStreamingEndpoint)
                      .testBigInt(
                        session,
                        streamParams['value']!.cast<BigInt?>(),
                      ),
        ),
      },
    );
    connectors['cloudStorage'] = _is.EndpointConnector(
      name: 'cloudStorage',
      endpoint: endpoints['cloudStorage']!,
      methodConnectors: {
        'reset': _is.MethodConnector(
          name: 'reset',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .reset(session),
        ),
        'storePublicFile': _is.MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'byteData': _is.ParameterDescription(
              name: 'byteData',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .storePublicFile(
                        session,
                        params['path'],
                        params['byteData'],
                      ),
        ),
        'retrievePublicFile': _is.MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .retrievePublicFile(
                        session,
                        params['path'],
                      ),
        ),
        'existsPublicFile': _is.MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .existsPublicFile(
                        session,
                        params['path'],
                      ),
        ),
        'deletePublicFile': _is.MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .deletePublicFile(
                        session,
                        params['path'],
                      ),
        ),
        'getPublicUrlForFile': _is.MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .getPublicUrlForFile(
                        session,
                        params['path'],
                      ),
        ),
        'getDirectFilePostUrl': _is.MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .getDirectFilePostUrl(
                        session,
                        params['path'],
                      ),
        ),
        'verifyDirectFileUpload': _is.MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cloudStorage'] as _i539zsf6.CloudStorageEndpoint)
                      .verifyDirectFileUpload(
                        session,
                        params['path'],
                      ),
        ),
      },
    );
    connectors['s3CloudStorage'] = _is.EndpointConnector(
      name: 's3CloudStorage',
      endpoint: endpoints['s3CloudStorage']!,
      methodConnectors: {
        'storePublicFile': _is.MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'byteData': _is.ParameterDescription(
              name: 'byteData',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage']
                          as _iez7ug2d.S3CloudStorageEndpoint)
                      .storePublicFile(
                        session,
                        params['path'],
                        params['byteData'],
                      ),
        ),
        'retrievePublicFile': _is.MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage']
                          as _iez7ug2d.S3CloudStorageEndpoint)
                      .retrievePublicFile(
                        session,
                        params['path'],
                      ),
        ),
        'existsPublicFile': _is.MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage']
                          as _iez7ug2d.S3CloudStorageEndpoint)
                      .existsPublicFile(
                        session,
                        params['path'],
                      ),
        ),
        'deletePublicFile': _is.MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage']
                          as _iez7ug2d.S3CloudStorageEndpoint)
                      .deletePublicFile(
                        session,
                        params['path'],
                      ),
        ),
        'getPublicUrlForFile': _is.MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage']
                          as _iez7ug2d.S3CloudStorageEndpoint)
                      .getPublicUrlForFile(
                        session,
                        params['path'],
                      ),
        ),
        'getDirectFilePostUrl': _is.MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage']
                          as _iez7ug2d.S3CloudStorageEndpoint)
                      .getDirectFilePostUrl(
                        session,
                        params['path'],
                      ),
        ),
        'verifyDirectFileUpload': _is.MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['s3CloudStorage']
                          as _iez7ug2d.S3CloudStorageEndpoint)
                      .verifyDirectFileUpload(
                        session,
                        params['path'],
                      ),
        ),
      },
    );
    connectors['customClassProtocol'] = _is.EndpointConnector(
      name: 'customClassProtocol',
      endpoint: endpoints['customClassProtocol']!,
      methodConnectors: {
        'getProtocolField': _is.MethodConnector(
          name: 'getProtocolField',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customClassProtocol']
                          as _iwz8g6i5.CustomClassProtocolEndpoint)
                      .getProtocolField(session),
        ),
      },
    );
    connectors['customTypes'] = _is.EndpointConnector(
      name: 'customTypes',
      endpoint: endpoints['customTypes']!,
      methodConnectors: {
        'returnCustomClass': _is.MethodConnector(
          name: 'returnCustomClass',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.CustomClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnCustomClass(
                        session,
                        params['data'],
                      ),
        ),
        'returnCustomClassNullable': _is.MethodConnector(
          name: 'returnCustomClassNullable',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.CustomClass?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnCustomClassNullable(
                        session,
                        params['data'],
                      ),
        ),
        'returnCustomClass2': _is.MethodConnector(
          name: 'returnCustomClass2',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.CustomClass2>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnCustomClass2(
                        session,
                        params['data'],
                      ),
        ),
        'returnCustomClass2Nullable': _is.MethodConnector(
          name: 'returnCustomClass2Nullable',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.CustomClass2?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnCustomClass2Nullable(
                        session,
                        params['data'],
                      ),
        ),
        'returnExternalCustomClass': _is.MethodConnector(
          name: 'returnExternalCustomClass',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.ExternalCustomClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnExternalCustomClass(
                        session,
                        params['data'],
                      ),
        ),
        'returnExternalCustomClassNullable': _is.MethodConnector(
          name: 'returnExternalCustomClassNullable',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.ExternalCustomClass?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnExternalCustomClassNullable(
                        session,
                        params['data'],
                      ),
        ),
        'returnFreezedCustomClass': _is.MethodConnector(
          name: 'returnFreezedCustomClass',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.FreezedCustomClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnFreezedCustomClass(
                        session,
                        params['data'],
                      ),
        ),
        'returnFreezedCustomClassNullable': _is.MethodConnector(
          name: 'returnFreezedCustomClassNullable',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_ilwf0zl1.FreezedCustomClass?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnFreezedCustomClassNullable(
                        session,
                        params['data'],
                      ),
        ),
        'returnCustomClassWithoutProtocolSerialization': _is.MethodConnector(
          name: 'returnCustomClassWithoutProtocolSerialization',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is
                  .getType<_ilwf0zl1.CustomClassWithoutProtocolSerialization>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnCustomClassWithoutProtocolSerialization(
                        session,
                        params['data'],
                      ),
        ),
        'returnCustomClassWithProtocolSerialization': _is.MethodConnector(
          name: 'returnCustomClassWithProtocolSerialization',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is
                  .getType<_ilwf0zl1.CustomClassWithProtocolSerialization>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnCustomClassWithProtocolSerialization(
                        session,
                        params['data'],
                      ),
        ),
        'returnCustomClassWithProtocolSerializationMethod': _is.MethodConnector(
          name: 'returnCustomClassWithProtocolSerializationMethod',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is
                  .getType<
                    _ilwf0zl1.CustomClassWithProtocolSerializationMethod
                  >(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['customTypes'] as _i7bcbcdf.CustomTypesEndpoint)
                      .returnCustomClassWithProtocolSerializationMethod(
                        session,
                        params['data'],
                      ),
        ),
      },
    );
    connectors['basicDatabase'] = _is.EndpointConnector(
      name: 'basicDatabase',
      endpoint: endpoints['basicDatabase']!,
      methodConnectors: {
        'deleteAllSimpleTestData': _is.MethodConnector(
          name: 'deleteAllSimpleTestData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .deleteAllSimpleTestData(session),
        ),
        'deleteSimpleTestDataLessThan': _is.MethodConnector(
          name: 'deleteSimpleTestDataLessThan',
          params: {
            'num': _is.ParameterDescription(
              name: 'num',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .deleteSimpleTestDataLessThan(
                    session,
                    params['num'],
                  ),
        ),
        'findAndDeleteSimpleTestData': _is.MethodConnector(
          name: 'findAndDeleteSimpleTestData',
          params: {
            'num': _is.ParameterDescription(
              name: 'num',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .findAndDeleteSimpleTestData(
                    session,
                    params['num'],
                  ),
        ),
        'createSimpleTestData': _is.MethodConnector(
          name: 'createSimpleTestData',
          params: {
            'numRows': _is.ParameterDescription(
              name: 'numRows',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .createSimpleTestData(
                    session,
                    params['numRows'],
                  ),
        ),
        'findSimpleData': _is.MethodConnector(
          name: 'findSimpleData',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .findSimpleData(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'findFirstRowSimpleData': _is.MethodConnector(
          name: 'findFirstRowSimpleData',
          params: {
            'num': _is.ParameterDescription(
              name: 'num',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .findFirstRowSimpleData(
                    session,
                    params['num'],
                  ),
        ),
        'findByIdSimpleData': _is.MethodConnector(
          name: 'findByIdSimpleData',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .findByIdSimpleData(
                    session,
                    params['id'],
                  ),
        ),
        'findSimpleDataRowsLessThan': _is.MethodConnector(
          name: 'findSimpleDataRowsLessThan',
          params: {
            'num': _is.ParameterDescription(
              name: 'num',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'descending': _is.ParameterDescription(
              name: 'descending',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .findSimpleDataRowsLessThan(
                    session,
                    params['num'],
                    params['offset'],
                    params['limit'],
                    params['descending'],
                  ),
        ),
        'insertRowSimpleData': _is.MethodConnector(
          name: 'insertRowSimpleData',
          params: {
            'simpleData': _is.ParameterDescription(
              name: 'simpleData',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .insertRowSimpleData(
                    session,
                    params['simpleData'],
                  ),
        ),
        'updateRowSimpleData': _is.MethodConnector(
          name: 'updateRowSimpleData',
          params: {
            'simpleData': _is.ParameterDescription(
              name: 'simpleData',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .updateRowSimpleData(
                    session,
                    params['simpleData'],
                  ),
        ),
        'deleteRowSimpleData': _is.MethodConnector(
          name: 'deleteRowSimpleData',
          params: {
            'simpleData': _is.ParameterDescription(
              name: 'simpleData',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .deleteRowSimpleData(
                    session,
                    params['simpleData'],
                  ),
        ),
        'deleteWhereSimpleData': _is.MethodConnector(
          name: 'deleteWhereSimpleData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .deleteWhereSimpleData(session),
        ),
        'countSimpleData': _is.MethodConnector(
          name: 'countSimpleData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .countSimpleData(session),
        ),
        'insertTypes': _is.MethodConnector(
          name: 'insertTypes',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_iuch3ck4.Types>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .insertTypes(
                    session,
                    params['value'],
                  ),
        ),
        'updateTypes': _is.MethodConnector(
          name: 'updateTypes',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_iuch3ck4.Types>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .updateTypes(
                    session,
                    params['value'],
                  ),
        ),
        'countTypesRows': _is.MethodConnector(
          name: 'countTypesRows',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .countTypesRows(session),
        ),
        'deleteAllInTypes': _is.MethodConnector(
          name: 'deleteAllInTypes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .deleteAllInTypes(session),
        ),
        'getTypes': _is.MethodConnector(
          name: 'getTypes',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .getTypes(
                    session,
                    params['id'],
                  ),
        ),
        'getTypesRawQuery': _is.MethodConnector(
          name: 'getTypesRawQuery',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .getTypesRawQuery(
                    session,
                    params['id'],
                  ),
        ),
        'storeObjectWithEnum': _is.MethodConnector(
          name: 'storeObjectWithEnum',
          params: {
            'object': _is.ParameterDescription(
              name: 'object',
              type: _is.getType<_in2ouh3f.ObjectWithEnum>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .storeObjectWithEnum(
                    session,
                    params['object'],
                  ),
        ),
        'getObjectWithEnum': _is.MethodConnector(
          name: 'getObjectWithEnum',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .getObjectWithEnum(
                    session,
                    params['id'],
                  ),
        ),
        'storeObjectWithEnumEnhanced': _is.MethodConnector(
          name: 'storeObjectWithEnumEnhanced',
          params: {
            'object': _is.ParameterDescription(
              name: 'object',
              type: _is.getType<_itaf3m7v.ObjectWithEnumEnhanced>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .storeObjectWithEnumEnhanced(
                    session,
                    params['object'],
                  ),
        ),
        'getObjectWithEnumEnhanced': _is.MethodConnector(
          name: 'getObjectWithEnumEnhanced',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .getObjectWithEnumEnhanced(
                    session,
                    params['id'],
                  ),
        ),
        'storeObjectWithObject': _is.MethodConnector(
          name: 'storeObjectWithObject',
          params: {
            'object': _is.ParameterDescription(
              name: 'object',
              type: _is.getType<_i120a7u7.ObjectWithObject>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .storeObjectWithObject(
                    session,
                    params['object'],
                  ),
        ),
        'getObjectWithObject': _is.MethodConnector(
          name: 'getObjectWithObject',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .getObjectWithObject(
                    session,
                    params['id'],
                  ),
        ),
        'deleteAll': _is.MethodConnector(
          name: 'deleteAll',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .deleteAll(session),
        ),
        'testByteDataStore': _is.MethodConnector(
          name: 'testByteDataStore',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['basicDatabase'] as _i72l4yiw.BasicDatabase)
                  .testByteDataStore(session),
        ),
      },
    );
    connectors['transactionsDatabase'] = _is.EndpointConnector(
      name: 'transactionsDatabase',
      endpoint: endpoints['transactionsDatabase']!,
      methodConnectors: {
        'removeRow': _is.MethodConnector(
          name: 'removeRow',
          params: {
            'num': _is.ParameterDescription(
              name: 'num',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transactionsDatabase']
                          as _iitlqru7.TransactionsDatabaseEndpoint)
                      .removeRow(
                        session,
                        params['num'],
                      ),
        ),
        'updateInsertDelete': _is.MethodConnector(
          name: 'updateInsertDelete',
          params: {
            'numUpdate': _is.ParameterDescription(
              name: 'numUpdate',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'numInsert': _is.ParameterDescription(
              name: 'numInsert',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'numDelete': _is.ParameterDescription(
              name: 'numDelete',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transactionsDatabase']
                          as _iitlqru7.TransactionsDatabaseEndpoint)
                      .updateInsertDelete(
                        session,
                        params['numUpdate'],
                        params['numInsert'],
                        params['numDelete'],
                      ),
        ),
      },
    );
    connectors['deprecation'] = _is.EndpointConnector(
      name: 'deprecation',
      endpoint: endpoints['deprecation']!,
      methodConnectors: {
        'setGlobalDouble': _is.MethodConnector(
          name: 'setGlobalDouble',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _idq2fszg.DeprecationEndpoint)
                      .setGlobalDouble(
                        session,
                        params['value'],
                      ),
        ),
        'getGlobalDouble': _is.MethodConnector(
          name: 'getGlobalDouble',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _idq2fszg.DeprecationEndpoint)
                      .getGlobalDouble(session),
        ),
        'methodWithDeprecatedParam': _is.MethodConnector(
          name: 'methodWithDeprecatedParam',
          params: {
            'deprecatedParam': _is.ParameterDescription(
              name: 'deprecatedParam',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _idq2fszg.DeprecationEndpoint)
                      .methodWithDeprecatedParam(
                        session,
                        params['deprecatedParam'],
                      ),
        ),
        'methodWithDeprecatedParamMessage': _is.MethodConnector(
          name: 'methodWithDeprecatedParamMessage',
          params: {
            'deprecatedParam': _is.ParameterDescription(
              name: 'deprecatedParam',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _idq2fszg.DeprecationEndpoint)
                      .methodWithDeprecatedParamMessage(
                        session,
                        params['deprecatedParam'],
                      ),
        ),
        'methodWithMixedParams': _is.MethodConnector(
          name: 'methodWithMixedParams',
          params: {
            'normalParam': _is.ParameterDescription(
              name: 'normalParam',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'deprecatedParam': _is.ParameterDescription(
              name: 'deprecatedParam',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _idq2fszg.DeprecationEndpoint)
                      .methodWithMixedParams(
                        session,
                        params['normalParam'],
                        params['deprecatedParam'],
                      ),
        ),
        'methodWithOptionalDeprecatedParam': _is.MethodConnector(
          name: 'methodWithOptionalDeprecatedParam',
          params: {
            'deprecatedParam': _is.ParameterDescription(
              name: 'deprecatedParam',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _idq2fszg.DeprecationEndpoint)
                      .methodWithOptionalDeprecatedParam(
                        session,
                        params['deprecatedParam'],
                      ),
        ),
        'methodWithNamedDeprecatedParam': _is.MethodConnector(
          name: 'methodWithNamedDeprecatedParam',
          params: {
            'normalParam': _is.ParameterDescription(
              name: 'normalParam',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'deprecatedParam': _is.ParameterDescription(
              name: 'deprecatedParam',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deprecation'] as _idq2fszg.DeprecationEndpoint)
                      .methodWithNamedDeprecatedParam(
                        session,
                        normalParam: params['normalParam'],
                        deprecatedParam: params['deprecatedParam'],
                      ),
        ),
      },
    );
    connectors['diagnosticEventTest'] = _is.EndpointConnector(
      name: 'diagnosticEventTest',
      endpoint: endpoints['diagnosticEventTest']!,
      methodConnectors: {
        'submitExceptionEvent': _is.MethodConnector(
          name: 'submitExceptionEvent',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['diagnosticEventTest']
                          as _i80k5lij.DiagnosticEventTestEndpoint)
                      .submitExceptionEvent(session),
        ),
      },
    );
    connectors['echoRequest'] = _is.EndpointConnector(
      name: 'echoRequest',
      endpoint: endpoints['echoRequest']!,
      methodConnectors: {
        'echoAuthenticationKey': _is.MethodConnector(
          name: 'echoAuthenticationKey',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['echoRequest'] as _ivddvur7.EchoRequestEndpoint)
                      .echoAuthenticationKey(session),
        ),
        'echoHttpHeader': _is.MethodConnector(
          name: 'echoHttpHeader',
          params: {
            'headerName': _is.ParameterDescription(
              name: 'headerName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['echoRequest'] as _ivddvur7.EchoRequestEndpoint)
                      .echoHttpHeader(
                        session,
                        params['headerName'],
                      ),
        ),
      },
    );
    connectors['echoRequiredField'] = _is.EndpointConnector(
      name: 'echoRequiredField',
      endpoint: endpoints['echoRequiredField']!,
      methodConnectors: {
        'echoModel': _is.MethodConnector(
          name: 'echoModel',
          params: {
            'model': _is.ParameterDescription(
              name: 'model',
              type: _is.getType<_iyoxtomg.ModelWithRequiredField>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['echoRequiredField']
                          as _ik6eczg2.EchoRequiredFieldEndpoint)
                      .echoModel(
                        session,
                        params['model'],
                      ),
        ),
        'throwException': _is.MethodConnector(
          name: 'throwException',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['echoRequiredField']
                          as _ik6eczg2.EchoRequiredFieldEndpoint)
                      .throwException(session),
        ),
      },
    );
    connectors['emailAuthTestMethods'] = _is.EndpointConnector(
      name: 'emailAuthTestMethods',
      endpoint: endpoints['emailAuthTestMethods']!,
      methodConnectors: {
        'findVerificationCode': _is.MethodConnector(
          name: 'findVerificationCode',
          params: {
            'userName': _is.ParameterDescription(
              name: 'userName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAuthTestMethods']
                          as _ijlsxep6.EmailAuthTestMethods)
                      .findVerificationCode(
                        session,
                        params['userName'],
                        params['email'],
                      ),
        ),
        'findResetCode': _is.MethodConnector(
          name: 'findResetCode',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAuthTestMethods']
                          as _ijlsxep6.EmailAuthTestMethods)
                      .findResetCode(
                        session,
                        params['email'],
                      ),
        ),
        'tearDown': _is.MethodConnector(
          name: 'tearDown',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAuthTestMethods']
                          as _ijlsxep6.EmailAuthTestMethods)
                      .tearDown(session),
        ),
        'createUser': _is.MethodConnector(
          name: 'createUser',
          params: {
            'userName': _is.ParameterDescription(
              name: 'userName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAuthTestMethods']
                          as _ijlsxep6.EmailAuthTestMethods)
                      .createUser(
                        session,
                        params['userName'],
                        params['email'],
                        params['password'],
                      ),
        ),
      },
    );
    connectors['concreteBase'] = _is.EndpointConnector(
      name: 'concreteBase',
      endpoint: endpoints['concreteBase']!,
      methodConnectors: {
        'virtualMethod': _is.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _i0zjahsw.ConcreteBaseEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _is.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _i0zjahsw.ConcreteBaseEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _is.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _i0zjahsw.ConcreteBaseEndpoint)
                      .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _is.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['concreteBase'] as _i0zjahsw.ConcreteBaseEndpoint)
                  .abstractBaseStreamMethod(session),
        ),
      },
    );
    connectors['concreteSubClass'] = _is.EndpointConnector(
      name: 'concreteSubClass',
      endpoint: endpoints['concreteSubClass']!,
      methodConnectors: {
        'subClassVirtualMethod': _is.MethodConnector(
          name: 'subClassVirtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i0zjahsw.ConcreteSubClassEndpoint)
                      .subClassVirtualMethod(session),
        ),
        'virtualMethod': _is.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i0zjahsw.ConcreteSubClassEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _is.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i0zjahsw.ConcreteSubClassEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _is.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteSubClass']
                          as _i0zjahsw.ConcreteSubClassEndpoint)
                      .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _is.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['concreteSubClass']
                          as _i0zjahsw.ConcreteSubClassEndpoint)
                      .abstractBaseStreamMethod(session),
        ),
      },
    );
    connectors['independent'] = _is.EndpointConnector(
      name: 'independent',
      endpoint: endpoints['independent']!,
      methodConnectors: {
        'subClassVirtualMethod': _is.MethodConnector(
          name: 'subClassVirtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['independent'] as _i0zjahsw.IndependentEndpoint)
                      .subClassVirtualMethod(session),
        ),
        'virtualMethod': _is.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['independent'] as _i0zjahsw.IndependentEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _is.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['independent'] as _i0zjahsw.IndependentEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _is.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['independent'] as _i0zjahsw.IndependentEndpoint)
                      .abstractBaseMethod(session),
        ),
        'abstractBaseStreamMethod': _is.MethodStreamConnector(
          name: 'abstractBaseStreamMethod',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['independent'] as _i0zjahsw.IndependentEndpoint)
                  .abstractBaseStreamMethod(session),
        ),
      },
    );
    connectors['concreteFromModuleAbstractBase'] = _is.EndpointConnector(
      name: 'concreteFromModuleAbstractBase',
      endpoint: endpoints['concreteFromModuleAbstractBase']!,
      methodConnectors: {
        'virtualMethod': _is.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteFromModuleAbstractBase']
                          as _i0zjahsw.ConcreteFromModuleAbstractBaseEndpoint)
                      .virtualMethod(session),
        ),
        'abstractBaseMethod': _is.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteFromModuleAbstractBase']
                          as _i0zjahsw.ConcreteFromModuleAbstractBaseEndpoint)
                      .abstractBaseMethod(session),
        ),
      },
    );
    connectors['concreteModuleBase'] = _is.EndpointConnector(
      name: 'concreteModuleBase',
      endpoint: endpoints['concreteModuleBase']!,
      methodConnectors: {
        'virtualMethod': _is.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteModuleBase']
                          as _i0zjahsw.ConcreteModuleBaseEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _is.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteModuleBase']
                          as _i0zjahsw.ConcreteModuleBaseEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _is.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteModuleBase']
                          as _i0zjahsw.ConcreteModuleBaseEndpoint)
                      .abstractBaseMethod(session),
        ),
      },
    );
    connectors['loggedIn'] = _is.EndpointConnector(
      name: 'loggedIn',
      endpoint: endpoints['loggedIn']!,
      methodConnectors: {},
    );
    connectors['myLoggedIn'] = _is.EndpointConnector(
      name: 'myLoggedIn',
      endpoint: endpoints['myLoggedIn']!,
      methodConnectors: {
        'echo': _is.MethodConnector(
          name: 'echo',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['myLoggedIn'] as _inx00omf.MyLoggedInEndpoint)
                      .echo(
                        session,
                        params['value'],
                      ),
        ),
      },
    );
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {},
    );
    connectors['myAdmin'] = _is.EndpointConnector(
      name: 'myAdmin',
      endpoint: endpoints['myAdmin']!,
      methodConnectors: {
        'echo': _is.MethodConnector(
          name: 'echo',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['myAdmin'] as _inx00omf.MyAdminEndpoint).echo(
                    session,
                    params['value'],
                  ),
        ),
      },
    );
    connectors['myConcreteAdmin'] = _is.EndpointConnector(
      name: 'myConcreteAdmin',
      endpoint: endpoints['myConcreteAdmin']!,
      methodConnectors: {
        'echo': _is.MethodConnector(
          name: 'echo',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['myConcreteAdmin']
                          as _inx00omf.MyConcreteAdminEndpoint)
                      .echo(
                        session,
                        params['value'],
                      ),
        ),
      },
    );
    connectors['exceptionTest'] = _is.EndpointConnector(
      name: 'exceptionTest',
      endpoint: endpoints['exceptionTest']!,
      methodConnectors: {
        'throwNormalException': _is.MethodConnector(
          name: 'throwNormalException',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exceptionTest']
                          as _igyldlid.ExceptionTestEndpoint)
                      .throwNormalException(session),
        ),
        'throwExceptionWithData': _is.MethodConnector(
          name: 'throwExceptionWithData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exceptionTest']
                          as _igyldlid.ExceptionTestEndpoint)
                      .throwExceptionWithData(session),
        ),
        'workingWithoutException': _is.MethodConnector(
          name: 'workingWithoutException',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exceptionTest']
                          as _igyldlid.ExceptionTestEndpoint)
                      .workingWithoutException(session),
        ),
      },
    );
    connectors['failedCalls'] = _is.EndpointConnector(
      name: 'failedCalls',
      endpoint: endpoints['failedCalls']!,
      methodConnectors: {
        'failedCall': _is.MethodConnector(
          name: 'failedCall',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['failedCalls'] as _ik2ddfcb.FailedCallsEndpoint)
                      .failedCall(session),
        ),
        'failedDatabaseQuery': _is.MethodConnector(
          name: 'failedDatabaseQuery',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['failedCalls'] as _ik2ddfcb.FailedCallsEndpoint)
                      .failedDatabaseQuery(session),
        ),
        'failedDatabaseQueryCaughtException': _is.MethodConnector(
          name: 'failedDatabaseQueryCaughtException',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['failedCalls'] as _ik2ddfcb.FailedCallsEndpoint)
                      .failedDatabaseQueryCaughtException(session),
        ),
        'slowCall': _is.MethodConnector(
          name: 'slowCall',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['failedCalls'] as _ik2ddfcb.FailedCallsEndpoint)
                      .slowCall(session),
        ),
        'caughtException': _is.MethodConnector(
          name: 'caughtException',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['failedCalls'] as _ik2ddfcb.FailedCallsEndpoint)
                      .caughtException(session),
        ),
      },
    );
    connectors['fieldScopes'] = _is.EndpointConnector(
      name: 'fieldScopes',
      endpoint: endpoints['fieldScopes']!,
      methodConnectors: {
        'storeObject': _is.MethodConnector(
          name: 'storeObject',
          params: {
            'object': _is.ParameterDescription(
              name: 'object',
              type: _is.getType<_io906m8r.ObjectFieldScopes>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['fieldScopes'] as _iwb8t23v.FieldScopesEndpoint)
                      .storeObject(
                        session,
                        params['object'],
                      ),
        ),
        'retrieveObject': _is.MethodConnector(
          name: 'retrieveObject',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['fieldScopes'] as _iwb8t23v.FieldScopesEndpoint)
                      .retrieveObject(session),
        ),
      },
    );
    connectors['testFutureCalls'] = _is.EndpointConnector(
      name: 'testFutureCalls',
      endpoint: endpoints['testFutureCalls']!,
      methodConnectors: {
        'makeFutureCall': _is.MethodConnector(
          name: 'makeFutureCall',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['testFutureCalls']
                          as _i86flpi8.TestFutureCallsEndpoint)
                      .makeFutureCall(
                        session,
                        params['data'],
                      ),
        ),
        'makeFutureCallThatThrows': _is.MethodConnector(
          name: 'makeFutureCallThatThrows',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['testFutureCalls']
                          as _i86flpi8.TestFutureCallsEndpoint)
                      .makeFutureCallThatThrows(
                        session,
                        params['data'],
                      ),
        ),
      },
    );
    connectors['listParameters'] = _is.EndpointConnector(
      name: 'listParameters',
      endpoint: endpoints['listParameters']!,
      methodConnectors: {
        'returnIntList': _is.MethodConnector(
          name: 'returnIntList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnIntList(
                        session,
                        params['list'],
                      ),
        ),
        'returnIntListList': _is.MethodConnector(
          name: 'returnIntListList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<List<int>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnIntListList(
                        session,
                        params['list'],
                      ),
        ),
        'returnIntListNullable': _is.MethodConnector(
          name: 'returnIntListNullable',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<int>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnIntListNullable(
                        session,
                        params['list'],
                      ),
        ),
        'returnIntListNullableList': _is.MethodConnector(
          name: 'returnIntListNullableList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<List<int>?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnIntListNullableList(
                        session,
                        params['list'],
                      ),
        ),
        'returnIntListListNullable': _is.MethodConnector(
          name: 'returnIntListListNullable',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<List<int>>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnIntListListNullable(
                        session,
                        params['list'],
                      ),
        ),
        'returnIntListNullableInts': _is.MethodConnector(
          name: 'returnIntListNullableInts',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<int?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnIntListNullableInts(
                        session,
                        params['list'],
                      ),
        ),
        'returnNullableIntListNullableInts': _is.MethodConnector(
          name: 'returnNullableIntListNullableInts',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<int?>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnNullableIntListNullableInts(
                        session,
                        params['list'],
                      ),
        ),
        'returnDoubleList': _is.MethodConnector(
          name: 'returnDoubleList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<double>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnDoubleList(
                        session,
                        params['list'],
                      ),
        ),
        'returnDoubleListNullableDoubles': _is.MethodConnector(
          name: 'returnDoubleListNullableDoubles',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<double?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnDoubleListNullableDoubles(
                        session,
                        params['list'],
                      ),
        ),
        'returnBoolList': _is.MethodConnector(
          name: 'returnBoolList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<bool>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnBoolList(
                        session,
                        params['list'],
                      ),
        ),
        'returnBoolListNullableBools': _is.MethodConnector(
          name: 'returnBoolListNullableBools',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<bool?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnBoolListNullableBools(
                        session,
                        params['list'],
                      ),
        ),
        'returnStringList': _is.MethodConnector(
          name: 'returnStringList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnStringList(
                        session,
                        params['list'],
                      ),
        ),
        'returnStringListNullableStrings': _is.MethodConnector(
          name: 'returnStringListNullableStrings',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<String?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnStringListNullableStrings(
                        session,
                        params['list'],
                      ),
        ),
        'returnDateTimeList': _is.MethodConnector(
          name: 'returnDateTimeList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<DateTime>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnDateTimeList(
                        session,
                        params['list'],
                      ),
        ),
        'returnDateTimeListNullableDateTimes': _is.MethodConnector(
          name: 'returnDateTimeListNullableDateTimes',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<DateTime?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnDateTimeListNullableDateTimes(
                        session,
                        params['list'],
                      ),
        ),
        'returnByteDataList': _is.MethodConnector(
          name: 'returnByteDataList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<_idt.ByteData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnByteDataList(
                        session,
                        params['list'],
                      ),
        ),
        'returnByteDataListNullableByteDatas': _is.MethodConnector(
          name: 'returnByteDataListNullableByteDatas',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<_idt.ByteData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnByteDataListNullableByteDatas(
                        session,
                        params['list'],
                      ),
        ),
        'returnSimpleDataList': _is.MethodConnector(
          name: 'returnSimpleDataList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<_i685tvwm.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnSimpleDataList(
                        session,
                        params['list'],
                      ),
        ),
        'returnSimpleDataListNullableSimpleData': _is.MethodConnector(
          name: 'returnSimpleDataListNullableSimpleData',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<_i685tvwm.SimpleData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnSimpleDataListNullableSimpleData(
                        session,
                        params['list'],
                      ),
        ),
        'returnSimpleDataListNullable': _is.MethodConnector(
          name: 'returnSimpleDataListNullable',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<_i685tvwm.SimpleData>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnSimpleDataListNullable(
                        session,
                        params['list'],
                      ),
        ),
        'returnNullableSimpleDataListNullableSimpleData': _is.MethodConnector(
          name: 'returnNullableSimpleDataListNullableSimpleData',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<_i685tvwm.SimpleData?>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnNullableSimpleDataListNullableSimpleData(
                        session,
                        params['list'],
                      ),
        ),
        'returnDurationList': _is.MethodConnector(
          name: 'returnDurationList',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<Duration>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnDurationList(
                        session,
                        params['list'],
                      ),
        ),
        'returnDurationListNullableDurations': _is.MethodConnector(
          name: 'returnDurationListNullableDurations',
          params: {
            'list': _is.ParameterDescription(
              name: 'list',
              type: _is.getType<List<Duration?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['listParameters']
                          as _ijuqq02d.ListParametersEndpoint)
                      .returnDurationListNullableDurations(
                        session,
                        params['list'],
                      ),
        ),
      },
    );
    connectors['logging'] = _is.EndpointConnector(
      name: 'logging',
      endpoint: endpoints['logging']!,
      methodConnectors: {
        'slowQueryMethod': _is.MethodConnector(
          name: 'slowQueryMethod',
          params: {
            'seconds': _is.ParameterDescription(
              name: 'seconds',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .slowQueryMethod(
                    session,
                    params['seconds'],
                  ),
        ),
        'queryMethod': _is.MethodConnector(
          name: 'queryMethod',
          params: {
            'queries': _is.ParameterDescription(
              name: 'queries',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .queryMethod(
                    session,
                    params['queries'],
                  ),
        ),
        'failedQueryMethod': _is.MethodConnector(
          name: 'failedQueryMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .failedQueryMethod(session),
        ),
        'slowMethod': _is.MethodConnector(
          name: 'slowMethod',
          params: {
            'delayMillis': _is.ParameterDescription(
              name: 'delayMillis',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .slowMethod(
                    session,
                    params['delayMillis'],
                  ),
        ),
        'failingMethod': _is.MethodConnector(
          name: 'failingMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .failingMethod(session),
        ),
        'emptyMethod': _is.MethodConnector(
          name: 'emptyMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .emptyMethod(session),
        ),
        'log': _is.MethodConnector(
          name: 'log',
          params: {
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'logLevels': _is.ParameterDescription(
              name: 'logLevels',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint).log(
                    session,
                    params['message'],
                    params['logLevels'],
                  ),
        ),
        'logInfo': _is.MethodConnector(
          name: 'logInfo',
          params: {
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint).logInfo(
                    session,
                    params['message'],
                  ),
        ),
        'logDebugAndInfoAndError': _is.MethodConnector(
          name: 'logDebugAndInfoAndError',
          params: {
            'debug': _is.ParameterDescription(
              name: 'debug',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'info': _is.ParameterDescription(
              name: 'info',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'error': _is.ParameterDescription(
              name: 'error',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .logDebugAndInfoAndError(
                    session,
                    params['debug'],
                    params['info'],
                    params['error'],
                  ),
        ),
        'twoQueries': _is.MethodConnector(
          name: 'twoQueries',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .twoQueries(session),
        ),
        'streamEmpty': _is.MethodStreamConnector(
          name: 'streamEmpty',
          params: {},
          streamParams: {
            'input': _is.StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .streamEmpty(
                    session,
                    streamParams['input']!.cast<int>(),
                  ),
        ),
        'streamLogging': _is.MethodStreamConnector(
          name: 'streamLogging',
          params: {},
          streamParams: {
            'input': _is.StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .streamLogging(
                    session,
                    streamParams['input']!.cast<int>(),
                  ),
        ),
        'streamQueryLogging': _is.MethodStreamConnector(
          name: 'streamQueryLogging',
          params: {},
          streamParams: {
            'input': _is.StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .streamQueryLogging(
                    session,
                    streamParams['input']!.cast<int>(),
                  ),
        ),
        'streamException': _is.MethodStreamConnector(
          name: 'streamException',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['logging'] as _ihsjb7qe.LoggingEndpoint)
                  .streamException(session),
        ),
      },
    );
    connectors['loggingDisabled'] = _is.EndpointConnector(
      name: 'loggingDisabled',
      endpoint: endpoints['loggingDisabled']!,
      methodConnectors: {
        'logInfo': _is.MethodConnector(
          name: 'logInfo',
          params: {
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loggingDisabled']
                          as _iqn8602i.LoggingDisabledEndpoint)
                      .logInfo(
                        session,
                        params['message'],
                      ),
        ),
      },
    );
    connectors['mapParameters'] = _is.EndpointConnector(
      name: 'mapParameters',
      endpoint: endpoints['mapParameters']!,
      methodConnectors: {
        'returnIntMap': _is.MethodConnector(
          name: 'returnIntMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnIntMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnIntMapNullable': _is.MethodConnector(
          name: 'returnIntMapNullable',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, int>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnIntMapNullable(
                        session,
                        params['map'],
                      ),
        ),
        'returnNestedIntMap': _is.MethodConnector(
          name: 'returnNestedIntMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, Map<String, int>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnNestedIntMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnIntMapNullableInts': _is.MethodConnector(
          name: 'returnIntMapNullableInts',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, int?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnIntMapNullableInts(
                        session,
                        params['map'],
                      ),
        ),
        'returnNullableIntMapNullableInts': _is.MethodConnector(
          name: 'returnNullableIntMapNullableInts',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, int?>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnNullableIntMapNullableInts(
                        session,
                        params['map'],
                      ),
        ),
        'returnIntIntMap': _is.MethodConnector(
          name: 'returnIntIntMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<int, int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnIntIntMap(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnNestedIntIntMap': _is.MethodConnector(
          name: 'returnNestedIntIntMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, Map<int, int>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnNestedIntIntMap(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnEnumIntMap': _is.MethodConnector(
          name: 'returnEnumIntMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<_izdri23a.TestEnum, int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnEnumIntMap(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnEnumMap': _is.MethodConnector(
          name: 'returnEnumMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, _izdri23a.TestEnum>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnEnumMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnDoubleMap': _is.MethodConnector(
          name: 'returnDoubleMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, double>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDoubleMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnDoubleMapNullableDoubles': _is.MethodConnector(
          name: 'returnDoubleMapNullableDoubles',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, double?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDoubleMapNullableDoubles(
                        session,
                        params['map'],
                      ),
        ),
        'returnBoolMap': _is.MethodConnector(
          name: 'returnBoolMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, bool>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnBoolMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnBoolMapNullableBools': _is.MethodConnector(
          name: 'returnBoolMapNullableBools',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, bool?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnBoolMapNullableBools(
                        session,
                        params['map'],
                      ),
        ),
        'returnStringMap': _is.MethodConnector(
          name: 'returnStringMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnStringMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnStringMapNullableStrings': _is.MethodConnector(
          name: 'returnStringMapNullableStrings',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, String?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnStringMapNullableStrings(
                        session,
                        params['map'],
                      ),
        ),
        'returnDateTimeMap': _is.MethodConnector(
          name: 'returnDateTimeMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, DateTime>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDateTimeMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnDateTimeMapNullableDateTimes': _is.MethodConnector(
          name: 'returnDateTimeMapNullableDateTimes',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, DateTime?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDateTimeMapNullableDateTimes(
                        session,
                        params['map'],
                      ),
        ),
        'returnByteDataMap': _is.MethodConnector(
          name: 'returnByteDataMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, _idt.ByteData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnByteDataMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnByteDataMapNullableByteDatas': _is.MethodConnector(
          name: 'returnByteDataMapNullableByteDatas',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, _idt.ByteData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnByteDataMapNullableByteDatas(
                        session,
                        params['map'],
                      ),
        ),
        'returnSimpleDataMap': _is.MethodConnector(
          name: 'returnSimpleDataMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, _i685tvwm.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnSimpleDataMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnSimpleDataMapNullableSimpleData': _is.MethodConnector(
          name: 'returnSimpleDataMapNullableSimpleData',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, _i685tvwm.SimpleData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnSimpleDataMapNullableSimpleData(
                        session,
                        params['map'],
                      ),
        ),
        'returnSimpleDataMapNullable': _is.MethodConnector(
          name: 'returnSimpleDataMapNullable',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, _i685tvwm.SimpleData>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnSimpleDataMapNullable(
                        session,
                        params['map'],
                      ),
        ),
        'returnNullableSimpleDataMapNullableSimpleData': _is.MethodConnector(
          name: 'returnNullableSimpleDataMapNullableSimpleData',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, _i685tvwm.SimpleData?>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnNullableSimpleDataMapNullableSimpleData(
                        session,
                        params['map'],
                      ),
        ),
        'returnDurationMap': _is.MethodConnector(
          name: 'returnDurationMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, Duration>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDurationMap(
                        session,
                        params['map'],
                      ),
        ),
        'returnDurationMapNullableDurations': _is.MethodConnector(
          name: 'returnDurationMapNullableDurations',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, Duration?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDurationMapNullableDurations(
                        session,
                        params['map'],
                      ),
        ),
        'returnNestedNonStringKeyedMapInsideRecordInsideMap':
            _is.MethodConnector(
              name: 'returnNestedNonStringKeyedMapInsideRecordInsideMap',
              params: {
                'map': _is.ParameterDescription(
                  name: 'map',
                  type: _is.getType<Map<(Map<int, String>, String), String>>(),
                  nullable: false,
                ),
              },
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['mapParameters']
                              as _i7zzrcbk.MapParametersEndpoint)
                          .returnNestedNonStringKeyedMapInsideRecordInsideMap(
                            session,
                            params['map'],
                          )
                          .then(
                            (container) => _igqrxdcj.Protocol()
                                .mapContainerToJson(container),
                          ),
            ),
        'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap':
            _is.MethodConnector(
              name: 'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap',
              params: {
                'map': _is.ParameterDescription(
                  name: 'map',
                  type: _is.getType<Map<String, (Map<int, int>,)>>(),
                  nullable: false,
                ),
              },
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['mapParameters']
                              as _i7zzrcbk.MapParametersEndpoint)
                          .returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap(
                            session,
                            params['map'],
                          )
                          .then(
                            (container) => _igqrxdcj.Protocol()
                                .mapContainerToJson(container),
                          ),
            ),
        'returnDateTimeBoolMap': _is.MethodConnector(
          name: 'returnDateTimeBoolMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<DateTime, bool>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDateTimeBoolMap(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnDateTimeBoolMapNullable': _is.MethodConnector(
          name: 'returnDateTimeBoolMapNullable',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<DateTime, bool>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnDateTimeBoolMapNullable(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) => container == null
                            ? null
                            : _igqrxdcj.Protocol().mapContainerToJson(
                                container,
                              ),
                      ),
        ),
        'returnIntStringMap': _is.MethodConnector(
          name: 'returnIntStringMap',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<int, String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnIntStringMap(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnIntStringMapNullable': _is.MethodConnector(
          name: 'returnIntStringMapNullable',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<int, String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mapParameters']
                          as _i7zzrcbk.MapParametersEndpoint)
                      .returnIntStringMapNullable(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) => container == null
                            ? null
                            : _igqrxdcj.Protocol().mapContainerToJson(
                                container,
                              ),
                      ),
        ),
      },
    );
    connectors['methodSignaturePermutations'] = _is.EndpointConnector(
      name: 'methodSignaturePermutations',
      endpoint: endpoints['methodSignaturePermutations']!,
      methodConnectors: {
        'echoPositionalArg': _is.MethodConnector(
          name: 'echoPositionalArg',
          params: {
            'string': _is.ParameterDescription(
              name: 'string',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoPositionalArg(
                        session,
                        params['string'],
                      ),
        ),
        'echoNamedArg': _is.MethodConnector(
          name: 'echoNamedArg',
          params: {
            'string': _is.ParameterDescription(
              name: 'string',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoNamedArg(
                        session,
                        string: params['string'],
                      ),
        ),
        'echoNullableNamedArg': _is.MethodConnector(
          name: 'echoNullableNamedArg',
          params: {
            'string': _is.ParameterDescription(
              name: 'string',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoNullableNamedArg(
                        session,
                        string: params['string'],
                      ),
        ),
        'echoOptionalArg': _is.MethodConnector(
          name: 'echoOptionalArg',
          params: {
            'string': _is.ParameterDescription(
              name: 'string',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoOptionalArg(
                        session,
                        params['string'],
                      ),
        ),
        'echoPositionalAndNamedArgs': _is.MethodConnector(
          name: 'echoPositionalAndNamedArgs',
          params: {
            'string1': _is.ParameterDescription(
              name: 'string1',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'string2': _is.ParameterDescription(
              name: 'string2',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoPositionalAndNamedArgs(
                        session,
                        params['string1'],
                        string2: params['string2'],
                      ),
        ),
        'echoPositionalAndNullableNamedArgs': _is.MethodConnector(
          name: 'echoPositionalAndNullableNamedArgs',
          params: {
            'string1': _is.ParameterDescription(
              name: 'string1',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'string2': _is.ParameterDescription(
              name: 'string2',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoPositionalAndNullableNamedArgs(
                        session,
                        params['string1'],
                        string2: params['string2'],
                      ),
        ),
        'echoPositionalAndOptionalArgs': _is.MethodConnector(
          name: 'echoPositionalAndOptionalArgs',
          params: {
            'string1': _is.ParameterDescription(
              name: 'string1',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'string2': _is.ParameterDescription(
              name: 'string2',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoPositionalAndOptionalArgs(
                        session,
                        params['string1'],
                        params['string2'],
                      ),
        ),
        'echoNamedArgStream': _is.MethodStreamConnector(
          name: 'echoNamedArgStream',
          params: {},
          streamParams: {
            'strings': _is.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoNamedArgStream(
                        session,
                        strings: streamParams['strings']!.cast<String>(),
                      ),
        ),
        'echoNamedArgStreamAsFuture': _is.MethodStreamConnector(
          name: 'echoNamedArgStreamAsFuture',
          params: {},
          streamParams: {
            'strings': _is.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoNamedArgStreamAsFuture(
                        session,
                        strings: streamParams['strings']!.cast<String>(),
                      ),
        ),
        'echoPositionalArgStream': _is.MethodStreamConnector(
          name: 'echoPositionalArgStream',
          params: {},
          streamParams: {
            'strings': _is.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoPositionalArgStream(
                        session,
                        streamParams['strings']!.cast<String>(),
                      ),
        ),
        'echoPositionalArgStreamAsFuture': _is.MethodStreamConnector(
          name: 'echoPositionalArgStreamAsFuture',
          params: {},
          streamParams: {
            'strings': _is.StreamParameterDescription<String>(
              name: 'strings',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['methodSignaturePermutations']
                          as _ixhdyiji.MethodSignaturePermutationsEndpoint)
                      .echoPositionalArgStreamAsFuture(
                        session,
                        streamParams['strings']!.cast<String>(),
                      ),
        ),
      },
    );
    connectors['methodStreaming'] = _is.EndpointConnector(
      name: 'methodStreaming',
      endpoint: endpoints['methodStreaming']!,
      methodConnectors: {
        'methodCallEndpoint': _is.MethodConnector(
          name: 'methodCallEndpoint',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .methodCallEndpoint(session),
        ),
        'wasBroadcastStreamCanceled': _is.MethodConnector(
          name: 'wasBroadcastStreamCanceled',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .wasBroadcastStreamCanceled(session),
        ),
        'wasSessionWillCloseListenerCalled': _is.MethodConnector(
          name: 'wasSessionWillCloseListenerCalled',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .wasSessionWillCloseListenerCalled(session),
        ),
        'simpleEndpoint': _is.MethodConnector(
          name: 'simpleEndpoint',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .simpleEndpoint(session),
        ),
        'intParameter': _is.MethodConnector(
          name: 'intParameter',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .intParameter(
                        session,
                        params['value'],
                      ),
        ),
        'doubleInputValue': _is.MethodConnector(
          name: 'doubleInputValue',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .doubleInputValue(
                        session,
                        params['value'],
                      ),
        ),
        'delayedResponse': _is.MethodConnector(
          name: 'delayedResponse',
          params: {
            'delay': _is.ParameterDescription(
              name: 'delay',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .delayedResponse(
                        session,
                        params['delay'],
                      ),
        ),
        'completeAllDelayedResponses': _is.MethodConnector(
          name: 'completeAllDelayedResponses',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                      .completeAllDelayedResponses(session),
        ),
        'simpleStream': _is.MethodStreamConnector(
          name: 'simpleStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleStream(session),
        ),
        'neverEndingStreamWithDelay': _is.MethodStreamConnector(
          name: 'neverEndingStreamWithDelay',
          params: {
            'millisecondsDelay': _is.ParameterDescription(
              name: 'millisecondsDelay',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .neverEndingStreamWithDelay(
                    session,
                    params['millisecondsDelay'],
                  ),
        ),
        'intReturnFromStream': _is.MethodStreamConnector(
          name: 'intReturnFromStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .intReturnFromStream(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'nullableIntReturnFromStream': _is.MethodStreamConnector(
          name: 'nullableIntReturnFromStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int?>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .nullableIntReturnFromStream(
                    session,
                    streamParams['stream']!.cast<int?>(),
                  ),
        ),
        'getBroadcastStream': _is.MethodStreamConnector(
          name: 'getBroadcastStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .getBroadcastStream(session),
        ),
        'intStreamFromValue': _is.MethodStreamConnector(
          name: 'intStreamFromValue',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .intStreamFromValue(
                    session,
                    params['value'],
                  ),
        ),
        'intEchoStream': _is.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .intEchoStream(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'dynamicEchoStream': _is.MethodStreamConnector(
          name: 'dynamicEchoStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<dynamic>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .dynamicEchoStream(
                    session,
                    streamParams['stream']!.cast<dynamic>(),
                  ),
        ),
        'nullableIntEchoStream': _is.MethodStreamConnector(
          name: 'nullableIntEchoStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int?>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .nullableIntEchoStream(
                    session,
                    streamParams['stream']!.cast<int?>(),
                  ),
        ),
        'voidReturnAfterStream': _is.MethodStreamConnector(
          name: 'voidReturnAfterStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .voidReturnAfterStream(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'multipleIntEchoStreams': _is.MethodStreamConnector(
          name: 'multipleIntEchoStreams',
          params: {},
          streamParams: {
            'stream1': _is.StreamParameterDescription<int>(
              name: 'stream1',
              nullable: false,
            ),
            'stream2': _is.StreamParameterDescription<int>(
              name: 'stream2',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .multipleIntEchoStreams(
                    session,
                    streamParams['stream1']!.cast<int>(),
                    streamParams['stream2']!.cast<int>(),
                  ),
        ),
        'directVoidReturnWithStreamInput': _is.MethodStreamConnector(
          name: 'directVoidReturnWithStreamInput',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .directVoidReturnWithStreamInput(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'directOneIntReturnWithStreamInput': _is.MethodStreamConnector(
          name: 'directOneIntReturnWithStreamInput',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .directOneIntReturnWithStreamInput(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'simpleInputReturnStream': _is.MethodStreamConnector(
          name: 'simpleInputReturnStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleInputReturnStream(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'simpleStreamWithParameter': _is.MethodStreamConnector(
          name: 'simpleStreamWithParameter',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleStreamWithParameter(
                    session,
                    params['value'],
                  ),
        ),
        'simpleDataStream': _is.MethodStreamConnector(
          name: 'simpleDataStream',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleDataStream(
                    session,
                    params['value'],
                  ),
        ),
        'simpleInOutDataStream': _is.MethodStreamConnector(
          name: 'simpleInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataStream':
                _is.StreamParameterDescription<_i685tvwm.SimpleData>(
                  name: 'simpleDataStream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleInOutDataStream(
                    session,
                    streamParams['simpleDataStream']!
                        .cast<_i685tvwm.SimpleData>(),
                  ),
        ),
        'simpleListInOutIntStream': _is.MethodStreamConnector(
          name: 'simpleListInOutIntStream',
          params: {},
          streamParams: {
            'simpleDataListStream': _is.StreamParameterDescription<List<int>>(
              name: 'simpleDataListStream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleListInOutIntStream(
                    session,
                    streamParams['simpleDataListStream']!.cast<List<int>>(),
                  ),
        ),
        'simpleListInOutDataStream': _is.MethodStreamConnector(
          name: 'simpleListInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataListStream':
                _is.StreamParameterDescription<List<_i685tvwm.SimpleData>>(
                  name: 'simpleDataListStream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleListInOutDataStream(
                    session,
                    streamParams['simpleDataListStream']!
                        .cast<List<_i685tvwm.SimpleData>>(),
                  ),
        ),
        'simpleListInOutOtherModuleTypeStream': _is.MethodStreamConnector(
          name: 'simpleListInOutOtherModuleTypeStream',
          params: {},
          streamParams: {
            'userInfoListStream':
                _is.StreamParameterDescription<List<_i1n3uhu0.UserInfo>>(
                  name: 'userInfoListStream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleListInOutOtherModuleTypeStream(
                    session,
                    streamParams['userInfoListStream']!
                        .cast<List<_i1n3uhu0.UserInfo>>(),
                  ),
        ),
        'simpleNullableListInOutNullableDataStream': _is.MethodStreamConnector(
          name: 'simpleNullableListInOutNullableDataStream',
          params: {},
          streamParams: {
            'simpleDataListStream':
                _is.StreamParameterDescription<List<_i685tvwm.SimpleData>?>(
                  name: 'simpleDataListStream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleNullableListInOutNullableDataStream(
                    session,
                    streamParams['simpleDataListStream']!
                        .cast<List<_i685tvwm.SimpleData>?>(),
                  ),
        ),
        'simpleListInOutNullableDataStream': _is.MethodStreamConnector(
          name: 'simpleListInOutNullableDataStream',
          params: {},
          streamParams: {
            'simpleDataListStream':
                _is.StreamParameterDescription<List<_i685tvwm.SimpleData?>>(
                  name: 'simpleDataListStream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleListInOutNullableDataStream(
                    session,
                    streamParams['simpleDataListStream']!
                        .cast<List<_i685tvwm.SimpleData?>>(),
                  ),
        ),
        'simpleSetInOutIntStream': _is.MethodStreamConnector(
          name: 'simpleSetInOutIntStream',
          params: {},
          streamParams: {
            'simpleDataSetStream': _is.StreamParameterDescription<Set<int>>(
              name: 'simpleDataSetStream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleSetInOutIntStream(
                    session,
                    streamParams['simpleDataSetStream']!.cast<Set<int>>(),
                  ),
        ),
        'simpleSetInOutDataStream': _is.MethodStreamConnector(
          name: 'simpleSetInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataSetStream':
                _is.StreamParameterDescription<Set<_i685tvwm.SimpleData>>(
                  name: 'simpleDataSetStream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .simpleSetInOutDataStream(
                    session,
                    streamParams['simpleDataSetStream']!
                        .cast<Set<_i685tvwm.SimpleData>>(),
                  ),
        ),
        'nestedSetInListInOutDataStream': _is.MethodStreamConnector(
          name: 'nestedSetInListInOutDataStream',
          params: {},
          streamParams: {
            'simpleDataSetStream':
                _is.StreamParameterDescription<List<Set<_i685tvwm.SimpleData>>>(
                  name: 'simpleDataSetStream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .nestedSetInListInOutDataStream(
                    session,
                    streamParams['simpleDataSetStream']!
                        .cast<List<Set<_i685tvwm.SimpleData>>>(),
                  ),
        ),
        'delayedStreamResponse': _is.MethodStreamConnector(
          name: 'delayedStreamResponse',
          params: {
            'delay': _is.ParameterDescription(
              name: 'delay',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .delayedStreamResponse(
                    session,
                    params['delay'],
                  ),
        ),
        'delayedNeverListenedInputStream': _is.MethodStreamConnector(
          name: 'delayedNeverListenedInputStream',
          params: {
            'delay': _is.ParameterDescription(
              name: 'delay',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .delayedNeverListenedInputStream(
                    session,
                    params['delay'],
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'delayedPausedInputStream': _is.MethodStreamConnector(
          name: 'delayedPausedInputStream',
          params: {
            'delay': _is.ParameterDescription(
              name: 'delay',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .delayedPausedInputStream(
                    session,
                    params['delay'],
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'inStreamThrowsException': _is.MethodStreamConnector(
          name: 'inStreamThrowsException',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .inStreamThrowsException(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'inStreamThrowsSerializableException': _is.MethodStreamConnector(
          name: 'inStreamThrowsSerializableException',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .inStreamThrowsSerializableException(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'outStreamThrowsException': _is.MethodStreamConnector(
          name: 'outStreamThrowsException',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .outStreamThrowsException(session),
        ),
        'outStreamThrowsSerializableException': _is.MethodStreamConnector(
          name: 'outStreamThrowsSerializableException',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .outStreamThrowsSerializableException(session),
        ),
        'throwsExceptionVoid': _is.MethodStreamConnector(
          name: 'throwsExceptionVoid',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .throwsExceptionVoid(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'throwsSerializableExceptionVoid': _is.MethodStreamConnector(
          name: 'throwsSerializableExceptionVoid',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.voidType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .throwsSerializableExceptionVoid(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'throwsException': _is.MethodStreamConnector(
          name: 'throwsException',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .throwsException(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'throwsSerializableException': _is.MethodStreamConnector(
          name: 'throwsSerializableException',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .throwsSerializableException(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'throwsExceptionStream': _is.MethodStreamConnector(
          name: 'throwsExceptionStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .throwsExceptionStream(session),
        ),
        'exceptionThrownBeforeStreamReturn': _is.MethodStreamConnector(
          name: 'exceptionThrownBeforeStreamReturn',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .exceptionThrownBeforeStreamReturn(session),
        ),
        'exceptionThrownInStreamReturn': _is.MethodStreamConnector(
          name: 'exceptionThrownInStreamReturn',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .exceptionThrownInStreamReturn(session),
        ),
        'throwsSerializableExceptionStream': _is.MethodStreamConnector(
          name: 'throwsSerializableExceptionStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .throwsSerializableExceptionStream(session),
        ),
        'didInputStreamHaveError': _is.MethodStreamConnector(
          name: 'didInputStreamHaveError',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['methodStreaming'] as _icmw7mkg.MethodStreaming)
                  .didInputStreamHaveError(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'didInputStreamHaveSerializableExceptionError':
            _is.MethodStreamConnector(
              name: 'didInputStreamHaveSerializableExceptionError',
              params: {},
              streamParams: {
                'stream': _is.StreamParameterDescription<int>(
                  name: 'stream',
                  nullable: false,
                ),
              },
              returnType: _is.MethodStreamReturnType.futureType,
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                    Map<String, Stream> streamParams,
                  ) =>
                      (endpoints['methodStreaming']
                              as _icmw7mkg.MethodStreaming)
                          .didInputStreamHaveSerializableExceptionError(
                            session,
                            streamParams['stream']!.cast<int>(),
                          ),
            ),
      },
    );
    connectors['authenticatedMethodStreaming'] = _is.EndpointConnector(
      name: 'authenticatedMethodStreaming',
      endpoint: endpoints['authenticatedMethodStreaming']!,
      methodConnectors: {
        'simpleStream': _is.MethodStreamConnector(
          name: 'simpleStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedMethodStreaming']
                          as _icmw7mkg.AuthenticatedMethodStreaming)
                      .simpleStream(session),
        ),
        'intEchoStream': _is.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedMethodStreaming']
                          as _icmw7mkg.AuthenticatedMethodStreaming)
                      .intEchoStream(
                        session,
                        streamParams['stream']!.cast<int>(),
                      ),
        ),
      },
    );
    connectors['moduleEndpointSubclass'] = _is.EndpointConnector(
      name: 'moduleEndpointSubclass',
      endpoint: endpoints['moduleEndpointSubclass']!,
      methodConnectors: {
        'echoString': _is.MethodConnector(
          name: 'echoString',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _ioqbbgad.ModuleEndpointSubclass)
                      .echoString(
                        session,
                        params['value'],
                      ),
        ),
        'echoRecord': _is.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<(int, BigInt)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _ioqbbgad.ModuleEndpointSubclass)
                      .echoRecord(
                        session,
                        params['value'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'echoContainer': _is.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _ioqbbgad.ModuleEndpointSubclass)
                      .echoContainer(
                        session,
                        params['value'],
                      ),
        ),
        'echoModel': _is.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_iom2gwyu.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointSubclass']
                          as _ioqbbgad.ModuleEndpointSubclass)
                      .echoModel(
                        session,
                        params['value'],
                      ),
        ),
      },
    );
    connectors['moduleEndpointAdaptation'] = _is.EndpointConnector(
      name: 'moduleEndpointAdaptation',
      endpoint: endpoints['moduleEndpointAdaptation']!,
      methodConnectors: {
        'echoString': _is.MethodConnector(
          name: 'echoString',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _ioqbbgad.ModuleEndpointAdaptation)
                      .echoString(
                        session,
                        params['value'],
                      ),
        ),
        'echoRecord': _is.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<(int, BigInt)>(),
              nullable: false,
            ),
            'multiplier': _is.ParameterDescription(
              name: 'multiplier',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _ioqbbgad.ModuleEndpointAdaptation)
                      .echoRecord(
                        session,
                        params['value'],
                        params['multiplier'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'echoContainer': _is.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _ioqbbgad.ModuleEndpointAdaptation)
                      .echoContainer(
                        session,
                        params['value'],
                      ),
        ),
        'echoModel': _is.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_iom2gwyu.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointAdaptation']
                          as _ioqbbgad.ModuleEndpointAdaptation)
                      .echoModel(
                        session,
                        params['value'],
                      ),
        ),
      },
    );
    connectors['moduleEndpointReduction'] = _is.EndpointConnector(
      name: 'moduleEndpointReduction',
      endpoint: endpoints['moduleEndpointReduction']!,
      methodConnectors: {
        'echoRecord': _is.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<(int, BigInt)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointReduction']
                          as _ioqbbgad.ModuleEndpointReduction)
                      .echoRecord(
                        session,
                        params['value'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'echoContainer': _is.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointReduction']
                          as _ioqbbgad.ModuleEndpointReduction)
                      .echoContainer(
                        session,
                        params['value'],
                      ),
        ),
        'echoModel': _is.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_iom2gwyu.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointReduction']
                          as _ioqbbgad.ModuleEndpointReduction)
                      .echoModel(
                        session,
                        params['value'],
                      ),
        ),
      },
    );
    connectors['moduleEndpointExtension'] = _is.EndpointConnector(
      name: 'moduleEndpointExtension',
      endpoint: endpoints['moduleEndpointExtension']!,
      methodConnectors: {
        'greet': _is.MethodConnector(
          name: 'greet',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _ioqbbgad.ModuleEndpointExtension)
                      .greet(
                        session,
                        params['name'],
                      ),
        ),
        'ignoredMethod': _is.MethodConnector(
          name: 'ignoredMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _ioqbbgad.ModuleEndpointExtension)
                      .ignoredMethod(session),
        ),
        'echoString': _is.MethodConnector(
          name: 'echoString',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _ioqbbgad.ModuleEndpointExtension)
                      .echoString(
                        session,
                        params['value'],
                      ),
        ),
        'echoRecord': _is.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<(int, BigInt)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _ioqbbgad.ModuleEndpointExtension)
                      .echoRecord(
                        session,
                        params['value'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'echoContainer': _is.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _ioqbbgad.ModuleEndpointExtension)
                      .echoContainer(
                        session,
                        params['value'],
                      ),
        ),
        'echoModel': _is.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_iom2gwyu.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleEndpointExtension']
                          as _ioqbbgad.ModuleEndpointExtension)
                      .echoModel(
                        session,
                        params['value'],
                      ),
        ),
      },
    );
    connectors['moduleSerialization'] = _is.EndpointConnector(
      name: 'moduleSerialization',
      endpoint: endpoints['moduleSerialization']!,
      methodConnectors: {
        'serializeModuleObject': _is.MethodConnector(
          name: 'serializeModuleObject',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleSerialization']
                          as _iwv9sobp.ModuleSerializationEndpoint)
                      .serializeModuleObject(session),
        ),
        'modifyModuleObject': _is.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _is.ParameterDescription(
              name: 'object',
              type: _is.getType<_iom2gwyu.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleSerialization']
                          as _iwv9sobp.ModuleSerializationEndpoint)
                      .modifyModuleObject(
                        session,
                        params['object'],
                      ),
        ),
        'modifySharedModuleTable': _is.MethodConnector(
          name: 'modifySharedModuleTable',
          params: {
            'object': _is.ParameterDescription(
              name: 'object',
              type: _is.getType<_iyx9etqn.SharedModuleTable>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleSerialization']
                          as _iwv9sobp.ModuleSerializationEndpoint)
                      .modifySharedModuleTable(
                        session,
                        params['object'],
                      ),
        ),
        'serializeNestedModuleObject': _is.MethodConnector(
          name: 'serializeNestedModuleObject',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['moduleSerialization']
                          as _iwv9sobp.ModuleSerializationEndpoint)
                      .serializeNestedModuleObject(session),
        ),
      },
    );
    connectors['namedParameters'] = _is.EndpointConnector(
      name: 'namedParameters',
      endpoint: endpoints['namedParameters']!,
      methodConnectors: {
        'namedParametersMethod': _is.MethodConnector(
          name: 'namedParametersMethod',
          params: {
            'namedInt': _is.ParameterDescription(
              name: 'namedInt',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'intWithDefaultValue': _is.ParameterDescription(
              name: 'intWithDefaultValue',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'nullableInt': _is.ParameterDescription(
              name: 'nullableInt',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'nullableIntWithDefaultValue': _is.ParameterDescription(
              name: 'nullableIntWithDefaultValue',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['namedParameters']
                          as _ims5wkpy.NamedParametersEndpoint)
                      .namedParametersMethod(
                        session,
                        namedInt: params['namedInt'],
                        intWithDefaultValue: params['intWithDefaultValue'],
                        nullableInt: params['nullableInt'],
                        nullableIntWithDefaultValue:
                            params['nullableIntWithDefaultValue'],
                      ),
        ),
        'namedParametersMethodEqualInts': _is.MethodConnector(
          name: 'namedParametersMethodEqualInts',
          params: {
            'namedInt': _is.ParameterDescription(
              name: 'namedInt',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'nullableInt': _is.ParameterDescription(
              name: 'nullableInt',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['namedParameters']
                          as _ims5wkpy.NamedParametersEndpoint)
                      .namedParametersMethodEqualInts(
                        session,
                        namedInt: params['namedInt'],
                        nullableInt: params['nullableInt'],
                      ),
        ),
      },
    );
    connectors['optionalParameters'] = _is.EndpointConnector(
      name: 'optionalParameters',
      endpoint: endpoints['optionalParameters']!,
      methodConnectors: {
        'returnOptionalInt': _is.MethodConnector(
          name: 'returnOptionalInt',
          params: {
            'optionalInt': _is.ParameterDescription(
              name: 'optionalInt',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['optionalParameters']
                          as _ifkxt35t.OptionalParametersEndpoint)
                      .returnOptionalInt(
                        session,
                        params['optionalInt'],
                      ),
        ),
      },
    );
    connectors['inheritancePolymorphismTest'] = _is.EndpointConnector(
      name: 'inheritancePolymorphismTest',
      endpoint: endpoints['inheritancePolymorphismTest']!,
      methodConnectors: {
        'polymorphicRoundtrip': _is.MethodConnector(
          name: 'polymorphicRoundtrip',
          params: {
            'parent': _is.ParameterDescription(
              name: 'parent',
              type: _is.getType<_ieub4zqi.PolymorphicParent>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['inheritancePolymorphismTest']
                          as _iiarbij8.InheritancePolymorphismTestEndpoint)
                      .polymorphicRoundtrip(
                        session,
                        params['parent'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'polymorphicContainerRoundtrip': _is.MethodConnector(
          name: 'polymorphicContainerRoundtrip',
          params: {
            'container': _is.ParameterDescription(
              name: 'container',
              type: _is.getType<_ioyh3y7j.PolymorphicChildContainer>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['inheritancePolymorphismTest']
                          as _iiarbij8.InheritancePolymorphismTestEndpoint)
                      .polymorphicContainerRoundtrip(
                        session,
                        params['container'],
                      ),
        ),
        'polymorphicModuleContainerRoundtrip': _is.MethodConnector(
          name: 'polymorphicModuleContainerRoundtrip',
          params: {
            'container': _is.ParameterDescription(
              name: 'container',
              type: _is.getType<_ij2aep0j.ModulePolymorphicChildContainer>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['inheritancePolymorphismTest']
                          as _iiarbij8.InheritancePolymorphismTestEndpoint)
                      .polymorphicModuleContainerRoundtrip(
                        session,
                        params['container'],
                      ),
        ),
        'polymorphicStreamingRoundtrip': _is.MethodStreamConnector(
          name: 'polymorphicStreamingRoundtrip',
          params: {},
          streamParams: {
            'stream':
                _is.StreamParameterDescription<_ieub4zqi.PolymorphicParent>(
                  name: 'stream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['inheritancePolymorphismTest']
                          as _iiarbij8.InheritancePolymorphismTestEndpoint)
                      .polymorphicStreamingRoundtrip(
                        session,
                        streamParams['stream']!
                            .cast<_ieub4zqi.PolymorphicParent>(),
                      ),
        ),
      },
    );
    connectors['recordParameters'] = _is.EndpointConnector(
      name: 'recordParameters',
      endpoint: endpoints['recordParameters']!,
      methodConnectors: {
        'returnRecordOfInt': _is.MethodConnector(
          name: 'returnRecordOfInt',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnRecordOfInt(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNullableRecordOfInt': _is.MethodConnector(
          name: 'returnNullableRecordOfInt',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int,)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNullableRecordOfInt(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnRecordOfNullableInt': _is.MethodConnector(
          name: 'returnRecordOfNullableInt',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int?,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnRecordOfNullableInt(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNullableRecordOfNullableInt': _is.MethodConnector(
          name: 'returnNullableRecordOfNullableInt',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int?,)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNullableRecordOfNullableInt(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnIntStringRecord': _is.MethodConnector(
          name: 'returnIntStringRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int, String)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNullableIntStringRecord': _is.MethodConnector(
          name: 'returnNullableIntStringRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int, String)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNullableIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnIntSimpleDataRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int, _i685tvwm.SimpleData)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnIntSimpleDataRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNullableIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnNullableIntSimpleDataRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int, _i685tvwm.SimpleData)?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNullableIntSimpleDataRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnStringKeyedMapRecord': _is.MethodConnector(
          name: 'returnStringKeyedMapRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(Map<String, int>,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnStringKeyedMapRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNonStringKeyedMapRecord': _is.MethodConnector(
          name: 'returnNonStringKeyedMapRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(Map<int, int>,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNonStringKeyedMapRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnSetWithNestedRecordRecord': _is.MethodConnector(
          name: 'returnSetWithNestedRecordRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(Set<(int,)>,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnSetWithNestedRecordRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNamedIntStringRecord': _is.MethodConnector(
          name: 'returnNamedIntStringRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<({int number, String text})>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNamedIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNamedNullableIntStringRecord': _is.MethodConnector(
          name: 'returnNamedNullableIntStringRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<({int number, String text})?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNamedNullableIntStringRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnRecordOfNamedIntAndObject': _is.MethodConnector(
          name: 'returnRecordOfNamedIntAndObject',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<({_i685tvwm.SimpleData data, int number})>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnRecordOfNamedIntAndObject(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNullableRecordOfNamedIntAndObject': _is.MethodConnector(
          name: 'returnNullableRecordOfNamedIntAndObject',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<({_i685tvwm.SimpleData data, int number})?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNullableRecordOfNamedIntAndObject(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnRecordOfNamedNullableIntAndNullableObject': _is.MethodConnector(
          name: 'returnRecordOfNamedNullableIntAndNullableObject',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<({_i685tvwm.SimpleData? data, int? number})>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnRecordOfNamedNullableIntAndNullableObject(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNamedNonStringKeyedMapRecord': _is.MethodConnector(
          name: 'returnNamedNonStringKeyedMapRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<({Map<int, int> intIntMap})>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNamedNonStringKeyedMapRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNamedSetWithNestedRecordRecord': _is.MethodConnector(
          name: 'returnNamedSetWithNestedRecordRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<({Set<(bool,)> boolSet})>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNamedSetWithNestedRecordRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord':
            _is.MethodConnector(
              name:
                  'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord',
              params: {
                'map': _is.ParameterDescription(
                  name: 'map',
                  type: _is
                      .getType<(Map<(Map<int, String>, String), String>,)>(),
                  nullable: false,
                ),
              },
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['recordParameters']
                              as _ib1glaoo.RecordParametersEndpoint)
                          .returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord(
                            session,
                            params['map'],
                          )
                          .then(
                            (record) =>
                                _igqrxdcj.Protocol().mapRecordToJson(record),
                          ),
            ),
        'returnRecordTypedef': _is.MethodConnector(
          name: 'returnRecordTypedef',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int, {_i685tvwm.SimpleData data})>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnRecordTypedef(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNullableRecordTypedef': _is.MethodConnector(
          name: 'returnNullableRecordTypedef',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(int, {_i685tvwm.SimpleData data})?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNullableRecordTypedef(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnListOfIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnListOfIntSimpleDataRecord',
          params: {
            'recordList': _is.ParameterDescription(
              name: 'recordList',
              type: _is.getType<List<(int, _i685tvwm.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnListOfIntSimpleDataRecord(
                        session,
                        params['recordList'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnListOfNullableIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnListOfNullableIntSimpleDataRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<List<(int, _i685tvwm.SimpleData)?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnListOfNullableIntSimpleDataRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnSetOfIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnSetOfIntSimpleDataRecord',
          params: {
            'recordSet': _is.ParameterDescription(
              name: 'recordSet',
              type: _is.getType<Set<(int, _i685tvwm.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnSetOfIntSimpleDataRecord(
                        session,
                        params['recordSet'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnSetOfNullableIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnSetOfNullableIntSimpleDataRecord',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<(int, _i685tvwm.SimpleData)?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnSetOfNullableIntSimpleDataRecord(
                        session,
                        params['set'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnNullableSetOfIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnNullableSetOfIntSimpleDataRecord',
          params: {
            'recordSet': _is.ParameterDescription(
              name: 'recordSet',
              type: _is.getType<Set<(int, _i685tvwm.SimpleData)>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNullableSetOfIntSimpleDataRecord(
                        session,
                        params['recordSet'],
                      )
                      .then(
                        (container) => container == null
                            ? null
                            : _igqrxdcj.Protocol().mapContainerToJson(
                                container,
                              ),
                      ),
        ),
        'returnStringMapOfIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnStringMapOfIntSimpleDataRecord',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, (int, _i685tvwm.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnStringMapOfIntSimpleDataRecord(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnStringMapOfNullableIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnStringMapOfNullableIntSimpleDataRecord',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is.getType<Map<String, (int, _i685tvwm.SimpleData)?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnStringMapOfNullableIntSimpleDataRecord(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnRecordMapOfIntSimpleDataRecord': _is.MethodConnector(
          name: 'returnRecordMapOfIntSimpleDataRecord',
          params: {
            'map': _is.ParameterDescription(
              name: 'map',
              type: _is
                  .getType<Map<(String, int), (int, _i685tvwm.SimpleData)>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnRecordMapOfIntSimpleDataRecord(
                        session,
                        params['map'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnStringMapOfListOfRecord': _is.MethodConnector(
          name: 'returnStringMapOfListOfRecord',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<Set<List<Map<String, (int,)>>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnStringMapOfListOfRecord(
                        session,
                        params['input'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'returnNestedNamedRecord': _is.MethodConnector(
          name: 'returnNestedNamedRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is
                  .getType<({(_i685tvwm.SimpleData, double) namedSubRecord})>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNestedNamedRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNestedNullableNamedRecord': _is.MethodConnector(
          name: 'returnNestedNullableNamedRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is
                  .getType<
                    ({(_i685tvwm.SimpleData, double)? namedSubRecord})
                  >(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNestedNullableNamedRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnNestedPositionalAndNamedRecord': _is.MethodConnector(
          name: 'returnNestedPositionalAndNamedRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is
                  .getType<
                    (
                      (int, String), {
                      (_i685tvwm.SimpleData, double) namedSubRecord,
                    })
                  >(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnNestedPositionalAndNamedRecord(
                        session,
                        params['record'],
                      )
                      .then(
                        (record) =>
                            _igqrxdcj.Protocol().mapRecordToJson(record),
                      ),
        ),
        'returnListOfNestedPositionalAndNamedRecord': _is.MethodConnector(
          name: 'returnListOfNestedPositionalAndNamedRecord',
          params: {
            'recordList': _is.ParameterDescription(
              name: 'recordList',
              type: _is
                  .getType<
                    List<
                      (
                        (int, String), {
                        (_i685tvwm.SimpleData, double) namedSubRecord,
                      })
                    >
                  >(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .returnListOfNestedPositionalAndNamedRecord(
                        session,
                        params['recordList'],
                      )
                      .then(
                        (container) =>
                            _igqrxdcj.Protocol().mapContainerToJson(container),
                      ),
        ),
        'echoModelClassWithRecordField': _is.MethodConnector(
          name: 'echoModelClassWithRecordField',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_ix95ig49.TypesRecord>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .echoModelClassWithRecordField(
                        session,
                        params['value'],
                      ),
        ),
        'echoNullableModelClassWithRecordField': _is.MethodConnector(
          name: 'echoNullableModelClassWithRecordField',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<_ix95ig49.TypesRecord?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .echoNullableModelClassWithRecordField(
                        session,
                        params['value'],
                      ),
        ),
        'echoNullableModelClassWithRecordFieldFromExternalModule':
            _is.MethodConnector(
              name: 'echoNullableModelClassWithRecordFieldFromExternalModule',
              params: {
                'value': _is.ParameterDescription(
                  name: 'value',
                  type: _is.getType<_iom2gwyu.ModuleClass?>(),
                  nullable: true,
                ),
              },
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                  ) async =>
                      (endpoints['recordParameters']
                              as _ib1glaoo.RecordParametersEndpoint)
                          .echoNullableModelClassWithRecordFieldFromExternalModule(
                            session,
                            params['value'],
                          ),
            ),
        'recordParametersWithCustomNames': _is.MethodConnector(
          name: 'recordParametersWithCustomNames',
          params: {
            'positionalRecord': _is.ParameterDescription(
              name: 'positionalRecord',
              type: _is.getType<(int,)>(),
              nullable: false,
            ),
            'namedRecord': _is.ParameterDescription(
              name: 'namedRecord',
              type: _is.getType<(int,)>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .recordParametersWithCustomNames(
                        session,
                        params['positionalRecord'],
                        namedRecord: params['namedRecord'],
                      ),
        ),
        'streamNullableRecordOfNullableInt': _is.MethodStreamConnector(
          name: 'streamNullableRecordOfNullableInt',
          params: {},
          streamParams: {
            'values': _is.StreamParameterDescription<(int?,)?>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .streamNullableRecordOfNullableInt(
                        session,
                        streamParams['values']!.cast<(int?,)?>(),
                      ),
        ),
        'streamNullableListOfNullableNestedPositionalAndNamedRecord':
            _is.MethodStreamConnector(
              name:
                  'streamNullableListOfNullableNestedPositionalAndNamedRecord',
              params: {
                'initialValue': _is.ParameterDescription(
                  name: 'initialValue',
                  type: _is
                      .getType<
                        List<
                          (
                            (int, String), {
                            (_i685tvwm.SimpleData, double) namedSubRecord,
                          })?
                        >?
                      >(),
                  nullable: true,
                ),
              },
              streamParams: {
                'values':
                    _is.StreamParameterDescription<
                      List<
                        (
                          (int, String), {
                          (_i685tvwm.SimpleData, double) namedSubRecord,
                        })?
                      >?
                    >(
                      name: 'values',
                      nullable: false,
                    ),
              },
              returnType: _is.MethodStreamReturnType.streamType,
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                    Map<String, Stream> streamParams,
                  ) =>
                      (endpoints['recordParameters']
                              as _ib1glaoo.RecordParametersEndpoint)
                          .streamNullableListOfNullableNestedPositionalAndNamedRecord(
                            session,
                            params['initialValue'],
                            streamParams['values']!
                                .cast<
                                  List<
                                    (
                                      (int, String), {
                                      (_i685tvwm.SimpleData, double)
                                      namedSubRecord,
                                    })?
                                  >?
                                >(),
                          ),
            ),
        'streamOfModelClassWithRecordField': _is.MethodStreamConnector(
          name: 'streamOfModelClassWithRecordField',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is.getType<_ix95ig49.TypesRecord>(),
              nullable: false,
            ),
          },
          streamParams: {
            'values': _is.StreamParameterDescription<_ix95ig49.TypesRecord>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .streamOfModelClassWithRecordField(
                        session,
                        params['initialValue'],
                        streamParams['values']!.cast<_ix95ig49.TypesRecord>(),
                      ),
        ),
        'streamOfNullableModelClassWithRecordField': _is.MethodStreamConnector(
          name: 'streamOfNullableModelClassWithRecordField',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is.getType<_ix95ig49.TypesRecord?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'values': _is.StreamParameterDescription<_ix95ig49.TypesRecord?>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .streamOfNullableModelClassWithRecordField(
                        session,
                        params['initialValue'],
                        streamParams['values']!.cast<_ix95ig49.TypesRecord?>(),
                      ),
        ),
        'streamOfNullableModelClassWithRecordFieldFromExternalModule':
            _is.MethodStreamConnector(
              name:
                  'streamOfNullableModelClassWithRecordFieldFromExternalModule',
              params: {
                'initialValue': _is.ParameterDescription(
                  name: 'initialValue',
                  type: _is.getType<_iom2gwyu.ModuleClass?>(),
                  nullable: true,
                ),
              },
              streamParams: {
                'values':
                    _is.StreamParameterDescription<_iom2gwyu.ModuleClass?>(
                      name: 'values',
                      nullable: false,
                    ),
              },
              returnType: _is.MethodStreamReturnType.streamType,
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                    Map<String, Stream> streamParams,
                  ) =>
                      (endpoints['recordParameters']
                              as _ib1glaoo.RecordParametersEndpoint)
                          .streamOfNullableModelClassWithRecordFieldFromExternalModule(
                            session,
                            params['initialValue'],
                            streamParams['values']!
                                .cast<_iom2gwyu.ModuleClass?>(),
                          ),
            ),
        'streamOfNullableIntAndModuleClass': _is.MethodStreamConnector(
          name: 'streamOfNullableIntAndModuleClass',
          params: {},
          streamParams: {
            'values':
                _is.StreamParameterDescription<
                  (int?, _iom2gwyu.ProjectStreamingClass?)
                >(
                  name: 'values',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordParameters']
                          as _ib1glaoo.RecordParametersEndpoint)
                      .streamOfNullableIntAndModuleClass(
                        session,
                        streamParams['values']!
                            .cast<(int?, _iom2gwyu.ProjectStreamingClass?)>(),
                      ),
        ),
      },
    );
    connectors['redis'] = _is.EndpointConnector(
      name: 'redis',
      endpoint: endpoints['redis']!,
      methodConnectors: {
        'setSimpleData': _is.MethodConnector(
          name: 'setSimpleData',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i5ia1kr7.RedisEndpoint).setSimpleData(
                    session,
                    params['key'],
                    params['data'],
                  ),
        ),
        'setSimpleDataWithLifetime': _is.MethodConnector(
          name: 'setSimpleDataWithLifetime',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i5ia1kr7.RedisEndpoint)
                  .setSimpleDataWithLifetime(
                    session,
                    params['key'],
                    params['data'],
                  ),
        ),
        'getSimpleData': _is.MethodConnector(
          name: 'getSimpleData',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i5ia1kr7.RedisEndpoint).getSimpleData(
                    session,
                    params['key'],
                  ),
        ),
        'deleteSimpleData': _is.MethodConnector(
          name: 'deleteSimpleData',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i5ia1kr7.RedisEndpoint)
                  .deleteSimpleData(
                    session,
                    params['key'],
                  ),
        ),
        'resetMessageCentralTest': _is.MethodConnector(
          name: 'resetMessageCentralTest',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i5ia1kr7.RedisEndpoint)
                  .resetMessageCentralTest(session),
        ),
        'listenToChannel': _is.MethodConnector(
          name: 'listenToChannel',
          params: {
            'channel': _is.ParameterDescription(
              name: 'channel',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i5ia1kr7.RedisEndpoint)
                  .listenToChannel(
                    session,
                    params['channel'],
                  ),
        ),
        'postToChannel': _is.MethodConnector(
          name: 'postToChannel',
          params: {
            'channel': _is.ParameterDescription(
              name: 'channel',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['redis'] as _i5ia1kr7.RedisEndpoint).postToChannel(
                    session,
                    params['channel'],
                    params['data'],
                  ),
        ),
        'countSubscribedChannels': _is.MethodConnector(
          name: 'countSubscribedChannels',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['redis'] as _i5ia1kr7.RedisEndpoint)
                  .countSubscribedChannels(session),
        ),
      },
    );
    connectors['serverOnlyScopedFieldModel'] = _is.EndpointConnector(
      name: 'serverOnlyScopedFieldModel',
      endpoint: endpoints['serverOnlyScopedFieldModel']!,
      methodConnectors: {
        'getScopeServerOnlyField': _is.MethodConnector(
          name: 'getScopeServerOnlyField',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['serverOnlyScopedFieldModel']
                          as _ix3s2g81.ServerOnlyScopedFieldModelEndpoint)
                      .getScopeServerOnlyField(session),
        ),
      },
    );
    connectors['serverOnlyScopedFieldChildModel'] = _is.EndpointConnector(
      name: 'serverOnlyScopedFieldChildModel',
      endpoint: endpoints['serverOnlyScopedFieldChildModel']!,
      methodConnectors: {
        'getProtocolField': _is.MethodConnector(
          name: 'getProtocolField',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['serverOnlyScopedFieldChildModel']
                          as _iv5t2nu0.ServerOnlyScopedFieldChildModelEndpoint)
                      .getProtocolField(session),
        ),
      },
    );
    connectors['sessionAuthentication'] = _is.EndpointConnector(
      name: 'sessionAuthentication',
      endpoint: endpoints['sessionAuthentication']!,
      methodConnectors: {
        'getAuthenticatedUserId': _is.MethodConnector(
          name: 'getAuthenticatedUserId',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _ieivi1oj.SessionAuthenticationEndpoint)
                      .getAuthenticatedUserId(session),
        ),
        'getAuthenticatedScopes': _is.MethodConnector(
          name: 'getAuthenticatedScopes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _ieivi1oj.SessionAuthenticationEndpoint)
                      .getAuthenticatedScopes(session),
        ),
        'getAuthenticatedAuthId': _is.MethodConnector(
          name: 'getAuthenticatedAuthId',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _ieivi1oj.SessionAuthenticationEndpoint)
                      .getAuthenticatedAuthId(session),
        ),
        'getAuthenticationInfo': _is.MethodConnector(
          name: 'getAuthenticationInfo',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _ieivi1oj.SessionAuthenticationEndpoint)
                      .getAuthenticationInfo(session),
        ),
        'isAuthenticated': _is.MethodConnector(
          name: 'isAuthenticated',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionAuthentication']
                          as _ieivi1oj.SessionAuthenticationEndpoint)
                      .isAuthenticated(session),
        ),
        'streamAuthenticatedUserId': _is.MethodStreamConnector(
          name: 'streamAuthenticatedUserId',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['sessionAuthentication']
                          as _ieivi1oj.SessionAuthenticationEndpoint)
                      .streamAuthenticatedUserId(session),
        ),
        'streamIsAuthenticated': _is.MethodStreamConnector(
          name: 'streamIsAuthenticated',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['sessionAuthentication']
                          as _ieivi1oj.SessionAuthenticationEndpoint)
                      .streamIsAuthenticated(session),
        ),
      },
    );
    connectors['setParameters'] = _is.EndpointConnector(
      name: 'setParameters',
      endpoint: endpoints['setParameters']!,
      methodConnectors: {
        'returnIntSet': _is.MethodConnector(
          name: 'returnIntSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnIntSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnIntSetSet': _is.MethodConnector(
          name: 'returnIntSetSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<Set<int>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnIntSetSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnIntListSet': _is.MethodConnector(
          name: 'returnIntListSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<List<int>>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnIntListSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnIntSetNullable': _is.MethodConnector(
          name: 'returnIntSetNullable',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<int>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnIntSetNullable(
                        session,
                        params['set'],
                      ),
        ),
        'returnIntSetNullableSet': _is.MethodConnector(
          name: 'returnIntSetNullableSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<Set<int>?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnIntSetNullableSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnIntSetSetNullable': _is.MethodConnector(
          name: 'returnIntSetSetNullable',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<Set<int>>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnIntSetSetNullable(
                        session,
                        params['set'],
                      ),
        ),
        'returnIntSetNullableInts': _is.MethodConnector(
          name: 'returnIntSetNullableInts',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<int?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnIntSetNullableInts(
                        session,
                        params['set'],
                      ),
        ),
        'returnNullableIntSetNullableInts': _is.MethodConnector(
          name: 'returnNullableIntSetNullableInts',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<int?>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnNullableIntSetNullableInts(
                        session,
                        params['set'],
                      ),
        ),
        'returnDoubleSet': _is.MethodConnector(
          name: 'returnDoubleSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<double>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnDoubleSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnDoubleSetNullableDoubles': _is.MethodConnector(
          name: 'returnDoubleSetNullableDoubles',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<double?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnDoubleSetNullableDoubles(
                        session,
                        params['set'],
                      ),
        ),
        'returnBoolSet': _is.MethodConnector(
          name: 'returnBoolSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<bool>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnBoolSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnBoolSetNullableBools': _is.MethodConnector(
          name: 'returnBoolSetNullableBools',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<bool?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnBoolSetNullableBools(
                        session,
                        params['set'],
                      ),
        ),
        'returnStringSet': _is.MethodConnector(
          name: 'returnStringSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnStringSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnStringSetNullableStrings': _is.MethodConnector(
          name: 'returnStringSetNullableStrings',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<String?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnStringSetNullableStrings(
                        session,
                        params['set'],
                      ),
        ),
        'returnDateTimeSet': _is.MethodConnector(
          name: 'returnDateTimeSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<DateTime>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnDateTimeSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnDateTimeSetNullableDateTimes': _is.MethodConnector(
          name: 'returnDateTimeSetNullableDateTimes',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<DateTime?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnDateTimeSetNullableDateTimes(
                        session,
                        params['set'],
                      ),
        ),
        'returnByteDataSet': _is.MethodConnector(
          name: 'returnByteDataSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<_idt.ByteData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnByteDataSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnByteDataSetNullableByteDatas': _is.MethodConnector(
          name: 'returnByteDataSetNullableByteDatas',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<_idt.ByteData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnByteDataSetNullableByteDatas(
                        session,
                        params['set'],
                      ),
        ),
        'returnSimpleDataSet': _is.MethodConnector(
          name: 'returnSimpleDataSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<_i685tvwm.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnSimpleDataSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnSimpleDataSetNullableSimpleData': _is.MethodConnector(
          name: 'returnSimpleDataSetNullableSimpleData',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<_i685tvwm.SimpleData?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnSimpleDataSetNullableSimpleData(
                        session,
                        params['set'],
                      ),
        ),
        'returnDurationSet': _is.MethodConnector(
          name: 'returnDurationSet',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<Duration>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnDurationSet(
                        session,
                        params['set'],
                      ),
        ),
        'returnDurationSetNullableDurations': _is.MethodConnector(
          name: 'returnDurationSetNullableDurations',
          params: {
            'set': _is.ParameterDescription(
              name: 'set',
              type: _is.getType<Set<Duration?>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['setParameters']
                          as _i80ils9z.SetParametersEndpoint)
                      .returnDurationSetNullableDurations(
                        session,
                        params['set'],
                      ),
        ),
      },
    );
    connectors['signInRequired'] = _is.EndpointConnector(
      name: 'signInRequired',
      endpoint: endpoints['signInRequired']!,
      methodConnectors: {
        'testMethod': _is.MethodConnector(
          name: 'testMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['signInRequired']
                          as _idzjag2f.SignInRequiredEndpoint)
                      .testMethod(session),
        ),
      },
    );
    connectors['adminScopeRequired'] = _is.EndpointConnector(
      name: 'adminScopeRequired',
      endpoint: endpoints['adminScopeRequired']!,
      methodConnectors: {
        'testMethod': _is.MethodConnector(
          name: 'testMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminScopeRequired']
                          as _idzjag2f.AdminScopeRequiredEndpoint)
                      .testMethod(session),
        ),
      },
    );
    connectors['simple'] = _is.EndpointConnector(
      name: 'simple',
      endpoint: endpoints['simple']!,
      methodConnectors: {
        'setGlobalInt': _is.MethodConnector(
          name: 'setGlobalInt',
          params: {
            'value': _is.ParameterDescription(
              name: 'value',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'secondValue': _is.ParameterDescription(
              name: 'secondValue',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['simple'] as _il4e9ez0.SimpleEndpoint)
                  .setGlobalInt(
                    session,
                    params['value'],
                    params['secondValue'],
                  ),
        ),
        'addToGlobalInt': _is.MethodConnector(
          name: 'addToGlobalInt',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['simple'] as _il4e9ez0.SimpleEndpoint)
                  .addToGlobalInt(session),
        ),
        'getGlobalInt': _is.MethodConnector(
          name: 'getGlobalInt',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['simple'] as _il4e9ez0.SimpleEndpoint)
                  .getGlobalInt(session),
        ),
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simple'] as _il4e9ez0.SimpleEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    connectors['subSubDirTest'] = _is.EndpointConnector(
      name: 'subSubDirTest',
      endpoint: endpoints['subSubDirTest']!,
      methodConnectors: {
        'testMethod': _is.MethodConnector(
          name: 'testMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['subSubDirTest']
                          as _ig647puh.SubSubDirTestEndpoint)
                      .testMethod(session),
        ),
      },
    );
    connectors['subDirTest'] = _is.EndpointConnector(
      name: 'subDirTest',
      endpoint: endpoints['subDirTest']!,
      methodConnectors: {
        'testMethod': _is.MethodConnector(
          name: 'testMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['subDirTest'] as _i7nbpkw0.SubDirTestEndpoint)
                      .testMethod(session),
        ),
      },
    );
    connectors['testTools'] = _is.EndpointConnector(
      name: 'testTools',
      endpoint: endpoints['testTools']!,
      methodConnectors: {
        'returnsSessionId': _is.MethodConnector(
          name: 'returnsSessionId',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsSessionId(session),
        ),
        'returnsSessionEndpointAndMethod': _is.MethodConnector(
          name: 'returnsSessionEndpointAndMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsSessionEndpointAndMethod(session),
        ),
        'returnsString': _is.MethodConnector(
          name: 'returnsString',
          params: {
            'string': _is.ParameterDescription(
              name: 'string',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsString(
                    session,
                    params['string'],
                  ),
        ),
        'postNumberToSharedStream': _is.MethodConnector(
          name: 'postNumberToSharedStream',
          params: {
            'number': _is.ParameterDescription(
              name: 'number',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .postNumberToSharedStream(
                    session,
                    params['number'],
                  ),
        ),
        'createSimpleData': _is.MethodConnector(
          name: 'createSimpleData',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleData(
                    session,
                    params['data'],
                  ),
        ),
        'getAllSimpleData': _is.MethodConnector(
          name: 'getAllSimpleData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .getAllSimpleData(session),
        ),
        'createSimpleDatasInsideTransactions': _is.MethodConnector(
          name: 'createSimpleDatasInsideTransactions',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleDatasInsideTransactions(
                    session,
                    params['data'],
                  ),
        ),
        'createSimpleDataAndThrowInsideTransaction': _is.MethodConnector(
          name: 'createSimpleDataAndThrowInsideTransaction',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleDataAndThrowInsideTransaction(
                    session,
                    params['data'],
                  ),
        ),
        'createSimpleDatasInParallelTransactionCalls': _is.MethodConnector(
          name: 'createSimpleDatasInParallelTransactionCalls',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleDatasInParallelTransactionCalls(session),
        ),
        'echoDynamic': _is.MethodConnector(
          name: 'echoDynamic',
          params: {
            'anything': _is.ParameterDescription(
              name: 'anything',
              type: _is.getType<dynamic>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoDynamic(
                    session,
                    params['anything'],
                  ),
        ),
        'echoSimpleData': _is.MethodConnector(
          name: 'echoSimpleData',
          params: {
            'simpleData': _is.ParameterDescription(
              name: 'simpleData',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoSimpleData(
                    session,
                    params['simpleData'],
                  ),
        ),
        'echoSimpleDatas': _is.MethodConnector(
          name: 'echoSimpleDatas',
          params: {
            'simpleDatas': _is.ParameterDescription(
              name: 'simpleDatas',
              type: _is.getType<List<_i685tvwm.SimpleData>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoSimpleDatas(
                    session,
                    params['simpleDatas'],
                  ),
        ),
        'echoObjectWithDynamic': _is.MethodConnector(
          name: 'echoObjectWithDynamic',
          params: {
            'objectWithDynamic': _is.ParameterDescription(
              name: 'objectWithDynamic',
              type: _is.getType<_i9ckso16.ObjectWithDynamic>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoObjectWithDynamic(
                    session,
                    params['objectWithDynamic'],
                  ),
        ),
        'echoTypes': _is.MethodConnector(
          name: 'echoTypes',
          params: {
            'typesModel': _is.ParameterDescription(
              name: 'typesModel',
              type: _is.getType<_iuch3ck4.Types>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoTypes(
                    session,
                    params['typesModel'],
                  ),
        ),
        'echoTypesList': _is.MethodConnector(
          name: 'echoTypesList',
          params: {
            'typesList': _is.ParameterDescription(
              name: 'typesList',
              type: _is.getType<List<_iuch3ck4.Types>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoTypesList(
                    session,
                    params['typesList'],
                  ),
        ),
        'echoModuleDatatype': _is.MethodConnector(
          name: 'echoModuleDatatype',
          params: {
            'moduleDatatype': _is.ParameterDescription(
              name: 'moduleDatatype',
              type: _is.getType<_idarivwd.ModuleDatatype>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoModuleDatatype(
                    session,
                    params['moduleDatatype'],
                  ),
        ),
        'echoModuleClass': _is.MethodConnector(
          name: 'echoModuleClass',
          params: {
            'moduleClass': _is.ParameterDescription(
              name: 'moduleClass',
              type: _is.getType<_iom2gwyu.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoModuleClass(
                    session,
                    params['moduleClass'],
                  ),
        ),
        'echoRecord': _is.MethodConnector(
          name: 'echoRecord',
          params: {
            'record': _is.ParameterDescription(
              name: 'record',
              type: _is.getType<(String, (int, bool))>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoRecord(
                    session,
                    params['record'],
                  )
                  .then(
                    (record) => _igqrxdcj.Protocol().mapRecordToJson(record),
                  ),
        ),
        'echoRecords': _is.MethodConnector(
          name: 'echoRecords',
          params: {
            'records': _is.ParameterDescription(
              name: 'records',
              type: _is.getType<List<(String, (int, bool))>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .echoRecords(
                    session,
                    params['records'],
                  )
                  .then(
                    (container) =>
                        _igqrxdcj.Protocol().mapContainerToJson(container),
                  ),
        ),
        'returnRecordWithSerializableObject': _is.MethodConnector(
          name: 'returnRecordWithSerializableObject',
          params: {
            'number': _is.ParameterDescription(
              name: 'number',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnRecordWithSerializableObject(
                    session,
                    params['number'],
                    params['data'],
                  )
                  .then(
                    (record) => _igqrxdcj.Protocol().mapRecordToJson(record),
                  ),
        ),
        'logMessageWithSession': _is.MethodConnector(
          name: 'logMessageWithSession',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .logMessageWithSession(session),
        ),
        'addWillCloseListenerToSessionAndThrow': _is.MethodConnector(
          name: 'addWillCloseListenerToSessionAndThrow',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .addWillCloseListenerToSessionAndThrow(session),
        ),
        'putInLocalCache': _is.MethodConnector(
          name: 'putInLocalCache',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .putInLocalCache(
                    session,
                    params['key'],
                    params['data'],
                  ),
        ),
        'getFromLocalCache': _is.MethodConnector(
          name: 'getFromLocalCache',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .getFromLocalCache(
                    session,
                    params['key'],
                  ),
        ),
        'putInLocalPrioCache': _is.MethodConnector(
          name: 'putInLocalPrioCache',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .putInLocalPrioCache(
                    session,
                    params['key'],
                    params['data'],
                  ),
        ),
        'getFromLocalPrioCache': _is.MethodConnector(
          name: 'getFromLocalPrioCache',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .getFromLocalPrioCache(
                    session,
                    params['key'],
                  ),
        ),
        'putInQueryCache': _is.MethodConnector(
          name: 'putInQueryCache',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .putInQueryCache(
                    session,
                    params['key'],
                    params['data'],
                  ),
        ),
        'getFromQueryCache': _is.MethodConnector(
          name: 'getFromQueryCache',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .getFromQueryCache(
                    session,
                    params['key'],
                  ),
        ),
        'putInLocalCacheWithGroup': _is.MethodConnector(
          name: 'putInLocalCacheWithGroup',
          params: {
            'key': _is.ParameterDescription(
              name: 'key',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_i685tvwm.SimpleData>(),
              nullable: false,
            ),
            'group': _is.ParameterDescription(
              name: 'group',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .putInLocalCacheWithGroup(
                    session,
                    params['key'],
                    params['data'],
                    params['group'],
                  ),
        ),
        'returnsSessionIdFromStream': _is.MethodStreamConnector(
          name: 'returnsSessionIdFromStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsSessionIdFromStream(session),
        ),
        'returnsSessionEndpointAndMethodFromStream': _is.MethodStreamConnector(
          name: 'returnsSessionEndpointAndMethodFromStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsSessionEndpointAndMethodFromStream(session),
        ),
        'returnsStream': _is.MethodStreamConnector(
          name: 'returnsStream',
          params: {
            'n': _is.ParameterDescription(
              name: 'n',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsStream(
                    session,
                    params['n'],
                  ),
        ),
        'returnsListFromInputStream': _is.MethodStreamConnector(
          name: 'returnsListFromInputStream',
          params: {},
          streamParams: {
            'numbers': _is.StreamParameterDescription<int>(
              name: 'numbers',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsListFromInputStream(
                    session,
                    streamParams['numbers']!.cast<int>(),
                  ),
        ),
        'returnsSimpleDataListFromInputStream': _is.MethodStreamConnector(
          name: 'returnsSimpleDataListFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _is.StreamParameterDescription<_i685tvwm.SimpleData>(
              name: 'simpleDatas',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsSimpleDataListFromInputStream(
                    session,
                    streamParams['simpleDatas']!.cast<_i685tvwm.SimpleData>(),
                  ),
        ),
        'returnsStreamFromInputStream': _is.MethodStreamConnector(
          name: 'returnsStreamFromInputStream',
          params: {},
          streamParams: {
            'numbers': _is.StreamParameterDescription<int>(
              name: 'numbers',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsStreamFromInputStream(
                    session,
                    streamParams['numbers']!.cast<int>(),
                  ),
        ),
        'returnsSimpleDataStreamFromInputStream': _is.MethodStreamConnector(
          name: 'returnsSimpleDataStreamFromInputStream',
          params: {},
          streamParams: {
            'simpleDatas': _is.StreamParameterDescription<_i685tvwm.SimpleData>(
              name: 'simpleDatas',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .returnsSimpleDataStreamFromInputStream(
                    session,
                    streamParams['simpleDatas']!.cast<_i685tvwm.SimpleData>(),
                  ),
        ),
        'postNumberToSharedStreamAndReturnStream': _is.MethodStreamConnector(
          name: 'postNumberToSharedStreamAndReturnStream',
          params: {
            'number': _is.ParameterDescription(
              name: 'number',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .postNumberToSharedStreamAndReturnStream(
                    session,
                    params['number'],
                  ),
        ),
        'listenForNumbersOnSharedStream': _is.MethodStreamConnector(
          name: 'listenForNumbersOnSharedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .listenForNumbersOnSharedStream(session),
        ),
        'streamModuleDatatype': _is.MethodStreamConnector(
          name: 'streamModuleDatatype',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is.getType<_idarivwd.ModuleDatatype?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'values': _is.StreamParameterDescription<_idarivwd.ModuleDatatype?>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .streamModuleDatatype(
                    session,
                    params['initialValue'],
                    streamParams['values']!.cast<_idarivwd.ModuleDatatype?>(),
                  ),
        ),
        'streamModuleClass': _is.MethodStreamConnector(
          name: 'streamModuleClass',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is.getType<_iom2gwyu.ModuleClass?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'values': _is.StreamParameterDescription<_iom2gwyu.ModuleClass?>(
              name: 'values',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .streamModuleClass(
                    session,
                    params['initialValue'],
                    streamParams['values']!.cast<_iom2gwyu.ModuleClass?>(),
                  ),
        ),
        'recordEchoStream': _is.MethodStreamConnector(
          name: 'recordEchoStream',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is
                  .getType<
                    (
                      String,
                      (
                        Map<String, int>, {
                        bool flag,
                        _i685tvwm.SimpleData simpleData,
                      }),
                    )
                  >(),
              nullable: false,
            ),
          },
          streamParams: {
            'stream':
                _is.StreamParameterDescription<
                  (
                    String,
                    (
                      Map<String, int>, {
                      bool flag,
                      _i685tvwm.SimpleData simpleData,
                    }),
                  )
                >(
                  name: 'stream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
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
                              _i685tvwm.SimpleData simpleData,
                            }),
                          )
                        >(),
                  ),
        ),
        'listOfRecordEchoStream': _is.MethodStreamConnector(
          name: 'listOfRecordEchoStream',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is.getType<List<(String, int)>>(),
              nullable: false,
            ),
          },
          streamParams: {
            'stream': _is.StreamParameterDescription<List<(String, int)>>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .listOfRecordEchoStream(
                    session,
                    params['initialValue'],
                    streamParams['stream']!.cast<List<(String, int)>>(),
                  ),
        ),
        'nullableRecordEchoStream': _is.MethodStreamConnector(
          name: 'nullableRecordEchoStream',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is
                  .getType<
                    (
                      String,
                      (
                        Map<String, int>, {
                        bool flag,
                        _i685tvwm.SimpleData simpleData,
                      }),
                    )?
                  >(),
              nullable: true,
            ),
          },
          streamParams: {
            'stream':
                _is.StreamParameterDescription<
                  (
                    String,
                    (
                      Map<String, int>, {
                      bool flag,
                      _i685tvwm.SimpleData simpleData,
                    }),
                  )?
                >(
                  name: 'stream',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
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
                              _i685tvwm.SimpleData simpleData,
                            }),
                          )?
                        >(),
                  ),
        ),
        'nullableListOfRecordEchoStream': _is.MethodStreamConnector(
          name: 'nullableListOfRecordEchoStream',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is.getType<List<(String, int)>?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'stream': _is.StreamParameterDescription<List<(String, int)>?>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .nullableListOfRecordEchoStream(
                    session,
                    params['initialValue'],
                    streamParams['stream']!.cast<List<(String, int)>?>(),
                  ),
        ),
        'modelWithRecordsEchoStream': _is.MethodStreamConnector(
          name: 'modelWithRecordsEchoStream',
          params: {
            'initialValue': _is.ParameterDescription(
              name: 'initialValue',
              type: _is.getType<_ix95ig49.TypesRecord?>(),
              nullable: true,
            ),
          },
          streamParams: {
            'stream': _is.StreamParameterDescription<_ix95ig49.TypesRecord?>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .modelWithRecordsEchoStream(
                    session,
                    params['initialValue'],
                    streamParams['stream']!.cast<_ix95ig49.TypesRecord?>(),
                  ),
        ),
        'addWillCloseListenerToSessionIntStreamMethodAndThrow':
            _is.MethodStreamConnector(
              name: 'addWillCloseListenerToSessionIntStreamMethodAndThrow',
              params: {},
              streamParams: {},
              returnType: _is.MethodStreamReturnType.streamType,
              call:
                  (
                    _is.Session session,
                    Map<String, dynamic> params,
                    Map<String, Stream> streamParams,
                  ) => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                      .addWillCloseListenerToSessionIntStreamMethodAndThrow(
                        session,
                      ),
            ),
      },
    );
    connectors['authenticatedTestTools'] = _is.EndpointConnector(
      name: 'authenticatedTestTools',
      endpoint: endpoints['authenticatedTestTools']!,
      methodConnectors: {
        'returnsString': _is.MethodConnector(
          name: 'returnsString',
          params: {
            'string': _is.ParameterDescription(
              name: 'string',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authenticatedTestTools']
                          as _itdztv0y.AuthenticatedTestToolsEndpoint)
                      .returnsString(
                        session,
                        params['string'],
                      ),
        ),
        'returnsStream': _is.MethodStreamConnector(
          name: 'returnsStream',
          params: {
            'n': _is.ParameterDescription(
              name: 'n',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedTestTools']
                          as _itdztv0y.AuthenticatedTestToolsEndpoint)
                      .returnsStream(
                        session,
                        params['n'],
                      ),
        ),
        'returnsListFromInputStream': _is.MethodStreamConnector(
          name: 'returnsListFromInputStream',
          params: {},
          streamParams: {
            'numbers': _is.StreamParameterDescription<int>(
              name: 'numbers',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedTestTools']
                          as _itdztv0y.AuthenticatedTestToolsEndpoint)
                      .returnsListFromInputStream(
                        session,
                        streamParams['numbers']!.cast<int>(),
                      ),
        ),
        'intEchoStream': _is.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedTestTools']
                          as _itdztv0y.AuthenticatedTestToolsEndpoint)
                      .intEchoStream(
                        session,
                        streamParams['stream']!.cast<int>(),
                      ),
        ),
      },
    );
    connectors['unauthenticated'] = _is.EndpointConnector(
      name: 'unauthenticated',
      endpoint: endpoints['unauthenticated']!,
      methodConnectors: {
        'unauthenticatedMethod': _is.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['unauthenticated']
                          as _ius7wovq.UnauthenticatedEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _is.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['unauthenticated']
                          as _ius7wovq.UnauthenticatedEndpoint)
                      .unauthenticatedStream(session),
        ),
      },
    );
    connectors['partiallyUnauthenticated'] = _is.EndpointConnector(
      name: 'partiallyUnauthenticated',
      endpoint: endpoints['partiallyUnauthenticated']!,
      methodConnectors: {
        'unauthenticatedMethod': _is.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'authenticatedMethod': _is.MethodConnector(
          name: 'authenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .authenticatedMethod(session),
        ),
        'unauthenticatedStream': _is.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .unauthenticatedStream(session),
        ),
        'authenticatedStream': _is.MethodStreamConnector(
          name: 'authenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .authenticatedStream(session),
        ),
      },
    );
    connectors['unauthenticatedRequireLogin'] = _is.EndpointConnector(
      name: 'unauthenticatedRequireLogin',
      endpoint: endpoints['unauthenticatedRequireLogin']!,
      methodConnectors: {
        'unauthenticatedMethod': _is.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['unauthenticatedRequireLogin']
                          as _ius7wovq.UnauthenticatedRequireLoginEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _is.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['unauthenticatedRequireLogin']
                          as _ius7wovq.UnauthenticatedRequireLoginEndpoint)
                      .unauthenticatedStream(session),
        ),
      },
    );
    connectors['requireLogin'] = _is.EndpointConnector(
      name: 'requireLogin',
      endpoint: endpoints['requireLogin']!,
      methodConnectors: {
        'unauthenticatedMethod': _is.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['requireLogin'] as _ius7wovq.RequireLoginEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _is.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['requireLogin'] as _ius7wovq.RequireLoginEndpoint)
                  .unauthenticatedStream(session),
        ),
      },
    );
    connectors['upload'] = _is.EndpointConnector(
      name: 'upload',
      endpoint: endpoints['upload']!,
      methodConnectors: {
        'uploadByteData': _is.MethodConnector(
          name: 'uploadByteData',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['upload'] as _ia6lpdch.UploadEndpoint)
                  .uploadByteData(
                    session,
                    params['path'],
                    params['data'],
                  ),
        ),
      },
    );
    connectors['myFeature'] = _is.EndpointConnector(
      name: 'myFeature',
      endpoint: endpoints['myFeature']!,
      methodConnectors: {
        'myFeatureMethod': _is.MethodConnector(
          name: 'myFeatureMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['myFeature'] as _ij2anjje.MyFeatureEndpoint)
                  .myFeatureMethod(session),
        ),
        'myFeatureModel': _is.MethodConnector(
          name: 'myFeatureModel',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['myFeature'] as _ij2anjje.MyFeatureEndpoint)
                  .myFeatureModel(session),
        ),
      },
    );
    modules['serverpod_auth'] = _i1n3uhu0.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_test_module'] = _iom2gwyu.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_test_shared_module'] = _iyx9etqn.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i3an2vcw.FutureCalls();
  }
}
