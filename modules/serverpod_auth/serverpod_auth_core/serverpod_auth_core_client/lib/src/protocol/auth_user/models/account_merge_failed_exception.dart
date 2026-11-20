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

/// Exception thrown when merging two accounts failed and was rolled back.
///
/// Both accounts are left untouched. The underlying error is logged on the
/// server, since it originates from application code and may contain details
/// that should not be sent to the client.
abstract class AccountMergeFailedException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  AccountMergeFailedException._({
    required this.userToKeepId,
    required this.userToRemoveId,
  });

  factory AccountMergeFailedException({
    required _isc.UuidValue userToKeepId,
    required _isc.UuidValue userToRemoveId,
  }) = _AccountMergeFailedExceptionImpl;

  factory AccountMergeFailedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountMergeFailedException(
      userToKeepId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['userToKeepId'],
      ),
      userToRemoveId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['userToRemoveId'],
      ),
    );
  }

  /// The account that was to be kept.
  _isc.UuidValue userToKeepId;

  /// The account that was to be merged in and removed.
  _isc.UuidValue userToRemoveId;

  /// Returns a shallow copy of this [AccountMergeFailedException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountMergeFailedException copyWith({
    _isc.UuidValue? userToKeepId,
    _isc.UuidValue? userToRemoveId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AccountMergeFailedException',
      'userToKeepId': userToKeepId.toJson(),
      'userToRemoveId': userToRemoveId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.AccountMergeFailedException',
      'userToKeepId': userToKeepId.toJson(),
      'userToRemoveId': userToRemoveId.toJson(),
    };
  }

  @override
  String toString() {
    return 'AccountMergeFailedException(userToKeepId: $userToKeepId, userToRemoveId: $userToRemoveId)';
  }
}

class _AccountMergeFailedExceptionImpl extends AccountMergeFailedException {
  _AccountMergeFailedExceptionImpl({
    required _isc.UuidValue userToKeepId,
    required _isc.UuidValue userToRemoveId,
  }) : super._(
         userToKeepId: userToKeepId,
         userToRemoveId: userToRemoveId,
       );

  /// Returns a shallow copy of this [AccountMergeFailedException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccountMergeFailedException copyWith({
    _isc.UuidValue? userToKeepId,
    _isc.UuidValue? userToRemoveId,
  }) {
    return AccountMergeFailedException(
      userToKeepId: userToKeepId ?? this.userToKeepId,
      userToRemoveId: userToRemoveId ?? this.userToRemoveId,
    );
  }
}
