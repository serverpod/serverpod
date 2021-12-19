/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class AuthenticationResponse extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.AuthenticationResponse';

  int? id;
  late bool success;
  String? key;
  int? keyId;
  UserInfo? userInfo;

  AuthenticationResponse({
    this.id,
    required this.success,
    this.key,
    this.keyId,
    this.userInfo,
  });

  AuthenticationResponse.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    success = _data['success']!;
    key = _data['key'];
    keyId = _data['keyId'];
    userInfo = _data['userInfo'] != null
        ? UserInfo?.fromSerialization(_data['userInfo'])
        : null;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'success': success,
      'key': key,
      'keyId': keyId,
      'userInfo': userInfo?.serialize(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'success': success,
      'key': key,
      'keyId': keyId,
      'userInfo': userInfo?.serialize(),
    });
  }
}
