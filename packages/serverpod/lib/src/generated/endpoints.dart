/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

import '../endpoints/cache.dart';
import '../endpoints/insights.dart';

class Endpoints extends EndpointDispatch {
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = {
      'insights': InsightsEndpoint()..initialize(server, 'insights'),
    };

    connectors['insights'] = EndpointConnector(
      name: 'insights',
      endpoint: endpoints['insights'],
      methodConnectors: {
        'getLog': MethodConnector(
          name: 'getLog',
          params: {
            'numEntries': ParameterDescription(name: 'numEntries', type: int),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).getLog(session,params['numEntries'],);
          },
        ),
        'getSessionLog': MethodConnector(
          name: 'getSessionLog',
          params: {
            'numEntries': ParameterDescription(name: 'numEntries', type: int),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).getSessionLog(session,params['numEntries'],);
          },
        ),
        'getCachesInfo': MethodConnector(
          name: 'getCachesInfo',
          params: {
            'fetchKeys': ParameterDescription(name: 'fetchKeys', type: bool),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).getCachesInfo(session,params['fetchKeys'],);
          },
        ),
        'shutdown': MethodConnector(
          name: 'shutdown',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).shutdown(session,);
          },
        ),
        'checkHealth': MethodConnector(
          name: 'checkHealth',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['insights'] as InsightsEndpoint).checkHealth(session,);
          },
        ),
      },
    );
  }
}

