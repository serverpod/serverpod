/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a Google refresh token.
abstract class GoogleRefreshToken extends _i1.SerializableEntity {
  const GoogleRefreshToken._();

  const factory GoogleRefreshToken({
    int? id,
    required int userId,
    required String refreshToken,
  }) = _GoogleRefreshToken;

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

  GoogleRefreshToken copyWith({
    int? id,
    int? userId,
    String? refreshToken,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The user id associated with the token.
  int get userId;

  /// The token iteself.
  String get refreshToken;
}

class _Undefined {}

/// Database bindings for a Google refresh token.
class _GoogleRefreshToken extends GoogleRefreshToken {
  const _GoogleRefreshToken({
    this.id,
    required this.userId,
    required this.refreshToken,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The user id associated with the token.
  @override
  final int userId;

  /// The token iteself.
  @override
  final String refreshToken;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is GoogleRefreshToken &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.refreshToken,
                  refreshToken,
                ) ||
                other.refreshToken == refreshToken));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        refreshToken,
      );

  @override
  GoogleRefreshToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? refreshToken,
  }) {
    return GoogleRefreshToken(
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
