/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

import 'package:serverpod_auth_client/module.dart' as serverpod_auth;
import 'package:serverpod_chat_client/module.dart' as serverpod_chat;

class _EndpointChannels extends EndpointRef {
  @override
  String get name => 'channels';

  _EndpointChannels(EndpointCaller caller) : super(caller);

  Future<ChannelList> getChannels() async {
    return await caller
        .callServerEndpoint('channels', 'getChannels', 'ChannelList', {});
  }
}

class _Modules {
  late final serverpod_auth.Caller auth;
  late final serverpod_chat.Caller chat;

  _Modules(Client client) {
    auth = serverpod_auth.Caller(client);
    chat = serverpod_chat.Caller(client);
  }
}

class Client extends ServerpodClient {
  late final _EndpointChannels channels;
  late final _Modules modules;

  Client(String host,
      {SecurityContext? context,
      ServerpodClientErrorCallback? errorHandler,
      AuthenticationKeyManager? authenticationKeyManager})
      : super(host, Protocol.instance,
            context: context,
            errorHandler: errorHandler,
            authenticationKeyManager: authenticationKeyManager) {
    channels = _EndpointChannels(this);

    modules = _Modules(this);
    registerModuleProtocol(serverpod_auth.Protocol());
    registerModuleProtocol(serverpod_chat.Protocol());
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
        'channels': channels,
      };

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {
        'auth': modules.auth,
        'chat': modules.chat,
      };
}
