/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class EmailAuth extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.EmailAuth';

  int? id;
  late int userId;
  late String email;
  late String hash;

  EmailAuth({
    this.id,
    required this.userId,
    required this.email,
    required this.hash,
});

  EmailAuth.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    email = _data['email']!;
    hash = _data['hash']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    });
  }
}

