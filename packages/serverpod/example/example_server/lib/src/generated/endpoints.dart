/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/channels.dart' as _i2;
import 'package:serverpod_auth_server/module.dart' as _i3;
import 'package:serverpod_chat_server/module.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'channels': _i2.ChannelsEndpoint()
        ..initialize(
          server,
          'channels',
          null,
        )
    };
    connectors['channels'] = _i1.EndpointConnector(
      name: 'channels',
      endpoint: endpoints['channels']!,
      methodConnectors: {
        'getChannels': _i1.MethodConnector(
          name: 'getChannels',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['channels'] as _i2.ChannelsEndpoint)
                  .getChannels(session),
        )
      },
    );
    modules['serverpod_auth'] = _i3.Endpoints()..initializeEndpoints(server);
    modules['serverpod_chat'] = _i4.Endpoints()..initializeEndpoints(server);
  }

  @override
  void registerModules(_i1.Serverpod pod) {
    pod.registerModule(
      _i3.Protocol(),
      'auth',
    );
    pod.registerModule(
      _i4.Protocol(),
      'chat',
    );
  }
}
