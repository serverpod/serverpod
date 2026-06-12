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

/// The reason for why the authentication via email credentials was rejected.
enum EmailAccountLoginExceptionReason implements _i1.SerializableModel {
  /// The credentials are either wrong or the email address is not known.
  invalidCredentials,

  /// Too many attempts made to login with the same email address.
  tooManyAttempts,

  /// Unknown error occurred.
  unknown;

  static EmailAccountLoginExceptionReason fromJson(String name) {
    switch (name) {
      case 'invalidCredentials':
        return EmailAccountLoginExceptionReason.invalidCredentials;
      case 'tooManyAttempts':
        return EmailAccountLoginExceptionReason.tooManyAttempts;
      case 'unknown':
        return EmailAccountLoginExceptionReason.unknown;
      default:
        return EmailAccountLoginExceptionReason.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
