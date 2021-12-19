/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class AppleAuthInfo extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.AppleAuthInfo';

  int? id;
  late String userIdentifier;
  String? email;
  late String fullName;
  late String nickname;
  late String identityToken;
  late String authorizationCode;

  AppleAuthInfo({
    this.id,
    required this.userIdentifier,
    this.email,
    required this.fullName,
    required this.nickname,
    required this.identityToken,
    required this.authorizationCode,
  });

  AppleAuthInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userIdentifier = _data['userIdentifier']!;
    email = _data['email'];
    fullName = _data['fullName']!;
    nickname = _data['nickname']!;
    identityToken = _data['identityToken']!;
    authorizationCode = _data['authorizationCode']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userIdentifier': userIdentifier,
      'email': email,
      'fullName': fullName,
      'nickname': nickname,
      'identityToken': identityToken,
      'authorizationCode': authorizationCode,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userIdentifier': userIdentifier,
      'email': email,
      'fullName': fullName,
      'nickname': nickname,
      'identityToken': identityToken,
      'authorizationCode': authorizationCode,
    });
  }
}
