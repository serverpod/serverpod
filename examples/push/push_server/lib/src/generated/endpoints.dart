/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart'
    as _ipcs;
import 'package:serverpod_push_store_server/serverpod_push_store_server.dart'
    as _ipss;
import '../greetings/greeting_endpoint.dart' as _il624ik7;
import '../push_test_endpoint.dart' as _ir0iy2ag;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'pushTest': _ir0iy2ag.PushTestEndpoint()
        ..initialize(
          server,
          'pushTest',
          null,
        ),
    };
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    connectors['pushTest'] = _is.EndpointConnector(
      name: 'pushTest',
      endpoint: endpoints['pushTest']!,
      methodConnectors: {
        'listCases': _is.MethodConnector(
          name: 'listCases',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pushTest'] as _ir0iy2ag.PushTestEndpoint)
                  .listCases(session),
        ),
        'runCase': _is.MethodConnector(
          name: 'runCase',
          params: {
            'caseId': _is.ParameterDescription(
              name: 'caseId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'installationId': _is.ParameterDescription(
              name: 'installationId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'credential': _is.ParameterDescription(
              name: 'credential',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pushTest'] as _ir0iy2ag.PushTestEndpoint).runCase(
                    session,
                    caseId: params['caseId'],
                    installationId: params['installationId'],
                    credential: params['credential'],
                  ),
        ),
        'queueStatus': _is.MethodConnector(
          name: 'queueStatus',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pushTest'] as _ir0iy2ag.PushTestEndpoint)
                  .queueStatus(session),
        ),
        'scheduleDelayedPing': _is.MethodConnector(
          name: 'scheduleDelayedPing',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pushTest'] as _ir0iy2ag.PushTestEndpoint)
                  .scheduleDelayedPing(session),
        ),
        'authorizedSend': _is.MethodConnector(
          name: 'authorizedSend',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pushTest'] as _ir0iy2ag.PushTestEndpoint)
                  .authorizedSend(session),
        ),
      },
    );
    modules['serverpod_push_core'] = _ipcs.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_push_store'] = _ipss.Endpoints()
      ..initializeEndpoints(server);
  }
}
