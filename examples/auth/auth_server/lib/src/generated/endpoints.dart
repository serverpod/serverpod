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
import '../endpoints/apple_idp_endpoint.dart' as _i2;
import '../endpoints/google_idp_endpoint.dart' as _i3;
import '../greeting_endpoint.dart' as _i4;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i5;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'appleIDP': _i2.AppleIDPEndpoint()
        ..initialize(
          server,
          'appleIDP',
          null,
        ),
      'googleIDP': _i3.GoogleIDPEndpoint()
        ..initialize(
          server,
          'googleIDP',
          null,
        ),
      'greeting': _i4.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['appleIDP'] = _i1.EndpointConnector(
      name: 'appleIDP',
      endpoint: endpoints['appleIDP']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'identityToken': _i1.ParameterDescription(
              name: 'identityToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'authorizationCode': _i1.ParameterDescription(
              name: 'authorizationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isNativeApplePlatformSignIn': _i1.ParameterDescription(
              name: 'isNativeApplePlatformSignIn',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firstName': _i1.ParameterDescription(
              name: 'firstName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'lastName': _i1.ParameterDescription(
              name: 'lastName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['appleIDP'] as _i2.AppleIDPEndpoint).login(
            session,
            identityToken: params['identityToken'],
            authorizationCode: params['authorizationCode'],
            isNativeApplePlatformSignIn: params['isNativeApplePlatformSignIn'],
            firstName: params['firstName'],
            lastName: params['lastName'],
          ),
        )
      },
    );
    connectors['googleIDP'] = _i1.EndpointConnector(
      name: 'googleIDP',
      endpoint: endpoints['googleIDP']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['googleIDP'] as _i3.GoogleIDPEndpoint).login(
            session,
            idToken: params['idToken'],
          ),
        )
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i4.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    modules['serverpod_auth_idp'] = _i5.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i6.Endpoints()
      ..initializeEndpoints(server);
  }
}
