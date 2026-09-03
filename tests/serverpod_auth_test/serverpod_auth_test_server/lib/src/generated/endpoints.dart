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
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart'
    as _iabs;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart'
    as _iams;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import 'package:serverpod_auth_test_server/src/generated/protocol.dart'
    as _ik2mg1i3;
import '../endpoints/apple_account_endpoint.dart' as _icrxlub7;
import '../endpoints/auth_test_endpoint.dart' as _ippcuuzn;
import '../endpoints/authenticated_streaming_test_endpoint.dart' as _iuowvgje;
import '../endpoints/email_account_backwards_compatibility_endpoint.dart'
    as _ixnayu92;
import '../endpoints/email_account_endpoint.dart' as _i58d5kqa;
import '../endpoints/firebase_account_endpoint.dart' as _i2sxdj8m;
import '../endpoints/github_account_endpoint.dart' as _ibkfnws8;
import '../endpoints/google_account_backwards_compatibility_test_endpoint.dart'
    as _in3qgg3o;
import '../endpoints/google_account_endpoint.dart' as _igz0k8y8;
import '../endpoints/jwt_refresh_endpoint.dart' as _in48dm4x;
import '../endpoints/passkey_account_endpoint.dart' as _ihtup2gw;
import '../endpoints/password_importing_email_account_endpoint.dart'
    as _i728np9q;
