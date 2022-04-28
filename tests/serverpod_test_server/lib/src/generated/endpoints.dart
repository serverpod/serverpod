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
import '../endpoints/future_calls.dart';
import '../endpoints/logging.dart';
import '../endpoints/logging_disabled.dart';
import '../endpoints/module_serialization.dart';
import '../endpoints/redis.dart';
import '../endpoints/signin_required.dart';
import '../endpoints/simple.dart';
import '../endpoints/streaming.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = <String, Endpoint>{
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
      'futureCalls': FutureCallsEndpoint()
        ..initialize(server, 'futureCalls', null),
      'logging': LoggingEndpoint()..initialize(server, 'logging', null),
      'loggingDisabled': LoggingDisabledEndpoint()
        ..initialize(server, 'loggingDisabled', null),
      'moduleSerialization': ModuleSerializationEndpoint()
        ..initialize(server, 'moduleSerialization', null),
      'redis': RedisEndpoint()..initialize(server, 'redis', null),
      'signInRequired': SignInRequiredEndpoint()
        ..initialize(server, 'signInRequired', null),
      'simple': SimpleEndpoint()..initialize(server, 'simple', null),
      'streaming': StreamingEndpoint()..initialize(server, 'streaming', null),
    };

    connectors['asyncTasks'] = EndpointConnector(
      name: 'asyncTasks',
      endpoint: endpoints['asyncTasks']!,
      methodConnectors: <String, MethodConnector>{
        'insertRowToSimpleDataAfterDelay': MethodConnector(
          name: 'insertRowToSimpleDataAfterDelay',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'removeAllUsers': MethodConnector(
          name: 'removeAllUsers',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['authentication'] as AuthenticationEndpoint)
                .removeAllUsers(
              session,
            );
          },
        ),
        'countUsers': MethodConnector(
          name: 'countUsers',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['authentication'] as AuthenticationEndpoint)
                .countUsers(
              session,
            );
          },
        ),
        'createUser': MethodConnector(
          name: 'createUser',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'testInt': MethodConnector(
          name: 'testInt',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'reset': MethodConnector(
          name: 'reset',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint).reset(
              session,
            );
          },
        ),
        'storePublicFile': MethodConnector(
          name: 'storePublicFile',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'storePublicFile': MethodConnector(
          name: 'storePublicFile',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'storeTypes': MethodConnector(
          name: 'storeTypes',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).countTypesRows(
              session,
            );
          },
        ),
        'deleteAllInTypes': MethodConnector(
          name: 'deleteAllInTypes',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .deleteAllInTypes(
              session,
            );
          },
        ),
        'createSimpleTestData': MethodConnector(
          name: 'createSimpleTestData',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .countSimpleData(
              session,
            );
          },
        ),
        'deleteAllSimpleTestData': MethodConnector(
          name: 'deleteAllSimpleTestData',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase)
                .deleteAllSimpleTestData(
              session,
            );
          },
        ),
        'deleteSimpleTestDataLessThan': MethodConnector(
          name: 'deleteSimpleTestDataLessThan',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'removeRow': MethodConnector(
          name: 'removeRow',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'failedCall': MethodConnector(
          name: 'failedCall',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['failedCalls'] as FailedCallsEndpoint).failedCall(
              session,
            );
          },
        ),
      },
    );

    connectors['futureCalls'] = EndpointConnector(
      name: 'futureCalls',
      endpoint: endpoints['futureCalls']!,
      methodConnectors: <String, MethodConnector>{
        'makeFutureCall': MethodConnector(
          name: 'makeFutureCall',
          params: <String, ParameterDescription>{
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

    connectors['logging'] = EndpointConnector(
      name: 'logging',
      endpoint: endpoints['logging']!,
      methodConnectors: <String, MethodConnector>{
        'logInfo': MethodConnector(
          name: 'logInfo',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{},
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
      methodConnectors: <String, MethodConnector>{
        'logInfo': MethodConnector(
          name: 'logInfo',
          params: <String, ParameterDescription>{
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
      methodConnectors: <String, MethodConnector>{
        'serializeModuleObject': MethodConnector(
          name: 'serializeModuleObject',
          params: <String, ParameterDescription>{},
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
          params: <String, ParameterDescription>{
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

    connectors['redis'] = EndpointConnector(
      name: 'redis',
      endpoint: endpoints['redis']!,
      methodConnectors: <String, MethodConnector>{
        'setSimpleData': MethodConnector(
          name: 'setSimpleData',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['redis'] as RedisEndpoint)
                .resetMessageCentralTest(
              session,
            );
          },
        ),
        'listenToChannel': MethodConnector(
          name: 'listenToChannel',
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{},
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
      methodConnectors: <String, MethodConnector>{
        'testMethod': MethodConnector(
          name: 'testMethod',
          params: <String, ParameterDescription>{},
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
      methodConnectors: <String, MethodConnector>{
        'setGlobalInt': MethodConnector(
          name: 'setGlobalInt',
          params: <String, ParameterDescription>{
            'value':
                ParameterDescription(name: 'value', type: int, nullable: true),
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
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['simple'] as SimpleEndpoint).addToGlobalInt(
              session,
            );
          },
        ),
        'getGlobalInt': MethodConnector(
          name: 'getGlobalInt',
          params: <String, ParameterDescription>{},
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
      methodConnectors: <String, MethodConnector>{
        'streamOpened': MethodConnector(
          name: 'streamOpened',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['streaming'] as StreamingEndpoint).streamOpened(
              session,
            );
          },
        ),
      },
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
