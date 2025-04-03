/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;
import 'package:serverpod_auth2_client/serverpod_auth2_client.dart' as _i4;
import 'package:serverpod_auth_email_client/serverpod_auth_email_client.dart'
    as _i5;
import 'package:serverpod_auth_email_account_client/serverpod_auth_email_account_client.dart'
    as _i6;
import 'package:serverpod_auth_migration_client/serverpod_auth_migration_client.dart'
    as _i7;
import 'package:serverpod_auth_session_client/serverpod_auth_session_client.dart'
    as _i8;
import 'protocol.dart' as _i9;

/// {@category Endpoint}
class EndpointExample extends _i1.EndpointRef {
  EndpointExample(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'example';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i3.Caller(client);
    serverpod_auth2 = _i4.Caller(client);
    serverpod_auth_email = _i5.Caller(client);
    serverpod_auth_email_account = _i6.Caller(client);
    serverpod_auth_migration = _i7.Caller(client);
    serverpod_auth_session = _i8.Caller(client);
  }

  late final _i3.Caller auth;

  late final _i4.Caller serverpod_auth2;

  late final _i5.Caller serverpod_auth_email;

  late final _i6.Caller serverpod_auth_email_account;

  late final _i7.Caller serverpod_auth_migration;

  late final _i8.Caller serverpod_auth_session;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i9.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    example = EndpointExample(this);
    modules = Modules(this);
  }

  late final EndpointExample example;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'example': example};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
        'auth': modules.auth,
        'serverpod_auth2': modules.serverpod_auth2,
        'serverpod_auth_email': modules.serverpod_auth_email,
        'serverpod_auth_email_account': modules.serverpod_auth_email_account,
        'serverpod_auth_migration': modules.serverpod_auth_migration,
        'serverpod_auth_session': modules.serverpod_auth_session,
      };
}
