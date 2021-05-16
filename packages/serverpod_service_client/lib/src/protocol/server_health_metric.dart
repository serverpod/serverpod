/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class ServerHealthMetric extends SerializableEntity {
  @override
  String get className => 'ServerHealthMetric';

  int? id;
  late String name;
  late bool isHealthy;
  late double value;

  ServerHealthMetric({
    this.id,
    required this.name,
    required this.isHealthy,
    required this.value,
});

  ServerHealthMetric.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    isHealthy = _data['isHealthy']!;
    value = _data['value']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'isHealthy': isHealthy,
      'value': value,
    });
  }
}

