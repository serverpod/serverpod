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
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;
import '../../profile/models/user_profile_model.dart' as _ifks8d43;

/// Describes the pre-existing account that owns the sign-in method a user is
/// trying to link.
///
/// Use this to show the user which account they would be merging away before
/// asking them to approve the merge.
abstract class AccountLinkConflict
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AccountLinkConflict._({
    required this.authUserId,
    this.profile,
    required this.createdAt,
    required this.method,
  });

  factory AccountLinkConflict({
    required _is.UuidValue authUserId,
    _ifks8d43.UserProfileModel? profile,
    required DateTime createdAt,
    required String method,
  }) = _AccountLinkConflictImpl;

  factory AccountLinkConflict.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountLinkConflict(
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      profile: jsonSerialization['profile'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_ifks8d43.UserProfileModel>(
              jsonSerialization['profile'],
            ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      method: jsonSerialization['method'] as String,
    );
  }

  /// The pre-existing account that owns the sign-in method.
  _is.UuidValue authUserId;

  /// The profile of the pre-existing account, if it has one.
  _ifks8d43.UserProfileModel? profile;

  /// The time when the pre-existing account was created.
  DateTime createdAt;

  /// The identity provider method used to sign in to it, for example "google".
  String method;

  /// Returns a shallow copy of this [AccountLinkConflict]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountLinkConflict copyWith({
    _is.UuidValue? authUserId,
    _ifks8d43.UserProfileModel? profile,
    DateTime? createdAt,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AccountLinkConflict',
      'authUserId': authUserId.toJson(),
      if (profile != null) 'profile': profile?.toJson(),
      'createdAt': createdAt.toJson(),
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.AccountLinkConflict',
      'authUserId': authUserId.toJson(),
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'method': method,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountLinkConflictImpl extends AccountLinkConflict {
  _AccountLinkConflictImpl({
    required _is.UuidValue authUserId,
    _ifks8d43.UserProfileModel? profile,
    required DateTime createdAt,
    required String method,
  }) : super._(
         authUserId: authUserId,
         profile: profile,
         createdAt: createdAt,
         method: method,
       );

  /// Returns a shallow copy of this [AccountLinkConflict]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountLinkConflict copyWith({
    _is.UuidValue? authUserId,
    Object? profile = _Undefined,
    DateTime? createdAt,
    String? method,
  }) {
    return AccountLinkConflict(
      authUserId: authUserId ?? this.authUserId,
      profile: profile is _ifks8d43.UserProfileModel?
          ? profile
          : this.profile?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      method: method ?? this.method,
    );
  }
}
