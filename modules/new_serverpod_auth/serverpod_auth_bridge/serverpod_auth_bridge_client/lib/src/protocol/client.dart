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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i3;

/// Endpoint to convert legacy sessions.
/// {@category Endpoint}
class EndpointSessionMigration extends _i1.EndpointRef {
  EndpointSessionMigration(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_bridge.sessionMigration';

  /// Converts a legacy session into a new token from the token manager.
  _i2.Future<_i3.AuthSuccess?> convertSession({required String sessionKey}) =>
      caller.callServerEndpoint<_i3.AuthSuccess?>(
        'serverpod_auth_bridge.sessionMigration',
        'convertSession',
        {'sessionKey': sessionKey},
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    sessionMigration = EndpointSessionMigration(this);
  }

  late final EndpointSessionMigration sessionMigration;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'serverpod_auth_bridge.sessionMigration': sessionMigration};
}
