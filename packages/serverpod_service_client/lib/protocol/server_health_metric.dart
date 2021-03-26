/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class ServerHealthMetric extends SerializableEntity {
  String get className => 'ServerHealthMetric';

  int? id;
  String? name;
  bool? isHealthy;
  double? value;

  ServerHealthMetric({
    this.id,
    this.name,
    this.isHealthy,
    this.value,
});

  ServerHealthMetric.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name'];
    isHealthy = _data['isHealthy'];
    value = _data['value'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'isHealthy': isHealthy,
      'value': value,
    });
  }
}

