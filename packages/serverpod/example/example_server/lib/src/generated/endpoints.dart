/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs

import 'package:serverpod/serverpod.dart';

import 'package:serverpod_auth_server/module.dart' as serverpod_auth;

// ignore: unused_import
import 'protocol.dart';

import '../endpoints/example_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
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

    modules['serverpod_auth'] = serverpod_auth.Endpoints()..initializeEndpoints(server);
  }

  @override
  void registerModules(Serverpod pod) {
    pod.registerModule(serverpod_auth.Protocol(), 'auth');
  }
}

