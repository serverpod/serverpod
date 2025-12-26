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
import '../../../../providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart'
    as _i2;

/// Exception to be thrown if anonymous account creation fails.
///
/// Inspect the [reason] field to understand this exception.
abstract class AnonymousAccountBlockedException
    implements _i1.SerializableException, _i1.SerializableModel {
  AnonymousAccountBlockedException._({required this.reason});

  factory AnonymousAccountBlockedException({
    required _i2.AnonymousAccountBlockedExceptionReason reason,
  }) = _AnonymousAccountBlockedExceptionImpl;

  factory AnonymousAccountBlockedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AnonymousAccountBlockedException(
      reason: _i2.AnonymousAccountBlockedExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i2.AnonymousAccountBlockedExceptionReason reason;

  /// Returns a shallow copy of this [AnonymousAccountBlockedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousAccountBlockedException copyWith({
    _i2.AnonymousAccountBlockedExceptionReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.AnonymousAccountBlockedException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'AnonymousAccountBlockedException(reason: $reason)';
  }
}

class _AnonymousAccountBlockedExceptionImpl
    extends AnonymousAccountBlockedException {
  _AnonymousAccountBlockedExceptionImpl({
    required _i2.AnonymousAccountBlockedExceptionReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [AnonymousAccountBlockedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousAccountBlockedException copyWith({
    _i2.AnonymousAccountBlockedExceptionReason? reason,
  }) {
    return AnonymousAccountBlockedException(reason: reason ?? this.reason);
  }
}
