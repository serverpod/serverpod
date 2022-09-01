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

class EmailFailedSignIn extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.EmailFailedSignIn';

  int? id;
  late String email;
  late DateTime time;
  late String ipAddress;

  EmailFailedSignIn({
    this.id,
    required this.email,
    required this.time,
    required this.ipAddress,
  });

  EmailFailedSignIn.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    email = _data['email']!;
    time = DateTime.tryParse(_data['time'])!;
    ipAddress = _data['ipAddress']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'email': email,
      'time': time.toUtc().toIso8601String(),
      'ipAddress': ipAddress,
    });
  }
}
