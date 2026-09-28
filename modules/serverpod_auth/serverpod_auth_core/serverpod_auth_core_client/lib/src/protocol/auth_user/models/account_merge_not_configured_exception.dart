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

/// Exception thrown when completing an account link would require merging a
/// pre-existing account, but the application has not configured how to merge
/// its own data.
///
/// Configure an `AccountMergeConfig` with an `applicationMergeHandler` to
/// support this, or keep users from linking sign-in methods that already
/// belong to another account.
abstract class AccountMergeNotConfiguredException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  AccountMergeNotConfiguredException._();

  factory AccountMergeNotConfiguredException() =
      _AccountMergeNotConfiguredExceptionImpl;

  factory AccountMergeNotConfiguredException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountMergeNotConfiguredException();
  }

  /// Returns a shallow copy of this [AccountMergeNotConfiguredException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountMergeNotConfiguredException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AccountMergeNotConfiguredException',
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.AccountMergeNotConfiguredException',
    };
  }

  @override
  String toString() {
    return 'AccountMergeNotConfiguredException';
  }
}

class _AccountMergeNotConfiguredExceptionImpl
    extends AccountMergeNotConfiguredException {
  _AccountMergeNotConfiguredExceptionImpl() : super._();

  /// Returns a shallow copy of this [AccountMergeNotConfiguredException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccountMergeNotConfiguredException copyWith() {
    return AccountMergeNotConfiguredException();
  }
}
