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

/// The reason for why the password reset request was rejected.
enum EmailAccountPasswordResetExceptionReason implements _i1.SerializableModel {
  /// Exception to be thrown when attempting to complete a valid password reset
  /// request that has already expired.
  expired,

  /// Exception to be thrown when attempting to complete a password reset with
  /// an invalid verification code or password reset request id.
  invalid,

  /// Exception to be thrown when attempting to set a password which does not
  /// match the configured policy.
  policyViolation,

  /// Exception to be thrown when attempting to verify a password reset
  /// request too many times.
  tooManyAttempts,

  /// Unknown error occurred.
  unknown;

  static EmailAccountPasswordResetExceptionReason fromJson(String name) {
    switch (name) {
      case 'expired':
        return EmailAccountPasswordResetExceptionReason.expired;
      case 'invalid':
        return EmailAccountPasswordResetExceptionReason.invalid;
      case 'policyViolation':
        return EmailAccountPasswordResetExceptionReason.policyViolation;
      case 'tooManyAttempts':
        return EmailAccountPasswordResetExceptionReason.tooManyAttempts;
      case 'unknown':
        return EmailAccountPasswordResetExceptionReason.unknown;
      default:
        return EmailAccountPasswordResetExceptionReason.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
