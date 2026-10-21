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
import '../auth_user/endpoints/account_linking_endpoint.dart' as _is0pusjq;
import '../common/endpoints/status_endpoint.dart' as _id66yt13;
import '../profile/endpoints/user_profile_base_endpoint.dart' as _ijdx9s01;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'accountLinking': _is0pusjq.AccountLinkingEndpoint()
        ..initialize(
          server,
          'accountLinking',
          'serverpod_auth_core',
        ),
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
    connectors['accountLinking'] = _is.EndpointConnector(
      name: 'accountLinking',
      endpoint: endpoints['accountLinking']!,
      methodConnectors: {
        'createLinkRequest': _is.MethodConnector(
          name: 'createLinkRequest',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accountLinking']
                          as _is0pusjq.AccountLinkingEndpoint)
                      .createLinkRequest(session),
        ),
        'cancelLinkRequest': _is.MethodConnector(
          name: 'cancelLinkRequest',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accountLinking']
                          as _is0pusjq.AccountLinkingEndpoint)
                      .cancelLinkRequest(session),
        ),
        'executeLinkRequest': _is.MethodConnector(
          name: 'executeLinkRequest',
          params: {
            'proofToken': _is.ParameterDescription(
              name: 'proofToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'approveMerge': _is.ParameterDescription(
              name: 'approveMerge',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['accountLinking']
                          as _is0pusjq.AccountLinkingEndpoint)
                      .executeLinkRequest(
                        session,
                        proofToken: params['proofToken'],
                        approveMerge: params['approveMerge'],
                      ),
        ),
      },
    );
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
