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
import '../endpoints/push_device_endpoint.dart' as _iaixtzyc;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'pushDevice': _iaixtzyc.PushDeviceEndpoint()
        ..initialize(
          server,
          'pushDevice',
          'serverpod_push_store',
        ),
    };
    connectors['pushDevice'] = _is.EndpointConnector(
      name: 'pushDevice',
      endpoint: endpoints['pushDevice']!,
      methodConnectors: {
        'registerDevice': _is.MethodConnector(
          name: 'registerDevice',
          params: {
            'provider': _is.ParameterDescription(
              name: 'provider',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'credential': _is.ParameterDescription(
              name: 'credential',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'platform': _is.ParameterDescription(
              name: 'platform',
              type: _is.getType<_ipcs.PushPlatform>(),
              nullable: false,
            ),
            'installationId': _is.ParameterDescription(
              name: 'installationId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'appVersion': _is.ParameterDescription(
              name: 'appVersion',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pushDevice'] as _iaixtzyc.PushDeviceEndpoint)
                      .registerDevice(
                        session,
                        provider: params['provider'],
                        credential: params['credential'],
                        platform: params['platform'],
                        installationId: params['installationId'],
                        locale: params['locale'],
                        appVersion: params['appVersion'],
                      ),
        ),
        'unregisterDevice': _is.MethodConnector(
          name: 'unregisterDevice',
          params: {
            'provider': _is.ParameterDescription(
              name: 'provider',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'credential': _is.ParameterDescription(
              name: 'credential',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pushDevice'] as _iaixtzyc.PushDeviceEndpoint)
                      .unregisterDevice(
                        session,
                        provider: params['provider'],
                        credential: params['credential'],
                      ),
        ),
        'acknowledge': _is.MethodConnector(
          name: 'acknowledge',
          params: {
            'deliveryId': _is.ParameterDescription(
              name: 'deliveryId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<_ipcs.PushAckType>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pushDevice'] as _iaixtzyc.PushDeviceEndpoint)
                      .acknowledge(
                        session,
                        deliveryId: params['deliveryId'],
                        type: params['type'],
                      ),
        ),
      },
    );
    modules['serverpod_push_core'] = _ipcs.Endpoints()
      ..initializeEndpoints(server);
  }
}
