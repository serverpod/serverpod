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
import '../endpoints/apple_account_endpoint.dart' as _i2;
import '../endpoints/auth_test_endpoint.dart' as _i3;
import '../endpoints/authenticated_streaming_test_endpoint.dart' as _i4;
import '../endpoints/email_account_backwards_compatibility_endpoint.dart'
    as _i5;
import '../endpoints/email_account_endpoint.dart' as _i6;
import '../endpoints/firebase_account_endpoint.dart' as _i7;
import '../endpoints/github_account_endpoint.dart' as _i8;
import '../endpoints/google_account_backwards_compatibility_test_endpoint.dart'
    as _i9;
import '../endpoints/google_account_endpoint.dart' as _i10;
import '../endpoints/jwt_refresh_endpoint.dart' as _i11;
import '../endpoints/passkey_account_endpoint.dart' as _i12;
import '../endpoints/password_importing_email_account_endpoint.dart' as _i13;
import '../endpoints/user_profile_endpoint.dart' as _i14;
import 'package:serverpod_auth_test_server/src/generated/protocol.dart' as _i15;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i16;
import 'dart:typed_data' as _i17;
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart'
    as _i18;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i19;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart'
    as _i20;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i21;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'appleAccount': _i2.AppleAccountEndpoint()
        ..initialize(
          server,
          'appleAccount',
          null,
        ),
      'authTest': _i3.AuthTestEndpoint()
        ..initialize(
          server,
          'authTest',
          null,
        ),
      'authenticatedStreamingTest': _i4.AuthenticatedStreamingTestEndpoint()
        ..initialize(
          server,
          'authenticatedStreamingTest',
          null,
        ),
      'emailAccountBackwardsCompatibilityTest':
          _i5.EmailAccountBackwardsCompatibilityTestEndpoint()..initialize(
            server,
            'emailAccountBackwardsCompatibilityTest',
            null,
          ),
      'emailAccount': _i6.EmailAccountEndpoint()
        ..initialize(
          server,
          'emailAccount',
          null,
        ),
      'firebaseAccount': _i7.FirebaseAccountEndpoint()
        ..initialize(
          server,
          'firebaseAccount',
          null,
        ),
      'gitHubAccount': _i8.GitHubAccountEndpoint()
        ..initialize(
          server,
          'gitHubAccount',
          null,
        ),
      'googleAccountBackwardsCompatibilityTest':
          _i9.GoogleAccountBackwardsCompatibilityTestEndpoint()..initialize(
            server,
            'googleAccountBackwardsCompatibilityTest',
            null,
          ),
      'googleAccount': _i10.GoogleAccountEndpoint()
        ..initialize(
          server,
          'googleAccount',
          null,
        ),
      'jwtRefresh': _i11.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'passkeyAccount': _i12.PasskeyAccountEndpoint()
        ..initialize(
          server,
          'passkeyAccount',
          null,
        ),
      'passwordImportingEmailAccount':
          _i13.PasswordImportingEmailAccountEndpoint()..initialize(
            server,
            'passwordImportingEmailAccount',
            null,
          ),
      'userProfile': _i14.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
    };
    connectors['appleAccount'] = _i1.EndpointConnector(
      name: 'appleAccount',
      endpoint: endpoints['appleAccount']!,
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appleAccount'] as _i2.AppleAccountEndpoint).login(
                    session,
                    identityToken: params['identityToken'],
                    authorizationCode: params['authorizationCode'],
                    isNativeApplePlatformSignIn:
                        params['isNativeApplePlatformSignIn'],
                    firstName: params['firstName'],
                    lastName: params['lastName'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['appleAccount'] as _i2.AppleAccountEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['authTest'] = _i1.EndpointConnector(
      name: 'authTest',
      endpoint: endpoints['authTest']!,
      methodConnectors: {
        'createTestUser': _i1.MethodConnector(
          name: 'createTestUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _i3.AuthTestEndpoint)
                  .createTestUser(session),
        ),
        'createSasToken': _i1.MethodConnector(
          name: 'createSasToken',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _i3.AuthTestEndpoint)
                  .createSasToken(
                    session,
                    params['authUserId'],
                  ),
        ),
        'deleteSasTokens': _i1.MethodConnector(
          name: 'deleteSasTokens',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _i3.AuthTestEndpoint)
                  .deleteSasTokens(
                    session,
                    params['authUserId'],
                  ),
        ),
        'createJwtToken': _i1.MethodConnector(
          name: 'createJwtToken',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _i3.AuthTestEndpoint)
                  .createJwtToken(
                    session,
                    params['authUserId'],
                  ),
        ),
        'deleteJwtRefreshTokens': _i1.MethodConnector(
          name: 'deleteJwtRefreshTokens',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _i3.AuthTestEndpoint)
                  .deleteJwtRefreshTokens(
                    session,
                    params['authUserId'],
                  ),
        ),
        'destroySpecificRefreshToken': _i1.MethodConnector(
          name: 'destroySpecificRefreshToken',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _i3.AuthTestEndpoint)
                  .destroySpecificRefreshToken(
                    session,
                    params['token'],
                  ),
        ),
        'checkSession': _i1.MethodConnector(
          name: 'checkSession',
          params: {
            'authUserId': _i1.ParameterDescription(
              name: 'authUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authTest'] as _i3.AuthTestEndpoint).checkSession(
                    session,
                    params['authUserId'],
                  ),
        ),
      },
    );
    connectors['authenticatedStreamingTest'] = _i1.EndpointConnector(
      name: 'authenticatedStreamingTest',
      endpoint: endpoints['authenticatedStreamingTest']!,
      methodConnectors: {
        'openAuthenticatedStream': _i1.MethodStreamConnector(
          name: 'openAuthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedStreamingTest']
                          as _i4.AuthenticatedStreamingTestEndpoint)
                      .openAuthenticatedStream(session),
        ),
      },
    );
    connectors['emailAccountBackwardsCompatibilityTest'] = _i1.EndpointConnector(
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _i5.EmailAccountBackwardsCompatibilityTestEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _i5.EmailAccountBackwardsCompatibilityTestEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _i5.EmailAccountBackwardsCompatibilityTestEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _i5.EmailAccountBackwardsCompatibilityTestEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _i5.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .deleteLegacyAuthData(
                        session,
                        userId: params['userId'],
                      ),
        ),
        'sessionUserIdentifier': _i1.MethodConnector(
          name: 'sessionUserIdentifier',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _i5.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .sessionUserIdentifier(session),
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _i5.EmailAccountBackwardsCompatibilityTestEndpoint)
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccount'] as _i6.EmailAccountEndpoint).login(
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailAccount'] as _i6.EmailAccountEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
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
              ) async => (endpoints['emailAccount'] as _i6.EmailAccountEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
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
              ) async => (endpoints['emailAccount'] as _i6.EmailAccountEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
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
              ) async => (endpoints['emailAccount'] as _i6.EmailAccountEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
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
              ) async => (endpoints['emailAccount'] as _i6.EmailAccountEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
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
              ) async => (endpoints['emailAccount'] as _i6.EmailAccountEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailAccount'] as _i6.EmailAccountEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['firebaseAccount'] = _i1.EndpointConnector(
      name: 'firebaseAccount',
      endpoint: endpoints['firebaseAccount']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
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
              ) async =>
                  (endpoints['firebaseAccount'] as _i7.FirebaseAccountEndpoint)
                      .login(
                        session,
                        idToken: params['idToken'],
                      ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['firebaseAccount'] as _i7.FirebaseAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['gitHubAccount'] = _i1.EndpointConnector(
      name: 'gitHubAccount',
      endpoint: endpoints['gitHubAccount']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'codeVerifier': _i1.ParameterDescription(
              name: 'codeVerifier',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _i1.ParameterDescription(
              name: 'redirectUri',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['gitHubAccount'] as _i8.GitHubAccountEndpoint)
                      .login(
                        session,
                        code: params['code'],
                        codeVerifier: params['codeVerifier'],
                        redirectUri: params['redirectUri'],
                      ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['gitHubAccount'] as _i8.GitHubAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['googleAccountBackwardsCompatibilityTest'] = _i1.EndpointConnector(
      name: 'googleAccountBackwardsCompatibilityTest',
      endpoint: endpoints['googleAccountBackwardsCompatibilityTest']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'accessToken': _i1.ParameterDescription(
              name: 'accessToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccountBackwardsCompatibilityTest']
                          as _i9.GoogleAccountBackwardsCompatibilityTestEndpoint)
                      .login(
                        session,
                        idToken: params['idToken'],
                        accessToken: params['accessToken'],
                      ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccountBackwardsCompatibilityTest']
                          as _i9.GoogleAccountBackwardsCompatibilityTestEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['googleAccount'] = _i1.EndpointConnector(
      name: 'googleAccount',
      endpoint: endpoints['googleAccount']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'accessToken': _i1.ParameterDescription(
              name: 'accessToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccount'] as _i10.GoogleAccountEndpoint)
                      .login(
                        session,
                        idToken: params['idToken'],
                        accessToken: params['accessToken'],
                      ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccount'] as _i10.GoogleAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i11.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['passkeyAccount'] = _i1.EndpointConnector(
      name: 'passkeyAccount',
      endpoint: endpoints['passkeyAccount']!,
      methodConnectors: {
        'createChallenge': _i1.MethodConnector(
          name: 'createChallenge',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount'] as _i12.PasskeyAccountEndpoint)
                      .createChallenge(session)
                      .then(
                        (record) => _i15.Protocol().mapRecordToJson(record),
                      ),
        ),
        'register': _i1.MethodConnector(
          name: 'register',
          params: {
            'registrationRequest': _i1.ParameterDescription(
              name: 'registrationRequest',
              type: _i1.getType<_i16.PasskeyRegistrationRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount'] as _i12.PasskeyAccountEndpoint)
                      .register(
                        session,
                        registrationRequest: params['registrationRequest'],
                      ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'loginRequest': _i1.ParameterDescription(
              name: 'loginRequest',
              type: _i1.getType<_i16.PasskeyLoginRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount'] as _i12.PasskeyAccountEndpoint)
                      .login(
                        session,
                        loginRequest: params['loginRequest'],
                      ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount'] as _i12.PasskeyAccountEndpoint)
                      .hasAccount(session),
        ),
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
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
                      .startRegistration(
                        session,
                        email: params['email'],
                      ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
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
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
                      .verifyRegistrationCode(
                        session,
                        accountRequestId: params['accountRequestId'],
                        verificationCode: params['verificationCode'],
                      ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
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
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
                      .finishRegistration(
                        session,
                        registrationToken: params['registrationToken'],
                        password: params['password'],
                      ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
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
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
                      .startPasswordReset(
                        session,
                        email: params['email'],
                      ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
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
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
                      .verifyPasswordResetCode(
                        session,
                        passwordResetRequestId:
                            params['passwordResetRequestId'],
                        verificationCode: params['verificationCode'],
                      ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
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
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
                      .finishPasswordReset(
                        session,
                        finishPasswordResetToken:
                            params['finishPasswordResetToken'],
                        newPassword: params['newPassword'],
                      ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i13.PasswordImportingEmailAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['userProfile'] = _i1.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'removeUserImage': _i1.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i14.UserProfileEndpoint)
                  .removeUserImage(session),
        ),
        'setUserImage': _i1.MethodConnector(
          name: 'setUserImage',
          params: {
            'image': _i1.ParameterDescription(
              name: 'image',
              type: _i1.getType<_i17.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i14.UserProfileEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i14.UserProfileEndpoint)
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i14.UserProfileEndpoint)
                  .changeFullName(
                    session,
                    params['fullName'],
                  ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i14.UserProfileEndpoint)
                  .get(session),
        ),
      },
    );
    modules['serverpod_auth_bridge'] = _i18.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i19.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i16.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_migration'] = _i20.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i21.Endpoints()..initializeEndpoints(server);
  }
}
