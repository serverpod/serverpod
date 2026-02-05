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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Result of verifying a SMS login code.
abstract class SmsVerifyLoginResult implements _i1.SerializableModel {
  SmsVerifyLoginResult._({
    required this.token,
    required this.needsPassword,
  });

  factory SmsVerifyLoginResult({
    required String token,
    required bool needsPassword,
  }) = _SmsVerifyLoginResultImpl;

  factory SmsVerifyLoginResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SmsVerifyLoginResult(
      token: jsonSerialization['token'] as String,
      needsPassword: jsonSerialization['needsPassword'] as bool,
    );
  }

  /// The completion token for finishing the login.
  String token;

  /// Whether a password is needed (for new user auto-registration).
  bool needsPassword;

  /// Returns a shallow copy of this [SmsVerifyLoginResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsVerifyLoginResult copyWith({
    String? token,
    bool? needsPassword,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsVerifyLoginResult',
      'token': token,
      'needsPassword': needsPassword,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SmsVerifyLoginResultImpl extends SmsVerifyLoginResult {
  _SmsVerifyLoginResultImpl({
    required String token,
    required bool needsPassword,
  }) : super._(
         token: token,
         needsPassword: needsPassword,
       );

  /// Returns a shallow copy of this [SmsVerifyLoginResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsVerifyLoginResult copyWith({
    String? token,
    bool? needsPassword,
  }) {
    return SmsVerifyLoginResult(
      token: token ?? this.token,
      needsPassword: needsPassword ?? this.needsPassword,
    );
  }
}
