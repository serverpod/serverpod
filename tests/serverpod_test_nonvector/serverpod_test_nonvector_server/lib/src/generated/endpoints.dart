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
import '../endpoints/insights_database.dart' as _i2;
import '../greeting_endpoint.dart' as _i3;
import 'package:serverpod/protocol.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'insightsDatabaseTest': _i2.InsightsDatabaseTestEndpoint()
        ..initialize(
          server,
          'insightsDatabaseTest',
          null,
        ),
      'greeting': _i3.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['insightsDatabaseTest'] = _i1.EndpointConnector(
      name: 'insightsDatabaseTest',
      endpoint: endpoints['insightsDatabaseTest']!,
      methodConnectors: {
        'executeSql': _i1.MethodConnector(
          name: 'executeSql',
          params: {
            'sql': _i1.ParameterDescription(
              name: 'sql',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insightsDatabaseTest']
                          as _i2.InsightsDatabaseTestEndpoint)
                      .executeSql(
                        session,
                        params['sql'],
                      ),
        ),
        'fetchDatabaseBulkData': _i1.MethodConnector(
          name: 'fetchDatabaseBulkData',
          params: {
            'table': _i1.ParameterDescription(
              name: 'table',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'startingId': _i1.ParameterDescription(
              name: 'startingId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'filter': _i1.ParameterDescription(
              name: 'filter',
              type: _i1.getType<_i4.Filter?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insightsDatabaseTest']
                          as _i2.InsightsDatabaseTestEndpoint)
                      .fetchDatabaseBulkData(
                        session,
                        table: params['table'],
                        startingId: params['startingId'],
                        limit: params['limit'],
                        filter: params['filter'],
                      ),
        ),
        'runQueries': _i1.MethodConnector(
          name: 'runQueries',
          params: {
            'queries': _i1.ParameterDescription(
              name: 'queries',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insightsDatabaseTest']
                          as _i2.InsightsDatabaseTestEndpoint)
                      .runQueries(
                        session,
                        params['queries'],
                      ),
        ),
        'getDatabaseRowCount': _i1.MethodConnector(
          name: 'getDatabaseRowCount',
          params: {
            'table': _i1.ParameterDescription(
              name: 'table',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insightsDatabaseTest']
                          as _i2.InsightsDatabaseTestEndpoint)
                      .getDatabaseRowCount(
                        session,
                        table: params['table'],
                      ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
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
              ) async => (endpoints['greeting'] as _i3.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
  }
}
