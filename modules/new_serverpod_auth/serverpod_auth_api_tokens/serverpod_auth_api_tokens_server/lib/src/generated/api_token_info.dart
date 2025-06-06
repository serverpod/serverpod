/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ApiTokenInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ApiTokenInfo._({
    required this.id,
    required this.authUserId,
    required this.scopeNames,
    required this.created,
    required this.lastUsed,
    this.expiresAt,
    this.expireAfterUnusedFor,
    String? kind,
  }) : kind = kind ?? '';

  factory ApiTokenInfo({
    required _i1.UuidValue id,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
    required DateTime created,
    required DateTime lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    String? kind,
  }) = _ApiTokenInfoImpl;

  factory ApiTokenInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiTokenInfo(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      scopeNames: _i1.SetJsonExtension.fromJson(
          (jsonSerialization['scopeNames'] as List),
          itemFromJson: (e) => e as String)!,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      lastUsed:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsed']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      expireAfterUnusedFor: jsonSerialization['expireAfterUnusedFor'] == null
          ? null
          : _i1.DurationJsonExtension.fromJson(
              jsonSerialization['expireAfterUnusedFor']),
      kind: jsonSerialization['kind'] as String,
    );
  }

  _i1.UuidValue id;

  /// The [AuthUser] this API token belongs to
  _i1.UuidValue authUserId;

  /// The scopes this API token provides access to.
  ///
  /// These are not connected to the [authUser], and can for example represent a subset of their permissions.
  Set<String> scopeNames;

  /// The time when this API token was created.
  DateTime created;

  /// The time when this access token was last used.
  ///
  /// Operates only with minute resolution, to avoid excessive writes to the database.
  DateTime lastUsed;

  /// The time after which this token can not be used anymore.
  ///
  /// If `null`, the token can be used indefinitely.
  DateTime? expiresAt;

  /// The maximum duration this token can go unused.
  ///
  /// If set, and the token is used after [lastUsed] + [expireAfterUnusedFor], then it will be rejected.
  ///
  /// If `null`, the token is valid until [expiresAt].
  Duration? expireAfterUnusedFor;

  /// The kind of API token this represents.
  ///
  /// This does not impact the behavior of the token, but can be useful for debugging.
  /// For example this could be used to differentiate between anonymous accounts, personal access tokens, or service accounts.
  String kind;

  /// Returns a shallow copy of this [ApiTokenInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiTokenInfo copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    String? kind,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
      'created': created.toJson(),
      'lastUsed': lastUsed.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (expireAfterUnusedFor != null)
        'expireAfterUnusedFor': expireAfterUnusedFor?.toJson(),
      'kind': kind,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id.toJson(),
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
      'created': created.toJson(),
      'lastUsed': lastUsed.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (expireAfterUnusedFor != null)
        'expireAfterUnusedFor': expireAfterUnusedFor?.toJson(),
      'kind': kind,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiTokenInfoImpl extends ApiTokenInfo {
  _ApiTokenInfoImpl({
    required _i1.UuidValue id,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
    required DateTime created,
    required DateTime lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    String? kind,
  }) : super._(
          id: id,
          authUserId: authUserId,
          scopeNames: scopeNames,
          created: created,
          lastUsed: lastUsed,
          expiresAt: expiresAt,
          expireAfterUnusedFor: expireAfterUnusedFor,
          kind: kind,
        );

  /// Returns a shallow copy of this [ApiTokenInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiTokenInfo copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    Object? expiresAt = _Undefined,
    Object? expireAfterUnusedFor = _Undefined,
    String? kind,
  }) {
    return ApiTokenInfo(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      created: created ?? this.created,
      lastUsed: lastUsed ?? this.lastUsed,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      expireAfterUnusedFor: expireAfterUnusedFor is Duration?
          ? expireAfterUnusedFor
          : this.expireAfterUnusedFor,
      kind: kind ?? this.kind,
    );
  }
}
