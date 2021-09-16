/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:typed_data' as typed_data;
import 'package:serverpod/serverpod.dart';

import 'protocol.dart';

import '../endpoints/streaming.dart';
import '../endpoints/module_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'streaming': StreamingEndpoint()..initialize(server, 'streaming', 'serverpod_test_module'),
      'module': ModuleEndpoint()..initialize(server, 'module', 'serverpod_test_module'),
    };

    connectors['streaming'] = EndpointConnector(
      name: 'streaming',
      endpoint: endpoints['streaming']!,
      methodConnectors: {
      },
    );

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

