/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class EmailPasswordReset extends SerializableEntity {
  @override
  String get className => 'serverpod_auth_server.EmailPasswordReset';

  late String userName;
  late String email;

  EmailPasswordReset({
    required this.userName,
    required this.email,
  });

  EmailPasswordReset.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    userName = _data['userName']!;
    email = _data['email']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'userName': userName,
      'email': email,
    });
  }
}
