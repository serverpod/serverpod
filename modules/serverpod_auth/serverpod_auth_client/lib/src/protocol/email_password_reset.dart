/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
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
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userName = _data['userName']!;
    email = _data['email']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
    });
  }
}
