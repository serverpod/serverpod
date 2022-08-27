/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: unused_import

import 'dart:typed_data' as typed_data;
import 'package:serverpod/serverpod.dart';

import 'package:serverpod_auth_server/module.dart' as serverpod_auth;
import 'package:serverpod_chat_server/module.dart' as serverpod_chat;

import 'protocol.dart';

import '../endpoints/channels.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'channels': ChannelsEndpoint()..initialize(server, 'channels', null),
    };

    connectors['channels'] = EndpointConnector(
      name: 'channels',
      endpoint: endpoints['channels']!,
      methodConnectors: {
        'getChannels': MethodConnector(
          name: 'getChannels',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['channels'] as ChannelsEndpoint).getChannels(
              session,
            );
          },
        ),
      },
    );

    modules['serverpod_auth'] = serverpod_auth.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_chat'] = serverpod_chat.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  void registerModules(Serverpod pod) {
    pod.registerModule(serverpod_auth.Protocol(), 'auth');
    pod.registerModule(serverpod_chat.Protocol(), 'chat');
  }
}
