/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class AuthenticationResponse extends _i1.SerializableEntity {
  AuthenticationResponse({
    required this.success,
    this.key,
    this.keyId,
    this.userInfo,
    this.failReason,
  });

  factory AuthenticationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return AuthenticationResponse(
      success: serializationManager
          .deserializeJson<bool>(jsonSerialization['success']),
      key: serializationManager
          .deserializeJson<String?>(jsonSerialization['key']),
      keyId: serializationManager
          .deserializeJson<int?>(jsonSerialization['keyId']),
      userInfo: serializationManager
          .deserializeJson<_i2.UserInfo?>(jsonSerialization['userInfo']),
      failReason:
          serializationManager.deserializeJson<_i2.AuthenticationFailReason?>(
              jsonSerialization['failReason']),
    );
  }

  bool success;

  String? key;

  int? keyId;

  _i2.UserInfo? userInfo;

  _i2.AuthenticationFailReason? failReason;

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'key': key,
      'keyId': keyId,
      'userInfo': userInfo,
      'failReason': failReason,
    };
  }
}
