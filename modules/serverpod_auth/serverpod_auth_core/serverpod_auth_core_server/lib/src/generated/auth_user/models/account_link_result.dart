/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;
import 'package:serverpod_serialization/undefined_sentinel.dart' as _issu;
import '../../auth_user/models/account_link_conflict.dart' as _ij0lqicu;
import '../../auth_user/models/account_link_status.dart' as _i5gmp6jk;

/// The result of executing an account link request.
abstract class AccountLinkResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AccountLinkResult._({
    required this.status,
    this.conflict,
  });

  factory AccountLinkResult({
    required _i5gmp6jk.AccountLinkStatus status,
    _ij0lqicu.AccountLinkConflict? conflict,
  }) = _AccountLinkResultImpl;

  factory AccountLinkResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountLinkResult(
      status: _i5gmp6jk.AccountLinkStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      conflict: jsonSerialization['conflict'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_ij0lqicu.AccountLinkConflict>(
              jsonSerialization['conflict'],
            ),
    );
  }

  /// What happened to the link request.
  _i5gmp6jk.AccountLinkStatus status;

  /// The pre-existing account that owns the sign-in method.
  ///
  /// Set when [status] is `mergeRequired`, describing the account awaiting the
  /// user's approval, and when [status] is `merged`, as a snapshot taken before
  /// that account was removed. `null` when [status] is `linked`, since no
  /// pre-existing account was involved.
  _ij0lqicu.AccountLinkConflict? conflict;

  /// Returns a shallow copy of this [AccountLinkResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountLinkResult copyWith({
    _i5gmp6jk.AccountLinkStatus? status,
    _ij0lqicu.AccountLinkConflict? conflict =
        const _UndefinedAccountLinkResult$conflict(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AccountLinkResult',
      'status': status.toJson(),
      if (conflict != null) 'conflict': conflict?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.AccountLinkResult',
      'status': status.toJson(),
      if (conflict != null) 'conflict': conflict?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UndefinedAccountLinkResult$conflict extends _issu.UndefinedSentinel
    implements _ij0lqicu.AccountLinkConflict {
  const _UndefinedAccountLinkResult$conflict();
}

class _AccountLinkResultImpl extends AccountLinkResult {
  _AccountLinkResultImpl({
    required _i5gmp6jk.AccountLinkStatus status,
    _ij0lqicu.AccountLinkConflict? conflict,
  }) : super._(
         status: status,
         conflict: conflict,
       );

  /// Returns a shallow copy of this [AccountLinkResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountLinkResult copyWith({
    _i5gmp6jk.AccountLinkStatus? status,
    _ij0lqicu.AccountLinkConflict? conflict =
        const _UndefinedAccountLinkResult$conflict(),
  }) {
    return AccountLinkResult(
      status: status ?? this.status,
      conflict: conflict is _issu.UndefinedSentinel
          ? this.conflict?.copyWith()
          : conflict,
    );
  }
}
