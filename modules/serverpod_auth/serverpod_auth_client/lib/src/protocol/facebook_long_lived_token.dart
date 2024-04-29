/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a Facebook long-lived server token.
abstract class FacebookLongLivedToken extends _i1.SerializableEntity {
  FacebookLongLivedToken._({
    this.id,
    required this.userId,
    required this.fbProfileId,
    required this.token,
    required this.expiresAt,
  });

  factory FacebookLongLivedToken({
    int? id,
    required int userId,
    required String fbProfileId,
    required String token,
    required DateTime expiresAt,
  }) = _FacebookLongLivedTokenImpl;

  factory FacebookLongLivedToken.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return FacebookLongLivedToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      fbProfileId: jsonSerialization['fbProfileId'] as String,
      token: jsonSerialization['token'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The Serverpod user id associated with the token.
  int userId;

  /// The Facebook profile id.
  String fbProfileId;

  /// The Facebook long-lived token.
  String token;

  /// The expiry date of the token.
  DateTime expiresAt;

  FacebookLongLivedToken copyWith({
    int? id,
    int? userId,
    String? fbProfileId,
    String? token,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'fbProfileId': fbProfileId,
      'token': token,
      'expiresAt': expiresAt.toJson(),
    };
  }
}

class _Undefined {}

class _FacebookLongLivedTokenImpl extends FacebookLongLivedToken {
  _FacebookLongLivedTokenImpl({
    int? id,
    required int userId,
    required String fbProfileId,
    required String token,
    required DateTime expiresAt,
  }) : super._(
          id: id,
          userId: userId,
          fbProfileId: fbProfileId,
          token: token,
          expiresAt: expiresAt,
        );

  @override
  FacebookLongLivedToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? fbProfileId,
    String? token,
    DateTime? expiresAt,
  }) {
    return FacebookLongLivedToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      fbProfileId: fbProfileId ?? this.fbProfileId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
