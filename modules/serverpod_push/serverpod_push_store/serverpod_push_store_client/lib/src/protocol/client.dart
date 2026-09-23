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
import 'dart:async' as _ida;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_push_core_client/serverpod_push_core_client.dart'
    as _ipcc;

/// Device registration endpoint. Anonymous registration is legitimate;
/// deployments should rate-limit this endpoint at the edge.
/// {@category Endpoint}
class EndpointPushDevice extends _isc.EndpointRef {
  EndpointPushDevice(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_push_store.pushDevice';

  /// Registers or updates a device token.
  _ida.Future<void> registerDevice({
    required String provider,
    required String credential,
    required _ipcc.PushPlatform platform,
    String? installationId,
    String? locale,
    String? appVersion,
  }) => caller.callServerEndpoint<void>(
    'serverpod_push_store.pushDevice',
    'registerDevice',
    {
      'provider': provider,
      'credential': credential,
      'platform': platform,
      'installationId': installationId,
      'locale': locale,
      'appVersion': appVersion,
    },
  );

  /// Soft-deletes a device. Owned rows require the owning user.
  _ida.Future<void> unregisterDevice({
    required String provider,
    required String credential,
  }) => caller.callServerEndpoint<void>(
    'serverpod_push_store.pushDevice',
    'unregisterDevice',
    {
      'provider': provider,
      'credential': credential,
    },
  );

  /// Records that a delivery was received or opened.
  _ida.Future<void> acknowledge({
    required _isc.UuidValue deliveryId,
    required _ipcc.PushAckType type,
  }) => caller.callServerEndpoint<void>(
    'serverpod_push_store.pushDevice',
    'acknowledge',
    {
      'deliveryId': deliveryId,
      'type': type,
    },
  );
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    pushDevice = EndpointPushDevice(this);
  }

  late final EndpointPushDevice pushDevice;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'serverpod_push_store.pushDevice': pushDevice,
  };
}
