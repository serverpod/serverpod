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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/runtime_settings.dart' as _inixclsf;
import 'package:serverpod/src/generated/session_log_filter.dart' as _i23rl7tl;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import '../endpoints/insights.dart' as _iodc3uo0;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'insights': _iodc3uo0.InsightsEndpoint()
        ..initialize(
          server,
          'insights',
          null,
        ),
    };
    connectors['insights'] = _is.EndpointConnector(
      name: 'insights',
      endpoint: endpoints['insights']!,
      methodConnectors: {
        'getRuntimeSettings': _is.MethodConnector(
          name: 'getRuntimeSettings',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getRuntimeSettings(session),
        ),
        'setRuntimeSettings': _is.MethodConnector(
          name: 'setRuntimeSettings',
          params: {
            'runtimeSettings': _is.ParameterDescription(
              name: 'runtimeSettings',
              type: _is.getType<_inixclsf.RuntimeSettings>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .setRuntimeSettings(
                    session,
                    params['runtimeSettings'],
                  ),
        ),
        'clearAllLogs': _is.MethodConnector(
          name: 'clearAllLogs',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .clearAllLogs(session),
        ),
        'getSessionLog': _is.MethodConnector(
          name: 'getSessionLog',
          params: {
            'numEntries': _is.ParameterDescription(
              name: 'numEntries',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_i23rl7tl.SessionLogFilter?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getSessionLog(
                    session,
                    params['numEntries'],
                    params['filter'],
                  ),
        ),
        'getOpenSessionLog': _is.MethodConnector(
          name: 'getOpenSessionLog',
          params: {
            'numEntries': _is.ParameterDescription(
              name: 'numEntries',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_i23rl7tl.SessionLogFilter?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getOpenSessionLog(
                    session,
                    params['numEntries'],
                    params['filter'],
                  ),
        ),
        'getCachesInfo': _is.MethodConnector(
          name: 'getCachesInfo',
          params: {
            'fetchKeys': _is.ParameterDescription(
              name: 'fetchKeys',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getCachesInfo(
                    session,
                    params['fetchKeys'],
                  ),
        ),
        'shutdown': _is.MethodConnector(
          name: 'shutdown',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .shutdown(session),
        ),
        'checkHealth': _is.MethodConnector(
          name: 'checkHealth',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .checkHealth(session),
        ),
        'getHealthData': _is.MethodConnector(
          name: 'getHealthData',
          params: {
            'start': _is.ParameterDescription(
              name: 'start',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'end': _is.ParameterDescription(
              name: 'end',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getHealthData(
                    session,
                    params['start'],
                    params['end'],
                  ),
        ),
        'hotReload': _is.MethodConnector(
          name: 'hotReload',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .hotReload(session),
        ),
        'getTargetTableDefinition': _is.MethodConnector(
          name: 'getTargetTableDefinition',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getTargetTableDefinition(session),
        ),
        'getLiveDatabaseDefinition': _is.MethodConnector(
          name: 'getLiveDatabaseDefinition',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getLiveDatabaseDefinition(session),
        ),
        'applyMigrations': _is.MethodConnector(
          name: 'applyMigrations',
          params: {
            'applyRepairMigration': _is.ParameterDescription(
              name: 'applyRepairMigration',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'applyMigrations': _is.ParameterDescription(
              name: 'applyMigrations',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .applyMigrations(
                    session,
                    applyRepairMigration: params['applyRepairMigration'],
                    applyMigrations: params['applyMigrations'],
                  ),
        ),
        'getDatabaseDefinitions': _is.MethodConnector(
          name: 'getDatabaseDefinitions',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getDatabaseDefinitions(session),
        ),
        'fetchDatabaseBulkData': _is.MethodConnector(
          name: 'fetchDatabaseBulkData',
          params: {
            'table': _is.ParameterDescription(
              name: 'table',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'startingId': _is.ParameterDescription(
              name: 'startingId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_isd.Filter?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .fetchDatabaseBulkData(
                    session,
                    table: params['table'],
                    startingId: params['startingId'],
                    limit: params['limit'],
                    filter: params['filter'],
                  ),
        ),
        'runQueries': _is.MethodConnector(
          name: 'runQueries',
          params: {
            'queries': _is.ParameterDescription(
              name: 'queries',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .runQueries(
                    session,
                    params['queries'],
                  ),
        ),
        'getDatabaseRowCount': _is.MethodConnector(
          name: 'getDatabaseRowCount',
          params: {
            'table': _is.ParameterDescription(
              name: 'table',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .getDatabaseRowCount(
                    session,
                    table: params['table'],
                  ),
        ),
        'executeSql': _is.MethodConnector(
          name: 'executeSql',
          params: {
            'sql': _is.ParameterDescription(
              name: 'sql',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .executeSql(
                    session,
                    params['sql'],
                  ),
        ),
        'fetchFile': _is.MethodConnector(
          name: 'fetchFile',
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
              ) async => (endpoints['insights'] as _iodc3uo0.InsightsEndpoint)
                  .fetchFile(
                    session,
                    params['path'],
                  ),
        ),
      },
    );
  }
}
