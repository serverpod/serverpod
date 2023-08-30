/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a Google refresh token.
class GoogleRefreshToken extends _i1.SerializableEntity {
  GoogleRefreshToken({
    this.id,
    required this.userId,
    required this.refreshToken,
  });

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

  int? id;

  /// The user id associated with the token.
  int userId;

  /// The token iteself.
  String refreshToken;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }
}
