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

class EmailCreateAccountRequest extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.EmailCreateAccountRequest';

  int? id;
  late String userName;
  late String email;
  late String hash;
  late String verificationCode;

  EmailCreateAccountRequest({
    this.id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  });

  EmailCreateAccountRequest.fromSerialization(
      Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userName = _data['userName']!;
    email = _data['email']!;
    hash = _data['hash']!;
    verificationCode = _data['verificationCode']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    });
  }
}
