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
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart'
    as _i2;

abstract class LegacyUserInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  LegacyUserInfo._({
    this.id,
    required this.userIdentifier,
    this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.blocked,
  });

  factory LegacyUserInfo({
    int? id,
    required String userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) = _LegacyUserInfoImpl;

  factory LegacyUserInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegacyUserInfo(
      id: jsonSerialization['id'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      scopeNames: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['scopeNames'],
      ),
      blocked: _i1.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
    );
  }

  int? id;

  String userIdentifier;

  String? userName;

  String? fullName;

  String? email;

  DateTime created;

  String? imageUrl;

  List<String> scopeNames;

  bool blocked;

  /// Returns a shallow copy of this [LegacyUserInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegacyUserInfo copyWith({
    int? id,
    String? userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    String? imageUrl,
    List<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_bridge.LegacyUserInfo',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_bridge.LegacyUserInfo',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacyUserInfoImpl extends LegacyUserInfo {
  _LegacyUserInfoImpl({
    int? id,
    required String userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) : super._(
         id: id,
         userIdentifier: userIdentifier,
         userName: userName,
         fullName: fullName,
         email: email,
         created: created,
         imageUrl: imageUrl,
         scopeNames: scopeNames,
         blocked: blocked,
       );

  /// Returns a shallow copy of this [LegacyUserInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegacyUserInfo copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
    List<String>? scopeNames,
    bool? blocked,
  }) {
    return LegacyUserInfo(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toList(),
      blocked: blocked ?? this.blocked,
    );
  }
}
