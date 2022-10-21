/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

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
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userId: serializationManager
          .deserializeJson<int>(jsonSerialization['userId']),
      refreshToken: serializationManager
          .deserializeJson<String>(jsonSerialization['refreshToken']),
    );
  }

  int? id;

  int userId;

  String refreshToken;

  @override
  String get className => 'serverpod_auth_server.GoogleRefreshToken';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }
}
