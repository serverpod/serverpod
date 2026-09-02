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

/// DTO for transferring JWT token information between server and client.
abstract class JwtTokenInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  JwtTokenInfo._({
    required this.id,
    required this.authUserId,
    required this.scopeNames,
    this.extraClaimsJSON,
    required this.lastUpdatedAt,
    required this.createdAt,
    required this.method,
  });

  factory JwtTokenInfo({
    required _is.UuidValue id,
    required _is.UuidValue authUserId,
    required Set<String> scopeNames,
    String? extraClaimsJSON,
    required DateTime lastUpdatedAt,
    required DateTime createdAt,
    required String method,
  }) = _JwtTokenInfoImpl;

  factory JwtTokenInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return JwtTokenInfo(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      scopeNames: _i8reeoob.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      extraClaimsJSON: jsonSerialization['extraClaimsJSON'] as String?,
      lastUpdatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUpdatedAt'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      method: jsonSerialization['method'] as String,
    );
  }

  _is.UuidValue id;

  /// The [AuthUser] this refresh token belongs to.
  _is.UuidValue authUserId;

  /// The scopes given to this session.
  Set<String> scopeNames;

  /// Extra claims set on this session.
  ///
  /// Stored as JSON encoded `Map<String, dynamic>`
  String? extraClaimsJSON;

  /// The last time when a new token pair was created for this session.
  DateTime lastUpdatedAt;

  /// The time when this session was initially created.
  DateTime createdAt;

  /// The method through which this token was created.
  String method;

  /// Returns a shallow copy of this [JwtTokenInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JwtTokenInfo copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    Set<String>? scopeNames,
    String? extraClaimsJSON,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.JwtTokenInfo',
      'id': id.toJson(),
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
      if (extraClaimsJSON != null) 'extraClaimsJSON': extraClaimsJSON,
      'lastUpdatedAt': lastUpdatedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.JwtTokenInfo',
      'id': id.toJson(),
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
      if (extraClaimsJSON != null) 'extraClaimsJSON': extraClaimsJSON,
      'lastUpdatedAt': lastUpdatedAt.toJson(),
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

class _JwtTokenInfoImpl extends JwtTokenInfo {
  _JwtTokenInfoImpl({
    required _is.UuidValue id,
    required _is.UuidValue authUserId,
    required Set<String> scopeNames,
    String? extraClaimsJSON,
    required DateTime lastUpdatedAt,
    required DateTime createdAt,
    required String method,
  }) : super._(
         id: id,
         authUserId: authUserId,
         scopeNames: scopeNames,
         extraClaimsJSON: extraClaimsJSON,
         lastUpdatedAt: lastUpdatedAt,
         createdAt: createdAt,
         method: method,
       );

  /// Returns a shallow copy of this [JwtTokenInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JwtTokenInfo copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    Set<String>? scopeNames,
    Object? extraClaimsJSON = _Undefined,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    String? method,
  }) {
    return JwtTokenInfo(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      extraClaimsJSON: extraClaimsJSON is String?
          ? extraClaimsJSON
          : this.extraClaimsJSON,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      method: method ?? this.method,
    );
  }
}
