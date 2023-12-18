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
abstract class GoogleRefreshToken extends _i1.SerializableEntity {
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

  factory GoogleRefreshToken.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return GoogleRefreshToken(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      refreshToken: serializationManager
          .deserialize<String>(jsonSerialization['refreshToken']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user id associated with the token.
  int userId;

  /// The token iteself.
  String refreshToken;

  GoogleRefreshToken copyWith({
    int? id,
    int? userId,
    String? refreshToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
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
