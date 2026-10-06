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
import 'package:serverpod/serverpod.dart' as _is;

/// The reason for why the passwordless email login was rejected.
enum EmailPasswordlessLoginExceptionReason implements _is.SerializableModel {
  /// The login code is correct, but the login request has already expired.
  expired,

  /// The login request does not exist, has already been used, or the
  /// verification code is wrong.
  ///
  /// These cases are intentionally indistinguishable to not leak whether an
  /// account exists for an email address.
  invalid,

  /// The email address is not a valid email address.
  invalidEmail,

  /// Too many verification attempts have been made for the login request or
  /// email address.
  tooManyAttempts,

  /// Too many login requests have been made for the email address.
  rateLimited,

  /// A login request was created for the email address less than the resend
  /// cooldown ago, so no new code is sent. The caller can keep using the
  /// request it created, and try again after the cooldown.
  resendCooldown,

  /// Unknown error occurred.
  unknown;

  static EmailPasswordlessLoginExceptionReason fromJson(String name) {
    switch (name) {
      case 'expired':
        return EmailPasswordlessLoginExceptionReason.expired;
      case 'invalid':
        return EmailPasswordlessLoginExceptionReason.invalid;
      case 'invalidEmail':
        return EmailPasswordlessLoginExceptionReason.invalidEmail;
      case 'tooManyAttempts':
        return EmailPasswordlessLoginExceptionReason.tooManyAttempts;
      case 'rateLimited':
        return EmailPasswordlessLoginExceptionReason.rateLimited;
      case 'resendCooldown':
        return EmailPasswordlessLoginExceptionReason.resendCooldown;
      case 'unknown':
        return EmailPasswordlessLoginExceptionReason.unknown;
      default:
        return EmailPasswordlessLoginExceptionReason.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
