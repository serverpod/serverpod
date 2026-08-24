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
import 'package:auth_server/src/generated/protocol.dart' as _ickm2fa2;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../endpoints/anonymous_idp_endpoint.dart' as _i6e224xf;
import '../endpoints/apple_idp_endpoint.dart' as _i3mgbwnw;
import '../endpoints/email_idp_endpoint.dart' as _ilutrrxn;
import '../endpoints/facebook_idp_endpoint.dart' as _ieof6ve0;
import '../endpoints/firebase_idp_endpoint.dart' as _illsbti4;
import '../endpoints/github_idp_endpoint.dart' as _iu9ytbxs;
import '../endpoints/google_idp_endpoint.dart' as _iiimk4ot;
import '../endpoints/jwt_refresh_endpoint.dart' as _in48dm4x;
import '../endpoints/microsoft_idp_endpoint.dart' as _iqcwmo15;
import '../endpoints/passkey_idp_endpoint.dart' as _i8m9zwyp;
import '../greeting_endpoint.dart' as _ikvw90o4;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'anonymousIdp': _i6e224xf.AnonymousIdpEndpoint()
        ..initialize(
          server,
          'anonymousIdp',
          null,
        ),
      'appleIdp': _i3mgbwnw.AppleIdpEndpoint()
        ..initialize(
          server,
          'appleIdp',
          null,
        ),
      'emailIdp': _ilutrrxn.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'facebookIdp': _ieof6ve0.FacebookIdpEndpoint()
        ..initialize(
          server,
          'facebookIdp',
          null,
        ),
      'firebaseIdp': _illsbti4.FirebaseIdpEndpoint()
        ..initialize(
          server,
          'firebaseIdp',
          null,
        ),
      'gitHubIdp': _iu9ytbxs.GitHubIdpEndpoint()
        ..initialize(
          server,
          'gitHubIdp',
          null,
        ),
      'googleIdp': _iiimk4ot.GoogleIdpEndpoint()
        ..initialize(
          server,
          'googleIdp',
          null,
        ),
      'refreshJwtTokens': _in48dm4x.RefreshJwtTokensEndpoint()
        ..initialize(
          server,
          'refreshJwtTokens',
          null,
        ),
      'microsoftIdp': _iqcwmo15.MicrosoftIdpEndpoint()
        ..initialize(
          server,
          'microsoftIdp',
          null,
        ),
      'passkeyIdp': _i8m9zwyp.PasskeyIdpEndpoint()
        ..initialize(
          server,
          'passkeyIdp',
          null,
        ),
      'greeting': _ikvw90o4.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['anonymousIdp'] = _is.EndpointConnector(
      name: 'anonymousIdp',
      endpoint: endpoints['anonymousIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['anonymousIdp'] as _i6e224xf.AnonymousIdpEndpoint)
                      .login(
                        session,
                        token: params['token'],
                      ),
        ),
      },
    );
    connectors['appleIdp'] = _is.EndpointConnector(
      name: 'appleIdp',
      endpoint: endpoints['appleIdp']!,
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
                  (endpoints['appleIdp'] as _i3mgbwnw.AppleIdpEndpoint).login(
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
              ) async => (endpoints['appleIdp'] as _i3mgbwnw.AppleIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
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
                  (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint).login(
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
              ) async => (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
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
              ) async => (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['facebookIdp'] = _is.EndpointConnector(
      name: 'facebookIdp',
      endpoint: endpoints['facebookIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'accessToken': _is.ParameterDescription(
              name: 'accessToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['facebookIdp'] as _ieof6ve0.FacebookIdpEndpoint)
                      .login(
                        session,
                        accessToken: params['accessToken'],
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
                  (endpoints['facebookIdp'] as _ieof6ve0.FacebookIdpEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['firebaseIdp'] = _is.EndpointConnector(
      name: 'firebaseIdp',
      endpoint: endpoints['firebaseIdp']!,
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
                  (endpoints['firebaseIdp'] as _illsbti4.FirebaseIdpEndpoint)
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
                  (endpoints['firebaseIdp'] as _illsbti4.FirebaseIdpEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['gitHubIdp'] = _is.EndpointConnector(
      name: 'gitHubIdp',
      endpoint: endpoints['gitHubIdp']!,
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
                  (endpoints['gitHubIdp'] as _iu9ytbxs.GitHubIdpEndpoint).login(
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
              ) async => (endpoints['gitHubIdp'] as _iu9ytbxs.GitHubIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['googleIdp'] = _is.EndpointConnector(
      name: 'googleIdp',
      endpoint: endpoints['googleIdp']!,
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
                  (endpoints['googleIdp'] as _iiimk4ot.GoogleIdpEndpoint).login(
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
              ) async => (endpoints['googleIdp'] as _iiimk4ot.GoogleIdpEndpoint)
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
              ) async => (endpoints['googleIdp'] as _iiimk4ot.GoogleIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['refreshJwtTokens'] = _is.EndpointConnector(
      name: 'refreshJwtTokens',
      endpoint: endpoints['refreshJwtTokens']!,
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
                  (endpoints['refreshJwtTokens']
                          as _in48dm4x.RefreshJwtTokensEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['microsoftIdp'] = _is.EndpointConnector(
      name: 'microsoftIdp',
      endpoint: endpoints['microsoftIdp']!,
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
            'isWebPlatform': _is.ParameterDescription(
              name: 'isWebPlatform',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['microsoftIdp'] as _iqcwmo15.MicrosoftIdpEndpoint)
                      .login(
                        session,
                        code: params['code'],
                        codeVerifier: params['codeVerifier'],
                        redirectUri: params['redirectUri'],
                        isWebPlatform: params['isWebPlatform'],
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
                  (endpoints['microsoftIdp'] as _iqcwmo15.MicrosoftIdpEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['passkeyIdp'] = _is.EndpointConnector(
      name: 'passkeyIdp',
      endpoint: endpoints['passkeyIdp']!,
      methodConnectors: {
        'createChallenge': _is.MethodConnector(
          name: 'createChallenge',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['passkeyIdp'] as _i8m9zwyp.PasskeyIdpEndpoint)
                      .createChallenge(session)
                      .then(
                        (record) =>
                            _ickm2fa2.Protocol().mapRecordToJson(record),
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
                  (endpoints['passkeyIdp'] as _i8m9zwyp.PasskeyIdpEndpoint)
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
                  (endpoints['passkeyIdp'] as _i8m9zwyp.PasskeyIdpEndpoint)
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
                  (endpoints['passkeyIdp'] as _i8m9zwyp.PasskeyIdpEndpoint)
                      .hasAccount(session),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _ikvw90o4.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
