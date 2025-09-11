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

/// The reason for why the password reset request was rejected.
enum EmailAccountPasswordResetExceptionReason implements _i1.SerializableModel {
  /// Exception to be thrown when attempting to set a password which does not
  /// match the configured policy.
  policyViolation,

  /// Exception to be thrown when the password reset request was used after
  /// it has expired.
  requestExpired,

  /// Exception to be thrown when a password reset request could not be found.
  ///
  /// This might mean that the password reset request never existed or has been
  /// removed in the meantime.
  requestNotFound,

  /// Exception to be thrown when too many attempts were made to request a
  /// password reset.
  requestTooManyAttempts,

  /// Exception to be thrown when an attempt was made to complete a password reset
  /// with an invalid verification code.
  requestUnauthorized,

  /// Exception to be thrown when too many attempts were made on a single password
  /// reset request.
  tooManyAttempts;

  static EmailAccountPasswordResetExceptionReason fromJson(int index) {
    switch (index) {
      case 0:
        return EmailAccountPasswordResetExceptionReason.policyViolation;
      case 1:
        return EmailAccountPasswordResetExceptionReason.requestExpired;
      case 2:
        return EmailAccountPasswordResetExceptionReason.requestNotFound;
      case 3:
        return EmailAccountPasswordResetExceptionReason.requestTooManyAttempts;
      case 4:
        return EmailAccountPasswordResetExceptionReason.requestUnauthorized;
      case 5:
        return EmailAccountPasswordResetExceptionReason.tooManyAttempts;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "EmailAccountPasswordResetExceptionReason"');
    }
  }

  @override
  int toJson() => index;

  @override
  String toString() => name;
}
