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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../endpoints/legacy_admin_endpoint.dart' as _ipsxdxoh;
import '../endpoints/legacy_email_endpoint.dart' as _id75tg82;
import '../endpoints/legacy_status_endpoint.dart' as _itabijgr;
import '../endpoints/legacy_user_endpoint.dart' as _i3lz1mgs;
import '../endpoints/session_migration_endpoint.dart' as _i85kth1k;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'legacyAdmin': _ipsxdxoh.LegacyAdminEndpoint()
        ..initialize(
          server,
          'legacyAdmin',
          'serverpod_auth_bridge',
        ),
      'legacyEmail': _id75tg82.LegacyEmailEndpoint()
        ..initialize(
          server,
          'legacyEmail',
          'serverpod_auth_bridge',
        ),
      'legacyStatus': _itabijgr.LegacyStatusEndpoint()
        ..initialize(
          server,
          'legacyStatus',
          'serverpod_auth_bridge',
        ),
      'legacyUser': _i3lz1mgs.LegacyUserEndpoint()
        ..initialize(
          server,
          'legacyUser',
          'serverpod_auth_bridge',
        ),
      'sessionMigration': _i85kth1k.SessionMigrationEndpoint()
        ..initialize(
          server,
          'sessionMigration',
          'serverpod_auth_bridge',
        ),
    };
    connectors['legacyAdmin'] = _is.EndpointConnector(
      name: 'legacyAdmin',
      endpoint: endpoints['legacyAdmin']!,
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
                  (endpoints['legacyAdmin'] as _ipsxdxoh.LegacyAdminEndpoint)
                      .getUserInfo(
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
                  (endpoints['legacyAdmin'] as _ipsxdxoh.LegacyAdminEndpoint)
                      .blockUser(
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
                  (endpoints['legacyAdmin'] as _ipsxdxoh.LegacyAdminEndpoint)
                      .unblockUser(
                        session,
                        params['userId'],
                      ),
        ),
      },
    );
    connectors['legacyEmail'] = _is.EndpointConnector(
      name: 'legacyEmail',
      endpoint: endpoints['legacyEmail']!,
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
                  (endpoints['legacyEmail'] as _id75tg82.LegacyEmailEndpoint)
                      .authenticate(
                        session,
                        params['email'],
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
              ) async =>
                  (endpoints['legacyEmail'] as _id75tg82.LegacyEmailEndpoint)
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
                  (endpoints['legacyEmail'] as _id75tg82.LegacyEmailEndpoint)
                      .createAccount(
                        session,
                        params['email'],
                        params['verificationCode'],
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
              ) async =>
                  (endpoints['legacyEmail'] as _id75tg82.LegacyEmailEndpoint)
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
              ) async =>
                  (endpoints['legacyEmail'] as _id75tg82.LegacyEmailEndpoint)
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
                  (endpoints['legacyEmail'] as _id75tg82.LegacyEmailEndpoint)
                      .resetPassword(
                        session,
                        params['verificationCode'],
                        params['password'],
                      ),
        ),
      },
    );
    connectors['legacyStatus'] = _is.EndpointConnector(
      name: 'legacyStatus',
      endpoint: endpoints['legacyStatus']!,
      methodConnectors: {
        'isSignedIn': _is.MethodConnector(
          name: 'isSignedIn',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legacyStatus'] as _itabijgr.LegacyStatusEndpoint)
                      .isSignedIn(session),
        ),
        'signOutDevice': _is.MethodConnector(
          name: 'signOutDevice',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legacyStatus'] as _itabijgr.LegacyStatusEndpoint)
                      .signOutDevice(session),
        ),
        'signOutAllDevices': _is.MethodConnector(
          name: 'signOutAllDevices',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legacyStatus'] as _itabijgr.LegacyStatusEndpoint)
                      .signOutAllDevices(session),
        ),
        'getUserInfo': _is.MethodConnector(
          name: 'getUserInfo',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legacyStatus'] as _itabijgr.LegacyStatusEndpoint)
                      .getUserInfo(session),
        ),
        'getUserSettingsConfig': _is.MethodConnector(
          name: 'getUserSettingsConfig',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legacyStatus'] as _itabijgr.LegacyStatusEndpoint)
                      .getUserSettingsConfig(session),
        ),
      },
    );
    connectors['legacyUser'] = _is.EndpointConnector(
      name: 'legacyUser',
      endpoint: endpoints['legacyUser']!,
      methodConnectors: {
        'removeUserImage': _is.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['legacyUser'] as _i3lz1mgs.LegacyUserEndpoint)
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
                  (endpoints['legacyUser'] as _i3lz1mgs.LegacyUserEndpoint)
                      .setUserImage(
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
                  (endpoints['legacyUser'] as _i3lz1mgs.LegacyUserEndpoint)
                      .changeUserName(
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
                  (endpoints['legacyUser'] as _i3lz1mgs.LegacyUserEndpoint)
                      .changeFullName(
                        session,
                        params['fullName'],
                      ),
        ),
      },
    );
    connectors['sessionMigration'] = _is.EndpointConnector(
      name: 'sessionMigration',
      endpoint: endpoints['sessionMigration']!,
      methodConnectors: {
        'convertSession': _is.MethodConnector(
          name: 'convertSession',
          params: {
            'sessionKey': _is.ParameterDescription(
              name: 'sessionKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionMigration']
                          as _i85kth1k.SessionMigrationEndpoint)
                      .convertSession(
                        session,
                        sessionKey: params['sessionKey'],
                      ),
        ),
      },
    );
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
  }
}
