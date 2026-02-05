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

/// The reason for why the SMS account creation request was rejected.
enum SmsAccountRequestExceptionReason implements _i1.SerializableModel {
  /// The account request has expired.
  expired,

  /// Invalid verification code or account request id.
  invalid,

  /// The password does not match the configured policy.
  policyViolation,

  /// Too many verification attempts.
  tooManyAttempts,

  /// Unknown error occurred.
  unknown;

  static SmsAccountRequestExceptionReason fromJson(String name) {
    switch (name) {
      case 'expired':
        return SmsAccountRequestExceptionReason.expired;
      case 'invalid':
        return SmsAccountRequestExceptionReason.invalid;
      case 'policyViolation':
        return SmsAccountRequestExceptionReason.policyViolation;
      case 'tooManyAttempts':
        return SmsAccountRequestExceptionReason.tooManyAttempts;
      case 'unknown':
        return SmsAccountRequestExceptionReason.unknown;
      default:
        return SmsAccountRequestExceptionReason.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
