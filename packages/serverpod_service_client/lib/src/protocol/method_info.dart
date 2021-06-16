/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class MethodInfo extends SerializableEntity {
  @override
  String get className => 'MethodInfo';

  int? id;
  late String endpoint;
  late String method;

  MethodInfo({
    this.id,
    required this.endpoint,
    required this.method,
});

  MethodInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    endpoint = _data['endpoint']!;
    method = _data['method']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'endpoint': endpoint,
      'method': method,
    });
  }
}

