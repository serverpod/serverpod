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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../../../providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _ikfzibqo;

/// Exception to be thrown if email account creation request fails.
///
/// Inspect the [reason] to determine whether this was due to invalid or unknown
/// credentials, or whether the client has been blocked outright.
abstract class EmailAccountRequestException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  EmailAccountRequestException._({required this.reason});

  factory EmailAccountRequestException({
    required _ikfzibqo.EmailAccountRequestExceptionReason reason,
  }) = _EmailAccountRequestExceptionImpl;

  factory EmailAccountRequestException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAccountRequestException(
      reason: _ikfzibqo.EmailAccountRequestExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _ikfzibqo.EmailAccountRequestExceptionReason reason;

  /// Returns a shallow copy of this [EmailAccountRequestException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EmailAccountRequestException copyWith({
    _ikfzibqo.EmailAccountRequestExceptionReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountRequestException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.EmailAccountRequestException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'EmailAccountRequestException(reason: $reason)';
  }
}

class _EmailAccountRequestExceptionImpl extends EmailAccountRequestException {
  _EmailAccountRequestExceptionImpl({
    required _ikfzibqo.EmailAccountRequestExceptionReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [EmailAccountRequestException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EmailAccountRequestException copyWith({
    _ikfzibqo.EmailAccountRequestExceptionReason? reason,
  }) {
    return EmailAccountRequestException(reason: reason ?? this.reason);
  }
}
