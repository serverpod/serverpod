/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

import '../endpoints/cache.dart';
import '../endpoints/insights.dart';

class Endpoints extends EndpointDispatch {
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = {
      'cache': CacheEndpoint()..initialize(server, 'cache'),
      'insights': InsightsEndpoint()..initialize(server, 'insights'),
    };

    connectors['cache'] = EndpointConnector(
      name: 'cache',
      endpoint: endpoints['cache'],
      methodConnectors: {
        'put': MethodConnector(
          name: 'put',
          params: {
            'priority': ParameterDescription(name: 'priority', type: bool),
            'key': ParameterDescription(name: 'key', type: String),
            'data': ParameterDescription(name: 'data', type: String),
            'group': ParameterDescription(name: 'group', type: String),
            'expiration': ParameterDescription(name: 'expiration', type: DateTime),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cache'] as CacheEndpoint).put(session,params['priority'],params['key'],params['data'],params['group'],params['expiration'],);
          },
        ),
        'get': MethodConnector(
          name: 'get',
          params: {
            'priority': ParameterDescription(name: 'priority', type: bool),
            'key': ParameterDescription(name: 'key', type: String),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cache'] as CacheEndpoint).get(session,params['priority'],params['key'],);
          },
        ),
        'invalidateKey': MethodConnector(
          name: 'invalidateKey',
          params: {
            'priority': ParameterDescription(name: 'priority', type: bool),
            'key': ParameterDescription(name: 'key', type: String),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cache'] as CacheEndpoint).invalidateKey(session,params['priority'],params['key'],);
          },
        ),
        'invalidateGroup': MethodConnector(
          name: 'invalidateGroup',
          params: {
            'priority': ParameterDescription(name: 'priority', type: bool),
            'group': ParameterDescription(name: 'group', type: String),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cache'] as CacheEndpoint).invalidateGroup(session,params['priority'],params['group'],);
          },
        ),
        'clear': MethodConnector(
          name: 'clear',
          params: {
            'priority': ParameterDescription(name: 'priority', type: bool),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['cache'] as CacheEndpoint).clear(session,params['priority'],);
          },
        ),
      },
    );

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

