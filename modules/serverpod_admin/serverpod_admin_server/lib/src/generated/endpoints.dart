/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../admin/endpoint/admin.dart' as _i2;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          'serverpod_admin',
        )
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'resources': _i1.MethodConnector(
          name: 'resources',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).resources(session),
        ),
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'resourceKey': _i1.ParameterDescription(
              name: 'resourceKey',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).list(
            session,
            params['resourceKey'],
          ),
        ),
        'listPage': _i1.MethodConnector(
          name: 'listPage',
          params: {
            'resourceKey': _i1.ParameterDescription(
              name: 'resourceKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).listPage(
            session,
            params['resourceKey'],
            params['offset'],
            params['limit'],
          ),
        ),
        'find': _i1.MethodConnector(
          name: 'find',
          params: {
            'resourceKey': _i1.ParameterDescription(
              name: 'resourceKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<Object>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).find(
            session,
            params['resourceKey'],
            params['id'],
          ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'resourceKey': _i1.ParameterDescription(
              name: 'resourceKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<Map<String, String>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).create(
            session,
            params['resourceKey'],
            params['data'],
          ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'resourceKey': _i1.ParameterDescription(
              name: 'resourceKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<Map<String, String>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).update(
            session,
            params['resourceKey'],
            params['data'],
          ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'resourceKey': _i1.ParameterDescription(
              name: 'resourceKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).delete(
            session,
            params['resourceKey'],
            params['id'],
          ),
        ),
      },
    );
  }
}
