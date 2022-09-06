/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: unused_import

import 'dart:typed_data' as typed_data;
import 'package:serverpod/serverpod.dart';

import 'package:serverpod_test_module_server/module.dart'
    as serverpod_test_module;
import 'package:serverpod_auth_server/module.dart' as serverpod_auth;

import 'protocol.dart';

import '../endpoints/async_tasks.dart';
import '../endpoints/authentication.dart';
import '../endpoints/basic_types.dart';
import '../endpoints/cloud_storage.dart';
import '../endpoints/cloud_storage_s3.dart';
import '../endpoints/database_basic.dart';
import '../endpoints/database_transactions.dart';
import '../endpoints/failed_calls.dart';
import '../endpoints/field_scopes.dart';
import '../endpoints/future_calls.dart';
import '../endpoints/list_parameters.dart';
import '../endpoints/logging.dart';
import '../endpoints/logging_disabled.dart';
import '../endpoints/module_serialization.dart';
import '../endpoints/named_parameters.dart';
import '../endpoints/optional_parameters.dart';
import '../endpoints/redis.dart';
import '../endpoints/signin_required.dart';
import '../endpoints/simple.dart';
import '../endpoints/streaming.dart';
import '../endpoints/streaming_logging.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'asyncTasks': AsyncTasksEndpoint()
        ..initialize(server, 'asyncTasks', null),
      'authentication': AuthenticationEndpoint()
        ..initialize(server, 'authentication', null),
      'basicTypes': BasicTypesEndpoint()
        ..initialize(server, 'basicTypes', null),
      'cloudStorage': CloudStorageEndpoint()
        ..initialize(server, 'cloudStorage', null),
      's3CloudStorage': S3CloudStorageEndpoint()
        ..initialize(server, 's3CloudStorage', null),
      'basicDatabase': BasicDatabase()
        ..initialize(server, 'basicDatabase', null),
      'transactionsDatabase': TransactionsDatabaseEndpoint()
        ..initialize(server, 'transactionsDatabase', null),
      'failedCalls': FailedCallsEndpoint()
        ..initialize(server, 'failedCalls', null),
      'fieldScopes': FieldScopesEndpoint()
        ..initialize(server, 'fieldScopes', null),
      'futureCalls': FutureCallsEndpoint()
        ..initialize(server, 'futureCalls', null),
      'listParameters': ListParametersEndpoint()
        ..initialize(server, 'listParameters', null),
      'logging': LoggingEndpoint()..initialize(server, 'logging', null),
      'loggingDisabled': LoggingDisabledEndpoint()
        ..initialize(server, 'loggingDisabled', null),
      'moduleSerialization': ModuleSerializationEndpoint()
        ..initialize(server, 'moduleSerialization', null),
      'namedParameters': NamedParametersEndpoint()
        ..initialize(server, 'namedParameters', null),
      'optionalParameters': OptionalParametersEndpoint()
        ..initialize(server, 'optionalParameters', null),
      'redis': RedisEndpoint()..initialize(server, 'redis', null),
      'signInRequired': SignInRequiredEndpoint()
        ..initialize(server, 'signInRequired', null),
      'simple': SimpleEndpoint()..initialize(server, 'simple', null),
      'streaming': StreamingEndpoint()..initialize(server, 'streaming', null),
      'streamingLogging': StreamingLoggingEndpoint()
        ..initialize(server, 'streamingLogging', null),
    };

    connectors['asyncTasks'] = EndpointConnector(
      name: 'asyncTasks',
      endpoint: endpoints['asyncTasks']!,
      methodConnectors: {
        'insertRowToSimpleDataAfterDelay': MethodConnector(
          name: 'insertRowToSimpleDataAfterDelay',
          params: {
            'num':
                ParameterDescription(name: 'num', type: int, nullable: false),
            'seconds': ParameterDescription(
                name: 'seconds', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['asyncTasks'] as AsyncTasksEndpoint)
                .insertRowToSimpleDataAfterDelay(
              session,
              params['num'],
              params['seconds'],
            );
          },
        ),
        'throwExceptionAfterDelay': MethodConnector(
          name: 'throwExceptionAfterDelay',
          params: {
            'seconds': ParameterDescription(
                name: 'seconds', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['asyncTasks'] as AsyncTasksEndpoint)
                .throwExceptionAfterDelay(
              session,
              params['seconds'],
            );
          },
        ),
      },
    );

    connectors['authentication'] = EndpointConnector(
      name: 'authentication',
      endpoint: endpoints['authentication']!,
      methodConnectors: {
        'removeAllUsers': MethodConnector(
          name: 'removeAllUsers',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['authentication'] as AuthenticationEndpoint)
                .removeAllUsers(
              session,
            );
          },
        ),
        'countUsers': MethodConnector(
          name: 'countUsers',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['authentication'] as AuthenticationEndpoint)
                .countUsers(
              session,
            );
          },
        ),
        'createUser': MethodConnector(
          name: 'createUser',
          params: {
            'email': ParameterDescription(
                name: 'email', type: String, nullable: false),
            'password': ParameterDescription(
                name: 'password', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['authentication'] as AuthenticationEndpoint)
                .createUser(
              session,
              params['email'],
              params['password'],
            );
          },
        ),
        'authenticate': MethodConnector(
          name: 'authenticate',
          params: {
            'email': ParameterDescription(
                name: 'email', type: String, nullable: false),
            'password': ParameterDescription(
                name: 'password', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['authentication'] as AuthenticationEndpoint)
                .authenticate(
              session,
              params['email'],
              params['password'],
            );
          },
        ),
      },
    );

    connectors['basicTypes'] = EndpointConnector(
      name: 'basicTypes',
      endpoint: endpoints['basicTypes']!,
      methodConnectors: {
        'testInt': MethodConnector(
          name: 'testInt',
          params: {
            'value':
                ParameterDescription(name: 'value', type: int, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testInt(
              session,
              params['value'],
            );
          },
        ),
        'testDouble': MethodConnector(
          name: 'testDouble',
          params: {
            'value': ParameterDescription(
                name: 'value', type: double, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testDouble(
              session,
              params['value'],
            );
          },
        ),
        'testBool': MethodConnector(
          name: 'testBool',
          params: {
            'value':
                ParameterDescription(name: 'value', type: bool, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testBool(
              session,
              params['value'],
            );
          },
        ),
        'testDateTime': MethodConnector(
          name: 'testDateTime',
          params: {
            'dateTime': ParameterDescription(
                name: 'dateTime', type: DateTime, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testDateTime(
              session,
              params['dateTime'],
            );
          },
        ),
        'testString': MethodConnector(
          name: 'testString',
          params: {
            'value': ParameterDescription(
                name: 'value', type: String, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testString(
              session,
              params['value'],
            );
          },
        ),
        'testByteData': MethodConnector(
          name: 'testByteData',
          params: {
            'value': ParameterDescription(
                name: 'value', type: typed_data.ByteData, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testByteData(
              session,
              params['value'],
            );
          },
        ),
      },
    );

    connectors['cloudStorage'] = EndpointConnector(
      name: 'cloudStorage',
      endpoint: endpoints['cloudStorage']!,
      methodConnectors: {
        'reset': MethodConnector(
          name: 'reset',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint).reset(
              session,
            );
          },
        ),
        'storePublicFile': MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
            'byteData': ParameterDescription(
                name: 'byteData', type: typed_data.ByteData, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint)
                .storePublicFile(
              session,
              params['path'],
              params['byteData'],
            );
          },
        ),
        'retrievePublicFile': MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint)
                .retrievePublicFile(
              session,
              params['path'],
            );
          },
        ),
        'existsPublicFile': MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint)
                .existsPublicFile(
              session,
              params['path'],
            );
          },
        ),
        'deletePublicFile': MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint)
                .deletePublicFile(
              session,
              params['path'],
            );
          },
        ),
        'getPublicUrlForFile': MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint)
                .getPublicUrlForFile(
              session,
              params['path'],
            );
          },
        ),
        'getDirectFilePostUrl': MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint)
                .getDirectFilePostUrl(
              session,
              params['path'],
            );
          },
        ),
        'verifyDirectFileUpload': MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint)
                .verifyDirectFileUpload(
              session,
              params['path'],
            );
          },
        ),
      },
    );

    connectors['s3CloudStorage'] = EndpointConnector(
      name: 's3CloudStorage',
      endpoint: endpoints['s3CloudStorage']!,
      methodConnectors: {
        'storePublicFile': MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
            'byteData': ParameterDescription(
                name: 'byteData', type: typed_data.ByteData, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['s3CloudStorage'] as S3CloudStorageEndpoint)
                .storePublicFile(
              session,
              params['path'],
              params['byteData'],
            );
          },
        ),
        'retrievePublicFile': MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['s3CloudStorage'] as S3CloudStorageEndpoint)
                .retrievePublicFile(
              session,
              params['path'],
            );
          },
        ),
        'existsPublicFile': MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['s3CloudStorage'] as S3CloudStorageEndpoint)
                .existsPublicFile(
              session,
              params['path'],
            );
          },
        ),
        'deletePublicFile': MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['s3CloudStorage'] as S3CloudStorageEndpoint)
                .deletePublicFile(
              session,
              params['path'],
            );
          },
        ),
        'getPublicUrlForFile': MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['s3CloudStorage'] as S3CloudStorageEndpoint)
                .getPublicUrlForFile(
              session,
              params['path'],
            );
          },
        ),
        'getDirectFilePostUrl': MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['s3CloudStorage'] as S3CloudStorageEndpoint)
                .getDirectFilePostUrl(
              session,
              params['path'],
            );
          },
        ),
        'verifyDirectFileUpload': MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': ParameterDescription(
                name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['s3CloudStorage'] as S3CloudStorageEndpoint)
                .verifyDirectFileUpload(
              session,
              params['path'],
            );
          },
        ),
      },
    );

    connectors['basicDatabase'] = EndpointConnector(
      name: 'basicDatabase',
      endpoint: endpoints['basicDatabase']!,
      methodConnectors: {
        'storeTypes': MethodConnector(
          name: 'storeTypes',
          params: {
            'types': ParameterDescription(
                name: 'types', type: Types, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).storeTypes(
              session,
              params['types'],
            );
          },
        ),
        'getTypes': MethodConnector(
          name: 'getTypes',
          params: {
            'id': ParameterDescription(name: 'id', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).getTypes(
              session,
              params['id'],
            );
          },
        ),
        'getTypesRawQuery': MethodConnector(
          name: 'getTypesRawQuery',
          params: {
            'id': ParameterDescription(name: 'id', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .getTypesRawQuery(
              session,
              params['id'],
            );
          },
        ),
        'countTypesRows': MethodConnector(
          name: 'countTypesRows',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).countTypesRows(
              session,
            );
          },
        ),
        'deleteAllInTypes': MethodConnector(
          name: 'deleteAllInTypes',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .deleteAllInTypes(
              session,
            );
          },
        ),
        'createSimpleTestData': MethodConnector(
          name: 'createSimpleTestData',
          params: {
            'numRows': ParameterDescription(
                name: 'numRows', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .createSimpleTestData(
              session,
              params['numRows'],
            );
          },
        ),
        'countSimpleData': MethodConnector(
          name: 'countSimpleData',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .countSimpleData(
              session,
            );
          },
        ),
        'deleteAllSimpleTestData': MethodConnector(
          name: 'deleteAllSimpleTestData',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .deleteAllSimpleTestData(
              session,
            );
          },
        ),
        'deleteSimpleTestDataLessThan': MethodConnector(
          name: 'deleteSimpleTestDataLessThan',
          params: {
            'num':
                ParameterDescription(name: 'num', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .deleteSimpleTestDataLessThan(
              session,
              params['num'],
            );
          },
        ),
        'findAndDeleteSimpleTestData': MethodConnector(
          name: 'findAndDeleteSimpleTestData',
          params: {
            'num':
                ParameterDescription(name: 'num', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .findAndDeleteSimpleTestData(
              session,
              params['num'],
            );
          },
        ),
        'findSimpleDataRowsLessThan': MethodConnector(
          name: 'findSimpleDataRowsLessThan',
          params: {
            'num':
                ParameterDescription(name: 'num', type: int, nullable: false),
            'offset': ParameterDescription(
                name: 'offset', type: int, nullable: false),
            'limit':
                ParameterDescription(name: 'limit', type: int, nullable: false),
            'descending': ParameterDescription(
                name: 'descending', type: bool, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .findSimpleDataRowsLessThan(
              session,
              params['num'],
              params['offset'],
              params['limit'],
              params['descending'],
            );
          },
        ),
        'updateSimpleDataRow': MethodConnector(
          name: 'updateSimpleDataRow',
          params: {
            'num':
                ParameterDescription(name: 'num', type: int, nullable: false),
            'newNum': ParameterDescription(
                name: 'newNum', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .updateSimpleDataRow(
              session,
              params['num'],
              params['newNum'],
            );
          },
        ),
        'storeObjectWithObject': MethodConnector(
          name: 'storeObjectWithObject',
          params: {
            'object': ParameterDescription(
                name: 'object', type: ObjectWithObject, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .storeObjectWithObject(
              session,
              params['object'],
            );
          },
        ),
        'getObjectWithObject': MethodConnector(
          name: 'getObjectWithObject',
          params: {
            'id': ParameterDescription(name: 'id', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .getObjectWithObject(
              session,
              params['id'],
            );
          },
        ),
      },
    );

    connectors['transactionsDatabase'] = EndpointConnector(
      name: 'transactionsDatabase',
      endpoint: endpoints['transactionsDatabase']!,
      methodConnectors: {
        'removeRow': MethodConnector(
          name: 'removeRow',
          params: {
            'num':
                ParameterDescription(name: 'num', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['transactionsDatabase']
                    as TransactionsDatabaseEndpoint)
                .removeRow(
              session,
              params['num'],
            );
          },
        ),
        'updateInsertDelete': MethodConnector(
          name: 'updateInsertDelete',
          params: {
            'numUpdate': ParameterDescription(
                name: 'numUpdate', type: int, nullable: false),
            'numInsert': ParameterDescription(
                name: 'numInsert', type: int, nullable: false),
            'numDelete': ParameterDescription(
                name: 'numDelete', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['transactionsDatabase']
                    as TransactionsDatabaseEndpoint)
                .updateInsertDelete(
              session,
              params['numUpdate'],
              params['numInsert'],
              params['numDelete'],
            );
          },
        ),
      },
    );

    connectors['failedCalls'] = EndpointConnector(
      name: 'failedCalls',
      endpoint: endpoints['failedCalls']!,
      methodConnectors: {
        'failedCall': MethodConnector(
          name: 'failedCall',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['failedCalls'] as FailedCallsEndpoint).failedCall(
              session,
            );
          },
        ),
        'failedDatabaseQuery': MethodConnector(
          name: 'failedDatabaseQuery',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['failedCalls'] as FailedCallsEndpoint)
                .failedDatabaseQuery(
              session,
            );
          },
        ),
        'failedDatabaseQueryCaughtException': MethodConnector(
          name: 'failedDatabaseQueryCaughtException',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['failedCalls'] as FailedCallsEndpoint)
                .failedDatabaseQueryCaughtException(
              session,
            );
          },
        ),
        'slowCall': MethodConnector(
          name: 'slowCall',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['failedCalls'] as FailedCallsEndpoint).slowCall(
              session,
            );
          },
        ),
        'caughtException': MethodConnector(
          name: 'caughtException',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['failedCalls'] as FailedCallsEndpoint)
                .caughtException(
              session,
            );
          },
        ),
      },
    );

    connectors['fieldScopes'] = EndpointConnector(
      name: 'fieldScopes',
      endpoint: endpoints['fieldScopes']!,
      methodConnectors: {
        'storeObject': MethodConnector(
          name: 'storeObject',
          params: {
            'object': ParameterDescription(
                name: 'object', type: ObjectFieldScopes, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['fieldScopes'] as FieldScopesEndpoint)
                .storeObject(
              session,
              params['object'],
            );
          },
        ),
        'retrieveObject': MethodConnector(
          name: 'retrieveObject',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['fieldScopes'] as FieldScopesEndpoint)
                .retrieveObject(
              session,
            );
          },
        ),
      },
    );

    connectors['futureCalls'] = EndpointConnector(
      name: 'futureCalls',
      endpoint: endpoints['futureCalls']!,
      methodConnectors: {
        'makeFutureCall': MethodConnector(
          name: 'makeFutureCall',
          params: {
            'data': ParameterDescription(
                name: 'data', type: SimpleData, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['futureCalls'] as FutureCallsEndpoint)
                .makeFutureCall(
              session,
              params['data'],
            );
          },
        ),
      },
    );

    connectors['listParameters'] = EndpointConnector(
      name: 'listParameters',
      endpoint: endpoints['listParameters']!,
      methodConnectors: {
        'returnIntList': MethodConnector(
          name: 'returnIntList',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<int>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnIntList(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnIntListNullable': MethodConnector(
          name: 'returnIntListNullable',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<int>, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnIntListNullable(
              session,
              (params['list'] as List?)?.cast(),
            );
          },
        ),
        'returnIntListNullableInts': MethodConnector(
          name: 'returnIntListNullableInts',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<int?>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnIntListNullableInts(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnNullableIntListNullableInts': MethodConnector(
          name: 'returnNullableIntListNullableInts',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<int?>, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnNullableIntListNullableInts(
              session,
              (params['list'] as List?)?.cast(),
            );
          },
        ),
        'returnDoubleList': MethodConnector(
          name: 'returnDoubleList',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<double>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnDoubleList(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnDoubleListNullableDoubles': MethodConnector(
          name: 'returnDoubleListNullableDoubles',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<double?>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnDoubleListNullableDoubles(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnBoolList': MethodConnector(
          name: 'returnBoolList',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<bool>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnBoolList(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnBoolListNullableBools': MethodConnector(
          name: 'returnBoolListNullableBools',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<bool?>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnBoolListNullableBools(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnStringList': MethodConnector(
          name: 'returnStringList',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<String>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnStringList(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnStringListNullableStrings': MethodConnector(
          name: 'returnStringListNullableStrings',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<String?>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnStringListNullableStrings(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnDateTimeList': MethodConnector(
          name: 'returnDateTimeList',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<DateTime>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnDateTimeList(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnDateTimeListNullableDateTimes': MethodConnector(
          name: 'returnDateTimeListNullableDateTimes',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<DateTime?>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnDateTimeListNullableDateTimes(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnByteDataList': MethodConnector(
          name: 'returnByteDataList',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<typed_data.ByteData>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnByteDataList(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnByteDataListNullableByteDatas': MethodConnector(
          name: 'returnByteDataListNullableByteDatas',
          params: {
            'list': ParameterDescription(
                name: 'list',
                type: List<typed_data.ByteData?>,
                nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnByteDataListNullableByteDatas(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnSimpleDataList': MethodConnector(
          name: 'returnSimpleDataList',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<SimpleData>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnSimpleDataList(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnSimpleDataListNullableSimpleData': MethodConnector(
          name: 'returnSimpleDataListNullableSimpleData',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<SimpleData?>, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnSimpleDataListNullableSimpleData(
              session,
              (params['list'] as List).cast(),
            );
          },
        ),
        'returnSimpleDataListNullable': MethodConnector(
          name: 'returnSimpleDataListNullable',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<SimpleData>, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnSimpleDataListNullable(
              session,
              (params['list'] as List?)?.cast(),
            );
          },
        ),
        'returnNullableSimpleDataListNullableSimpleData': MethodConnector(
          name: 'returnNullableSimpleDataListNullableSimpleData',
          params: {
            'list': ParameterDescription(
                name: 'list', type: List<SimpleData?>, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['listParameters'] as ListParametersEndpoint)
                .returnNullableSimpleDataListNullableSimpleData(
              session,
              (params['list'] as List?)?.cast(),
            );
          },
        ),
      },
    );

    connectors['logging'] = EndpointConnector(
      name: 'logging',
      endpoint: endpoints['logging']!,
      methodConnectors: {
        'logInfo': MethodConnector(
          name: 'logInfo',
          params: {
            'message': ParameterDescription(
                name: 'message', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['logging'] as LoggingEndpoint).logInfo(
              session,
              params['message'],
            );
          },
        ),
        'logDebugAndInfoAndError': MethodConnector(
          name: 'logDebugAndInfoAndError',
          params: {
            'debug': ParameterDescription(
                name: 'debug', type: String, nullable: false),
            'info': ParameterDescription(
                name: 'info', type: String, nullable: false),
            'error': ParameterDescription(
                name: 'error', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['logging'] as LoggingEndpoint)
                .logDebugAndInfoAndError(
              session,
              params['debug'],
              params['info'],
              params['error'],
            );
          },
        ),
        'twoQueries': MethodConnector(
          name: 'twoQueries',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['logging'] as LoggingEndpoint).twoQueries(
              session,
            );
          },
        ),
      },
    );

    connectors['loggingDisabled'] = EndpointConnector(
      name: 'loggingDisabled',
      endpoint: endpoints['loggingDisabled']!,
      methodConnectors: {
        'logInfo': MethodConnector(
          name: 'logInfo',
          params: {
            'message': ParameterDescription(
                name: 'message', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['loggingDisabled'] as LoggingDisabledEndpoint)
                .logInfo(
              session,
              params['message'],
            );
          },
        ),
      },
    );

    connectors['moduleSerialization'] = EndpointConnector(
      name: 'moduleSerialization',
      endpoint: endpoints['moduleSerialization']!,
      methodConnectors: {
        'serializeModuleObject': MethodConnector(
          name: 'serializeModuleObject',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['moduleSerialization']
                    as ModuleSerializationEndpoint)
                .serializeModuleObject(
              session,
            );
          },
        ),
        'modifyModuleObject': MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': ParameterDescription(
                name: 'object',
                type: serverpod_test_module.ModuleClass,
                nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['moduleSerialization']
                    as ModuleSerializationEndpoint)
                .modifyModuleObject(
              session,
              params['object'],
            );
          },
        ),
      },
    );

    connectors['namedParameters'] = EndpointConnector(
      name: 'namedParameters',
      endpoint: endpoints['namedParameters']!,
      methodConnectors: {
        'namedParametersMethod': MethodConnector(
          name: 'namedParametersMethod',
          params: {
            'namedInt': ParameterDescription(
                name: 'namedInt', type: int, nullable: false),
            'intWithDefaultValue': ParameterDescription(
                name: 'intWithDefaultValue', type: int, nullable: false),
            'nullableInt': ParameterDescription(
                name: 'nullableInt', type: int, nullable: true),
            'nullableIntWithDefaultValue': ParameterDescription(
                name: 'nullableIntWithDefaultValue', type: int, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['namedParameters'] as NamedParametersEndpoint)
                .namedParametersMethod(
              session,
              namedInt: params['namedInt'],
              intWithDefaultValue: params['intWithDefaultValue'],
              nullableInt: params['nullableInt'],
              nullableIntWithDefaultValue:
                  params['nullableIntWithDefaultValue'],
            );
          },
        ),
        'namedParametersMethodEqualInts': MethodConnector(
          name: 'namedParametersMethodEqualInts',
          params: {
            'namedInt': ParameterDescription(
                name: 'namedInt', type: int, nullable: false),
            'nullableInt': ParameterDescription(
                name: 'nullableInt', type: int, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['namedParameters'] as NamedParametersEndpoint)
                .namedParametersMethodEqualInts(
              session,
              namedInt: params['namedInt'],
              nullableInt: params['nullableInt'],
            );
          },
        ),
      },
    );

    connectors['optionalParameters'] = EndpointConnector(
      name: 'optionalParameters',
      endpoint: endpoints['optionalParameters']!,
      methodConnectors: {
        'returnOptionalInt': MethodConnector(
          name: 'returnOptionalInt',
          params: {
            'optionalInt': ParameterDescription(
                name: 'optionalInt', type: int, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['optionalParameters']
                    as OptionalParametersEndpoint)
                .returnOptionalInt(
              session,
              params['optionalInt'],
            );
          },
        ),
      },
    );

    connectors['redis'] = EndpointConnector(
      name: 'redis',
      endpoint: endpoints['redis']!,
      methodConnectors: {
        'setSimpleData': MethodConnector(
          name: 'setSimpleData',
          params: {
            'key': ParameterDescription(
                name: 'key', type: String, nullable: false),
            'data': ParameterDescription(
                name: 'data', type: SimpleData, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint).setSimpleData(
              session,
              params['key'],
              params['data'],
            );
          },
        ),
        'setSimpleDataWithLifetime': MethodConnector(
          name: 'setSimpleDataWithLifetime',
          params: {
            'key': ParameterDescription(
                name: 'key', type: String, nullable: false),
            'data': ParameterDescription(
                name: 'data', type: SimpleData, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint)
                .setSimpleDataWithLifetime(
              session,
              params['key'],
              params['data'],
            );
          },
        ),
        'getSimpleData': MethodConnector(
          name: 'getSimpleData',
          params: {
            'key': ParameterDescription(
                name: 'key', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint).getSimpleData(
              session,
              params['key'],
            );
          },
        ),
        'deleteSimpleData': MethodConnector(
          name: 'deleteSimpleData',
          params: {
            'key': ParameterDescription(
                name: 'key', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint).deleteSimpleData(
              session,
              params['key'],
            );
          },
        ),
        'resetMessageCentralTest': MethodConnector(
          name: 'resetMessageCentralTest',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint)
                .resetMessageCentralTest(
              session,
            );
          },
        ),
        'listenToChannel': MethodConnector(
          name: 'listenToChannel',
          params: {
            'channel': ParameterDescription(
                name: 'channel', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint).listenToChannel(
              session,
              params['channel'],
            );
          },
        ),
        'postToChannel': MethodConnector(
          name: 'postToChannel',
          params: {
            'channel': ParameterDescription(
                name: 'channel', type: String, nullable: false),
            'data': ParameterDescription(
                name: 'data', type: SimpleData, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint).postToChannel(
              session,
              params['channel'],
              params['data'],
            );
          },
        ),
        'countSubscribedChannels': MethodConnector(
          name: 'countSubscribedChannels',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint)
                .countSubscribedChannels(
              session,
            );
          },
        ),
      },
    );

    connectors['signInRequired'] = EndpointConnector(
      name: 'signInRequired',
      endpoint: endpoints['signInRequired']!,
      methodConnectors: {
        'testMethod': MethodConnector(
          name: 'testMethod',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['signInRequired'] as SignInRequiredEndpoint)
                .testMethod(
              session,
            );
          },
        ),
      },
    );

    connectors['simple'] = EndpointConnector(
      name: 'simple',
      endpoint: endpoints['simple']!,
      methodConnectors: {
        'setGlobalInt': MethodConnector(
          name: 'setGlobalInt',
          params: {
            'value':
                ParameterDescription(name: 'value', type: int, nullable: true),
            'secondValue': ParameterDescription(
                name: 'secondValue', type: int, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['simple'] as SimpleEndpoint).setGlobalInt(
              session,
              params['value'],
              params['secondValue'],
            );
          },
        ),
        'addToGlobalInt': MethodConnector(
          name: 'addToGlobalInt',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['simple'] as SimpleEndpoint).addToGlobalInt(
              session,
            );
          },
        ),
        'getGlobalInt': MethodConnector(
          name: 'getGlobalInt',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['simple'] as SimpleEndpoint).getGlobalInt(
              session,
            );
          },
        ),
      },
    );

    connectors['streaming'] = EndpointConnector(
      name: 'streaming',
      endpoint: endpoints['streaming']!,
      methodConnectors: {},
    );

    connectors['streamingLogging'] = EndpointConnector(
      name: 'streamingLogging',
      endpoint: endpoints['streamingLogging']!,
      methodConnectors: {},
    );

    modules['serverpod_test_module'] = serverpod_test_module.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = serverpod_auth.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  void registerModules(Serverpod pod) {
    pod.registerModule(serverpod_test_module.Protocol(), 'module');
    pod.registerModule(serverpod_auth.Protocol(), 'auth');
  }
}
