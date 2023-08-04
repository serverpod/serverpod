/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:chat_client/src/protocol/channel.dart' as _i3;
import 'package:serverpod_auth_client/module.dart' as _i4;
import 'package:serverpod_chat_client/module.dart' as _i5;
import 'dart:io' as _i6;
import 'protocol.dart' as _i7;

/// {@category Endpoint}
class EndpointChannels extends _i1.EndpointRef {
  EndpointChannels(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'channels';

  _i2.Future<List<_i3.Channel>> getChannels() =>
      caller.callServerEndpoint<List<_i3.Channel>>(
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
    Duration? timeout,
  }) : super(
          host,
          _i7.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
          timeout: timeout,
        ) {
    channels = EndpointChannels(this);
    modules = _Modules(this);
  }

  late final EndpointChannels channels;

  late final _Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'channels': channels};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
        'auth': modules.auth,
        'chat': modules.chat,
      };
}
