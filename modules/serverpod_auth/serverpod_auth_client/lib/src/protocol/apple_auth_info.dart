/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Authentication info for Sign in with Apple.
abstract class AppleAuthInfo extends _i1.SerializableModel {
  AppleAuthInfo._({
    required this.userIdentifier,
    this.email,
    required this.fullName,
    required this.nickname,
    required this.identityToken,
    required this.authorizationCode,
  });

  factory AppleAuthInfo({
    required String userIdentifier,
    String? email,
    required String fullName,
    required String nickname,
    required String identityToken,
    required String authorizationCode,
  }) = _AppleAuthInfoImpl;

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

  AppleAuthInfo copyWith({
    String? userIdentifier,
    String? email,
    String? fullName,
    String? nickname,
    String? identityToken,
    String? authorizationCode,
  });
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

class _Undefined {}

class _AppleAuthInfoImpl extends AppleAuthInfo {
  _AppleAuthInfoImpl({
    required String userIdentifier,
    String? email,
    required String fullName,
    required String nickname,
    required String identityToken,
    required String authorizationCode,
  }) : super._(
          userIdentifier: userIdentifier,
          email: email,
          fullName: fullName,
          nickname: nickname,
          identityToken: identityToken,
          authorizationCode: authorizationCode,
        );

  @override
  AppleAuthInfo copyWith({
    String? userIdentifier,
    Object? email = _Undefined,
    String? fullName,
    String? nickname,
    String? identityToken,
    String? authorizationCode,
  }) {
    return AppleAuthInfo(
      userIdentifier: userIdentifier ?? this.userIdentifier,
      email: email is String? ? email : this.email,
      fullName: fullName ?? this.fullName,
      nickname: nickname ?? this.nickname,
      identityToken: identityToken ?? this.identityToken,
      authorizationCode: authorizationCode ?? this.authorizationCode,
    );
  }
}
