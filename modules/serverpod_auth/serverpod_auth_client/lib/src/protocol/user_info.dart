/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class UserInfo extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.UserInfo';

  int? id;
  late String userIdentifier;
  late String userName;
  String? fullName;
  String? email;
  late DateTime created;
  String? imageUrl;
  late List<String> scopeNames;
  late bool active;
  late bool blocked;
  DateTime? suspendedUntil;

  UserInfo({
    this.id,
    required this.userIdentifier,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.active,
    required this.blocked,
    this.suspendedUntil,
  });

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userIdentifier = _data['userIdentifier']!;
    userName = _data['userName']!;
    fullName = _data['fullName'];
    email = _data['email'];
    created = DateTime.tryParse(_data['created'])!;
    imageUrl = _data['imageUrl'];
    scopeNames = _data['scopeNames']!.cast<String>();
    active = _data['active']!;
    blocked = _data['blocked']!;
    suspendedUntil = _data['suspendedUntil'] != null
        ? DateTime.tryParse(_data['suspendedUntil'])
        : null;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil?.toUtc().toIso8601String(),
    });
  }
}
