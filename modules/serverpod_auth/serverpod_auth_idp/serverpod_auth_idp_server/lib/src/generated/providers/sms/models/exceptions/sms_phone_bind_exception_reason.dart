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

/// The reason for why the SMS phone bind request was rejected.
enum SmsPhoneBindExceptionReason implements _i1.SerializableModel {
  /// The bind request has expired.
  expired,

  /// Invalid verification code or bind request id.
  invalid,

  /// The phone is already bound to another user.
  phoneAlreadyBound,

  /// Too many bind attempts.
  tooManyAttempts,

  /// Unknown error occurred.
  unknown;

  static SmsPhoneBindExceptionReason fromJson(String name) {
    switch (name) {
      case 'expired':
        return SmsPhoneBindExceptionReason.expired;
      case 'invalid':
        return SmsPhoneBindExceptionReason.invalid;
      case 'phoneAlreadyBound':
        return SmsPhoneBindExceptionReason.phoneAlreadyBound;
      case 'tooManyAttempts':
        return SmsPhoneBindExceptionReason.tooManyAttempts;
      case 'unknown':
        return SmsPhoneBindExceptionReason.unknown;
      default:
        return SmsPhoneBindExceptionReason.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
