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

class ServerHealthMetric extends SerializableEntity {
  @override
  String get className => 'ServerHealthMetric';

  int? id;
  late String name;
  late String serverId;
  late DateTime timestamp;
  late bool isHealthy;
  late double value;

  ServerHealthMetric({
    this.id,
    required this.name,
    required this.serverId,
    required this.timestamp,
    required this.isHealthy,
    required this.value,
  });

  ServerHealthMetric.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    serverId = _data['serverId']!;
    timestamp = DateTime.tryParse(_data['timestamp'])!;
    isHealthy = _data['isHealthy']!;
    value = _data['value']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'isHealthy': isHealthy,
      'value': value,
    });
  }
}
