/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;

/// Endpoint for handling authentication via email and password
/// {@category Endpoint}
class EndpointEmail extends _i1.EndpointRef {
  EndpointEmail(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_email_endpoint.email';

  /// Authenticates a user with email and password. Returns an
  /// [AuthenticationResponse] with the users information.
  _i2.Future<_i3.AuthenticationResponse> authenticate(
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<_i3.AuthenticationResponse>(
        'serverpod_auth_email_endpoint.email',
        'authenticate',
        {
          'email': email,
          'password': password,
        },
      );

  /// Changes a users password.
  _i2.Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_email_endpoint.email',
        'changePassword',
        {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

  /// Initiates a password reset and sends an email with the reset code to the
  /// user.
  _i2.Future<bool> initiatePasswordReset(String email) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_email_endpoint.email',
        'initiatePasswordReset',
        {'email': email},
      );

  /// Resets a users password using the reset code.
  _i2.Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_email_endpoint.email',
        'resetPassword',
        {
          'verificationCode': verificationCode,
          'password': password,
        },
      );

  /// Starts the procedure for creating an account by sending an email with
  /// a verification code.
  _i2.Future<bool> createAccountRequest(
    String userName,
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth_email_endpoint.email',
        'createAccountRequest',
        {
          'userName': userName,
          'email': email,
          'password': password,
        },
      );

  /// Creates a new account using a verification code.
  _i2.Future<_i3.UserInfo?> createAccount(
    String email,
    String verificationCode,
  ) =>
      caller.callServerEndpoint<_i3.UserInfo?>(
        'serverpod_auth_email_endpoint.email',
        'createAccount',
        {
          'email': email,
          'verificationCode': verificationCode,
        },
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    email = EndpointEmail(this);
  }

  late final EndpointEmail email;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'serverpod_auth_email_endpoint.email': email};
}
