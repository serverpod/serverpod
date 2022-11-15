/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:example_client/src/protocol/channel_list.dart' as _i3;
import 'package:serverpod_auth_client/module.dart' as _i4;
import 'package:serverpod_chat_client/module.dart' as _i5;
import 'dart:io' as _i6;
import 'protocol.dart' as _i7;

class _EndpointChannels extends _i1.EndpointRef {
  _EndpointChannels(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'channels';

  _i2.Future<_i3.ChannelList> getChannels() =>
      caller.callServerEndpoint<_i3.ChannelList>(
        'channels',
        'getChannels',
        {},
      );
}

class _Modules {
  _Modules(Client client) {
    auth = _i4.Caller(client);
    chat = _i5.Caller(client);
  }

  late final _i4.Caller auth;

  late final _i5.Caller chat;
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i6.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i7.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {
    channels = _EndpointChannels(this);
    modules = _Modules(this);
  }

  late final _EndpointChannels channels;

  late final _Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'channels': channels};
  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
        'auth': modules.auth,
        'chat': modules.chat,
      };
}
