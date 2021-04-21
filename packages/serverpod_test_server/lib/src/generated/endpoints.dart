/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

// ignore: unused_import
import 'protocol.dart';

import '../endpoints/database_basic.dart';
import '../endpoints/basic_types.dart';
import '../endpoints/failed_calls.dart';
import '../endpoints/future_calls.dart';
import '../endpoints/simple.dart';
import '../endpoints/logging.dart';
import '../endpoints/async_tasks.dart';
import '../endpoints/database_transactions.dart';
import '../endpoints/logging_disabled.dart';

class Endpoints extends EndpointDispatch {
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = {
      'basicDatabase': BasicDatabase()..initialize(server, 'basicDatabase'),
      'basicTypes': BasicTypesEndpoint()..initialize(server, 'basicTypes'),
      'failedCalls': FailedCallsEndpoint()..initialize(server, 'failedCalls'),
      'futureCalls': FutureCallsEndpoint()..initialize(server, 'futureCalls'),
      'simple': SimpleEndpoint()..initialize(server, 'simple'),
      'logging': LoggingEndpoint()..initialize(server, 'logging'),
      'asyncTasks': AsyncTasksEndpoint()..initialize(server, 'asyncTasks'),
      'transactionsDatabase': TransactionsDatabaseEndpoint()..initialize(server, 'transactionsDatabase'),
      'loggingDisabled': LoggingDisabledEndpoint()..initialize(server, 'loggingDisabled'),
    };

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
  }
}

