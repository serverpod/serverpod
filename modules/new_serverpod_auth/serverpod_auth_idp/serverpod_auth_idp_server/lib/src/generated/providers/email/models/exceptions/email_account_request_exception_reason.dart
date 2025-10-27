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

/// The reason for why the account creation with email request was rejected.
enum EmailAccountRequestExceptionReason implements _i1.SerializableModel {
  /// Exception to be thrown when attempting to complete a valid email account
  /// request that has already expired.
  expired,

  /// Exception to be thrown when attempting to complete an email account
  /// request with an invalid verification code or account request id.
  invalid,

  /// Exception to be thrown when attempting to set a password which does not
  /// match the configured policy.
  policyViolation,

  /// Unknown error occurred.
  unknown;

  static EmailAccountRequestExceptionReason fromJson(String name) {
    switch (name) {
      case 'expired':
        return EmailAccountRequestExceptionReason.expired;
      case 'invalid':
        return EmailAccountRequestExceptionReason.invalid;
      case 'policyViolation':
        return EmailAccountRequestExceptionReason.policyViolation;
      case 'unknown':
        return EmailAccountRequestExceptionReason.unknown;
      default:
        return EmailAccountRequestExceptionReason.unknown;
    }
  }

  @override
  String toJson() => name;
  @override
  String toString() => name;
}
