/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

import '../endpoints/basic_types.dart';
import '../endpoints/simple.dart';

class Endpoints extends EndpointDispatch {
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = {
      'basicTypes': BasicTypesEndpoint()..initialize(server, 'basicTypes'),
      'simple': SimpleEndpoint()..initialize(server, 'simple'),
    };

    connectors['basicTypes'] = EndpointConnector(
      name: 'basicTypes',
      endpoint: endpoints['basicTypes']!,
      methodConnectors: {
        'testInt': MethodConnector(
          name: 'testInt',
          params: {
            'value': ParameterDescription(name: 'value', type: int),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testInt(session,params['value'],);
          },
        ),
        'testDouble': MethodConnector(
          name: 'testDouble',
          params: {
            'value': ParameterDescription(name: 'value', type: double),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testDouble(session,params['value'],);
          },
        ),
        'testString': MethodConnector(
          name: 'testString',
          params: {
            'value': ParameterDescription(name: 'value', type: String),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['basicTypes'] as BasicTypesEndpoint).testString(session,params['value'],);
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
            'value': ParameterDescription(name: 'value', type: int),
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
  }
}

