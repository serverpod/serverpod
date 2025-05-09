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
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as _i3;
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart'
    as _i4;
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart'
    as _i5;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailAccount': _i2.EmailAccountEndpoint()
        ..initialize(
          server,
          'emailAccount',
          'serverpod_auth_email',
        )
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
        'requestAccount': _i1.MethodConnector(
          name: 'requestAccount',
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
                  .requestAccount(
            session,
            email: params['email'],
            password: params['password'],
          ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
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
              (endpoints['emailAccount'] as _i2.EmailAccountEndpoint)
                  .finishRegistration(
            session,
            verificationCode: params['verificationCode'],
          ),
        ),
        'requestPasswordReset': _i1.MethodConnector(
          name: 'requestPasswordReset',
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
                  .requestPasswordReset(
            session,
            email: params['email'],
          ),
        ),
        'completePasswordReset': _i1.MethodConnector(
          name: 'completePasswordReset',
          params: {
            'resetCode': _i1.ParameterDescription(
              name: 'resetCode',
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
                  .completePasswordReset(
            session,
            resetCode: params['resetCode'],
            newPassword: params['newPassword'],
          ),
        ),
      },
    );
    modules['serverpod_auth_email_account'] = _i3.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_profile'] = _i4.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_session'] = _i5.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_user'] = _i6.Endpoints()
      ..initializeEndpoints(server);
  }
}
