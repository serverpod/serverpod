/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/insights.dart' as _i2;
import 'package:serverpod/src/generated/runtime_settings.dart' as _i3;
import 'package:serverpod/src/generated/session_log_filter.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'insights': _i2.InsightsEndpoint()
        ..initialize(
          server,
          'insights',
          null,
        )
    };
    connectors['insights'] = _i1.EndpointConnector(
      name: 'insights',
      endpoint: endpoints['insights']!,
      methodConnectors: {
        'getRuntimeSettings': _i1.MethodConnector(
          name: 'getRuntimeSettings',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint)
                  .getRuntimeSettings(session),
        ),
        'setRuntimeSettings': _i1.MethodConnector(
          name: 'setRuntimeSettings',
          params: {
            'runtimeSettings': _i1.ParameterDescription(
              name: 'runtimeSettings',
              type: _i1.getType<_i3.RuntimeSettings>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint)
                  .setRuntimeSettings(
            session,
            params['runtimeSettings'],
          ),
        ),
        'clearAllLogs': _i1.MethodConnector(
          name: 'clearAllLogs',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint)
                  .clearAllLogs(session),
        ),
        'getSessionLog': _i1.MethodConnector(
          name: 'getSessionLog',
          params: {
            'numEntries': _i1.ParameterDescription(
              name: 'numEntries',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'filter': _i1.ParameterDescription(
              name: 'filter',
              type: _i1.getType<_i4.SessionLogFilter?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint).getSessionLog(
            session,
            params['numEntries'],
            params['filter'],
          ),
        ),
        'getOpenSessionLog': _i1.MethodConnector(
          name: 'getOpenSessionLog',
          params: {
            'numEntries': _i1.ParameterDescription(
              name: 'numEntries',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'filter': _i1.ParameterDescription(
              name: 'filter',
              type: _i1.getType<_i4.SessionLogFilter?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint).getOpenSessionLog(
            session,
            params['numEntries'],
            params['filter'],
          ),
        ),
        'getCachesInfo': _i1.MethodConnector(
          name: 'getCachesInfo',
          params: {
            'fetchKeys': _i1.ParameterDescription(
              name: 'fetchKeys',
              type: _i1.getType<bool>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint).getCachesInfo(
            session,
            params['fetchKeys'],
          ),
        ),
        'shutdown': _i1.MethodConnector(
          name: 'shutdown',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint).shutdown(session),
        ),
        'checkHealth': _i1.MethodConnector(
          name: 'checkHealth',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint)
                  .checkHealth(session),
        ),
        'getHealthData': _i1.MethodConnector(
          name: 'getHealthData',
          params: {
            'start': _i1.ParameterDescription(
              name: 'start',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'end': _i1.ParameterDescription(
              name: 'end',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint).getHealthData(
            session,
            params['start'],
            params['end'],
          ),
        ),
        'hotReload': _i1.MethodConnector(
          name: 'hotReload',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['insights'] as _i2.InsightsEndpoint)
                  .hotReload(session),
        ),
      },
    );
  }

  @override
  void registerModules(_i1.Serverpod pod) {}
}
