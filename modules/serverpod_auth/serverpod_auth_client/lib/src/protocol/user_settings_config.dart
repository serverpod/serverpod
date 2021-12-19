/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class UserSettingsConfig extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.UserSettingsConfig';

  int? id;
  late bool canSeeUserName;
  late bool canSeeFullName;
  late bool canEditUserName;
  late bool canEditFullName;
  late bool canEditUserImage;

  UserSettingsConfig({
    this.id,
    required this.canSeeUserName,
    required this.canSeeFullName,
    required this.canEditUserName,
    required this.canEditFullName,
    required this.canEditUserImage,
  });

  UserSettingsConfig.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    canSeeUserName = _data['canSeeUserName']!;
    canSeeFullName = _data['canSeeFullName']!;
    canEditUserName = _data['canEditUserName']!;
    canEditFullName = _data['canEditFullName']!;
    canEditUserImage = _data['canEditUserImage']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'canSeeUserName': canSeeUserName,
      'canSeeFullName': canSeeFullName,
      'canEditUserName': canEditUserName,
      'canEditFullName': canEditFullName,
      'canEditUserImage': canEditUserImage,
    });
  }
}
