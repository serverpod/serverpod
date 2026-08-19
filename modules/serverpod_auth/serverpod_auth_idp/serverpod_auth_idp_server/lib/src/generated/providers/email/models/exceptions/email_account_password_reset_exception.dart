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
import '../../../../providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _i17ufdat;

/// Exception to be thrown if email reset request fails.
///
/// Inspect the [reason] to determine whether this was due to invalid or unknown
/// credentials, or whether the client has been blocked outright.
abstract class EmailAccountPasswordResetException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  EmailAccountPasswordResetException._({required this.reason});

  factory EmailAccountPasswordResetException({
    required _i17ufdat.EmailAccountPasswordResetExceptionReason reason,
  }) = _EmailAccountPasswordResetExceptionImpl;

  factory EmailAccountPasswordResetException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAccountPasswordResetException(
      reason: _i17ufdat.EmailAccountPasswordResetExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i17ufdat.EmailAccountPasswordResetExceptionReason reason;

  /// Returns a shallow copy of this [EmailAccountPasswordResetException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailAccountPasswordResetException copyWith({
    _i17ufdat.EmailAccountPasswordResetExceptionReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountPasswordResetException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountPasswordResetException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'EmailAccountPasswordResetException(reason: $reason)';
  }
}

class _EmailAccountPasswordResetExceptionImpl
    extends EmailAccountPasswordResetException {
  _EmailAccountPasswordResetExceptionImpl({
    required _i17ufdat.EmailAccountPasswordResetExceptionReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [EmailAccountPasswordResetException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailAccountPasswordResetException copyWith({
    _i17ufdat.EmailAccountPasswordResetExceptionReason? reason,
  }) {
    return EmailAccountPasswordResetException(reason: reason ?? this.reason);
  }
}
