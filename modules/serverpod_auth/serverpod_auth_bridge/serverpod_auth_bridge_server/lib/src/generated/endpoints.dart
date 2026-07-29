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
import '../endpoints/legacy_admin_endpoint.dart' as _i2;
import '../endpoints/legacy_email_endpoint.dart' as _i3;
import '../endpoints/legacy_google_endpoint.dart' as _i4;
import '../endpoints/legacy_status_endpoint.dart' as _i5;
import '../endpoints/legacy_user_endpoint.dart' as _i6;
import '../endpoints/session_migration_endpoint.dart' as _i7;
import 'dart:typed_data' as _i8;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i9;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i10;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'legacyAdmin': _i2.LegacyAdminEndpoint()
        ..initialize(
          server,
          'legacyAdmin',
          'serverpod_auth_bridge',
        ),
      'legacyEmail': _i3.LegacyEmailEndpoint()
        ..initialize(
          server,
          'legacyEmail',
          'serverpod_auth_bridge',
        ),
      'legacyGoogle': _i4.LegacyGoogleEndpoint()
        ..initialize(
          server,
          'legacyGoogle',
          'serverpod_auth_bridge',
        ),
      'legacyStatus': _i5.LegacyStatusEndpoint()
        ..initialize(
          server,
          'legacyStatus',
          'serverpod_auth_bridge',
        ),
      'legacyUser': _i6.LegacyUserEndpoint()
        ..initialize(
          server,
          'legacyUser',
          'serverpod_auth_bridge',
        ),
      'sessionMigration': _i7.SessionMigrationEndpoint()
        ..initialize(
          server,
          'sessionMigration',
          'serverpod_auth_bridge',
        ),
    };
    connectors['legacyAdmin'] = _i1.EndpointConnector(
      name: 'legacyAdmin',
      endpoint: endpoints['legacyAdmin']!,
      methodConnectors: {
        'getUserInfo': _i1.MethodConnector(
          name: 'getUserInfo',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyAdmin'] as _i2.LegacyAdminEndpoint)
                  .getUserInfo(
                    session,
                    params['userId'],
                  ),
        ),
        'blockUser': _i1.MethodConnector(
          name: 'blockUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyAdmin'] as _i2.LegacyAdminEndpoint)
                  .blockUser(
                    session,
                    params['userId'],
                  ),
        ),
        'unblockUser': _i1.MethodConnector(
          name: 'unblockUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyAdmin'] as _i2.LegacyAdminEndpoint)
                  .unblockUser(
                    session,
                    params['userId'],
                  ),
        ),
      },
    );
    connectors['legacyEmail'] = _i1.EndpointConnector(
      name: 'legacyEmail',
      endpoint: endpoints['legacyEmail']!,
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyEmail'] as _i3.LegacyEmailEndpoint)
                  .authenticate(
                    session,
                    params['email'],
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyEmail'] as _i3.LegacyEmailEndpoint)
                  .createAccountRequest(
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyEmail'] as _i3.LegacyEmailEndpoint)
                  .createAccount(
                    session,
                    params['email'],
                    params['verificationCode'],
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyEmail'] as _i3.LegacyEmailEndpoint)
                  .changePassword(
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyEmail'] as _i3.LegacyEmailEndpoint)
                  .initiatePasswordReset(
                    session,
                    params['email'],
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyEmail'] as _i3.LegacyEmailEndpoint)
                  .resetPassword(
                    session,
                    params['verificationCode'],
                    params['password'],
                  ),
        ),
      },
    );
    connectors['legacyGoogle'] = _i1.EndpointConnector(
      name: 'legacyGoogle',
      endpoint: endpoints['legacyGoogle']!,
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyGoogle'] as _i4.LegacyGoogleEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyGoogle'] as _i4.LegacyGoogleEndpoint)
                  .authenticateWithIdToken(
                    session,
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['legacyStatus'] = _i1.EndpointConnector(
      name: 'legacyStatus',
      endpoint: endpoints['legacyStatus']!,
      methodConnectors: {
        'isSignedIn': _i1.MethodConnector(
          name: 'isSignedIn',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyStatus'] as _i5.LegacyStatusEndpoint)
                  .isSignedIn(session),
        ),
        'signOutDevice': _i1.MethodConnector(
          name: 'signOutDevice',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyStatus'] as _i5.LegacyStatusEndpoint)
                  .signOutDevice(session),
        ),
        'signOutAllDevices': _i1.MethodConnector(
          name: 'signOutAllDevices',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyStatus'] as _i5.LegacyStatusEndpoint)
                  .signOutAllDevices(session),
        ),
        'getUserInfo': _i1.MethodConnector(
          name: 'getUserInfo',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyStatus'] as _i5.LegacyStatusEndpoint)
                  .getUserInfo(session),
        ),
        'getUserSettingsConfig': _i1.MethodConnector(
          name: 'getUserSettingsConfig',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyStatus'] as _i5.LegacyStatusEndpoint)
                  .getUserSettingsConfig(session),
        ),
      },
    );
    connectors['legacyUser'] = _i1.EndpointConnector(
      name: 'legacyUser',
      endpoint: endpoints['legacyUser']!,
      methodConnectors: {
        'removeUserImage': _i1.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyUser'] as _i6.LegacyUserEndpoint)
                  .removeUserImage(session),
        ),
        'setUserImage': _i1.MethodConnector(
          name: 'setUserImage',
          params: {
            'image': _i1.ParameterDescription(
              name: 'image',
              type: _i1.getType<_i8.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyUser'] as _i6.LegacyUserEndpoint)
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
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyUser'] as _i6.LegacyUserEndpoint)
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
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['legacyUser'] as _i6.LegacyUserEndpoint)
                  .changeFullName(
                    session,
                    params['fullName'],
                  ),
        ),
      },
    );
    connectors['sessionMigration'] = _i1.EndpointConnector(
      name: 'sessionMigration',
      endpoint: endpoints['sessionMigration']!,
      methodConnectors: {
        'convertSession': _i1.MethodConnector(
          name: 'convertSession',
          params: {
            'sessionKey': _i1.ParameterDescription(
              name: 'sessionKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionMigration']
                          as _i7.SessionMigrationEndpoint)
                      .convertSession(
                        session,
                        sessionKey: params['sessionKey'],
                      ),
        ),
      },
    );
    modules['serverpod_auth_core'] = _i9.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i10.Endpoints()
      ..initializeEndpoints(server);
  }
}
