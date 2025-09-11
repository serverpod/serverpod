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

  /// Exception to be thrown when an email account request could not be found by
  /// the given id.
  ///
  /// This might mean that the account request never existed or has since been
  /// deleted.
  notFound,

  /// Exception to be thrown when an attempt is made to complete the creation
  /// of an email account before the account request has been verified.
  notVerified,

  /// Exception to be thrown when too many verification attempts were made on a
  /// email account request.
  tooManyAttempts,

  /// Exception to be thrown when the verification code given for an email account
  /// request is not valid.
  unauthorized;

  static EmailAccountRequestExceptionReason fromJson(int index) {
    switch (index) {
      case 0:
        return EmailAccountRequestExceptionReason.expired;
      case 1:
        return EmailAccountRequestExceptionReason.notFound;
      case 2:
        return EmailAccountRequestExceptionReason.notVerified;
      case 3:
        return EmailAccountRequestExceptionReason.tooManyAttempts;
      case 4:
        return EmailAccountRequestExceptionReason.unauthorized;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "EmailAccountRequestExceptionReason"');
    }
  }

  @override
  int toJson() => index;

  @override
  String toString() => name;
}
