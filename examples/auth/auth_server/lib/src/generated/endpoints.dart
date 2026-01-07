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
import '../endpoints/anonymous_idp_endpoint.dart' as _i2;
import '../endpoints/apple_idp_endpoint.dart' as _i3;
import '../endpoints/email_idp_endpoint.dart' as _i4;
import '../endpoints/firebase_idp_endpoint.dart' as _i5;
import '../endpoints/github_idp_endpoint.dart' as _i6;
import '../endpoints/google_idp_endpoint.dart' as _i7;
import '../endpoints/jwt_refresh_endpoint.dart' as _i8;
import '../endpoints/passkey_idp_endpoint.dart' as _i9;
import '../greeting_endpoint.dart' as _i10;
import 'package:auth_server/src/generated/protocol.dart' as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i12;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'anonymousIdp': _i2.AnonymousIdpEndpoint()
        ..initialize(
          server,
          'anonymousIdp',
          null,
        ),
      'appleIdp': _i3.AppleIdpEndpoint()
        ..initialize(
          server,
          'appleIdp',
          null,
        ),
      'emailIdp': _i4.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'firebaseIdp': _i5.FirebaseIdpEndpoint()
        ..initialize(
          server,
          'firebaseIdp',
          null,
        ),
      'gitHubIdp': _i6.GitHubIdpEndpoint()
        ..initialize(
          server,
          'gitHubIdp',
          null,
        ),
      'googleIdp': _i7.GoogleIdpEndpoint()
        ..initialize(
          server,
          'googleIdp',
          null,
        ),
      'refreshJwtTokens': _i8.RefreshJwtTokensEndpoint()
        ..initialize(
          server,
          'refreshJwtTokens',
          null,
        ),
      'passkeyIdp': _i9.PasskeyIdpEndpoint()
        ..initialize(
          server,
          'passkeyIdp',
          null,
        ),
      'greeting': _i10.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['anonymousIdp'] = _i1.EndpointConnector(
      name: 'anonymousIdp',
      endpoint: endpoints['anonymousIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['anonymousIdp'] as _i2.AnonymousIdpEndpoint).login(
                    session,
                    token: params['token'],
                  ),
        ),
      },
    );
    connectors['appleIdp'] = _i1.EndpointConnector(
      name: 'appleIdp',
      endpoint: endpoints['appleIdp']!,
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
              ) async => (endpoints['appleIdp'] as _i3.AppleIdpEndpoint).login(
                session,
                identityToken: params['identityToken'],
                authorizationCode: params['authorizationCode'],
                isNativeApplePlatformSignIn:
                    params['isNativeApplePlatformSignIn'],
                firstName: params['firstName'],
                lastName: params['lastName'],
              ),
        ),
      },
    );
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
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
              ) async => (endpoints['emailIdp'] as _i4.EmailIdpEndpoint).login(
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
              ) async => (endpoints['emailIdp'] as _i4.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i4.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i4.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i4.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i4.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i4.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['firebaseIdp'] = _i1.EndpointConnector(
      name: 'firebaseIdp',
      endpoint: endpoints['firebaseIdp']!,
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
                  (endpoints['firebaseIdp'] as _i5.FirebaseIdpEndpoint).login(
                    session,
                    idToken: params['idToken'],
                  ),
        ),
      },
    );
    connectors['gitHubIdp'] = _i1.EndpointConnector(
      name: 'gitHubIdp',
      endpoint: endpoints['gitHubIdp']!,
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
                  (endpoints['gitHubIdp'] as _i6.GitHubIdpEndpoint).login(
                    session,
                    code: params['code'],
                    codeVerifier: params['codeVerifier'],
                    redirectUri: params['redirectUri'],
                  ),
        ),
      },
    );
    connectors['googleIdp'] = _i1.EndpointConnector(
      name: 'googleIdp',
      endpoint: endpoints['googleIdp']!,
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
                  (endpoints['googleIdp'] as _i7.GoogleIdpEndpoint).login(
                    session,
                    idToken: params['idToken'],
                    accessToken: params['accessToken'],
                  ),
        ),
      },
    );
    connectors['refreshJwtTokens'] = _i1.EndpointConnector(
      name: 'refreshJwtTokens',
      endpoint: endpoints['refreshJwtTokens']!,
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
              ) async =>
                  (endpoints['refreshJwtTokens']
                          as _i8.RefreshJwtTokensEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['passkeyIdp'] = _i1.EndpointConnector(
      name: 'passkeyIdp',
      endpoint: endpoints['passkeyIdp']!,
      methodConnectors: {
        'createChallenge': _i1.MethodConnector(
          name: 'createChallenge',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['passkeyIdp'] as _i9.PasskeyIdpEndpoint)
                  .createChallenge(session)
                  .then((record) => _i11.Protocol().mapRecordToJson(record)),
        ),
        'register': _i1.MethodConnector(
          name: 'register',
          params: {
            'registrationRequest': _i1.ParameterDescription(
              name: 'registrationRequest',
              type: _i1.getType<_i12.PasskeyRegistrationRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyIdp'] as _i9.PasskeyIdpEndpoint).register(
                    session,
                    registrationRequest: params['registrationRequest'],
                  ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'loginRequest': _i1.ParameterDescription(
              name: 'loginRequest',
              type: _i1.getType<_i12.PasskeyLoginRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyIdp'] as _i9.PasskeyIdpEndpoint).login(
                    session,
                    loginRequest: params['loginRequest'],
                  ),
        ),
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
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i10.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i12.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i13.Endpoints()
      ..initializeEndpoints(server);
  }
}
