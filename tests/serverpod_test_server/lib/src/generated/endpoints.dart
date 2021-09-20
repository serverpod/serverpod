/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:typed_data' as typed_data;
import 'package:serverpod/serverpod.dart';

import 'package:serverpod_test_module_server/module.dart' as serverpod_test_module;
import 'package:serverpod_auth_server/module.dart' as serverpod_auth;

import 'protocol.dart';

import '../endpoints/streaming.dart';
import '../endpoints/cloud_storage.dart';
import '../endpoints/database_basic.dart';
import '../endpoints/basic_types.dart';
import '../endpoints/authentication.dart';
import '../endpoints/failed_calls.dart';
import '../endpoints/module_serialization.dart';
import '../endpoints/future_calls.dart';
import '../endpoints/simple.dart';
import '../endpoints/logging.dart';
import '../endpoints/async_tasks.dart';
import '../endpoints/signin_required.dart';
import '../endpoints/database_transactions.dart';
import '../endpoints/logging_disabled.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'streaming': StreamingEndpoint()..initialize(server, 'streaming', null),
      'cloudStorage': CloudStorageEndpoint()..initialize(server, 'cloudStorage', null),
      'basicDatabase': BasicDatabase()..initialize(server, 'basicDatabase', null),
      'basicTypes': BasicTypesEndpoint()..initialize(server, 'basicTypes', null),
      'authentication': AuthenticationEndpoint()..initialize(server, 'authentication', null),
      'failedCalls': FailedCallsEndpoint()..initialize(server, 'failedCalls', null),
      'moduleSerialization': ModuleSerializationEndpoint()..initialize(server, 'moduleSerialization', null),
      'futureCalls': FutureCallsEndpoint()..initialize(server, 'futureCalls', null),
      'simple': SimpleEndpoint()..initialize(server, 'simple', null),
      'logging': LoggingEndpoint()..initialize(server, 'logging', null),
      'asyncTasks': AsyncTasksEndpoint()..initialize(server, 'asyncTasks', null),
      'signInRequired': SignInRequiredEndpoint()..initialize(server, 'signInRequired', null),
      'transactionsDatabase': TransactionsDatabaseEndpoint()..initialize(server, 'transactionsDatabase', null),
      'loggingDisabled': LoggingDisabledEndpoint()..initialize(server, 'loggingDisabled', null),
    };

    connectors['streaming'] = EndpointConnector(
      name: 'streaming',
      endpoint: endpoints['streaming']!,
      methodConnectors: {
      },
    );

    connectors['cloudStorage'] = EndpointConnector(
      name: 'cloudStorage',
      endpoint: endpoints['cloudStorage']!,
      methodConnectors: {
        'storePublicFile': MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': ParameterDescription(name: 'path', type: String, nullable: false),
            'byteData': ParameterDescription(name: 'byteData', type: typed_data.ByteData, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint).storePublicFile(session,params['path'],params['byteData'],);
          },
        ),
        'retrievePublicFile': MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': ParameterDescription(name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint).retrievePublicFile(session,params['path'],);
          },
        ),
        'existsPublicFile': MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': ParameterDescription(name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint).existsPublicFile(session,params['path'],);
          },
        ),
        'deletePublicFile': MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': ParameterDescription(name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint).deletePublicFile(session,params['path'],);
          },
        ),
        'getPublicUrlForFile': MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': ParameterDescription(name: 'path', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cloudStorage'] as CloudStorageEndpoint).getPublicUrlForFile(session,params['path'],);
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
            'types': ParameterDescription(name: 'types', type: Types, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).storeTypes(session,params['types'],);
          },
        ),
        'getTypes': MethodConnector(
          name: 'getTypes',
          params: {
            'id': ParameterDescription(name: 'id', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).getTypes(session,params['id'],);
          },
        ),
        'getTypesRawQuery': MethodConnector(
          name: 'getTypesRawQuery',
          params: {
            'id': ParameterDescription(name: 'id', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).getTypesRawQuery(session,params['id'],);
          },
        ),
        'countTypesRows': MethodConnector(
          name: 'countTypesRows',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).countTypesRows(session,);
          },
        ),
        'deleteAllInTypes': MethodConnector(
          name: 'deleteAllInTypes',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).deleteAllInTypes(session,);
          },
        ),
        'createSimpleTestData': MethodConnector(
          name: 'createSimpleTestData',
          params: {
            'numRows': ParameterDescription(name: 'numRows', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).createSimpleTestData(session,params['numRows'],);
          },
        ),
        'countSimpleData': MethodConnector(
          name: 'countSimpleData',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).countSimpleData(session,);
          },
        ),
        'deleteAllSimpleTestData': MethodConnector(
          name: 'deleteAllSimpleTestData',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).deleteAllSimpleTestData(session,);
          },
        ),
        'deleteSimpleTestDataLessThan': MethodConnector(
          name: 'deleteSimpleTestDataLessThan',
          params: {
            'num': ParameterDescription(name: 'num', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).deleteSimpleTestDataLessThan(session,params['num'],);
          },
        ),
        'findAndDeleteSimpleTestData': MethodConnector(
          name: 'findAndDeleteSimpleTestData',
          params: {
            'num': ParameterDescription(name: 'num', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).findAndDeleteSimpleTestData(session,params['num'],);
          },
        ),
        'findSimpleDataRowsLessThan': MethodConnector(
          name: 'findSimpleDataRowsLessThan',
          params: {
            'num': ParameterDescription(name: 'num', type: int, nullable: false),
            'offset': ParameterDescription(name: 'offset', type: int, nullable: false),
            'limit': ParameterDescription(name: 'limit', type: int, nullable: false),
            'descending': ParameterDescription(name: 'descending', type: bool, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).findSimpleDataRowsLessThan(session,params['num'],params['offset'],params['limit'],params['descending'],);
          },
        ),
        'updateSimpleDataRow': MethodConnector(
          name: 'updateSimpleDataRow',
          params: {
            'num': ParameterDescription(name: 'num', type: int, nullable: false),
            'newNum': ParameterDescription(name: 'newNum', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).updateSimpleDataRow(session,params['num'],params['newNum'],);
          },
        ),
        'storeObjectWithObject': MethodConnector(
          name: 'storeObjectWithObject',
          params: {
            'object': ParameterDescription(name: 'object', type: ObjectWithObject, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).storeObjectWithObject(session,params['object'],);
          },
        ),
        'getObjectWithObject': MethodConnector(
          name: 'getObjectWithObject',
          params: {
            'id': ParameterDescription(name: 'id', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicDatabase'] as BasicDatabase).getObjectWithObject(session,params['id'],);
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
            'value': ParameterDescription(name: 'value', type: int, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testInt(session,params['value'],);
          },
        ),
        'testDouble': MethodConnector(
          name: 'testDouble',
          params: {
            'value': ParameterDescription(name: 'value', type: double, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testDouble(session,params['value'],);
          },
        ),
        'testBool': MethodConnector(
          name: 'testBool',
          params: {
            'value': ParameterDescription(name: 'value', type: bool, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testBool(session,params['value'],);
          },
        ),
        'testDateTime': MethodConnector(
          name: 'testDateTime',
          params: {
            'dateTime': ParameterDescription(name: 'dateTime', type: DateTime, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testDateTime(session,params['dateTime'],);
          },
        ),
        'testString': MethodConnector(
          name: 'testString',
          params: {
            'value': ParameterDescription(name: 'value', type: String, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testString(session,params['value'],);
          },
        ),
        'testByteData': MethodConnector(
          name: 'testByteData',
          params: {
            'value': ParameterDescription(name: 'value', type: typed_data.ByteData, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testByteData(session,params['value'],);
          },
        ),
      },
    );

    connectors['authentication'] = EndpointConnector(
      name: 'authentication',
      endpoint: endpoints['authentication']!,
      methodConnectors: {
        'authenticate': MethodConnector(
          name: 'authenticate',
          params: {
            'email': ParameterDescription(name: 'email', type: String, nullable: false),
            'password': ParameterDescription(name: 'password', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['authentication'] as AuthenticationEndpoint).authenticate(session,params['email'],params['password'],);
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
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['failedCalls'] as FailedCallsEndpoint).failedCall(session,);
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
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['moduleSerialization'] as ModuleSerializationEndpoint).serializeModuleObject(session,);
          },
        ),
        'modifyModuleObject': MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': ParameterDescription(name: 'object', type: serverpod_test_module.ModuleClass, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['moduleSerialization'] as ModuleSerializationEndpoint).modifyModuleObject(session,params['object'],);
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
            'data': ParameterDescription(name: 'data', type: SimpleData, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['futureCalls'] as FutureCallsEndpoint).makeFutureCall(session,params['data'],);
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
            'value': ParameterDescription(name: 'value', type: int, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['simple'] as SimpleEndpoint).setGlobalInt(session,params['value'],params['secondValue'],);
          },
        ),
        'addToGlobalInt': MethodConnector(
          name: 'addToGlobalInt',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['simple'] as SimpleEndpoint).addToGlobalInt(session,);
          },
        ),
        'getGlobalInt': MethodConnector(
          name: 'getGlobalInt',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['simple'] as SimpleEndpoint).getGlobalInt(session,);
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
            'message': ParameterDescription(name: 'message', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['logging'] as LoggingEndpoint).logInfo(session,params['message'],);
          },
        ),
        'logDebugAndInfoAndError': MethodConnector(
          name: 'logDebugAndInfoAndError',
          params: {
            'debug': ParameterDescription(name: 'debug', type: String, nullable: false),
            'info': ParameterDescription(name: 'info', type: String, nullable: false),
            'error': ParameterDescription(name: 'error', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['logging'] as LoggingEndpoint).logDebugAndInfoAndError(session,params['debug'],params['info'],params['error'],);
          },
        ),
        'twoQueries': MethodConnector(
          name: 'twoQueries',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['logging'] as LoggingEndpoint).twoQueries(session,);
          },
        ),
      },
    );

    connectors['asyncTasks'] = EndpointConnector(
      name: 'asyncTasks',
      endpoint: endpoints['asyncTasks']!,
      methodConnectors: {
        'insertRowToSimpleDataAfterDelay': MethodConnector(
          name: 'insertRowToSimpleDataAfterDelay',
          params: {
            'num': ParameterDescription(name: 'num', type: int, nullable: false),
            'seconds': ParameterDescription(name: 'seconds', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['asyncTasks'] as AsyncTasksEndpoint).insertRowToSimpleDataAfterDelay(session,params['num'],params['seconds'],);
          },
        ),
        'throwExceptionAfterDelay': MethodConnector(
          name: 'throwExceptionAfterDelay',
          params: {
            'seconds': ParameterDescription(name: 'seconds', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['asyncTasks'] as AsyncTasksEndpoint).throwExceptionAfterDelay(session,params['seconds'],);
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
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['signInRequired'] as SignInRequiredEndpoint).testMethod(session,);
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
            'num': ParameterDescription(name: 'num', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['transactionsDatabase'] as TransactionsDatabaseEndpoint).removeRow(session,params['num'],);
          },
        ),
        'updateInsertDelete': MethodConnector(
          name: 'updateInsertDelete',
          params: {
            'numUpdate': ParameterDescription(name: 'numUpdate', type: int, nullable: false),
            'numInsert': ParameterDescription(name: 'numInsert', type: int, nullable: false),
            'numDelete': ParameterDescription(name: 'numDelete', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['transactionsDatabase'] as TransactionsDatabaseEndpoint).updateInsertDelete(session,params['numUpdate'],params['numInsert'],params['numDelete'],);
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
            'message': ParameterDescription(name: 'message', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['loggingDisabled'] as LoggingDisabledEndpoint).logInfo(session,params['message'],);
          },
        ),
      },
    );

    modules['serverpod_test_module'] = serverpod_test_module.Endpoints()..initializeEndpoints(server);
    modules['serverpod_auth'] = serverpod_auth.Endpoints()..initializeEndpoints(server);
  }

  @override
  void registerModules(Serverpod pod) {
    pod.registerModule(serverpod_test_module.Protocol(), 'module');
    pod.registerModule(serverpod_auth.Protocol(), 'auth');
  }
}

