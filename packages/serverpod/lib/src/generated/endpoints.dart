/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: unused_import

import 'dart:typed_data' as typed_data;
import '../../serverpod.dart';

import 'protocol.dart';

import '../endpoints/cache.dart';
import '../endpoints/insights.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = <String, Endpoint>{
      'insights': InsightsEndpoint()..initialize(server, 'insights', null),
    };

    connectors['insights'] = EndpointConnector(
      name: 'insights',
      endpoint: endpoints['insights']!,
      methodConnectors: <String, MethodConnector>{
        'getRuntimeSettings': MethodConnector(
          name: 'getRuntimeSettings',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint)
                .getRuntimeSettings(
              session,
            );
          },
        ),
        'setRuntimeSettings': MethodConnector(
          name: 'setRuntimeSettings',
          params: <String, ParameterDescription>{
            'runtimeSettings': ParameterDescription(
                name: 'runtimeSettings',
                type: RuntimeSettings,
                nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint)
                .setRuntimeSettings(
              session,
              params['runtimeSettings'],
            );
          },
        ),
        'reloadRuntimeSettings': MethodConnector(
          name: 'reloadRuntimeSettings',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint)
                .reloadRuntimeSettings(
              session,
            );
          },
        ),
        'clearAllLogs': MethodConnector(
          name: 'clearAllLogs',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).clearAllLogs(
              session,
            );
          },
        ),
        'getSessionLog': MethodConnector(
          name: 'getSessionLog',
          params: <String, ParameterDescription>{
            'numEntries': ParameterDescription(
                name: 'numEntries', type: int, nullable: true),
            'filter': ParameterDescription(
                name: 'filter', type: SessionLogFilter, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).getSessionLog(
              session,
              params['numEntries'],
              params['filter'],
            );
          },
        ),
        'getOpenSessionLog': MethodConnector(
          name: 'getOpenSessionLog',
          params: <String, ParameterDescription>{
            'numEntries': ParameterDescription(
                name: 'numEntries', type: int, nullable: true),
            'filter': ParameterDescription(
                name: 'filter', type: SessionLogFilter, nullable: true),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint)
                .getOpenSessionLog(
              session,
              params['numEntries'],
              params['filter'],
            );
          },
        ),
        'getCachesInfo': MethodConnector(
          name: 'getCachesInfo',
          params: <String, ParameterDescription>{
            'fetchKeys': ParameterDescription(
                name: 'fetchKeys', type: bool, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).getCachesInfo(
              session,
              params['fetchKeys'],
            );
          },
        ),
        'shutdown': MethodConnector(
          name: 'shutdown',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).shutdown(
              session,
            );
          },
        ),
        'checkHealth': MethodConnector(
          name: 'checkHealth',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).checkHealth(
              session,
            );
          },
        ),
        'hotReload': MethodConnector(
          name: 'hotReload',
          params: <String, ParameterDescription>{},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).hotReload(
              session,
            );
          },
        ),
      },
    );
  }

  @override
  void registerModules(Serverpod pod) {}
}
