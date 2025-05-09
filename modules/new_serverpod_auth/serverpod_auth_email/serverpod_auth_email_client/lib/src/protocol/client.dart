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

/// Endpoint for email based accounts
/// {@category Endpoint}
class EndpointEmailAccount extends _i1.EndpointRef {
  EndpointEmailAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth_email.emailAccount';

  /// Returns the session key for the user with the given credentials.
  ///
  /// In case an expected error occurs, this throws a `EmailAccountLoginException`.
  _i2.Future<String> login({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<String>(
        'serverpod_auth_email.emailAccount',
        'login',
        {
          'email': email,
          'password': password,
        },
      );

  /// Starts the registration for an email based account.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to complete the registration.
  _i2.Future<void> requestAccount({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<void>(
        'serverpod_auth_email.emailAccount',
        'requestAccount',
        {
          'email': email,
          'password': password,
        },
      );

  /// Completes the email account registration.
  ///
  /// In case the given [session] belongs to a logged-in user,
  /// the email account will be added as an authentication method for that user.
  ///
  /// If the [session] belongs to a guest, a new auth user account and profile will
  /// be created.
  ///
  /// Returns the session key for the new session.
  _i2.Future<String> finishRegistration({required String verificationCode}) =>
      caller.callServerEndpoint<String>(
        'serverpod_auth_email.emailAccount',
        'finishRegistration',
        {'verificationCode': verificationCode},
      );

  /// Requests a password reset for [email].
  _i2.Future<void> requestPasswordReset({required String email}) =>
      caller.callServerEndpoint<void>(
        'serverpod_auth_email.emailAccount',
        'requestPasswordReset',
        {'email': email},
      );

  /// Completes a password reset request by setting a new password.
  ///
  /// If the reset was successful, a new session key is returned.
  ///
  /// Destroy all active sessions of the user.
  _i2.Future<String> completePasswordReset({
    required String resetCode,
    required String newPassword,
  }) =>
      caller.callServerEndpoint<String>(
        'serverpod_auth_email.emailAccount',
        'completePasswordReset',
        {
          'resetCode': resetCode,
          'newPassword': newPassword,
        },
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    emailAccount = EndpointEmailAccount(this);
  }

  late final EndpointEmailAccount emailAccount;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'serverpod_auth_email.emailAccount': emailAccount};
}
