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
import '../endpoints/email_account_endpoint.dart' as _i2;
import '../endpoints/session_test_endpoint.dart' as _i3;
import '../endpoints/user_profile_endpoint.dart' as _i4;
import 'package:uuid/uuid_value.dart' as _i5;
import 'dart:typed_data' as _i6;
import 'package:serverpod_auth_email_server/serverpod_auth_email_server.dart'
    as _i7;
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart'
    as _i8;
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as _i9;
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart'
    as _i10;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i11;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailAccount': _i2.EmailAccountEndpoint()
        ..initialize(
          server,
          'emailAccount',
          null,
        ),
      'sessionTest': _i3.SessionTestEndpoint()
        ..initialize(
          server,
          'sessionTest',
          null,
        ),
      'userProfile': _i4.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
    };
    connectors['emailAccount'] = _i1.EndpointConnector(
      name: 'emailAccount',
      endpoint: endpoints['emailAccount']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
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
              (endpoints['emailAccount'] as _i2.EmailAccountEndpoint).login(
            session,
            email: params['email'],
            password: params['password'],
          ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
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
              (endpoints['emailAccount'] as _i2.EmailAccountEndpoint)
                  .startRegistration(
            session,
            email: params['email'],
            password: params['password'],
          ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i5.UuidValue>(),
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
              (endpoints['emailAccount'] as _i2.EmailAccountEndpoint)
                  .finishRegistration(
            session,
            accountRequestId: params['accountRequestId'],
            verificationCode: params['verificationCode'],
          ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
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
              (endpoints['emailAccount'] as _i2.EmailAccountEndpoint)
                  .startPasswordReset(
            session,
            email: params['email'],
          ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i5.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
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
              (endpoints['emailAccount'] as _i2.EmailAccountEndpoint)
                  .finishPasswordReset(
            session,
            passwordResetRequestId: params['passwordResetRequestId'],
            verificationCode: params['verificationCode'],
            newPassword: params['newPassword'],
          ),
        ),
      },
    );
    connectors['sessionTest'] = _i1.EndpointConnector(
      name: 'sessionTest',
      endpoint: endpoints['sessionTest']!,
      methodConnectors: {
        'createTestUser': _i1.MethodConnector(
          name: 'createTestUser',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionTest'] as _i3.SessionTestEndpoint)
                  .createTestUser(session),
        ),
        'createSession': _i1.MethodConnector(
          name: 'createSession',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i5.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionTest'] as _i3.SessionTestEndpoint)
                  .createSession(
            session,
            params['authUserId'],
          ),
        ),
        'checkSession': _i1.MethodConnector(
          name: 'checkSession',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i5.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionTest'] as _i3.SessionTestEndpoint)
                  .checkSession(
            session,
            params['authUserId'],
          ),
        ),
      },
    );
    connectors['userProfile'] = _i1.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'get': _i1.MethodConnector(
          name: 'get',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i4.UserProfileEndpoint)
                  .get(session),
        ),
        'removeUserImage': _i1.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i4.UserProfileEndpoint)
                  .removeUserImage(session),
        ),
        'setUserImage': _i1.MethodConnector(
          name: 'setUserImage',
          params: {
            'image': _i1.ParameterDescription(
              name: 'image',
              type: _i1.getType<_i6.ByteData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i4.UserProfileEndpoint)
                  .setUserImage(
            session,
            params['image'],
          ),
        ),
        'changeUserName': _i1.MethodConnector(
          name: 'changeUserName',
          params: {
            'userName': _i1.ParameterDescription(
              name: 'userName',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i4.UserProfileEndpoint)
                  .changeUserName(
            session,
            params['userName'],
          ),
        ),
        'changeFullName': _i1.MethodConnector(
          name: 'changeFullName',
          params: {
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i4.UserProfileEndpoint)
                  .changeFullName(
            session,
            params['fullName'],
          ),
        ),
      },
    );
    modules['serverpod_auth_email'] = _i7.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_profile'] = _i8.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_email_account'] = _i9.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_session'] = _i10.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_user'] = _i11.Endpoints()
      ..initializeEndpoints(server);
  }
}
