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

abstract class AuthSessionInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AuthSessionInfo._({
    required this.id,
    required this.authUserId,
    required this.scopeNames,
    required this.created,
    required this.lastUsed,
    this.expiresAt,
    this.expireAfterUnusedFor,
    required this.method,
  });

  factory AuthSessionInfo({
    required _i1.UuidValue id,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
    required DateTime created,
    required DateTime lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required String method,
  }) = _AuthSessionInfoImpl;

  factory AuthSessionInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthSessionInfo(
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
      method: jsonSerialization['method'] as String,
    );
  }

  _i1.UuidValue id;

  /// The [AuthUser] this session belongs to.
  _i1.UuidValue authUserId;

  /// The scopes this session provides access to.
  ///
  /// These are not connected to the [authUser], and can for example represent a subset of their permissions.
  Set<String> scopeNames;

  /// The time when this session was created.
  DateTime created;

  /// The time when this session was last used.
  ///
  /// Operates only with minute resolution, to avoid excessive writes to the database.
  DateTime lastUsed;

  /// The time after which this session can not be used anymore.
  ///
  /// If `null`, the session can be used indefinitely.
  DateTime? expiresAt;

  /// The maximum duration this session can go unused.
  ///
  /// If set, and the session is used after [lastUsed] + [expireAfterUnusedFor], then it will be rejected.
  ///
  /// If `null`, the session is valid until [expiresAt].
  Duration? expireAfterUnusedFor;

  /// The method through which this session was created.
  String method;

  /// Returns a shallow copy of this [AuthSessionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthSessionInfo copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    String? method,
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
      'method': method,
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
      'method': method,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthSessionInfoImpl extends AuthSessionInfo {
  _AuthSessionInfoImpl({
    required _i1.UuidValue id,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
    required DateTime created,
    required DateTime lastUsed,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required String method,
  }) : super._(
          id: id,
          authUserId: authUserId,
          scopeNames: scopeNames,
          created: created,
          lastUsed: lastUsed,
          expiresAt: expiresAt,
          expireAfterUnusedFor: expireAfterUnusedFor,
          method: method,
        );

  /// Returns a shallow copy of this [AuthSessionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthSessionInfo copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
    DateTime? created,
    DateTime? lastUsed,
    Object? expiresAt = _Undefined,
    Object? expireAfterUnusedFor = _Undefined,
    String? method,
  }) {
    return AuthSessionInfo(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      created: created ?? this.created,
      lastUsed: lastUsed ?? this.lastUsed,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      expireAfterUnusedFor: expireAfterUnusedFor is Duration?
          ? expireAfterUnusedFor
          : this.expireAfterUnusedFor,
      method: method ?? this.method,
    );
  }
}
