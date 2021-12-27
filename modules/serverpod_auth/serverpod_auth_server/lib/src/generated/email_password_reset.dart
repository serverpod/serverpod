/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class EmailPasswordReset extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.EmailPasswordReset';

  int? id;
  late String userName;
  late String email;

  EmailPasswordReset({
    this.id,
    required this.userName,
    required this.email,
  });

  EmailPasswordReset.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userName = _data['userName']!;
    email = _data['email']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'email': email,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'email': email,
    });
  }
}
