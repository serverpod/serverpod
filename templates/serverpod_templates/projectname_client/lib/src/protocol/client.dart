/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:io' as _i2;
import 'protocol.dart' as _i3;

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i2.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i3.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {}

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {};
  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
