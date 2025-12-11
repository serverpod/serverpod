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
import 'package:serverpod/serverpod.dart' as _i1;
import '../common/endpoints/status_endpoint.dart' as _i2;
import '../profile/endpoints/user_profile_base_endpoint.dart' as _i3;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'status': _i2.StatusEndpoint()
        ..initialize(
          server,
          'status',
          'serverpod_auth_core',
        ),
      'userProfileInfo': _i3.UserProfileInfoEndpoint()
        ..initialize(
          server,
          'userProfileInfo',
          'serverpod_auth_core',
        ),
    };
    connectors['status'] = _i1.EndpointConnector(
      name: 'status',
      endpoint: endpoints['status']!,
      methodConnectors: {
        'isSignedIn': _i1.MethodConnector(
          name: 'isSignedIn',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _i2.StatusEndpoint).isSignedIn(
                session,
              ),
        ),
        'signOutDevice': _i1.MethodConnector(
          name: 'signOutDevice',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _i2.StatusEndpoint)
                  .signOutDevice(session),
        ),
        'signOutAllDevices': _i1.MethodConnector(
          name: 'signOutAllDevices',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _i2.StatusEndpoint)
                  .signOutAllDevices(session),
        ),
      },
    );
    connectors['userProfileInfo'] = _i1.EndpointConnector(
      name: 'userProfileInfo',
      endpoint: endpoints['userProfileInfo']!,
      methodConnectors: {
        'get': _i1.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfileInfo'] as _i3.UserProfileInfoEndpoint)
                      .get(session),
        ),
      },
    );
  }
}
