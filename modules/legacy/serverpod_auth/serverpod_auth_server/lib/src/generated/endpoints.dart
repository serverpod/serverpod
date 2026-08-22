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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_server/src/generated/apple_auth_info.dart'
    as _idx01old;
import '../endpoints/admin_endpoint.dart' as _i5t1w2d2;
import '../endpoints/apple_endpoint.dart' as _i9swvpdc;
import '../endpoints/email_endpoint.dart' as _i5tf3zut;
import '../endpoints/firebase_endpoint.dart' as _inw80j1s;
import '../endpoints/google_endpoint.dart' as _i3p8780q;
import '../endpoints/status_endpoint.dart' as _iv1cbiab;
import '../endpoints/user_endpoint.dart' as _iymy5306;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'admin': _i5t1w2d2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          'serverpod_auth',
        ),
      'apple': _i9swvpdc.AppleEndpoint()
        ..initialize(
          server,
          'apple',
          'serverpod_auth',
        ),
      'email': _i5tf3zut.EmailEndpoint()
        ..initialize(
          server,
          'email',
          'serverpod_auth',
        ),
      'firebase': _inw80j1s.FirebaseEndpoint()
        ..initialize(
          server,
          'firebase',
          'serverpod_auth',
        ),
      'google': _i3p8780q.GoogleEndpoint()
        ..initialize(
          server,
          'google',
          'serverpod_auth',
        ),
      'status': _iv1cbiab.StatusEndpoint()
        ..initialize(
          server,
          'status',
          'serverpod_auth',
        ),
      'user': _iymy5306.UserEndpoint()
        ..initialize(
          server,
          'user',
          'serverpod_auth',
        ),
    };
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'getUserInfo': _is.MethodConnector(
          name: 'getUserInfo',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).getUserInfo(
                    session,
                    params['userId'],
                  ),
        ),
        'blockUser': _is.MethodConnector(
          name: 'blockUser',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).blockUser(
                    session,
                    params['userId'],
                  ),
        ),
        'unblockUser': _is.MethodConnector(
          name: 'unblockUser',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).unblockUser(
                    session,
                    params['userId'],
                  ),
        ),
      },
    );
    connectors['apple'] = _is.EndpointConnector(
      name: 'apple',
      endpoint: endpoints['apple']!,
      methodConnectors: {
        'authenticate': _is.MethodConnector(
          name: 'authenticate',
          params: {
            'authInfo': _is.ParameterDescription(
              name: 'authInfo',
              type: _is.getType<_idx01old.AppleAuthInfo>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['apple'] as _i9swvpdc.AppleEndpoint).authenticate(
                    session,
                    params['authInfo'],
                  ),
        ),
      },
    );
    connectors['email'] = _is.EndpointConnector(
      name: 'email',
      endpoint: endpoints['email']!,
      methodConnectors: {
        'authenticate': _is.MethodConnector(
          name: 'authenticate',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['email'] as _i5tf3zut.EmailEndpoint).authenticate(
                    session,
                    params['email'],
                    params['password'],
                  ),
        ),
        'changePassword': _is.MethodConnector(
          name: 'changePassword',
          params: {
            'oldPassword': _is.ParameterDescription(
              name: 'oldPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['email'] as _i5tf3zut.EmailEndpoint)
                  .changePassword(
                    session,
                    params['oldPassword'],
                    params['newPassword'],
                  ),
        ),
        'initiatePasswordReset': _is.MethodConnector(
          name: 'initiatePasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['email'] as _i5tf3zut.EmailEndpoint)
                  .initiatePasswordReset(
                    session,
                    params['email'],
                  ),
        ),
        'resetPassword': _is.MethodConnector(
          name: 'resetPassword',
          params: {
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['email'] as _i5tf3zut.EmailEndpoint).resetPassword(
                    session,
                    params['verificationCode'],
                    params['password'],
                  ),
        ),
        'createAccountRequest': _is.MethodConnector(
          name: 'createAccountRequest',
          params: {
            'userName': _is.ParameterDescription(
              name: 'userName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['email'] as _i5tf3zut.EmailEndpoint)
                  .createAccountRequest(
                    session,
                    params['userName'],
                    params['email'],
                    params['password'],
                  ),
        ),
        'createAccount': _is.MethodConnector(
          name: 'createAccount',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['email'] as _i5tf3zut.EmailEndpoint).createAccount(
                    session,
                    params['email'],
                    params['verificationCode'],
                  ),
        ),
      },
    );
    connectors['firebase'] = _is.EndpointConnector(
      name: 'firebase',
      endpoint: endpoints['firebase']!,
      methodConnectors: {
        'authenticate': _is.MethodConnector(
          name: 'authenticate',
          params: {
            'idToken': _is.ParameterDescription(
              name: 'idToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['firebase'] as _inw80j1s.FirebaseEndpoint)
                  .authenticate(
                    session,
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['google'] = _is.EndpointConnector(
      name: 'google',
      endpoint: endpoints['google']!,
      methodConnectors: {
        'authenticateWithServerAuthCode': _is.MethodConnector(
          name: 'authenticateWithServerAuthCode',
          params: {
            'authenticationCode': _is.ParameterDescription(
              name: 'authenticationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _is.ParameterDescription(
              name: 'redirectUri',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['google'] as _i3p8780q.GoogleEndpoint)
                  .authenticateWithServerAuthCode(
                    session,
                    params['authenticationCode'],
                    params['redirectUri'],
                  ),
        ),
        'authenticateWithIdToken': _is.MethodConnector(
          name: 'authenticateWithIdToken',
          params: {
            'idToken': _is.ParameterDescription(
              name: 'idToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['google'] as _i3p8780q.GoogleEndpoint)
                  .authenticateWithIdToken(
                    session,
                    params['idToken'],
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
              ) async => (endpoints['status'] as _iv1cbiab.StatusEndpoint)
                  .isSignedIn(session),
        ),
        'signOutDevice': _is.MethodConnector(
          name: 'signOutDevice',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _iv1cbiab.StatusEndpoint)
                  .signOutDevice(session),
        ),
        'signOutAllDevices': _is.MethodConnector(
          name: 'signOutAllDevices',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _iv1cbiab.StatusEndpoint)
                  .signOutAllDevices(session),
        ),
        'getUserInfo': _is.MethodConnector(
          name: 'getUserInfo',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _iv1cbiab.StatusEndpoint)
                  .getUserInfo(session),
        ),
        'getUserSettingsConfig': _is.MethodConnector(
          name: 'getUserSettingsConfig',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['status'] as _iv1cbiab.StatusEndpoint)
                  .getUserSettingsConfig(session),
        ),
      },
    );
    connectors['user'] = _is.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'removeUserImage': _is.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint)
                  .removeUserImage(session),
        ),
        'setUserImage': _is.MethodConnector(
          name: 'setUserImage',
          params: {
            'image': _is.ParameterDescription(
              name: 'image',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).setUserImage(
                    session,
                    params['image'],
                  ),
        ),
        'changeUserName': _is.MethodConnector(
          name: 'changeUserName',
          params: {
            'userName': _is.ParameterDescription(
              name: 'userName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).changeUserName(
                    session,
                    params['userName'],
                  ),
        ),
        'changeFullName': _is.MethodConnector(
          name: 'changeFullName',
          params: {
            'fullName': _is.ParameterDescription(
              name: 'fullName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).changeFullName(
                    session,
                    params['fullName'],
                  ),
        ),
      },
    );
  }
}
