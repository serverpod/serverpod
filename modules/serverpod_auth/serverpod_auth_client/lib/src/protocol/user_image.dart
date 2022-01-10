/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class UserImage extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.UserImage';

  int? id;
  late int userId;
  late int version;
  late String url;

  UserImage({
    this.id,
    required this.userId,
    required this.version,
    required this.url,
  });

  UserImage.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    version = _data['version']!;
    url = _data['url']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    });
  }
}
