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
import '../../../../providers/passwordless/models/exceptions/passwordless_login_exception_reason.dart'
    as _i2;

/// Exception thrown when passwordless login request fails.
///
/// Inspect the [reason] to determine the cause of the failure.
abstract class PasswordlessLoginException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  PasswordlessLoginException._({required this.reason});

  factory PasswordlessLoginException({
    required _i2.PasswordlessLoginExceptionReason reason,
  }) = _PasswordlessLoginExceptionImpl;

  factory PasswordlessLoginException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PasswordlessLoginException(
      reason: _i2.PasswordlessLoginExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i2.PasswordlessLoginExceptionReason reason;

  /// Returns a shallow copy of this [PasswordlessLoginException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasswordlessLoginException copyWith({
    _i2.PasswordlessLoginExceptionReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.PasswordlessLoginException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.PasswordlessLoginException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'PasswordlessLoginException(reason: $reason)';
  }
}

class _PasswordlessLoginExceptionImpl extends PasswordlessLoginException {
  _PasswordlessLoginExceptionImpl({
    required _i2.PasswordlessLoginExceptionReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [PasswordlessLoginException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasswordlessLoginException copyWith({
    _i2.PasswordlessLoginExceptionReason? reason,
  }) {
    return PasswordlessLoginException(reason: reason ?? this.reason);
  }
}
