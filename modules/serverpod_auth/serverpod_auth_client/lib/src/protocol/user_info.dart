/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class UserInfo extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.UserInfo';

  int? id;
  late String userName;
  String? fullName;
  String? email;
  late DateTime created;
  String? avatarUrl;
  late List<String> scopes;
  late bool active;
  late bool blocked;

  UserInfo({
    this.id,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.avatarUrl,
    required this.scopes,
    required this.active,
    required this.blocked,
});

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userName = _data['userName']!;
    fullName = _data['fullName'];
    email = _data['email'];
    created = DateTime.tryParse(_data['created'])!;
    avatarUrl = _data['avatarUrl'];
    scopes = _data['scopes']!.cast<String>();
    active = _data['active']!;
    blocked = _data['blocked']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'avatarUrl': avatarUrl,
      'scopes': scopes,
      'active': active,
      'blocked': blocked,
    });
  }
}

