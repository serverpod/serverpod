/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Authentication info for Sign in with Apple.
abstract class AppleAuthInfo extends _i1.SerializableEntity {
  const AppleAuthInfo._();

  const factory AppleAuthInfo({
    required String userIdentifier,
    String? email,
    required String fullName,
    required String nickname,
    required String identityToken,
    required String authorizationCode,
  }) = _AppleAuthInfo;

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

  AppleAuthInfo copyWith({
    String? userIdentifier,
    String? email,
    String? fullName,
    String? nickname,
    String? identityToken,
    String? authorizationCode,
  });

  /// The unique user identifier.
  String get userIdentifier;

  /// User email, if available.
  String? get email;

  /// Full name of the user.
  String get fullName;

  /// Nickname or first name of the user.
  String get nickname;

  /// Identity token associated with the sign in.
  String get identityToken;

  /// Authorization code associated with the sign in.
  String get authorizationCode;
}

class _Undefined {}

/// Authentication info for Sign in with Apple.
class _AppleAuthInfo extends AppleAuthInfo {
  const _AppleAuthInfo({
    required this.userIdentifier,
    this.email,
    required this.fullName,
    required this.nickname,
    required this.identityToken,
    required this.authorizationCode,
  }) : super._();

  /// The unique user identifier.
  @override
  final String userIdentifier;

  /// User email, if available.
  @override
  final String? email;

  /// Full name of the user.
  @override
  final String fullName;

  /// Nickname or first name of the user.
  @override
  final String nickname;

  /// Identity token associated with the sign in.
  @override
  final String identityToken;

  /// Authorization code associated with the sign in.
  @override
  final String authorizationCode;

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

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is AppleAuthInfo &&
            (identical(
                  other.userIdentifier,
                  userIdentifier,
                ) ||
                other.userIdentifier == userIdentifier) &&
            (identical(
                  other.email,
                  email,
                ) ||
                other.email == email) &&
            (identical(
                  other.fullName,
                  fullName,
                ) ||
                other.fullName == fullName) &&
            (identical(
                  other.nickname,
                  nickname,
                ) ||
                other.nickname == nickname) &&
            (identical(
                  other.identityToken,
                  identityToken,
                ) ||
                other.identityToken == identityToken) &&
            (identical(
                  other.authorizationCode,
                  authorizationCode,
                ) ||
                other.authorizationCode == authorizationCode));
  }

  @override
  int get hashCode => Object.hash(
        userIdentifier,
        email,
        fullName,
        nickname,
        identityToken,
        authorizationCode,
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
      email: email == _Undefined ? this.email : (email as String?),
      fullName: fullName ?? this.fullName,
      nickname: nickname ?? this.nickname,
      identityToken: identityToken ?? this.identityToken,
      authorizationCode: authorizationCode ?? this.authorizationCode,
    );
  }
}
