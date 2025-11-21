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
import 'package:serverpod_admin_client/src/protocol/admin/admin_resource.dart'
    as _i3;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_admin.admin';

  _i2.Future<List<_i3.AdminResource>> resources() =>
      caller.callServerEndpoint<List<_i3.AdminResource>>(
        'serverpod_admin.admin',
        'resources',
        {},
      );

  _i2.Future<List<Map<String, String>>> list(String resourceKey) =>
      caller.callServerEndpoint<List<Map<String, String>>>(
        'serverpod_admin.admin',
        'list',
        {'resourceKey': resourceKey},
      );

  _i2.Future<List<Map<String, String>>> listPage(
    String resourceKey,
    int offset,
    int limit,
  ) =>
      caller.callServerEndpoint<List<Map<String, String>>>(
        'serverpod_admin.admin',
        'listPage',
        {
          'resourceKey': resourceKey,
          'offset': offset,
          'limit': limit,
        },
      );

  _i2.Future<Map<String, dynamic>?> find(
    String resourceKey,
    Object id,
  ) =>
      caller.callServerEndpoint<Map<String, dynamic>?>(
        'serverpod_admin.admin',
        'find',
        {
          'resourceKey': resourceKey,
          'id': id,
        },
      );

  _i2.Future<Map<String, String>> create(
    String resourceKey,
    Map<String, String> data,
  ) =>
      caller.callServerEndpoint<Map<String, String>>(
        'serverpod_admin.admin',
        'create',
        {
          'resourceKey': resourceKey,
          'data': data,
        },
      );

  _i2.Future<Map<String, String>> update(
    String resourceKey,
    Map<String, String> data,
  ) =>
      caller.callServerEndpoint<Map<String, String>>(
        'serverpod_admin.admin',
        'update',
        {
          'resourceKey': resourceKey,
          'data': data,
        },
      );

  _i2.Future<bool> delete(
    String resourceKey,
    String id,
  ) =>
      caller.callServerEndpoint<bool>(
        'serverpod_admin.admin',
        'delete',
        {
          'resourceKey': resourceKey,
          'id': id,
        },
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    admin = EndpointAdmin(this);
  }

  late final EndpointAdmin admin;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'serverpod_admin.admin': admin};
}
