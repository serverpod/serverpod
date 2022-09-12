/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class AuthenticationResponse extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.AuthenticationResponse';

  late bool success;
  String? key;
  int? keyId;
  UserInfo? userInfo;
  AuthenticationFailReason? failReason;

  AuthenticationResponse({
    required this.success,
    this.key,
    this.keyId,
    this.userInfo,
    this.failReason,
  });

  AuthenticationResponse.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    success = _data['success']!;
    key = _data['key'];
    keyId = _data['keyId'];
    userInfo = _data['userInfo'] != null
        ? UserInfo?.fromSerialization(_data['userInfo'])
        : null;
    failReason = _data['failReason'] != null
        ? AuthenticationFailReason?.fromSerialization(_data['failReason'])
        : null;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'success': success,
      'key': key,
      'keyId': keyId,
      'userInfo': userInfo?.serialize(),
      'failReason': failReason?.serialize(),
    });
  }
}
