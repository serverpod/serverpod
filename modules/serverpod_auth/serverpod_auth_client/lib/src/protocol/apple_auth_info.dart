/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class AppleAuthInfo extends _i1.SerializableEntity {
  AppleAuthInfo({
    required this.userIdentifier,
    this.email,
    required this.fullName,
    required this.nickname,
    required this.identityToken,
    required this.authorizationCode,
  });

  factory AppleAuthInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return AppleAuthInfo(
      userIdentifier: serializationManager
          .deserializeJson<String>(jsonSerialization['userIdentifier']),
      email: serializationManager
          .deserializeJson<String?>(jsonSerialization['email']),
      fullName: serializationManager
          .deserializeJson<String>(jsonSerialization['fullName']),
      nickname: serializationManager
          .deserializeJson<String>(jsonSerialization['nickname']),
      identityToken: serializationManager
          .deserializeJson<String>(jsonSerialization['identityToken']),
      authorizationCode: serializationManager
          .deserializeJson<String>(jsonSerialization['authorizationCode']),
    );
  }

  String userIdentifier;

  String? email;

  String fullName;

  String nickname;

  String identityToken;

  String authorizationCode;

  @override
  String get className => 'serverpod_auth_server.AppleAuthInfo';
  @override
  Map<String, dynamic> toJson() {
    return {
      'userIdentifier': userIdentifier,
      'email': email,
      'fullName': fullName,
      'nickname': nickname,
      'identityToken': identityToken,
      'authorizationCode': authorizationCode,
    };
  }
}
