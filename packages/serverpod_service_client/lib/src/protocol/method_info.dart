/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
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

