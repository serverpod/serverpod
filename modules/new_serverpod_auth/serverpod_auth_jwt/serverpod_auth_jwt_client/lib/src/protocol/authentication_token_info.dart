/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AuthenticationTokenInfo implements _i1.SerializableModel {
  AuthenticationTokenInfo._({
    required this.id,
    required this.authUserId,
    required this.scopeNames,
    this.extraClaimsJSON,
    required this.lastUpdated,
    required this.created,
  });

  factory AuthenticationTokenInfo({
    required _i1.UuidValue id,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
    String? extraClaimsJSON,
    required DateTime lastUpdated,
    required DateTime created,
  }) = _AuthenticationTokenInfoImpl;

  factory AuthenticationTokenInfo.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AuthenticationTokenInfo(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      scopeNames: _i1.SetJsonExtension.fromJson(
          (jsonSerialization['scopeNames'] as List),
          itemFromJson: (e) => e as String)!,
      extraClaimsJSON: jsonSerialization['extraClaimsJSON'] as String?,
      lastUpdated:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUpdated']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
    );
  }

  _i1.UuidValue id;

  /// The [AuthUser] this refresh token belongs to.
  _i1.UuidValue authUserId;

  /// The scopes given to this session.
  Set<String> scopeNames;

  /// Extra claims set on this session.
  ///
  /// Stored as JSON encoded `Map<String, dynamic>`
  String? extraClaimsJSON;

  /// The last time when a new token pair was created for this session.
  DateTime lastUpdated;

  /// The time when this session was initially created.
  DateTime created;

  /// Returns a shallow copy of this [AuthenticationTokenInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthenticationTokenInfo copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
    String? extraClaimsJSON,
    DateTime? lastUpdated,
    DateTime? created,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
      if (extraClaimsJSON != null) 'extraClaimsJSON': extraClaimsJSON,
      'lastUpdated': lastUpdated.toJson(),
      'created': created.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthenticationTokenInfoImpl extends AuthenticationTokenInfo {
  _AuthenticationTokenInfoImpl({
    required _i1.UuidValue id,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
    String? extraClaimsJSON,
    required DateTime lastUpdated,
    required DateTime created,
  }) : super._(
          id: id,
          authUserId: authUserId,
          scopeNames: scopeNames,
          extraClaimsJSON: extraClaimsJSON,
          lastUpdated: lastUpdated,
          created: created,
        );

  /// Returns a shallow copy of this [AuthenticationTokenInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthenticationTokenInfo copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
    Object? extraClaimsJSON = _Undefined,
    DateTime? lastUpdated,
    DateTime? created,
  }) {
    return AuthenticationTokenInfo(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      extraClaimsJSON:
          extraClaimsJSON is String? ? extraClaimsJSON : this.extraClaimsJSON,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      created: created ?? this.created,
    );
  }
}