import '../endpoints/user_profile_endpoint.dart' as _i5r4pchv;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'appleAccount': _icrxlub7.AppleAccountEndpoint()
        ..initialize(
          server,
          'appleAccount',
          null,
        ),
      'authTest': _ippcuuzn.AuthTestEndpoint()
        ..initialize(
          server,
          'authTest',
          null,
        ),
      'unauthenticatedRequireLoginAuthTest':
          _ippcuuzn.UnauthenticatedRequireLoginAuthTestEndpoint()..initialize(
            server,
            'unauthenticatedRequireLoginAuthTest',
            null,
          ),
      'authenticatedStreamingTest':
          _iuowvgje.AuthenticatedStreamingTestEndpoint()..initialize(
            server,
            'authenticatedStreamingTest',
            null,
          ),
      'emailAccountBackwardsCompatibilityTest':
          _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint()
            ..initialize(
              server,
              'emailAccountBackwardsCompatibilityTest',
              null,
            ),
      'emailAccount': _i58d5kqa.EmailAccountEndpoint()
        ..initialize(
          server,
          'emailAccount',
          null,
        ),
      'firebaseAccount': _i2sxdj8m.FirebaseAccountEndpoint()
        ..initialize(
          server,
          'firebaseAccount',
          null,
        ),
      'gitHubAccount': _ibkfnws8.GitHubAccountEndpoint()
        ..initialize(
          server,
          'gitHubAccount',
          null,
        ),
      'googleAccountBackwardsCompatibilityTest':
          _in3qgg3o.GoogleAccountBackwardsCompatibilityTestEndpoint()
            ..initialize(
              server,
              'googleAccountBackwardsCompatibilityTest',
              null,
            ),
      'googleAccount': _igz0k8y8.GoogleAccountEndpoint()
        ..initialize(
          server,
          'googleAccount',
          null,
        ),
      'jwtRefresh': _in48dm4x.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'passkeyAccount': _ihtup2gw.PasskeyAccountEndpoint()
        ..initialize(
          server,
          'passkeyAccount',
          null,
        ),
      'passwordImportingEmailAccount':
          _i728np9q.PasswordImportingEmailAccountEndpoint()..initialize(
            server,
            'passwordImportingEmailAccount',
            null,
          ),
      'userProfile': _i5r4pchv.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
    };
    connectors['appleAccount'] = _is.EndpointConnector(
      name: 'appleAccount',
      endpoint: endpoints['appleAccount']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'identityToken': _is.ParameterDescription(
              name: 'identityToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'authorizationCode': _is.ParameterDescription(
              name: 'authorizationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'isNativeApplePlatformSignIn': _is.ParameterDescription(
              name: 'isNativeApplePlatformSignIn',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'firstName': _is.ParameterDescription(
              name: 'firstName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'lastName': _is.ParameterDescription(
              name: 'lastName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appleAccount'] as _icrxlub7.AppleAccountEndpoint)
                      .login(
                        session,
                        identityToken: params['identityToken'],
                        authorizationCode: params['authorizationCode'],
                        isNativeApplePlatformSignIn:
                            params['isNativeApplePlatformSignIn'],
                        firstName: params['firstName'],
                        lastName: params['lastName'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appleAccount'] as _icrxlub7.AppleAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['authTest'] = _is.EndpointConnector(
      name: 'authTest',
      endpoint: endpoints['authTest']!,
      methodConnectors: {
        'createTestUser': _is.MethodConnector(
          name: 'createTestUser',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .createTestUser(session),
        ),
        'createSasToken': _is.MethodConnector(
          name: 'createSasToken',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .createSasToken(
                    session,
                    params['authUserId'],
                  ),
        ),
        'deleteSasTokens': _is.MethodConnector(
          name: 'deleteSasTokens',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .deleteSasTokens(
                    session,
                    params['authUserId'],
                  ),
        ),
        'createJwtToken': _is.MethodConnector(
          name: 'createJwtToken',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .createJwtToken(
                    session,
                    params['authUserId'],
                  ),
        ),
        'deleteJwtRefreshTokens': _is.MethodConnector(
          name: 'deleteJwtRefreshTokens',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .deleteJwtRefreshTokens(
                    session,
                    params['authUserId'],
                  ),
        ),
        'destroySpecificRefreshToken': _is.MethodConnector(
          name: 'destroySpecificRefreshToken',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .destroySpecificRefreshToken(
                    session,
                    params['token'],
                  ),
        ),
        'checkSession': _is.MethodConnector(
          name: 'checkSession',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .checkSession(
                    session,
                    params['authUserId'],
                  ),
        ),
        'checkSessionUnauthenticated': _is.MethodConnector(
          name: 'checkSessionUnauthenticated',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .checkSessionUnauthenticated(session),
        ),
        'resetJwtRefreshConcurrency': _is.MethodConnector(
          name: 'resetJwtRefreshConcurrency',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .resetJwtRefreshConcurrency(session),
        ),
        'getMaxConcurrentJwtRefreshes': _is.MethodConnector(
          name: 'getMaxConcurrentJwtRefreshes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .getMaxConcurrentJwtRefreshes(session),
        ),
        'getJwtRefreshCallCount': _is.MethodConnector(
          name: 'getJwtRefreshCallCount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .getJwtRefreshCallCount(session),
        ),
        'getReceivedAuthHeaders': _is.MethodConnector(
          name: 'getReceivedAuthHeaders',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .getReceivedAuthHeaders(session),
        ),
        'getReceivedAuthHeadersUnauthenticated': _is.MethodConnector(
          name: 'getReceivedAuthHeadersUnauthenticated',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .getReceivedAuthHeadersUnauthenticated(session),
        ),
        'checkSessionUnauthenticatedStream': _is.MethodStreamConnector(
          name: 'checkSessionUnauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .checkSessionUnauthenticatedStream(session),
        ),
        'openPublicUserStream': _is.MethodStreamConnector(
          name: 'openPublicUserStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['authTest'] as _ippcuuzn.AuthTestEndpoint)
                  .openPublicUserStream(session),
        ),
      },
    );
    connectors['unauthenticatedRequireLoginAuthTest'] = _is.EndpointConnector(
      name: 'unauthenticatedRequireLoginAuthTest',
      endpoint: endpoints['unauthenticatedRequireLoginAuthTest']!,
      methodConnectors: {
        'call': _is.MethodConnector(
          name: 'call',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['unauthenticatedRequireLoginAuthTest']
                          as _ippcuuzn.UnauthenticatedRequireLoginAuthTestEndpoint)
                      .call(session),
        ),
      },
    );
    connectors['authenticatedStreamingTest'] = _is.EndpointConnector(
      name: 'authenticatedStreamingTest',
      endpoint: endpoints['authenticatedStreamingTest']!,
      methodConnectors: {
        'openAuthenticatedStream': _is.MethodStreamConnector(
          name: 'openAuthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedStreamingTest']
                          as _iuowvgje.AuthenticatedStreamingTestEndpoint)
                      .openAuthenticatedStream(session),
        ),
        'watchAuthenticatedUserId': _is.MethodStreamConnector(
          name: 'watchAuthenticatedUserId',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['authenticatedStreamingTest']
                          as _iuowvgje.AuthenticatedStreamingTestEndpoint)
                      .watchAuthenticatedUserId(session),
        ),
      },
    );
    connectors['emailAccountBackwardsCompatibilityTest'] = _is.EndpointConnector(
      name: 'emailAccountBackwardsCompatibilityTest',
      endpoint: endpoints['emailAccountBackwardsCompatibilityTest']!,
      methodConnectors: {
        'createLegacyUser': _is.MethodConnector(
          name: 'createLegacyUser',
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
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .createLegacyUser(
                        session,
                        email: params['email'],
                        password: params['password'],
                      ),
        ),
        'createLegacySession': _is.MethodConnector(
          name: 'createLegacySession',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'scopes': _is.ParameterDescription(
              name: 'scopes',
              type: _is.getType<Set<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .createLegacySession(
                        session,
                        userId: params['userId'],
                        scopes: params['scopes'],
                      ),
        ),
        'migrateUser': _is.MethodConnector(
          name: 'migrateUser',
          params: {
            'legacyUserId': _is.ParameterDescription(
              name: 'legacyUserId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .migrateUser(
                        session,
                        legacyUserId: params['legacyUserId'],
                        password: params['password'],
                      ),
        ),
        'getNewAuthUserId': _is.MethodConnector(
          name: 'getNewAuthUserId',
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
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .getNewAuthUserId(
                        session,
                        userId: params['userId'],
                      ),
        ),
        'deleteLegacyAuthData': _is.MethodConnector(
          name: 'deleteLegacyAuthData',
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
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .deleteLegacyAuthData(
                        session,
                        userId: params['userId'],
                      ),
        ),
        'sessionUserIdentifier': _is.MethodConnector(
          name: 'sessionUserIdentifier',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .sessionUserIdentifier(session),
        ),
        'checkLegacyPassword': _is.MethodConnector(
          name: 'checkLegacyPassword',
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
                  (endpoints['emailAccountBackwardsCompatibilityTest']
                          as _ixnayu92.EmailAccountBackwardsCompatibilityTestEndpoint)
                      .checkLegacyPassword(
                        session,
                        email: params['email'],
                        password: params['password'],
                      ),
        ),
      },
    );
    connectors['emailAccount'] = _is.EndpointConnector(
      name: 'emailAccount',
      endpoint: endpoints['emailAccount']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
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
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .login(
                        session,
                        email: params['email'],
                        password: params['password'],
                      ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
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
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .startRegistration(
                        session,
                        email: params['email'],
                      ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
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
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .verifyRegistrationCode(
                        session,
                        accountRequestId: params['accountRequestId'],
                        verificationCode: params['verificationCode'],
                      ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
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
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .finishRegistration(
                        session,
                        registrationToken: params['registrationToken'],
                        password: params['password'],
                      ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
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
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .startPasswordReset(
                        session,
                        email: params['email'],
                      ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
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
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .verifyPasswordResetCode(
                        session,
                        passwordResetRequestId:
                            params['passwordResetRequestId'],
                        verificationCode: params['verificationCode'],
                      ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
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
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .finishPasswordReset(
                        session,
                        finishPasswordResetToken:
                            params['finishPasswordResetToken'],
                        newPassword: params['newPassword'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailAccount'] as _i58d5kqa.EmailAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['firebaseAccount'] = _is.EndpointConnector(
      name: 'firebaseAccount',
      endpoint: endpoints['firebaseAccount']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
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
              ) async =>
                  (endpoints['firebaseAccount']
                          as _i2sxdj8m.FirebaseAccountEndpoint)
                      .login(
                        session,
                        idToken: params['idToken'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['firebaseAccount']
                          as _i2sxdj8m.FirebaseAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['gitHubAccount'] = _is.EndpointConnector(
      name: 'gitHubAccount',
      endpoint: endpoints['gitHubAccount']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'codeVerifier': _is.ParameterDescription(
              name: 'codeVerifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _is.ParameterDescription(
              name: 'redirectUri',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['gitHubAccount']
                          as _ibkfnws8.GitHubAccountEndpoint)
                      .login(
                        session,
                        code: params['code'],
                        codeVerifier: params['codeVerifier'],
                        redirectUri: params['redirectUri'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['gitHubAccount']
                          as _ibkfnws8.GitHubAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['googleAccountBackwardsCompatibilityTest'] = _is.EndpointConnector(
      name: 'googleAccountBackwardsCompatibilityTest',
      endpoint: endpoints['googleAccountBackwardsCompatibilityTest']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'idToken': _is.ParameterDescription(
              name: 'idToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'accessToken': _is.ParameterDescription(
              name: 'accessToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccountBackwardsCompatibilityTest']
                          as _in3qgg3o.GoogleAccountBackwardsCompatibilityTestEndpoint)
                      .login(
                        session,
                        idToken: params['idToken'],
                        accessToken: params['accessToken'],
                      ),
        ),
        'loginWithCode': _is.MethodConnector(
          name: 'loginWithCode',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'codeVerifier': _is.ParameterDescription(
              name: 'codeVerifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _is.ParameterDescription(
              name: 'redirectUri',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccountBackwardsCompatibilityTest']
                          as _in3qgg3o.GoogleAccountBackwardsCompatibilityTestEndpoint)
                      .loginWithCode(
                        session,
                        code: params['code'],
                        codeVerifier: params['codeVerifier'],
                        redirectUri: params['redirectUri'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccountBackwardsCompatibilityTest']
                          as _in3qgg3o.GoogleAccountBackwardsCompatibilityTestEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['googleAccount'] = _is.EndpointConnector(
      name: 'googleAccount',
      endpoint: endpoints['googleAccount']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'idToken': _is.ParameterDescription(
              name: 'idToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'accessToken': _is.ParameterDescription(
              name: 'accessToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccount']
                          as _igz0k8y8.GoogleAccountEndpoint)
                      .login(
                        session,
                        idToken: params['idToken'],
                        accessToken: params['accessToken'],
                      ),
        ),
        'loginWithCode': _is.MethodConnector(
          name: 'loginWithCode',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'codeVerifier': _is.ParameterDescription(
              name: 'codeVerifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'redirectUri': _is.ParameterDescription(
              name: 'redirectUri',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccount']
                          as _igz0k8y8.GoogleAccountEndpoint)
                      .loginWithCode(
                        session,
                        code: params['code'],
                        codeVerifier: params['codeVerifier'],
                        redirectUri: params['redirectUri'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleAccount']
                          as _igz0k8y8.GoogleAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _in48dm4x.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['passkeyAccount'] = _is.EndpointConnector(
      name: 'passkeyAccount',
      endpoint: endpoints['passkeyAccount']!,
      methodConnectors: {
        'createChallenge': _is.MethodConnector(
          name: 'createChallenge',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount']
                          as _ihtup2gw.PasskeyAccountEndpoint)
                      .createChallenge(session)
                      .then(
                        (record) =>
                            _ik2mg1i3.Protocol().mapRecordToJson(record),
                      ),
        ),
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'registrationRequest': _is.ParameterDescription(
              name: 'registrationRequest',
              type: _is.getType<_iais.PasskeyRegistrationRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount']
                          as _ihtup2gw.PasskeyAccountEndpoint)
                      .register(
                        session,
                        registrationRequest: params['registrationRequest'],
                      ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'loginRequest': _is.ParameterDescription(
              name: 'loginRequest',
              type: _is.getType<_iais.PasskeyLoginRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount']
                          as _ihtup2gw.PasskeyAccountEndpoint)
                      .login(
                        session,
                        loginRequest: params['loginRequest'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyAccount']
                          as _ihtup2gw.PasskeyAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['passwordImportingEmailAccount'] = _is.EndpointConnector(
      name: 'passwordImportingEmailAccount',
      endpoint: endpoints['passwordImportingEmailAccount']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
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
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .login(
                        session,
                        email: params['email'],
                        password: params['password'],
                      ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
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
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .startRegistration(
                        session,
                        email: params['email'],
                      ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
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
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .verifyRegistrationCode(
                        session,
                        accountRequestId: params['accountRequestId'],
                        verificationCode: params['verificationCode'],
                      ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
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
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .finishRegistration(
                        session,
                        registrationToken: params['registrationToken'],
                        password: params['password'],
                      ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
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
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .startPasswordReset(
                        session,
                        email: params['email'],
                      ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
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
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .verifyPasswordResetCode(
                        session,
                        passwordResetRequestId:
                            params['passwordResetRequestId'],
                        verificationCode: params['verificationCode'],
                      ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
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
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .finishPasswordReset(
                        session,
                        finishPasswordResetToken:
                            params['finishPasswordResetToken'],
                        newPassword: params['newPassword'],
                      ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passwordImportingEmailAccount']
                          as _i728np9q.PasswordImportingEmailAccountEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['userProfile'] = _is.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'removeUserImage': _is.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfile'] as _i5r4pchv.UserProfileEndpoint)
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
                  (endpoints['userProfile'] as _i5r4pchv.UserProfileEndpoint)
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
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfile'] as _i5r4pchv.UserProfileEndpoint)
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
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfile'] as _i5r4pchv.UserProfileEndpoint)
                      .changeFullName(
                        session,
                        params['fullName'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfile'] as _i5r4pchv.UserProfileEndpoint)
                      .get(session),
        ),
      },
    );
    modules['serverpod_auth_bridge'] = _iabs.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_migration'] = _iams.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i1n3uhu0.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  Future<void> onStartup(_is.Session session) async {
    await modules['serverpod_auth']!.onStartup(session);
    await modules['serverpod_auth_bridge']!.onStartup(session);
    await modules['serverpod_auth_core']!.onStartup(session);
    await modules['serverpod_auth_idp']!.onStartup(session);
    await modules['serverpod_auth_migration']!.onStartup(session);
  }
}
