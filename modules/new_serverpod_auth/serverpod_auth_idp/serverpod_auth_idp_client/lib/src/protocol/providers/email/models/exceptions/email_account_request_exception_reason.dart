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

/// The reason for why the account creation with email request was rejected.
enum EmailAccountRequestExceptionReason implements _i1.SerializableModel {
  /// Exception to be thrown when one attempts to complete an email account
  /// request after it has expired.
  expired,

  /// Exception to be thrown when an email account request could not be found.
  ///
  /// This might mean that the account request never existed or has since been
  /// deleted. This reason is only available in the server and will be replaced
  /// by `unauthorized` when sent to the client.
  notFound,

  /// Exception to be thrown when an attempt is made to complete the creation
  /// of an email account before the account request has been verified.
  notVerified,

  /// Exception to be thrown when too many verification attempts were made on a
  /// email account request.
  tooManyAttempts,

  /// Exception to be thrown when the verification code given for an email
  /// account request is not valid.
  unauthorized,

  /// Unknown error occurred.
  unknown;

  static EmailAccountRequestExceptionReason fromJson(String name) {
    switch (name) {
      case 'expired':
        return EmailAccountRequestExceptionReason.expired;
      case 'notFound':
        return EmailAccountRequestExceptionReason.notFound;
      case 'notVerified':
        return EmailAccountRequestExceptionReason.notVerified;
      case 'tooManyAttempts':
        return EmailAccountRequestExceptionReason.tooManyAttempts;
      case 'unauthorized':
        return EmailAccountRequestExceptionReason.unauthorized;
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
