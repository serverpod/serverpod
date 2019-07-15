/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class ServerHealthMetric extends SerializableEntity {
  String get className => 'ServerHealthMetric';

  int id;
  double value;
  String name;
  bool isHealthy;

  ServerHealthMetric({
    this.id,
    this.value,
    this.name,
    this.isHealthy,
});

  ServerHealthMetric.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    value = _data['value'];
    name = _data['name'];
    isHealthy = _data['isHealthy'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'value': value,
      'name': name,
      'isHealthy': isHealthy,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'value': value,
      'name': name,
      'isHealthy': isHealthy,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'value': value,
      'name': name,
      'isHealthy': isHealthy,
    });
  }
}

