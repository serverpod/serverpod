/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

// ignore: unused_import
import 'protocol.dart';

import '../endpoints/bundle_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'bundle': BundleEndpoint()..initialize(server, 'bundle'),
    };

    connectors['bundle'] = EndpointConnector(
      name: 'bundle',
      endpoint: endpoints['bundle']!,
      methodConnectors: {
        'hello': MethodConnector(
          name: 'hello',
          params: {
            'name': ParameterDescription(name: 'name', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['bundle'] as BundleEndpoint).hello(session,params['name'],);
          },
        ),
        'modifyBundleObject': MethodConnector(
          name: 'modifyBundleObject',
          params: {
            'object': ParameterDescription(name: 'object', type: BundleClass, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['bundle'] as BundleEndpoint).modifyBundleObject(session,params['object'],);
          },
        ),
      },
    );
  }
}

