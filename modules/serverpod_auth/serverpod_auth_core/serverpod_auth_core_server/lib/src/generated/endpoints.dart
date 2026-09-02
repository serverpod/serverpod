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
import 'package:serverpod/serverpod.dart' as _is;
import '../common/endpoints/status_endpoint.dart' as _id66yt13;
import '../profile/endpoints/user_profile_base_endpoint.dart' as _ijdx9s01;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'status': _id66yt13.StatusEndpoint()
        ..initialize(
          server,
          'status',
          'serverpod_auth_core',
        ),
      'userProfileInfo': _ijdx9s01.UserProfileInfoEndpoint()
        ..initialize(
          server,
          'userProfileInfo',
          'serverpod_auth_core',
        ),
    };
    connectors['status'] = _is.EndpointConnector(
      name: 'status',
      endpoint: endpoints['status']!,
      methodConnectors: {
        'isSignedIn': _is.MethodConnector(
          name: 'isSignedIn',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _id66yt13.StatusEndpoint)
                  .isSignedIn(session),
        ),
        'signOutDevice': _is.MethodConnector(
          name: 'signOutDevice',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _id66yt13.StatusEndpoint)
                  .signOutDevice(session),
        ),
        'signOutAllDevices': _is.MethodConnector(
          name: 'signOutAllDevices',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _id66yt13.StatusEndpoint)
                  .signOutAllDevices(session),
        ),
      },
    );
    connectors['userProfileInfo'] = _is.EndpointConnector(
      name: 'userProfileInfo',
      endpoint: endpoints['userProfileInfo']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfileInfo']
                          as _ijdx9s01.UserProfileInfoEndpoint)
                      .get(session),
        ),
      },
    );
  }
}
