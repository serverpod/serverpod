/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Authentication info for Sign in with Apple.
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
          .deserialize<String>(jsonSerialization['userIdentifier']),
      email:
          serializationManager.deserialize<String?>(jsonSerialization['email']),
      fullName: serializationManager
          .deserialize<String>(jsonSerialization['fullName']),
      nickname: serializationManager
          .deserialize<String>(jsonSerialization['nickname']),
      identityToken: serializationManager
          .deserialize<String>(jsonSerialization['identityToken']),
      authorizationCode: serializationManager
          .deserialize<String>(jsonSerialization['authorizationCode']),
    );
  }

  /// The unique user identifier.
  String userIdentifier;

  /// User email, if available.
  String? email;

  /// Full name of the user.
  String fullName;

  /// Nickname or first name of the user.
  String nickname;

  /// Identity token associated with the sign in.
  String identityToken;

  /// Authorization code associated with the sign in.
  String authorizationCode;

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
