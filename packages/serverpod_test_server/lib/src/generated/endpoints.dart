/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

import 'protocol.dart';

import '../endpoints/database_basic.dart';
import '../endpoints/basic_types.dart';
import '../endpoints/simple.dart';
import '../endpoints/async_tasks.dart';
import '../endpoints/database_transactions.dart';

class Endpoints extends EndpointDispatch {
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = {
      'basicDatabase': BasicDatabase()..initialize(server, 'basicDatabase'),
      'basicTypes': BasicTypesEndpoint()..initialize(server, 'basicTypes'),
      'simple': SimpleEndpoint()..initialize(server, 'simple'),
      'asyncTasks': AsyncTasksEndpoint()..initialize(server, 'asyncTasks'),
      'transactionsDatabase': TransactionsDatabaseEndpoint()..initialize(server, 'transactionsDatabase'),
    };

    connectors['basicDatabase'] = EndpointConnector(
      name: 'basicDatabase',
      endpoint: endpoints['basicDatabase']!,
      methodConnectors: {
      },
    );

    connectors['basicTypes'] = EndpointConnector(
      name: 'basicTypes',
      endpoint: endpoints['basicTypes']!,
      methodConnectors: {
      },
    );

    connectors['simple'] = EndpointConnector(
      name: 'simple',
      endpoint: endpoints['simple']!,
      methodConnectors: {
      },
    );

    connectors['asyncTasks'] = EndpointConnector(
      name: 'asyncTasks',
      endpoint: endpoints['asyncTasks']!,
      methodConnectors: {
      },
    );

    connectors['transactionsDatabase'] = EndpointConnector(
      name: 'transactionsDatabase',
      endpoint: endpoints['transactionsDatabase']!,
      methodConnectors: {
      },
    );
  }
}

