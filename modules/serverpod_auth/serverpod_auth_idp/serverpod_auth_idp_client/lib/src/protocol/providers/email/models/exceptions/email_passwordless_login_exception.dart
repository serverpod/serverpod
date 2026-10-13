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
import '../../../../providers/email/models/exceptions/email_passwordless_login_exception_reason.dart'
    as _iinela7q;

/// Exception to be thrown if a passwordless email login fails.
///
/// Inspect the [reason] to determine why the login was rejected.
abstract class EmailPasswordlessLoginException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  EmailPasswordlessLoginException._({required this.reason});

  factory EmailPasswordlessLoginException({
    required _iinela7q.EmailPasswordlessLoginExceptionReason reason,
  }) = _EmailPasswordlessLoginExceptionImpl;

  factory EmailPasswordlessLoginException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailPasswordlessLoginException(
      reason: _iinela7q.EmailPasswordlessLoginExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _iinela7q.EmailPasswordlessLoginExceptionReason reason;

  /// Returns a shallow copy of this [EmailPasswordlessLoginException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EmailPasswordlessLoginException copyWith({
    _iinela7q.EmailPasswordlessLoginExceptionReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.EmailPasswordlessLoginException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.EmailPasswordlessLoginException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'EmailPasswordlessLoginException(reason: $reason)';
  }
}

class _EmailPasswordlessLoginExceptionImpl
    extends EmailPasswordlessLoginException {
  _EmailPasswordlessLoginExceptionImpl({
    required _iinela7q.EmailPasswordlessLoginExceptionReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [EmailPasswordlessLoginException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EmailPasswordlessLoginException copyWith({
    _iinela7q.EmailPasswordlessLoginExceptionReason? reason,
  }) {
    return EmailPasswordlessLoginException(reason: reason ?? this.reason);
  }
}
