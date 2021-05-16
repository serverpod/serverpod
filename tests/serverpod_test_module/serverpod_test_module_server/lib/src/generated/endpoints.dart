/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/serverpod.dart';

// ignore: unused_import
import 'protocol.dart';

import '../endpoints/module_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'module': ModuleEndpoint()..initialize(server, 'module'),
    };

    connectors['module'] = EndpointConnector(
      name: 'module',
      endpoint: endpoints['module']!,
      methodConnectors: {
        'hello': MethodConnector(
          name: 'hello',
          params: {
            'name': ParameterDescription(name: 'name', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['module'] as ModuleEndpoint).hello(session,params['name'],);
          },
        ),
        'modifyModuleObject': MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': ParameterDescription(name: 'object', type: ModuleClass, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['module'] as ModuleEndpoint).modifyModuleObject(session,params['object'],);
          },
        ),
      },
    );
  }

  @override
  void registerModules(Serverpod pod) {
  }
}

