/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/admin_endpoint.dart' as _i2;
import '../endpoints/apple_endpoint.dart' as _i3;
import '../endpoints/email_endpoint.dart' as _i4;
import '../endpoints/firebase_endpoint.dart' as _i5;
import '../endpoints/google_endpoint.dart' as _i6;
import '../endpoints/sms_endpoint.dart' as _i7;
import '../endpoints/status_endpoint.dart' as _i8;
import '../endpoints/user_endpoint.dart' as _i9;
import 'package:serverpod_auth_server/src/generated/apple_auth_info.dart'
    as _i10;
import 'dart:typed_data' as _i11;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          'serverpod_auth',
        ),
      'apple': _i3.AppleEndpoint()
        ..initialize(
          server,
          'apple',
          'serverpod_auth',
        ),
      'email': _i4.EmailEndpoint()
        ..initialize(
          server,
          'email',
          'serverpod_auth',
        ),
      'firebase': _i5.FirebaseEndpoint()
        ..initialize(
          server,
          'firebase',
          'serverpod_auth',
        ),
      'google': _i6.GoogleEndpoint()
        ..initialize(
          server,
          'google',
          'serverpod_auth',
        ),
      'sms': _i7.SmsEndpoint()
        ..initialize(
          server,
          'sms',
          'serverpod_auth',
        ),
      'status': _i8.StatusEndpoint()
        ..initialize(
          server,
          'status',
          'serverpod_auth',
        ),
      'user': _i9.UserEndpoint()
        ..initialize(
          server,
          'user',
          'serverpod_auth',
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'getUserInfo': _i1.MethodConnector(
          name: 'getUserInfo',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getUserInfo(
            session,
            params['userId'],
          ),
        )
      },
    );
    connectors['apple'] = _i1.EndpointConnector(
      name: 'apple',
      endpoint: endpoints['apple']!,
      methodConnectors: {
        'authenticate': _i1.MethodConnector(
          name: 'authenticate',
          params: {
            'authInfo': _i1.ParameterDescription(
              name: 'authInfo',
              type: _i1.getType<_i10.AppleAuthInfo>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['apple'] as _i3.AppleEndpoint).authenticate(
            session,
            params['authInfo'],
          ),
        )
      },
    );
    connectors['email'] = _i1.EndpointConnector(
      name: 'email',
      endpoint: endpoints['email']!,
      methodConnectors: {
        'authenticate': _i1.MethodConnector(
          name: 'authenticate',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['email'] as _i4.EmailEndpoint).authenticate(
            session,
            params['email'],
            params['password'],
          ),
        ),
        'changePassword': _i1.MethodConnector(
          name: 'changePassword',
          params: {
            'oldPassword': _i1.ParameterDescription(
              name: 'oldPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['email'] as _i4.EmailEndpoint).changePassword(
            session,
            params['oldPassword'],
            params['newPassword'],
          ),
        ),
        'initiatePasswordReset': _i1.MethodConnector(
          name: 'initiatePasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['email'] as _i4.EmailEndpoint).initiatePasswordReset(
            session,
            params['email'],
          ),
        ),
        'verifyEmailPasswordReset': _i1.MethodConnector(
          name: 'verifyEmailPasswordReset',
          params: {
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['email'] as _i4.EmailEndpoint)
                  .verifyEmailPasswordReset(
            session,
            params['verificationCode'],
          ),
        ),
        'resetPassword': _i1.MethodConnector(
          name: 'resetPassword',
          params: {
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['email'] as _i4.EmailEndpoint).resetPassword(
            session,
            params['verificationCode'],
            params['password'],
          ),
        ),
        'createAccountRequest': _i1.MethodConnector(
          name: 'createAccountRequest',
          params: {
            'userName': _i1.ParameterDescription(
              name: 'userName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['email'] as _i4.EmailEndpoint).createAccountRequest(
            session,
            params['userName'],
            params['email'],
            params['password'],
          ),
        ),
        'createAccount': _i1.MethodConnector(
          name: 'createAccount',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['email'] as _i4.EmailEndpoint).createAccount(
            session,
            params['email'],
            params['verificationCode'],
          ),
        ),
      },
    );
    connectors['firebase'] = _i1.EndpointConnector(
      name: 'firebase',
      endpoint: endpoints['firebase']!,
      methodConnectors: {
        'authenticate': _i1.MethodConnector(
          name: 'authenticate',
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
              (endpoints['firebase'] as _i5.FirebaseEndpoint).authenticate(
            session,
            params['idToken'],
          ),
        )
      },
    );
    connectors['google'] = _i1.EndpointConnector(
      name: 'google',
      endpoint: endpoints['google']!,
      methodConnectors: {
        'authenticateWithServerAuthCode': _i1.MethodConnector(
          name: 'authenticateWithServerAuthCode',
          params: {
            'authenticationCode': _i1.ParameterDescription(
              name: 'authenticationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _i1.ParameterDescription(
              name: 'redirectUri',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['google'] as _i6.GoogleEndpoint)
                  .authenticateWithServerAuthCode(
            session,
            params['authenticationCode'],
            params['redirectUri'],
          ),
        ),
        'authenticateWithIdToken': _i1.MethodConnector(
          name: 'authenticateWithIdToken',
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
              (endpoints['google'] as _i6.GoogleEndpoint)
                  .authenticateWithIdToken(
            session,
            params['idToken'],
          ),
        ),
      },
    );
    connectors['sms'] = _i1.EndpointConnector(
      name: 'sms',
      endpoint: endpoints['sms']!,
      methodConnectors: {
        'startAuthentication': _i1.MethodConnector(
          name: 'startAuthentication',
          params: {
            'phoneNumber': _i1.ParameterDescription(
              name: 'phoneNumber',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sms'] as _i7.SmsEndpoint).startAuthentication(
            session,
            params['phoneNumber'],
          ),
        ),
        'verifyAuthentication': _i1.MethodConnector(
          name: 'verifyAuthentication',
          params: {
            'phoneNumber': _i1.ParameterDescription(
              name: 'phoneNumber',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'otp': _i1.ParameterDescription(
              name: 'otp',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'storedHash': _i1.ParameterDescription(
              name: 'storedHash',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sms'] as _i7.SmsEndpoint).verifyAuthentication(
            session,
            params['phoneNumber'],
            params['otp'],
            params['storedHash'],
          ),
        ),
      },
    );
    connectors['status'] = _i1.EndpointConnector(
      name: 'status',
      endpoint: endpoints['status']!,
      methodConnectors: {
        'isSignedIn': _i1.MethodConnector(
          name: 'isSignedIn',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['status'] as _i8.StatusEndpoint).isSignedIn(session),
        ),
        'signOut': _i1.MethodConnector(
          name: 'signOut',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['status'] as _i8.StatusEndpoint).signOut(session),
        ),
        'getUserInfo': _i1.MethodConnector(
          name: 'getUserInfo',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['status'] as _i8.StatusEndpoint).getUserInfo(session),
        ),
        'getUserSettingsConfig': _i1.MethodConnector(
          name: 'getUserSettingsConfig',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['status'] as _i8.StatusEndpoint)
                  .getUserSettingsConfig(session),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'removeUserImage': _i1.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).removeUserImage(session),
        ),
        'setUserImage': _i1.MethodConnector(
          name: 'setUserImage',
          params: {
            'image': _i1.ParameterDescription(
              name: 'image',
              type: _i1.getType<_i11.ByteData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).setUserImage(
            session,
            params['image'],
          ),
        ),
        'changeUserName': _i1.MethodConnector(
          name: 'changeUserName',
          params: {
            'userName': _i1.ParameterDescription(
              name: 'userName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).changeUserName(
            session,
            params['userName'],
          ),
        ),
      },
    );
  }
}
