/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class UserSettingsConfig extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.UserSettingsConfig';

  late bool canSeeUserName;
  late bool canSeeFullName;
  late bool canEditUserName;
  late bool canEditFullName;
  late bool canEditUserImage;

  UserSettingsConfig({
    required this.canSeeUserName,
    required this.canSeeFullName,
    required this.canEditUserName,
    required this.canEditFullName,
    required this.canEditUserImage,
  });

  UserSettingsConfig.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    canSeeUserName = _data['canSeeUserName']!;
    canSeeFullName = _data['canSeeFullName']!;
    canEditUserName = _data['canEditUserName']!;
    canEditFullName = _data['canEditFullName']!;
    canEditUserImage = _data['canEditUserImage']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'canSeeUserName': canSeeUserName,
      'canSeeFullName': canSeeFullName,
      'canEditUserName': canEditUserName,
      'canEditFullName': canEditFullName,
      'canEditUserImage': canEditUserImage,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'canSeeUserName': canSeeUserName,
      'canSeeFullName': canSeeFullName,
      'canEditUserName': canEditUserName,
      'canEditFullName': canEditFullName,
      'canEditUserImage': canEditUserImage,
    });
  }
}
