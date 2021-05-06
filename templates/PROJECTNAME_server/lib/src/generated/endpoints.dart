/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

// ignore: unused_import
import 'protocol.dart';

import '../endpoints/example_endpoint.dart';

class Endpoints extends EndpointDispatch {
  void initializeEndpoints(Server server) {
    Map<String, Endpoint> endpoints = {
      'example': ExampleEndpoint()..initialize(server, 'example'),
    };

    connectors['example'] = EndpointConnector(
      name: 'example',
      endpoint: endpoints['example']!,
      methodConnectors: {
        'hello': MethodConnector(
          name: 'hello',
          params: {
            'name': ParameterDescription(name: 'name', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['example'] as ExampleEndpoint).hello(session,params['name'],);
          },
        ),
      },
    );
  }
}

