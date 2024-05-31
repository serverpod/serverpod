/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a Google refresh token.
abstract class GoogleRefreshToken implements _i1.SerializableModel {
  GoogleRefreshToken._({
    this.id,
    required this.userId,
    required this.refreshToken,
  });

  factory GoogleRefreshToken({
    int? id,
    required int userId,
    required String refreshToken,
  }) = _GoogleRefreshTokenImpl;

  factory GoogleRefreshToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleRefreshToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      refreshToken: jsonSerialization['refreshToken'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user id associated with the token.
  int userId;

  /// The token itself.
  String refreshToken;

  GoogleRefreshToken copyWith({
    int? id,
    int? userId,
    String? refreshToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleRefreshTokenImpl extends GoogleRefreshToken {
  _GoogleRefreshTokenImpl({
    int? id,
    required int userId,
    required String refreshToken,
  }) : super._(
          id: id,
          userId: userId,
          refreshToken: refreshToken,
        );

  @override
  GoogleRefreshToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? refreshToken,
  }) {
    return GoogleRefreshToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
