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
import '../endpoints/email_account_backwards_compatibility_endpoint.dart'
    as _i2;
import '../endpoints/email_account_endpoint.dart' as _i3;
import '../endpoints/google_account_backwards_compatibility_test_endpoint.dart'
    as _i4;
import '../endpoints/google_account_endpoint.dart' as _i5;
import '../endpoints/password_importing_email_account_endpoint.dart' as _i6;
import '../endpoints/session_test_endpoint.dart' as _i7;
import '../endpoints/user_profile_endpoint.dart' as _i8;
import 'package:uuid/uuid_value.dart' as _i9;
import 'dart:typed_data' as _i10;
import 'package:serverpod_auth_backwards_compatibility_server/serverpod_auth_backwards_compatibility_server.dart'
    as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i12;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart'
    as _i13;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i14;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i15;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailAccountBackwardsCompatibilityTest':
          _i2.EmailAccountBackwardsCompatibilityTestEndpoint()
            ..initialize(
              server,
              'emailAccountBackwardsCompatibilityTest',
              null,
            ),
      'emailAccount': _i3.EmailAccountEndpoint()
        ..initialize(
          server,
          'emailAccount',
          null,
        ),
      'googleAccountBackwardsCompatibilityTest':
          _i4.GoogleAccountBackwardsCompatibilityTestEndpoint()
            ..initialize(
              server,
              'googleAccountBackwardsCompatibilityTest',
              null,
            ),
      'googleAccount': _i5.GoogleAccountEndpoint()
        ..initialize(
          server,
          'googleAccount',
          null,
        ),
      'passwordImportingEmailAccount':
          _i6.PasswordImportingEmailAccountEndpoint()
            ..initialize(
              server,
              'passwordImportingEmailAccount',
              null,
            ),
      'sessionTest': _i7.SessionTestEndpoint()
        ..initialize(
          server,
          'sessionTest',
          null,
        ),
      'userProfile': _i8.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
    };
    connectors['emailAccountBackwardsCompatibilityTest'] =
        _i1.EndpointConnector(
      name: 'emailAccountBackwardsCompatibilityTest',
      endpoint: endpoints['emailAccountBackwardsCompatibilityTest']!,
      methodConnectors: {
        'createLegacyUser': _i1.MethodConnector(
          name: 'createLegacyUser',
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
              (endpoints['emailAccountBackwardsCompatibilityTest']
                      as _i2.EmailAccountBackwardsCompatibilityTestEndpoint)
                  .createLegacyUser(
            session,
            email: params['email'],
            password: params['password'],
          ),
        ),
        'createLegacySession': _i1.MethodConnector(
          name: 'createLegacySession',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'scopes': _i1.ParameterDescription(
              name: 'scopes',
              type: _i1.getType<Set<String>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['emailAccountBackwardsCompatibilityTest']
                      as _i2.EmailAccountBackwardsCompatibilityTestEndpoint)
                  .createLegacySession(
            session,
            userId: params['userId'],
            scopes: params['scopes'],
          ),
        ),
        'migrateUser': _i1.MethodConnector(
          name: 'migrateUser',
          params: {
            'legacyUserId': _i1.ParameterDescription(
              name: 'legacyUserId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['emailAccountBackwardsCompatibilityTest']
                      as _i2.EmailAccountBackwardsCompatibilityTestEndpoint)
                  .migrateUser(
            session,
            legacyUserId: params['legacyUserId'],
            password: params['password'],
          ),
        ),
        'getNewAuthUserId': _i1.MethodConnector(
          name: 'getNewAuthUserId',
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
              (endpoints['emailAccountBackwardsCompatibilityTest']
                      as _i2.EmailAccountBackwardsCompatibilityTestEndpoint)
                  .getNewAuthUserId(
            session,
            userId: params['userId'],
          ),
        ),
        'deleteLegacyAuthData': _i1.MethodConnector(
          name: 'deleteLegacyAuthData',
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
              (endpoints['emailAccountBackwardsCompatibilityTest']
                      as _i2.EmailAccountBackwardsCompatibilityTestEndpoint)
                  .deleteLegacyAuthData(
            session,
            userId: params['userId'],
          ),
        ),
        'sessionUserIdentifer': _i1.MethodConnector(
          name: 'sessionUserIdentifer',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['emailAccountBackwardsCompatibilityTest']
                      as _i2.EmailAccountBackwardsCompatibilityTestEndpoint)
                  .sessionUserIdentifer(session),
        ),
        'checkLegacyPassword': _i1.MethodConnector(
          name: 'checkLegacyPassword',
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
              (endpoints['emailAccountBackwardsCompatibilityTest']
                      as _i2.EmailAccountBackwardsCompatibilityTestEndpoint)
                  .checkLegacyPassword(
            session,
            email: params['email'],
            password: params['password'],
          ),
        ),
      },
    );
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
              (endpoints['emailAccount'] as _i3.EmailAccountEndpoint).login(
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
              (endpoints['emailAccount'] as _i3.EmailAccountEndpoint)
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
              type: _i1.getType<_i9.UuidValue>(),
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
              (endpoints['emailAccount'] as _i3.EmailAccountEndpoint)
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
              (endpoints['emailAccount'] as _i3.EmailAccountEndpoint)
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
              type: _i1.getType<_i9.UuidValue>(),
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
              (endpoints['emailAccount'] as _i3.EmailAccountEndpoint)
                  .finishPasswordReset(
            session,
            passwordResetRequestId: params['passwordResetRequestId'],
            verificationCode: params['verificationCode'],
            newPassword: params['newPassword'],
          ),
        ),
      },
    );
    connectors['googleAccountBackwardsCompatibilityTest'] =
        _i1.EndpointConnector(
      name: 'googleAccountBackwardsCompatibilityTest',
      endpoint: endpoints['googleAccountBackwardsCompatibilityTest']!,
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
              (endpoints['googleAccountBackwardsCompatibilityTest']
                      as _i4.GoogleAccountBackwardsCompatibilityTestEndpoint)
                  .authenticate(
            session,
            idToken: params['idToken'],
          ),
        )
      },
    );
    connectors['googleAccount'] = _i1.EndpointConnector(
      name: 'googleAccount',
      endpoint: endpoints['googleAccount']!,
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
              (endpoints['googleAccount'] as _i5.GoogleAccountEndpoint)
                  .authenticate(
            session,
            idToken: params['idToken'],
          ),
        )
      },
    );
    connectors['passwordImportingEmailAccount'] = _i1.EndpointConnector(
      name: 'passwordImportingEmailAccount',
      endpoint: endpoints['passwordImportingEmailAccount']!,
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
              (endpoints['passwordImportingEmailAccount']
                      as _i6.PasswordImportingEmailAccountEndpoint)
                  .login(
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
              (endpoints['passwordImportingEmailAccount']
                      as _i6.PasswordImportingEmailAccountEndpoint)
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
              type: _i1.getType<_i9.UuidValue>(),
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
              (endpoints['passwordImportingEmailAccount']
                      as _i6.PasswordImportingEmailAccountEndpoint)
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
              (endpoints['passwordImportingEmailAccount']
                      as _i6.PasswordImportingEmailAccountEndpoint)
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
              type: _i1.getType<_i9.UuidValue>(),
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
              (endpoints['passwordImportingEmailAccount']
                      as _i6.PasswordImportingEmailAccountEndpoint)
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
              (endpoints['sessionTest'] as _i7.SessionTestEndpoint)
                  .createTestUser(session),
        ),
        'createSession': _i1.MethodConnector(
          name: 'createSession',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i9.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionTest'] as _i7.SessionTestEndpoint)
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
              type: _i1.getType<_i9.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['sessionTest'] as _i7.SessionTestEndpoint)
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
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .get(session),
        ),
        'removeUserImage': _i1.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .removeUserImage(session),
        ),
        'setUserImage': _i1.MethodConnector(
          name: 'setUserImage',
          params: {
            'image': _i1.ParameterDescription(
              name: 'image',
              type: _i1.getType<_i10.ByteData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
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
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
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
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .changeFullName(
            session,
            params['fullName'],
          ),
        ),
      },
    );
    modules['serverpod_auth_backwards_compatibility'] = _i11.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i12.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_migration'] = _i13.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i14.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i15.Endpoints()..initializeEndpoints(server);
  }
}
