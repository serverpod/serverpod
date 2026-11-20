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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// The result of verifying a one-time password (OTP) for an email login.
///
/// Only returned after the one-time password has been verified, so it does not
/// leak the existence of accounts to anyone not in control of the email.
abstract class EmailAccountOtpVerificationResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EmailAccountOtpVerificationResult._({
    required this.token,
    required this.accountExists,
    required this.allowPassword,
  });

  factory EmailAccountOtpVerificationResult({
    required String token,
    required bool accountExists,
    required bool allowPassword,
  }) = _EmailAccountOtpVerificationResultImpl;

  factory EmailAccountOtpVerificationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAccountOtpVerificationResult(
      token: jsonSerialization['token'] as String,
      accountExists: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['accountExists'],
      ),
      allowPassword: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['allowPassword'],
      ),
    );
  }

  /// Token to complete the flow.
  ///
  /// If [accountExists] is `true`, pass it to `finishOtpLogin` to sign in.
  /// Otherwise pass it to `finishOtpRegistration` to create the account, after
  /// the user has accepted the terms.
  String token;

  /// Whether an account is already registered for the email.
  bool accountExists;

  /// Whether the user may set a password when creating the account.
  ///
  /// Only relevant when [accountExists] is `false`.
  bool allowPassword;

  /// Returns a shallow copy of this [EmailAccountOtpVerificationResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EmailAccountOtpVerificationResult copyWith({
    String? token,
    bool? accountExists,
    bool? allowPassword,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountOtpVerificationResult',
      'token': token,
      'accountExists': accountExists,
      'allowPassword': allowPassword,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountOtpVerificationResult',
      'token': token,
      'accountExists': accountExists,
      'allowPassword': allowPassword,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _EmailAccountOtpVerificationResultImpl
    extends EmailAccountOtpVerificationResult {
  _EmailAccountOtpVerificationResultImpl({
    required String token,
    required bool accountExists,
    required bool allowPassword,
  }) : super._(
         token: token,
         accountExists: accountExists,
         allowPassword: allowPassword,
       );

  /// Returns a shallow copy of this [EmailAccountOtpVerificationResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EmailAccountOtpVerificationResult copyWith({
    String? token,
    bool? accountExists,
    bool? allowPassword,
  }) {
    return EmailAccountOtpVerificationResult(
      token: token ?? this.token,
      accountExists: accountExists ?? this.accountExists,
      allowPassword: allowPassword ?? this.allowPassword,
    );
  }
}
