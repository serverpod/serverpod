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

/// The reason for why the passwordless login request was rejected.
enum PasswordlessLoginExceptionReason implements _i1.SerializableModel {
  /// The login request has expired.
  expired,

  /// Invalid verification code or login request id.
  invalid,

  /// Too many login attempts.
  tooManyAttempts,

  /// Unknown error occurred.
  unknown;

  static PasswordlessLoginExceptionReason fromJson(String name) {
    switch (name) {
      case 'expired':
        return PasswordlessLoginExceptionReason.expired;
      case 'invalid':
        return PasswordlessLoginExceptionReason.invalid;
      case 'tooManyAttempts':
        return PasswordlessLoginExceptionReason.tooManyAttempts;
      case 'unknown':
        return PasswordlessLoginExceptionReason.unknown;
      default:
        return PasswordlessLoginExceptionReason.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
